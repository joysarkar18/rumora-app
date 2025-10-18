import 'package:campus_crush_app/app/common/widgets/common_button.dart';
import 'package:campus_crush_app/app/modules/login/views/widgets/phone_no_input.dart';
import 'package:campus_crush_app/app/utils/app_colors.dart';
import 'package:campus_crush_app/app/utils/text_styles.dart';
import 'package:campus_crush_app/constants/assets.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';
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
        child: Obx(
          () => controller.isOtpSent.value
              ? _buildOtpScreen(context)
              : _buildPhoneScreen(context),
        ),
      ),
    );
  }

  Widget _buildPhoneScreen(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.sp),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 2.h),
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

          SizedBox(height: 1.h),

          // Error message display
          Obx(
            () => controller.showError.value
                ? Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.red.withOpacity(0.5)),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.error_outline, color: Colors.red, size: 18),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            controller.errorMessage.value,
                            style: AppTextStyles.style12w400(color: Colors.red),
                          ),
                        ),
                      ],
                    ),
                  )
                : SizedBox.shrink(),
          ),

          const Spacer(),

          // Terms and Conditions Checkbox
          Obx(
            () => Row(
              children: [
                Checkbox(
                  value: controller.agreeToTerms.value,
                  onChanged: (value) {
                    controller.agreeToTerms.value = value ?? false;
                  },
                  activeColor: AppColors.primary,
                ),
                Expanded(
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: "I agree to the ",
                          style: AppTextStyles.style12w400(
                            color: AppColors.grayBlue,
                          ),
                        ),
                        TextSpan(
                          text: "Terms & Conditions",
                          style: AppTextStyles.style12w600(
                            color: AppColors.primary,
                          ),
                          recognizer: TapGestureRecognizer()..onTap = () {},
                        ),
                        TextSpan(
                          text: " & ",
                          style: AppTextStyles.style12w400(
                            color: AppColors.grayBlue,
                          ),
                        ),
                        TextSpan(
                          text: "Privacy Policy",
                          style: AppTextStyles.style12w600(
                            color: AppColors.primary,
                          ),
                          recognizer: TapGestureRecognizer()..onTap = () {},
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 1.5.h),

          CommonButton(
            text: controller.isSendingOtp.value ? "Sending OTP..." : "Get OTP",
            onPressed: controller.isSendingOtp.value
                ? null
                : () {
                    if (controller.agreeToTerms.value) {
                      if (controller.isValidPhoneNumber) {
                        controller.sendOTP();
                      } else {
                        Get.snackbar(
                          'Invalid Phone',
                          'Please enter a valid 10-digit phone number',
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: AppColors.darkRed,
                          colorText: Colors.white,
                        );
                      }
                    } else {
                      Get.snackbar(
                        'Required',
                        'Please agree to Terms & Conditions and Privacy Policy',
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: AppColors.darkRed,
                        colorText: Colors.white,
                      );
                    }
                  },
          ),

          SizedBox(height: 1.h),
        ],
      ),
    );
  }

  Widget _buildOtpScreen(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: const TextStyle(
        fontSize: 24,
        color: AppColors.primary,
        fontWeight: FontWeight.w600,
        letterSpacing: 1.5,
      ),
      decoration: BoxDecoration(
        color: AppColors.cream,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.primary, width: 2),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: AppColors.primary, width: 2.5),
      borderRadius: BorderRadius.circular(12),
    );

    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration?.copyWith(color: AppColors.cream),
    );

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.sp),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 2.h),

          // Back Button
          GestureDetector(
            onTap: () {
              controller.goBackToPhoneInput();
            },
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primary.withOpacity(0.1),
              ),
              child: Icon(
                Icons.keyboard_arrow_left_rounded,
                color: AppColors.primary,
                size: 30,
              ),
            ),
          ),

          // OTP Sent Illustration
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [SvgPicture.asset(Assets.iconsOtpSent, width: 50.w)],
          ),

          SizedBox(height: 2.h),

          // Title
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Enter 6 digit verification code",
                textAlign: TextAlign.center,
                style: AppTextStyles.style22w700(color: AppColors.primary),
              ),
            ],
          ),

          SizedBox(height: 0.5.h),

          // Subtitle with phone number
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "sent to +91${controller.phoneNumber.value}",
                textAlign: TextAlign.center,
                style: AppTextStyles.style14w400(color: AppColors.grayBlue),
              ),
            ],
          ),

          SizedBox(height: 2.5.h),

          // OTP Input Field
          Center(
            child: Pinput(
              length: 4,
              onChanged: (value) {
                controller.otp.value = value;
              },
              defaultPinTheme: defaultPinTheme,
              focusedPinTheme: focusedPinTheme,
              submittedPinTheme: submittedPinTheme,
              showCursor: true,
              onCompleted: (pin) {
                controller.otp.value = pin;
              },
              keyboardType: TextInputType.number,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            ),
          ),

          SizedBox(height: 1.5.h),

          // Error message display
          Obx(
            () => controller.showError.value
                ? Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.red.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: Colors.red.withOpacity(0.5),
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.error_outline,
                              color: Colors.red,
                              size: 18,
                            ),
                            SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                controller.errorMessage.value,
                                style: AppTextStyles.style12w400(
                                  color: Colors.red,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 1.h),
                    ],
                  )
                : SizedBox.shrink(),
          ),

          const Spacer(),

          // Resend OTP section
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Didn't receive the code? ",
                style: AppTextStyles.style14w400(color: AppColors.grayBlue),
              ),
              GestureDetector(
                onTap: () {
                  controller.resendOTP();
                },
                child: Text(
                  "Resend",
                  style: AppTextStyles.style14w600(color: AppColors.primary),
                ),
              ),
            ],
          ),

          SizedBox(height: 1.5.h),

          // Verify Button
          Obx(
            () => CommonButton(
              text: controller.isVerifyingOtp.value ? "Verifying..." : "Verify",
              onPressed: controller.isVerifyingOtp.value
                  ? null
                  : () {
                      controller.verifyOTP();
                    },
            ),
          ),

          SizedBox(height: 1.h),
        ],
      ),
    );
  }
}
