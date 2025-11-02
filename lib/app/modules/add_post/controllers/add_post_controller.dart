import 'dart:io';
import 'package:campus_crush_app/app/modules/add_post/views/widgets/image_cropper_screen.dart';
import 'package:campus_crush_app/app/modules/navbar/controllers/user_controller.dart';
import 'package:campus_crush_app/app/services/logger_service.dart';
import 'package:campus_crush_app/app/services/login_manager.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class AddPostController extends GetxController {
  // Text controller
  final TextEditingController textController = TextEditingController();
  UserController userController = Get.put(UserController());

  // Observables
  final textLength = 0.obs;
  final selectedImages = <File>[].obs;
  final isLoading = false.obs;

  final _firebaseStorage = FirebaseStorage.instance;
  final _firebaseFirestore = FirebaseFirestore.instance;

  // Image picker
  final ImagePicker _imagePicker = ImagePicker();

  // Constraints
  static const int maxTextLength = 500;
  static const int maxImages = 5;

  @override
  void onInit() {
    super.onInit();
    textController.addListener(updateTextLength);
  }

  @override
  void onClose() {
    textController.dispose();
    super.onClose();
  }

  /// Update text length when text changes
  void updateTextLength() {
    textLength.value = textController.text.length;
  }

  /// Pick images from gallery
  Future<void> pickImages() async {
    try {
      final List<XFile> pickedFiles = await _imagePicker.pickMultiImage(
        // Don't limit quality here since we'll crop and compress after
        imageQuality: 100, // Keep original quality for cropping
      );

      if (pickedFiles.isNotEmpty) {
        int remainingSlots = maxImages - selectedImages.length;

        for (int i = 0; i < pickedFiles.length && i < remainingSlots; i++) {
          // Open custom image cropper screen
          final croppedFile = await Get.to(
            () => ImageCropperScreen(imageFile: File(pickedFiles[i].path)),
          );

          if (croppedFile != null && croppedFile is File) {
            // Verify file size
            final fileSize = await croppedFile.length();
            final fileSizeKB = fileSize / 1024;

            if (fileSizeKB > 500) {
              Get.snackbar(
                'Warning',
                'Image is ${fileSizeKB.toStringAsFixed(0)} KB. Recommended: under 500 KB',
                snackPosition: SnackPosition.BOTTOM,
                duration: Duration(seconds: 2),
              );
            }

            selectedImages.add(croppedFile);
          }
        }

        // Show message if some images were not added due to limit
        if (pickedFiles.length > remainingSlots) {
          Get.snackbar(
            'Image Limit',
            'Only $remainingSlots image(s) can be added. Maximum is $maxImages.',
            snackPosition: SnackPosition.BOTTOM,
            duration: Duration(seconds: 2),
          );
        }
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to pick images: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.white,
        colorText: Colors.red,
      );
    }
  }

  /// Remove image from selected list
  void removeImage(int index) {
    if (index >= 0 && index < selectedImages.length) {
      // Delete the temporary cropped file
      final file = selectedImages[index];
      if (file.existsSync()) {
        file.deleteSync();
      }
      selectedImages.removeAt(index);
    }
  }

  /// Upload images to Firebase Storage and return URLs
  Future<List<String>> _uploadImagesToFirebase(List<File> images) async {
    List<String> imageUrls = [];

    try {
      for (int i = 0; i < images.length; i++) {
        String fileName =
            'posts/${LoginManager.instance.currentUserId}/image_${DateTime.now().millisecondsSinceEpoch}_$i.jpg';

        // Upload to Firebase Storage
        TaskSnapshot snapshot = await _firebaseStorage
            .ref(fileName)
            .putFile(images[i], SettableMetadata(contentType: 'image/jpeg'));

        // Get download URL
        String downloadUrl = await snapshot.ref.getDownloadURL();
        imageUrls.add(downloadUrl);
      }

      return imageUrls;
    } catch (e) {
      throw Exception('Failed to upload images: $e');
    }
  }

  /// Create and upload post to Firestore
  Future<void> createPost() async {
    try {
      // Validate text
      if (textController.text.trim().isEmpty) {
        Get.snackbar(
          'Error',
          'Please enter some text before posting',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.white,
          colorText: Colors.red,
        );
        return;
      }

      if (textController.text.length > maxTextLength) {
        Get.snackbar(
          'Error',
          'Post content exceeds maximum length of $maxTextLength characters',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.white,
          colorText: Colors.red,
        );
        return;
      }

      isLoading.value = true;

      if (LoginManager.instance.currentUserId.isEmpty) {
        throw Exception('User not authenticated');
      }

      // Upload images if any
      List<String> imageUrls = [];
      if (selectedImages.isNotEmpty) {
        imageUrls = await _uploadImagesToFirebase(selectedImages);
      }

      // Generate document reference with ID first
      DocumentReference docRef = _firebaseFirestore.collection('posts').doc();
      String postId = docRef.id;

      // Create post data with postId included
      Map<String, dynamic> postData = {
        'postId': postId,
        'userId': LoginManager.instance.currentUserId,
        'username': userController.user.value!.username,
        'phoneNo': LoginManager.instance.phoneNumber.value,
        'college': userController.user.value!.college.toJson(),
        'postContent': textController.text.trim(),
        'imageUrls': imageUrls,
        'likes': 0,
        'comments': 0,
        'poops': 0,
        "poopBy": [],
        'likedBy': [],
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
        'isHot': false,
      };

      // Single write operation
      await docRef.set(postData);

      isLoading.value = false;

      // Clean up temporary cropped files
      for (var file in selectedImages) {
        if (file.existsSync()) {
          file.deleteSync();
        }
      }

      // Reset form
      textController.clear();
      selectedImages.clear();
      textLength.value = 0;

      Get.back();
      Get.back();
    } catch (e) {
      LoggerService.logError(e.toString());
      isLoading.value = false;
      Get.snackbar(
        'Error',
        'Failed to create post!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.white,
        colorText: Colors.red,
      );
    }
  }
}
