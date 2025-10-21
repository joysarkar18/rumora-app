import 'package:avatar_plus/avatar_plus.dart';
import 'package:campus_crush_app/app/common/widgets/common_button.dart';
import 'package:campus_crush_app/app/utils/app_colors.dart';
import 'package:campus_crush_app/app/utils/text_styles.dart';
import 'package:campus_crush_app/constants/assets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../controllers/choose_username_controller.dart';

class ChooseUsernameView extends GetView<ChooseUsernameController> {
  const ChooseUsernameView({super.key});

  @override
  Widget build(BuildContext context) {
    final diceKey = GlobalKey();

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
                SizedBox(height: 5.h),
                Text(
                  "Your secret identity?",
                  style: AppTextStyles.style22w700(color: AppColors.primary),
                ),
                SizedBox(height: 1.h),
                Text(
                  "This is how others will see you. You can \nchange it anytime you like!",
                  textAlign: TextAlign.center,
                  style: AppTextStyles.style15w400(color: AppColors.primary),
                ),
                SizedBox(height: 4.h),
                Obx(
                  () => Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AvatarPlus(
                        controller.username.value,
                        height: 20.w,
                        width: 20.w,
                      ),
                      SizedBox(width: 3.w),
                      Container(
                        height: 60,
                        width: 50.w,
                        decoration: BoxDecoration(
                          color: AppColorDark.brightPink.withAlpha(95),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Text(
                            controller.username.value,
                            style: AppTextStyles.style21w700(
                              color: AppColors.primary,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 2.h),
                SizedBox(height: 2.h),
                Obx(
                  () => GestureDetector(
                    key: diceKey,
                    onTap: controller.isAnimating.value
                        ? null
                        : controller.onDiceTap,
                    child: Opacity(
                      opacity: controller.isAnimating.value ? 0.5 : 1.0,
                      child: LottieBuilder.asset(
                        Assets.animationsDice,
                        width: 20.w,
                        animate: controller.isAnimating.value,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Tooltip(
                  message: "Tap to generate a new username",
                  textStyle: AppTextStyles.style13w500(color: Colors.white),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    "✨ Tap the dice to change your username",
                    style: AppTextStyles.style14w500(
                      color: AppColors.primary.withAlpha(180),
                    ),
                  ),
                ),

                Spacer(),
                Obx(
                  () => CommonButton(
                    text: "Next",
                    onPressed: controller.saveUsername,
                    isLoading: controller.isLoading.value,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
