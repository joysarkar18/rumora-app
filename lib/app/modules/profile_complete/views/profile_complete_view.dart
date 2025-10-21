import 'package:campus_crush_app/app/utils/app_colors.dart';
import 'package:campus_crush_app/app/utils/text_styles.dart';
import 'package:campus_crush_app/constants/assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../controllers/profile_complete_controller.dart';

class ProfileCompleteView extends GetView<ProfileCompleteController> {
  const ProfileCompleteView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: SizedBox(
        width: 100.w,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(Assets.iconsProfileComplete),
            Obx(
              () => Text(
                controller.count.value == 0
                    ? "Setup Complete"
                    : "Setup Complete",
                style: AppTextStyles.style24w900(color: AppColors.cream),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                "Setting up your profile. You will be redirected\nto home page infew moments",
                textAlign: TextAlign.center,
                style: AppTextStyles.style14w500(color: AppColors.cream),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
