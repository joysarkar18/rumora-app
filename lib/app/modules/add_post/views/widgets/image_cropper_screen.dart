import 'dart:io';
import 'dart:typed_data';

import 'package:campus_crush_app/app/utils/app_colors.dart';
import 'package:campus_crush_app/app/utils/text_styles.dart';
import 'package:crop_your_image/crop_your_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image/image.dart' as img;

class ImageCropperScreen extends StatefulWidget {
  final File imageFile;

  const ImageCropperScreen({super.key, required this.imageFile});

  @override
  State<ImageCropperScreen> createState() => _ImageCropperScreenState();
}

class _ImageCropperScreenState extends State<ImageCropperScreen> {
  final _cropController = CropController();

  Uint8List? _imageData;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    // Read the file data into memory once
    _imageData = widget.imageFile.readAsBytesSync();
  }

  /// This function is called by the onCropped callback after cropping.
  /// It contains your original logic for resizing and compressing the image.
  Future<void> _processAndSaveChanges(Uint8List croppedData) async {
    try {
      // Decode the cropped data
      img.Image? image = img.decodeImage(croppedData);
      if (image == null) {
        throw Exception('Failed to decode image');
      }

      // Resize if needed (same as your original logic)
      if (image.width > 1080) {
        image = img.copyResize(image, width: 1080, height: 1080);
      }

      // Compress (same as your original logic)
      int quality = 92;
      List<int> jpg = img.encodeJpg(image, quality: quality);

      while (jpg.length > 500 * 1024 && quality > 60) {
        quality -= 5;
        jpg = img.encodeJpg(image, quality: quality);
      }

      if (jpg.length > 500 * 1024) {
        int targetSize = 900;
        while (targetSize >= 600 && jpg.length > 500 * 1024) {
          img.Image resized = img.copyResize(
            image,
            width: targetSize,
            height: targetSize,
          );
          jpg = img.encodeJpg(resized, quality: 85);
          targetSize -= 50;
        }
      }

      // Save the final compressed bytes to a file
      final output = File(
        '${widget.imageFile.parent.path}/cropped_${DateTime.now().millisecondsSinceEpoch}.jpg',
      );
      await output.writeAsBytes(jpg);

      // Go back and return the new file
      Get.back(result: output);
    } catch (e) {
      if (mounted) {
        setState(() => _isSaving = false);
      }
      Get.snackbar(
        'Error',
        'Failed to save cropped image: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'Crop to Square',
          style: AppTextStyles.style18w700(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: _imageData == null
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  child: Crop(
                    controller: _cropController,
                    image: _imageData!,
                    aspectRatio: 1.0,
                    onCropped: (croppedData) {
                      if (croppedData is CropSuccess) {
                        _processAndSaveChanges(croppedData.croppedImage);
                      }
                    },
                    // --- UI Customization ---
                    baseColor: Colors.black,
                    maskColor: Colors.black.withValues(alpha: 0.8),
                    cornerDotBuilder: (size, edge) =>
                        const DotControl(color: AppColors.primary),
                    withCircleUi: false, // Use a square crop area
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(16),
                  color: Colors.grey[900],
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Pinch to zoom • Drag to select',
                        style: AppTextStyles.style12w400(color: Colors.white70),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: _isSaving ? null : () => Get.back(),
                              style: OutlinedButton.styleFrom(
                                side: BorderSide(
                                  color: _isSaving ? Colors.grey : Colors.white,
                                ),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                ),
                              ),
                              child: Text(
                                'Cancel',
                                style: AppTextStyles.style14w600(
                                  color: _isSaving ? Colors.grey : Colors.white,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: _isSaving
                                  ? null
                                  : () {
                                      setState(() => _isSaving = true);
                                      // This starts the cropping process and will trigger the onCropped callback.
                                      _cropController.crop();
                                    },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                ),
                              ),
                              child: _isSaving
                                  ? const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : Text(
                                      'Crop & Save',
                                      style: AppTextStyles.style14w600(
                                        color: Colors.white,
                                      ),
                                    ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
