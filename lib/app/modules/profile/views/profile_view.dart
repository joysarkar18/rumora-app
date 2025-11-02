import 'package:campus_crush_app/app/modules/navbar/controllers/user_controller.dart';
import 'package:campus_crush_app/app/modules/profile/views/widgets/animated_profile_rings.dart';
import 'package:campus_crush_app/app/utils/app_colors.dart';
import 'package:campus_crush_app/app/utils/text_styles.dart';
import 'package:campus_crush_app/constants/assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final UserController userController = Get.find<UserController>();
    return Scaffold(
      body: SizedBox(
        width: 100.w,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Animated Profile with Rings
              AnimatedProfileRings(
                profileImageUrl:
                    userController.user.value?.username ??
                    "", // Replace with your image
                ringCount: 2,
                bubbleCount: 10,
                primaryColor: AppColors.primary,
                accentColor: AppColors.pink,
              ),

              // Profile Information
              Text(
                '${userController.user.value?.username}',
                style: TextStyle(
                  fontSize: 22.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  '${userController.user.value?.college.name}',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 15.sp, color: Colors.grey[600]),
                ),
              ),
              SizedBox(height: 1.3.h),
              // Stats or additional info
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildStatCard('Posts', '128'),
                  _buildStatCard('3rd Year', 'B.Tech'),
                  _buildStatCard('Cap Coins', '2442'),
                ],
              ),

              SizedBox(height: 1.4.h),

              // My Interest Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'My Interests',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),

                  IconButton(
                    onPressed: () {},
                    icon: SvgPicture.asset(
                      Assets.iconsEdit,
                      width: 18,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),

              SizedBox(height: 1.h),

              // Interest Tags
              Align(
                alignment: Alignment.centerLeft,
                child: Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  alignment: WrapAlignment.start,
                  runAlignment: WrapAlignment.start,
                  children: [
                    _buildInterestChip(
                      'Yoga',
                      '🧘',
                      AppColors.pink.withAlpha(50),
                      AppColors.pink,
                    ),
                    _buildInterestChip(
                      'Singing',
                      '🎤',
                      Colors.blue.withAlpha(50),
                      Colors.blue,
                    ),

                    _buildInterestChip(
                      'Movie',
                      '🎬',
                      Colors.purple.withAlpha(50),
                      Colors.purple,
                    ),
                    _buildInterestChip(
                      'Photography',
                      '📷',
                      Colors.cyan.withAlpha(50),
                      Colors.cyan,
                    ),
                    _buildInterestChip(
                      'Fashion',
                      '👗',
                      AppColors.pink.withAlpha(50),
                      AppColors.pink,
                    ),
                    _buildInterestChip(
                      'Painting',
                      '🎨',
                      Colors.blue.withAlpha(50),
                      Colors.blue,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(String label, String value) {
    return Container(
      width: 28.w,
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.3.h),
      decoration: BoxDecoration(
        color: AppColors.primary.withAlpha(20),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
          Text(
            label,
            style: TextStyle(fontSize: 14.sp, color: AppColors.primary),
          ),
        ],
      ),
    );
  }

  Widget _buildInterestChip(
    String label,
    String emoji,
    Color backgroundColor,
    Color textColor,
  ) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 0.3.h),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: textColor.withAlpha(80), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(emoji, style: TextStyle(fontSize: 18.sp)),
          SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 15.sp,
              fontWeight: FontWeight.w500,
              color: textColor.withAlpha(255),
            ),
          ),
        ],
      ),
    );
  }
}
