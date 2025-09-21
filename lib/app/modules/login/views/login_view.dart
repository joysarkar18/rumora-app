import 'package:campus_crush_app/app/common/widgets/common_button.dart';
import 'package:campus_crush_app/app/modules/login/views/widgets/phone_no_input.dart';
import 'package:campus_crush_app/app/services/logger_service.dart';
import 'package:campus_crush_app/app/utils/app_colors.dart';
import 'package:campus_crush_app/app/utils/text_styles.dart';
import 'package:campus_crush_app/constants/assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color(0xFFF5F0F0),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.sp),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 2.h),

              // Your welcome SVG
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [SvgPicture.asset(Assets.iconsWelcome, width: 88.w)],
              ),

              SizedBox(height: 1.h),

              Padding(
                padding: const EdgeInsets.only(left: 2),
                child: Text(
                  "Login to Your Account",
                  style: AppTextStyles.style24w800(color: AppColors.primary),
                ),
              ),

              SizedBox(height: 1.5.h),

              // Phone Number Input Field
              PhoneNumberInputField(
                onChanged: (phoneNumber) {
                  controller.phoneNumber.value = phoneNumber;
                },
              ),

              Spacer(),
              CommonButton(
                onPressed: () {
                  LoggerService.logInfo(controller.phoneNumber.value);
                },
              ),

              SizedBox(height: 1.h),
            ],
          ),
        ),
      ),
    );
  }
}
