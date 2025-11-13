import 'package:campus_crush_app/app/data/models/user_model.dart';
import 'package:campus_crush_app/app/services/logger_service.dart';
import 'package:campus_crush_app/app/services/login_manager.dart';
import 'package:campus_crush_app/app/utils/app_colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserController extends GetxController {
  final user = Rx<UserModel?>(null);
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
  }

  Future<void> fetchUser() async {
    isLoading.value = true;
    try {
      // Validate that user is logged in
      if (LoginManager.instance.currentUserId.isEmpty) {
        Get.snackbar(
          'Error',
          'User not logged in!',
          backgroundColor: AppColors.primary,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }

      // Fetch user data from Firestore
      final userData = await FirebaseFirestore.instance
          .collection("user")
          .doc(LoginManager.instance.currentUserId)
          .get();

      // Check if document exists
      if (!userData.exists) {
        Get.snackbar(
          'Error',
          'User data not found!',
          backgroundColor: AppColors.primary,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }

      final userDataAsModel = UserModel.fromFirestoreSnapshot(userData);

      LoggerService.logInfo("Got User Data");
      user.value = userDataAsModel;
    } on FirebaseException catch (e) {
      Get.snackbar(
        'Error',
        'Firebase error: ${e.message ?? "Failed to fetch user data"}',
        backgroundColor: AppColors.primary,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'An unexpected error occurred: ${e.toString()}',
        backgroundColor: AppColors.primary,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void setUser(UserModel userData) {
    user.value = userData;
  }

  /// Update user interests in Firebase
  /// Returns true if successful, false otherwise
  Future<bool> updateUserInterests(List<String> interests) async {
    try {
      isLoading.value = true;

      // Validate that user is logged in
      if (LoginManager.instance.currentUserId.isEmpty) {
        isLoading.value = false;
        Get.snackbar(
          'Error',
          'User not logged in!',
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
        return false;
      }

      // Validate user exists
      if (user.value == null) {
        isLoading.value = false;
        Get.snackbar(
          'Error',
          'User data not found!',
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
        return false;
      }

      // Update interests in Firestore
      await FirebaseFirestore.instance
          .collection("user")
          .doc(LoginManager.instance.currentUserId)
          .update({
            'interests': interests,
            'updatedAt': FieldValue.serverTimestamp(),
          });

      // Update local user model immediately using Freezed's copyWith
      user.value = user.value!.copyWith(
        interests: interests,
        updatedAt: DateTime.now(), // Update timestamp locally
      );

      LoggerService.logInfo("Interests updated successfully");

      // Set loading to false BEFORE returning
      isLoading.value = false;

      return true; // Success - let the UI handle navigation and showing snackbar
    } on FirebaseException catch (e) {
      isLoading.value = false;
      Get.snackbar(
        'Error',
        'Firebase error: ${e.message ?? "Failed to update interests"}',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    } catch (e) {
      isLoading.value = false;
      Get.snackbar(
        'Error',
        'An unexpected error occurred: ${e.toString()}',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }
  }
}
