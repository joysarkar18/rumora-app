// New widget that accepts File images for preview
import 'dart:io';

import 'package:avatar_plus/avatar_plus.dart';
import 'package:campus_crush_app/app/utils/app_colors.dart';
import 'package:campus_crush_app/app/utils/text_styles.dart';
import 'package:campus_crush_app/constants/assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class FileImagePostCard extends StatefulWidget {
  final String username;
  final String university;
  final String timeAgo;
  final String postContent;
  final int likes;
  final int comments;
  final int poops;
  final List<File> imageFiles;

  const FileImagePostCard({
    super.key,
    this.username = "You",
    this.university = "Your College",
    this.timeAgo = "now",
    this.postContent = "",
    this.likes = 0,
    this.comments = 0,
    this.poops = 0,
    this.imageFiles = const [],
  });

  @override
  State<FileImagePostCard> createState() => _FileImagePostCardState();
}

class _FileImagePostCardState extends State<FileImagePostCard> {
  late PageController _pageController;
  int _currentImageIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(12),
              child: Column(
                children: [
                  // Header with avatar and user info
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AvatarPlus(widget.username, height: 40, width: 40),
                      SizedBox(width: 4),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(height: 4),
                            Text(
                              widget.username,
                              style: AppTextStyles.style14w500(
                                color: AppColors.grayBlue,
                              ),
                            ),
                            SizedBox(height: 2),
                            Text(
                              widget.university,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppTextStyles.style12w400(
                                color: AppColors.grayBlue,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 10.w),
                      Text(
                        widget.timeAgo,
                        style: AppTextStyles.style12w600(
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),

                  // Post content with images carousel
                  Container(
                    margin: EdgeInsets.only(top: 10),
                    decoration: BoxDecoration(
                      color: AppColors.lightPink.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Text content
                        Padding(
                          padding: EdgeInsets.all(12),
                          child: Text(
                            widget.postContent,
                            style: AppTextStyles.style14w500(
                              color: AppColors.grayBlue,
                            ),
                          ),
                        ),
                        // Images carousel with File images
                        if (widget.imageFiles.isNotEmpty)
                          _buildFileImagesCarousel(widget.imageFiles),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Engagement stats
            Padding(
              padding: EdgeInsets.all(12),
              child: Row(
                children: [
                  SizedBox(width: 4),
                  Icon(Icons.favorite_border_rounded),
                  SizedBox(width: 4),
                  Text(
                    "${widget.likes}",
                    style: AppTextStyles.style15w700(color: AppColors.primary),
                  ),
                  SizedBox(width: 16),
                  SvgPicture.asset(Assets.iconsComment, height: 21),
                  SizedBox(width: 4),
                  Text(
                    "${widget.comments}",
                    style: AppTextStyles.style15w700(color: AppColors.primary),
                  ),
                  SizedBox(width: 16),
                  SvgPicture.asset(
                    Assets.iconsPoopFilled,
                    height: 22,
                    color: AppColors.orangePrimary,
                  ),
                  SizedBox(width: 4),
                  Text(
                    "${widget.poops}",
                    style: AppTextStyles.style15w700(
                      color: AppColors.orangePrimary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFileImagesCarousel(List<File> files) {
    if (files.isEmpty) return SizedBox.shrink();

    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: AspectRatio(
        aspectRatio: 1,
        child: Stack(
          children: [
            // Carousel with square images
            PageView.builder(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentImageIndex = index;
                });
              },
              itemCount: files.length,
              itemBuilder: (context, index) {
                return Image.file(
                  files[index],
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                );
              },
            ),
            // Indicator dots overlay
            if (files.length > 1)
              Positioned(
                bottom: 12,
                left: 0,
                right: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    files.length,
                    (index) => GestureDetector(
                      onTap: () {
                        _pageController.animateToPage(
                          index,
                          duration: Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      },
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 4),
                        height: 6,
                        width: _currentImageIndex == index ? 20 : 6,
                        decoration: BoxDecoration(
                          color: _currentImageIndex == index
                              ? AppColors.primary.withAlpha(140)
                              : Colors.white.withValues(alpha: 0.6),
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
