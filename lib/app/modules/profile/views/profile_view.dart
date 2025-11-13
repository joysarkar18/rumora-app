import 'package:campus_crush_app/app/modules/navbar/controllers/user_controller.dart';
import 'package:campus_crush_app/app/modules/profile/views/intrest_view.dart';
import 'package:campus_crush_app/app/modules/profile/views/widgets/animated_profile_rings.dart';
import 'package:campus_crush_app/app/utils/app_colors.dart';
import 'package:campus_crush_app/constants/assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});

  // Interest configuration with emoji and color - SYNCHRONIZED with EditInterestsView
  final Map<String, Map<String, dynamic>> interestConfig = const {
    // Creative Arts
    'Painting': {'emoji': '🎨', 'color': 'blue'},
    'Photography': {'emoji': '📷', 'color': 'cyan'},
    'Drawing': {'emoji': '✏️', 'color': 'purple'},
    'Art': {'emoji': '🖼️', 'color': 'pink'},
    'Crafting': {'emoji': '✂️', 'color': 'orange'},
    'Design': {'emoji': '🎯', 'color': 'cyan'},

    // Music & Performance
    'Singing': {'emoji': '🎤', 'color': 'blue'},
    'Music': {'emoji': '🎵', 'color': 'pink'},
    'Dancing': {'emoji': '💃', 'color': 'purple'},
    'Guitar': {'emoji': '🎸', 'color': 'red'},
    'Piano': {'emoji': '🎹', 'color': 'blue'},
    'DJ': {'emoji': '🎧', 'color': 'purple'},

    // Sports & Fitness
    'Yoga': {'emoji': '🧘', 'color': 'pink'},
    'Fitness': {'emoji': '💪', 'color': 'orange'},
    'Sports': {'emoji': '⚽', 'color': 'green'},
    'Running': {'emoji': '🏃', 'color': 'orange'},
    'Cycling': {'emoji': '🚴', 'color': 'green'},
    'Swimming': {'emoji': '🏊', 'color': 'blue'},
    'Hiking': {'emoji': '🥾', 'color': 'green'},
    'Basketball': {'emoji': '🏀', 'color': 'orange'},
    'Cricket': {'emoji': '🏏', 'color': 'green'},
    'Football': {'emoji': '⚽', 'color': 'green'},
    'Badminton': {'emoji': '🏸', 'color': 'cyan'},
    'Gym': {'emoji': '🏋️', 'color': 'red'},

    // Entertainment
    'Movie': {'emoji': '🎬', 'color': 'purple'},
    'Gaming': {'emoji': '🎮', 'color': 'green'},
    'Anime': {'emoji': '🎌', 'color': 'red'},
    'Netflix': {'emoji': '📺', 'color': 'red'},
    'Comedy': {'emoji': '😂', 'color': 'orange'},
    'Theater': {'emoji': '🎭', 'color': 'purple'},

    // Intellectual
    'Reading': {'emoji': '📚', 'color': 'orange'},
    'Writing': {'emoji': '✍️', 'color': 'cyan'},
    'Poetry': {'emoji': '📝', 'color': 'purple'},
    'Technology': {'emoji': '💻', 'color': 'blue'},
    'Science': {'emoji': '🔬', 'color': 'cyan'},
    'Astronomy': {'emoji': '🔭', 'color': 'purple'},
    'Chess': {'emoji': '♟️', 'color': 'blue'},
    'Coding': {'emoji': '👨‍💻', 'color': 'green'},
    'Philosophy': {'emoji': '🤔', 'color': 'purple'},

    // Lifestyle
    'Fashion': {'emoji': '👗', 'color': 'pink'},
    'Cooking': {'emoji': '🍳', 'color': 'red'},
    'Baking': {'emoji': '🧁', 'color': 'pink'},
    'Foodie': {'emoji': '🍕', 'color': 'red'},
    'Coffee': {'emoji': '☕', 'color': 'orange'},
    'Traveling': {'emoji': '✈️', 'color': 'blue'},
    'Adventure': {'emoji': '🏔️', 'color': 'green'},
    'Nature': {'emoji': '🌿', 'color': 'green'},
    'Gardening': {'emoji': '🌻', 'color': 'green'},
    'Pets': {'emoji': '🐾', 'color': 'pink'},
    'Cars': {'emoji': '🚗', 'color': 'red'},
    'Bikes': {'emoji': '🏍️', 'color': 'orange'},

    // Wellness
    'Meditation': {'emoji': '🧘‍♀️', 'color': 'purple'},
    'Mindfulness': {'emoji': '🧠', 'color': 'cyan'},
    'Spa': {'emoji': '💆', 'color': 'pink'},

    // Social
    'Volunteering': {'emoji': '🤝', 'color': 'green'},
    'Networking': {'emoji': '👥', 'color': 'blue'},
    'Partying': {'emoji': '🎉', 'color': 'purple'},
    'Socializing': {'emoji': '💬', 'color': 'orange'},

    // Other
    'Shopping': {'emoji': '🛍️', 'color': 'pink'},
    'DIY': {'emoji': '🔨', 'color': 'orange'},
    'Podcasts': {'emoji': '🎙️', 'color': 'purple'},
    'Blogging': {'emoji': '📱', 'color': 'cyan'},
  };

  Color _getColorFromString(String colorName) {
    switch (colorName) {
      case 'pink':
        return AppColors.pink;
      case 'blue':
        return Colors.blue;
      case 'purple':
        return Colors.purple;
      case 'cyan':
        return Colors.cyan;
      case 'green':
        return Colors.green;
      case 'orange':
        return Colors.orange;
      case 'red':
        return Colors.red;
      default:
        return AppColors.primary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final UserController userController = Get.find<UserController>();

    return Scaffold(
      body: Obx(() {
        final user = userController.user.value;
        final userInterests = user?.interests ?? [];

        return SingleChildScrollView(
          child: SizedBox(
            width: 100.w,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // Animated Profile with Rings
                  AnimatedProfileRings(
                    profileImageUrl: user?.username ?? "",
                    ringCount: 2,
                    bubbleCount: 10,
                    primaryColor: AppColors.primary,
                    accentColor: AppColors.pink,
                  ),

                  // Profile Information
                  Text(
                    user?.username ?? 'Unknown User',
                    style: TextStyle(
                      fontSize: 22.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      user?.college.name ?? 'No College',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 15.sp,
                        color: Colors.grey[600],
                      ),
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
                        onPressed: () {
                          Get.to(() => const EditInterestsView());
                        },
                        icon: SvgPicture.asset(
                          Assets.iconsEdit,
                          width: 18,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 1.h),

                  // Interest Tags - Dynamic from user data
                  if (userInterests.isEmpty)
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 2.h),
                      child: Column(
                        children: [
                          Icon(
                            Icons.interests_outlined,
                            size: 48,
                            color: Colors.grey[400],
                          ),
                          SizedBox(height: 1.h),
                          Text(
                            'No interests added yet',
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: Colors.grey[600],
                            ),
                          ),
                          SizedBox(height: 0.5.h),
                          TextButton(
                            onPressed: () {
                              Get.to(() => const EditInterestsView());
                            },
                            child: Text(
                              'Add your interests',
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: AppColors.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  else
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Wrap(
                        spacing: 12,
                        runSpacing: 12,
                        alignment: WrapAlignment.start,
                        runAlignment: WrapAlignment.start,
                        children: userInterests.map((interest) {
                          final config = interestConfig[interest];
                          if (config == null) {
                            // Fallback for interests not in config
                            return _buildInterestChip(
                              interest,
                              '✨',
                              AppColors.primary.withAlpha(50),
                              AppColors.primary,
                            );
                          }

                          final color = _getColorFromString(config['color']);
                          return _buildInterestChip(
                            interest,
                            config['emoji'],
                            color.withAlpha(50),
                            color,
                          );
                        }).toList(),
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      }),
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
