import 'dart:io';

import 'package:campus_crush_app/app/common/widgets/common_button.dart';
import 'package:campus_crush_app/app/modules/add_post/views/widgets/file_image_post_card.dart';
import 'package:campus_crush_app/app/utils/app_colors.dart';
import 'package:campus_crush_app/app/utils/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../controllers/add_post_controller.dart';

class AddPostView extends GetView<AddPostController> {
  const AddPostView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 2.h),
              _buildTextInputSection(),
              SizedBox(height: 3.h),
              _buildImageGrid(),
              SizedBox(height: 8.h),
              _buildPreviewButton(),
              SizedBox(height: 3.h),
            ],
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0.5,
      leading: Obx(
        () => IconButton(
          icon: Icon(Icons.arrow_back_ios_new, size: 18),
          onPressed: controller.isLoading.value ? null : () => Get.back(),
        ),
      ),
      title: Text(
        'Create Post',
        style: AppTextStyles.style18w700(color: AppColors.grayBlue),
      ),
      centerTitle: true,
    );
  }

  Widget _buildTextInputSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 2.w, bottom: 1.5.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "What's on your mind?",
                style: AppTextStyles.style17w700(color: AppColors.grayBlue),
              ),
              SizedBox(height: 0.5.h),
              Text(
                'Share your thoughts with the campus community',
                style: AppTextStyles.style12w400(
                  color: AppColors.grayBlue.withValues(alpha: 0.6),
                ),
              ),
            ],
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: AppColors.grayBlue.withValues(alpha: 0.1),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Obx(
            () => TextField(
              controller: controller.textController,
              enabled: !controller.isLoading.value,
              maxLines: 8,
              maxLength: 500,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(
                hintText: 'Share something interesting...',
                hintStyle: AppTextStyles.style14w400(
                  color: AppColors.grayBlue.withValues(alpha: 0.4),
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.all(4.w),
                counter: Obx(() {
                  final count = controller.textLength.value;
                  Color textColor;
                  if (count > 450) {
                    textColor = Colors.red;
                  } else if (count > 350) {
                    textColor = Colors.orange;
                  } else {
                    textColor = AppColors.primary.withValues(alpha: 0.8);
                  }
                  return Text(
                    '$count/500',
                    style: AppTextStyles.style12w600(
                      color: textColor,
                      height: 3,
                    ),
                  );
                }),
              ),
              style: AppTextStyles.style14w500(color: AppColors.grayBlue),
              onChanged: (value) => controller.updateTextLength(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildImageGrid() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 2.w, bottom: 1.5.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Add Photos',
                    style: AppTextStyles.style17w700(color: AppColors.grayBlue),
                  ),
                  SizedBox(height: 0.4.h),
                  Text(
                    'Optional • Maximum 5 photos (Square)',
                    style: AppTextStyles.style11w400(
                      color: AppColors.grayBlue.withValues(alpha: 0.5),
                    ),
                  ),
                ],
              ),
              Obx(
                () => Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: controller.selectedImages.length == 5
                        ? Colors.red.withValues(alpha: 0.1)
                        : AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${controller.selectedImages.length}/5',
                    style: AppTextStyles.style13w700(
                      color: controller.selectedImages.length == 5
                          ? Colors.red
                          : AppColors.primary,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Obx(
          () => Wrap(
            spacing: 3.w,
            runSpacing: 3.w,
            children: [
              ...controller.selectedImages.asMap().entries.map((entry) {
                int index = entry.key;
                File imageFile = entry.value;
                return _buildSquareImagePreviewItem(imageFile, index);
              }).toList(),
              if (controller.selectedImages.length < 5 &&
                  !controller.isLoading.value)
                _buildAddImageButton(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAddImageButton() {
    return GestureDetector(
      onTap: () => controller.pickImages(),
      child: Container(
        height: 22.w,
        width: 22.w,
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: AppColors.primary.withValues(alpha: 0.3),
            width: 1.5,
          ),
        ),
        child: Icon(
          Icons.add_a_photo_outlined,
          color: AppColors.primary,
          size: 28,
        ),
      ),
    );
  }

  Widget _buildSquareImagePreviewItem(File imageFile, int index) {
    return SizedBox(
      height: 22.w,
      width: 22.w,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: AppColors.primary.withValues(alpha: 0.2),
                width: 1,
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(13),
              child: Image.file(
                imageFile,
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
              ),
            ),
          ),
          Obx(
            () => controller.isLoading.value
                ? const SizedBox.shrink()
                : Positioned(
                    top: -10,
                    right: -10,
                    child: GestureDetector(
                      onTap: () => controller.removeImage(index),
                      child: Container(
                        height: 28,
                        width: 28,
                        decoration: BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.red.withValues(alpha: 0.3),
                              blurRadius: 6,
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.close_rounded,
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildPreviewButton() {
    return Obx(
      () => CommonButton(
        text: 'Preview & Post',
        onPressed:
            controller.textLength.value > 0 && !controller.isLoading.value
            ? () => _showPreviewModal()
            : null,
        isLoading: controller.isLoading.value,
        loadingWidget: const SizedBox(
          height: 22,
          width: 22,
          child: CircularProgressIndicator(
            color: Colors.white,
            strokeWidth: 2.8,
          ),
        ),
        trailingIcon: !controller.isLoading.value
            ? const Icon(
                Icons.keyboard_arrow_right_rounded,
                color: Colors.white,
                size: 20,
              )
            : null,
      ),
    );
  }

  void _showPreviewModal() {
    Get.bottomSheet(
      _buildPreviewContent(),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      enableDrag: true,
    );
  }

  Widget _buildPreviewContent() {
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.9,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: const Color(0xFFF8F9FA),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
            ),
          ),
          child: Column(
            children: [
              // Header
              Padding(
                padding: EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Preview Your Post',
                      style: AppTextStyles.style18w700(
                        color: AppColors.grayBlue,
                      ),
                    ),
                    Obx(
                      () => GestureDetector(
                        onTap: controller.isLoading.value
                            ? null
                            : () => Get.back(),
                        child: Icon(
                          Icons.close,
                          color: controller.isLoading.value
                              ? AppColors.grayBlue.withValues(alpha: 0.3)
                              : AppColors.grayBlue,
                          size: 24,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Divider(height: 1, thickness: 1),
              // Preview content using PostCard widget with file images
              Expanded(
                child: Obx(
                  () => SingleChildScrollView(
                    controller: scrollController,
                    physics: controller.isLoading.value
                        ? const NeverScrollableScrollPhysics()
                        : null,
                    child: Padding(
                      padding: EdgeInsets.all(12),
                      child: _buildPostCardPreview(),
                    ),
                  ),
                ),
              ),
              // Post Button at bottom
              Padding(
                padding: EdgeInsets.all(16),
                child: Obx(
                  () => CommonButton(
                    text: 'Post Now',
                    onPressed: controller.isLoading.value
                        ? null
                        : () => _confirmAndPost(),
                    isLoading: controller.isLoading.value,
                    loadingWidget: const SizedBox(
                      height: 22,
                      width: 22,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2.8,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPostCardPreview() {
    return FileImagePostCard(
      username: controller.userController.user.value?.username ?? "You",
      university:
          controller.userController.user.value?.college?.name ?? 'Your College',
      timeAgo: 'now',
      postContent: controller.textController.text,
      imageFiles: controller.selectedImages.toList(),
      likes: 0,
      comments: 0,
      poops: 0,
    );
  }

  void _confirmAndPost() {
    controller.createPost();
  }
}
