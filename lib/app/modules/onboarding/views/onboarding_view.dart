import 'package:campus_crush_app/app/common/widgets/common_button.dart';
import 'package:campus_crush_app/app/modules/onboarding/controllers/onboarding_controller.dart';
import 'package:campus_crush_app/app/utils/app_colors.dart';
import 'package:campus_crush_app/app/utils/text_styles.dart';
import 'package:campus_crush_app/constants/assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class OnboardingView extends GetView<OnboardingController> {
  const OnboardingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<OnboardingController>(
        init: OnboardingController(),
        builder: (controller) {
          return Column(
            children: [
              SvgPicture.asset(
                Assets.iconsOnboardingTopImage,
                width: Get.width,
              ),
              SizedBox(height: 10.h),
              Expanded(
                child: Column(
                  children: [
                    // PageView for titles and subtitles
                    SizedBox(
                      height: 20.h,
                      child: PageView.builder(
                        controller: controller.pageController,
                        onPageChanged: controller.onPageChanged,
                        itemCount: controller.onboardingData.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16.sp),
                            child: Column(
                              children: [
                                Text(
                                  controller.onboardingData[index]['title']!,
                                  style: AppTextStyles.style22w900(
                                    color: AppColors.grayBlue,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                SizedBox(height: 2.h),
                                Text(
                                  controller.onboardingData[index]['subtitle']!,
                                  textAlign: TextAlign.center,
                                  style: AppTextStyles.style15w500(
                                    color: AppColors.grayMedium,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    // Page Indicators
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        controller.onboardingData.length,
                        (index) => AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          margin: EdgeInsets.symmetric(horizontal: 1.w),
                          height: 1.h,
                          width: controller.currentPage.value == index
                              ? 4.w
                              : 2.w,
                          decoration: BoxDecoration(
                            color: controller.currentPage.value == index
                                ? AppColors.pink
                                : AppColors.grayMedium.withValues(alpha: 0.3),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                    const Spacer(),
                    // Get Started Button
                    Padding(
                      padding: EdgeInsets.all(16.sp),
                      child: CommonButton(
                        enabled: true,
                        onPressed: controller.onGetStarted,
                        text: "Get Started",
                      ),
                    ),
                    SizedBox(height: 1.h),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
