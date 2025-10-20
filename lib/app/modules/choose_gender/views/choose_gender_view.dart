import 'package:campus_crush_app/app/common/widgets/common_button.dart';
import 'package:campus_crush_app/app/utils/app_colors.dart';
import 'package:campus_crush_app/constants/assets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../controllers/choose_gender_controller.dart';

class ChooseGenderView extends GetView<ChooseGenderController> {
  const ChooseGenderView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SizedBox(
            width: 100.w,
            child: Column(
              children: [
                SizedBox(height: 1.h),
                Row(
                  children: [
                    SizedBox(width: 6),
                    GestureDetector(
                      onTap: () {
                        Get.back();
                      },
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.primary.withAlpha(10),
                        ),
                        child: Icon(
                          Icons.keyboard_arrow_left_rounded,
                          color: AppColors.primary,
                          size: 30,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 1.h),
                SvgPicture.asset(Assets.iconsChooseGen, width: 60.w),
                SizedBox(height: 4.h),
                Row(
                  children: [
                    Text(
                      "How do you Identify?",
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 2.h),
                // Gender Selection
                Obx(
                  () => Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _genderOption(
                        label: "Female",
                        asset: Assets.imagesFemale,
                        isSelected: controller.selectedGender.value == "Female",
                        onTap: () => controller.selectGender("Female"),
                      ),
                      _genderOption(
                        label: "Male",
                        asset: Assets.imagesMale,
                        isSelected: controller.selectedGender.value == "Male",
                        onTap: () => controller.selectGender("Male"),
                      ),
                      _genderOption(
                        label: "Others",
                        asset: Assets.imagesOthers,
                        isSelected: controller.selectedGender.value == "Others",
                        onTap: () => controller.selectGender("Others"),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 3.h),
                Row(
                  children: [
                    Text(
                      "Your Birthday?",
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 2.h),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: SizedBox(
                    height: 14.h,
                    width: 100.w,
                    child: CupertinoDatePicker(
                      mode: CupertinoDatePickerMode.date,
                      initialDateTime: DateTime(2005, 1, 1),
                      minimumDate: DateTime(1950),
                      maximumDate: DateTime.now(),
                      backgroundColor: AppColors.primary.withAlpha(10),
                      onDateTimeChanged: (DateTime newDate) {
                        controller.updateDate(newDate);
                      },
                    ),
                  ),
                ),
                Spacer(),
                Obx(
                  () => CommonButton(
                    text: "Next",
                    isLoading: controller.isLoading.value,
                    onPressed: controller.isFormValid()
                        ? () => controller.saveGenderAndBirthday()
                        : null,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Gender option widget with selection indicator
  Widget _genderOption({
    required String label,
    required String asset,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              Container(
                width: 25.w,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: isSelected
                      ? Border.all(color: AppColors.primary, width: 3)
                      : null,
                ),
                child: Image.asset(asset, width: 25.w),
              ),
              if (isSelected)
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.primary,
                  ),
                  child: Icon(Icons.check, color: Colors.white, size: 16),
                ),
            ],
          ),
          SizedBox(height: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w700,
              color: isSelected ? AppColors.primary : AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }
}
