import 'package:campus_crush_app/app/modules/navbar/controllers/user_controller.dart';
import 'package:campus_crush_app/app/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class EditInterestsView extends StatefulWidget {
  const EditInterestsView({super.key});

  @override
  State<EditInterestsView> createState() => _EditInterestsViewState();
}

class _EditInterestsViewState extends State<EditInterestsView> {
  final UserController userController = Get.find<UserController>();

  // List of selected interests (initialize with user's current interests)
  late List<String> selectedInterests;

  // Expanded list of interests with categories
  final List<Map<String, String>> allInterests = [
    // Creative Arts
    {'name': 'Painting', 'emoji': '🎨', 'color': 'blue'},
    {'name': 'Photography', 'emoji': '📷', 'color': 'cyan'},
    {'name': 'Drawing', 'emoji': '✏️', 'color': 'purple'},
    {'name': 'Art', 'emoji': '🖼️', 'color': 'pink'},
    {'name': 'Crafting', 'emoji': '✂️', 'color': 'orange'},
    {'name': 'Design', 'emoji': '🎯', 'color': 'cyan'},

    // Music & Performance
    {'name': 'Singing', 'emoji': '🎤', 'color': 'blue'},
    {'name': 'Music', 'emoji': '🎵', 'color': 'pink'},
    {'name': 'Dancing', 'emoji': '💃', 'color': 'purple'},
    {'name': 'Guitar', 'emoji': '🎸', 'color': 'red'},
    {'name': 'Piano', 'emoji': '🎹', 'color': 'blue'},
    {'name': 'DJ', 'emoji': '🎧', 'color': 'purple'},

    // Sports & Fitness
    {'name': 'Yoga', 'emoji': '🧘', 'color': 'pink'},
    {'name': 'Fitness', 'emoji': '💪', 'color': 'orange'},
    {'name': 'Sports', 'emoji': '⚽', 'color': 'green'},
    {'name': 'Running', 'emoji': '🏃', 'color': 'orange'},
    {'name': 'Cycling', 'emoji': '🚴', 'color': 'green'},
    {'name': 'Swimming', 'emoji': '🏊', 'color': 'blue'},
    {'name': 'Hiking', 'emoji': '🥾', 'color': 'green'},
    {'name': 'Basketball', 'emoji': '🏀', 'color': 'orange'},
    {'name': 'Cricket', 'emoji': '🏏', 'color': 'green'},
    {'name': 'Football', 'emoji': '⚽', 'color': 'green'},
    {'name': 'Badminton', 'emoji': '🏸', 'color': 'cyan'},
    {'name': 'Gym', 'emoji': '🏋️', 'color': 'red'},

    // Entertainment
    {'name': 'Movie', 'emoji': '🎬', 'color': 'purple'},
    {'name': 'Gaming', 'emoji': '🎮', 'color': 'green'},
    {'name': 'Anime', 'emoji': '🎌', 'color': 'red'},
    {'name': 'Netflix', 'emoji': '📺', 'color': 'red'},
    {'name': 'Comedy', 'emoji': '😂', 'color': 'orange'},
    {'name': 'Theater', 'emoji': '🎭', 'color': 'purple'},

    // Intellectual
    {'name': 'Reading', 'emoji': '📚', 'color': 'orange'},
    {'name': 'Writing', 'emoji': '✍️', 'color': 'cyan'},
    {'name': 'Poetry', 'emoji': '📝', 'color': 'purple'},
    {'name': 'Technology', 'emoji': '💻', 'color': 'blue'},
    {'name': 'Science', 'emoji': '🔬', 'color': 'cyan'},
    {'name': 'Astronomy', 'emoji': '🔭', 'color': 'purple'},
    {'name': 'Chess', 'emoji': '♟️', 'color': 'blue'},
    {'name': 'Coding', 'emoji': '👨‍💻', 'color': 'green'},
    {'name': 'Philosophy', 'emoji': '🤔', 'color': 'purple'},

    // Lifestyle
    {'name': 'Fashion', 'emoji': '👗', 'color': 'pink'},
    {'name': 'Cooking', 'emoji': '🍳', 'color': 'red'},
    {'name': 'Baking', 'emoji': '🧁', 'color': 'pink'},
    {'name': 'Foodie', 'emoji': '🍕', 'color': 'red'},
    {'name': 'Coffee', 'emoji': '☕', 'color': 'orange'},
    {'name': 'Traveling', 'emoji': '✈️', 'color': 'blue'},
    {'name': 'Adventure', 'emoji': '🏔️', 'color': 'green'},
    {'name': 'Nature', 'emoji': '🌿', 'color': 'green'},
    {'name': 'Gardening', 'emoji': '🌻', 'color': 'green'},
    {'name': 'Pets', 'emoji': '🐾', 'color': 'pink'},
    {'name': 'Cars', 'emoji': '🚗', 'color': 'red'},
    {'name': 'Bikes', 'emoji': '🏍️', 'color': 'orange'},

    // Wellness
    {'name': 'Meditation', 'emoji': '🧘‍♀️', 'color': 'purple'},
    {'name': 'Mindfulness', 'emoji': '🧠', 'color': 'cyan'},
    {'name': 'Spa', 'emoji': '💆', 'color': 'pink'},

    // Social
    {'name': 'Volunteering', 'emoji': '🤝', 'color': 'green'},
    {'name': 'Networking', 'emoji': '👥', 'color': 'blue'},
    {'name': 'Partying', 'emoji': '🎉', 'color': 'purple'},
    {'name': 'Socializing', 'emoji': '💬', 'color': 'orange'},

    // Other
    {'name': 'Shopping', 'emoji': '🛍️', 'color': 'pink'},
    {'name': 'DIY', 'emoji': '🔨', 'color': 'orange'},
    {'name': 'Podcasts', 'emoji': '🎙️', 'color': 'purple'},
    {'name': 'Blogging', 'emoji': '📱', 'color': 'cyan'},
  ];

  @override
  void initState() {
    super.initState();
    // Initialize with user's current interests from user model
    selectedInterests = List<String>.from(
      userController.user.value?.interests ?? [],
    );
  }

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

  void _toggleInterest(String interestName) {
    setState(() {
      if (selectedInterests.contains(interestName)) {
        selectedInterests.remove(interestName);
      } else {
        // Optional: Add a maximum limit
        if (selectedInterests.length < 20) {
          selectedInterests.add(interestName);
        } else {
          Get.snackbar(
            'Limit Reached',
            'You can select up to 20 interests',
            backgroundColor: AppColors.primary,
            colorText: Colors.white,
            snackPosition: SnackPosition.BOTTOM,
            duration: Duration(seconds: 2),
          );
        }
      }
    });
  }

  Future<void> _saveInterests() async {
    if (selectedInterests.isEmpty) {
      Get.snackbar(
        'No Interests Selected',
        'Please select at least one interest',
        backgroundColor: Colors.orange,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        duration: Duration(seconds: 2),
      );
      return;
    }

    // Call the UserController method to update interests
    final success = await userController.updateUserInterests(selectedInterests);

    // Navigate back only if successful
    if (success && mounted) {
      Navigator.pop(context);

      // Show success message after navigation
      Future.delayed(Duration(milliseconds: 200), () {
        Get.snackbar(
          'Success',
          'Your interests have been updated!',
          backgroundColor: Colors.green,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
          duration: Duration(seconds: 2),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back, color: Colors.black87),
        ),
        title: Text(
          'Edit Interests',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        centerTitle: true,
        actions: [
          Obx(() {
            final isLoading = userController.isLoading.value;

            if (isLoading) {
              return Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        AppColors.primary,
                      ),
                    ),
                  ),
                ),
              );
            } else {
              return TextButton(
                onPressed: _saveInterests,
                child: Text(
                  'Save',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
              );
            }
          }),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Section
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.primary.withAlpha(20),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: AppColors.primary,
                      size: 24,
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Select your interests to help others know you better',
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 2.h),

              // Selected Count and Quick Actions Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Selected: ${selectedInterests.length}/20',
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w600,
                      color: selectedInterests.isEmpty
                          ? Colors.grey[700]
                          : AppColors.primary,
                    ),
                  ),
                  if (selectedInterests.isNotEmpty)
                    TextButton.icon(
                      onPressed: () {
                        setState(() {
                          selectedInterests.clear();
                        });
                      },
                      icon: Icon(Icons.clear_all, color: Colors.red, size: 18),
                      label: Text(
                        'Clear All',
                        style: TextStyle(fontSize: 14.sp, color: Colors.red),
                      ),
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.symmetric(horizontal: 8),
                      ),
                    ),
                ],
              ),

              SizedBox(height: 2.h),

              // Interest Grid
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: allInterests.map((interest) {
                  final isSelected = selectedInterests.contains(
                    interest['name'],
                  );
                  final color = _getColorFromString(interest['color']!);

                  return GestureDetector(
                    onTap: () => _toggleInterest(interest['name']!),
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 200),
                      curve: Curves.easeInOut,
                      padding: EdgeInsets.symmetric(
                        horizontal: 4.w,
                        vertical: 1.h,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? color.withAlpha(50)
                            : Colors.grey.withAlpha(30),
                        borderRadius: BorderRadius.circular(25),
                        border: Border.all(
                          color: isSelected
                              ? color.withAlpha(80)
                              : Colors.grey.withAlpha(80),
                          width: isSelected ? 2 : 1,
                        ),
                        boxShadow: isSelected
                            ? [
                                BoxShadow(
                                  color: color.withAlpha(30),
                                  blurRadius: 8,
                                  offset: Offset(0, 2),
                                ),
                              ]
                            : null,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            interest['emoji']!,
                            style: TextStyle(fontSize: 18.sp),
                          ),
                          SizedBox(width: 8),
                          Text(
                            interest['name']!,
                            style: TextStyle(
                              fontSize: 15.sp,
                              fontWeight: isSelected
                                  ? FontWeight.w600
                                  : FontWeight.w500,
                              color: isSelected
                                  ? color.withAlpha(255)
                                  : Colors.grey[700],
                            ),
                          ),
                          if (isSelected) ...[
                            SizedBox(width: 6),
                            Icon(Icons.check_circle, size: 16, color: color),
                          ],
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),

              SizedBox(height: 3.h),

              // Bottom Save Button (Mobile friendly)
              Obx(() {
                final isLoading = userController.isLoading.value;

                if (isLoading) {
                  return SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary.withAlpha(150),
                        padding: EdgeInsets.symmetric(vertical: 1.5.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 2,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                            ),
                          ),
                          SizedBox(width: 12),
                          Text(
                            'Saving...',
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                } else {
                  return SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _saveInterests,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        padding: EdgeInsets.symmetric(vertical: 1.5.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 2,
                      ),
                      child: Text(
                        'Save Interests',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  );
                }
              }),
            ],
          ),
        ),
      ),
    );
  }
}
