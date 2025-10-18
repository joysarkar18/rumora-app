import 'package:campus_crush_app/app/utils/app_colors.dart';
import 'package:campus_crush_app/app/utils/text_styles.dart';
import 'package:campus_crush_app/constants/assets.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../controllers/verified_controller.dart';

class VerifiedView extends GetView<VerifiedController> {
  const VerifiedView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            LottieBuilder.asset(Assets.animationsComplete, width: 50.w),

            SizedBox(height: 1.sh),

            Text(
              "Phone Number Verified",
              style: AppTextStyles.style20w800(color: AppColors.white),
            ),
            SizedBox(height: 0.7.sh),

            Text(
              "You will be redirected to main page shortly",
              style: AppTextStyles.style14w600(color: AppColors.offWhite),
            ),
          ],
        ),
      ),
    );
  }
}
