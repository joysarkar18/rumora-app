import 'dart:io';

import 'package:campus_crush_app/app/routes/app_pages.dart';
import 'package:campus_crush_app/app/services/logger_service.dart';
import 'package:get/get.dart';
import 'package:otpless_headless_flutter/otpless_flutter.dart';

class LoginController extends GetxController {
  RxString phoneNumber = ''.obs;
  RxBool agreeToTerms = false.obs;
  bool get isValidPhoneNumber => phoneNumber.value.length == 10;
  final _otplessHeadlessPlugin = Otpless();
  RxBool isOtpSent = false.obs;
  RxString otp = ''.obs;
  RxBool isVerifyingOtp = false.obs;
  RxString errorMessage = ''.obs;
  RxBool showError = false.obs;
  RxBool isSendingOtp = false.obs;
  RxInt resendCooldown = 0.obs;
  RxBool canResendOtp = true.obs;

  @override
  void onInit() {
    super.onInit();
    _otplessHeadlessPlugin.initialize("53F1MC6XNHYQIAJG3TAL");
    _otplessHeadlessPlugin.setResponseCallback(onOtplessResponse);
  }

  void onOtplessResponse(dynamic result) {
    _otplessHeadlessPlugin.commitResponse(result);

    final responseType = result['responseType'];

    switch (responseType) {
      case "SDK_READY":
        LoggerService.logInfo("SDK is ready");
        break;

      case "FAILED":
        LoggerService.logInfo("SDK initialization failed");
        _showError("SDK initialization failed");
        break;

      case "INITIATE":
        if (result["statusCode"] == 200) {
          LoggerService.logInfo("Headless authentication initiated");
          final authType = result["response"]["authType"];
          if (authType == "OTP") {
            isOtpSent.value = true;
            _showError(""); // Clear previous errors
            LoggerService.logInfo("OTP sent successfully");
          } else if (authType == "SILENT_AUTH") {
            LoggerService.logInfo("Silent auth initiated");
          }
        } else {
          if (Platform.isAndroid) {
            handleInitiateErrorAndroid(result["response"]);
          } else if (Platform.isIOS) {
            handleInitiateErrorIOS(result["response"]);
          }
        }
        break;

      case "OTP_AUTO_READ":
        final otpValue = result["response"]["otp"];
        LoggerService.logInfo("OTP Auto-Read: $otpValue");
        otp.value = otpValue;
        // Auto-verify when OTP is auto-read
        Future.delayed(const Duration(milliseconds: 500), () {
          verifyOTP();
        });
        break;

      case "VERIFY":
        isVerifyingOtp.value = false;
        final authType = result["response"]["authType"];
        if (result["statusCode"] == 200) {
          LoggerService.logInfo("OTP verified successfully");
          _showError(""); // Clear errors
          // Get the token or user data from response
          final token = result["response"]["token"];
          _handleVerificationSuccess(token);
        } else {
          if (authType == "SILENT_AUTH") {
            if (result["statusCode"] == 9106) {
              _showError("Authentication failed. Please try again.");
            } else {
              _showError("Silent authentication failed. Please try again.");
            }
          } else {
            if (Platform.isAndroid) {
              handleVerifyErrorAndroid(result["response"]);
            } else if (Platform.isIOS) {
              handleVerifyErrorIOS(result["response"]);
            }
          }
        }
        break;

      case "DELIVERY_STATUS":
        final authType = result["response"]["authType"];
        final deliveryChannel = result["response"]["deliveryChannel"];
        LoggerService.logInfo(
          "OTP delivery status - AuthType: $authType, Channel: $deliveryChannel",
        );
        break;

      case "ONETAP":
        final token = result["response"]["token"];
        if (token != null) {
          LoggerService.logInfo("OneTap Data: $token");
          _handleVerificationSuccess(token);
        }
        break;

      case "FALLBACK_TRIGGERED":
        final newDeliveryChannel = result["response"]["deliveryChannel"];
        LoggerService.logInfo("Fallback triggered to: $newDeliveryChannel");
        _showError(""); // Clear errors as fallback is handling it
        break;

      default:
        LoggerService.logInfo("Unknown response type: $responseType");
        break;
    }
  }

  void handleInitiateErrorAndroid(dynamic response) {
    final String? errorCode = response?['errorCode'];
    final String? errorMessage = response?['errorMessage'];

    if (errorCode == null) {
      _showError("An unknown error occurred");
      return;
    }

    String userFriendlyMessage = "An error occurred";

    switch (errorCode) {
      case "7101":
        userFriendlyMessage = "Invalid phone number format";
        break;
      case "7102":
        userFriendlyMessage = "Invalid phone number";
        break;
      case "7103":
        userFriendlyMessage = "SMS delivery not available";
        break;
      case "7106":
        userFriendlyMessage = "Invalid phone number";
        break;
      case "7025":
      case "401":
        userFriendlyMessage = "Service not available for your region";
        break;
      case "7020":
      case "7022":
      case "7023":
      case "7024":
        userFriendlyMessage = "Too many requests. Please try again later";
        break;
      case "9100":
      case "9104":
      case "9103":
        userFriendlyMessage =
            "Network error. Please check your internet connection";
        break;
      default:
        userFriendlyMessage = errorMessage ?? "Failed to send OTP";
    }

    LoggerService.logInfo("OTPless Error: $errorCode - $errorMessage");
    _showError(userFriendlyMessage);
  }

  void handleVerifyErrorAndroid(dynamic response) {
    final String? errorCode = response?['errorCode'];
    final String? errorMessage = response?['errorMessage'];

    if (errorCode == null) {
      _showError("Verification failed");
      return;
    }

    String userFriendlyMessage = "Verification failed";

    switch (errorCode) {
      case "7112":
        userFriendlyMessage = "Please enter the OTP";
        break;
      case "7118":
        userFriendlyMessage = "Incorrect OTP. Please try again";
        break;
      case "7303":
        userFriendlyMessage = "OTP expired. Please request a new one";
        break;
      case "9100":
      case "9104":
      case "9103":
        userFriendlyMessage =
            "Network error. Please check your internet connection";
        break;
      default:
        userFriendlyMessage = errorMessage ?? "Verification failed";
    }

    LoggerService.logInfo("OTPless Verify Error: $errorCode - $errorMessage");
    _showError(userFriendlyMessage);
  }

  void handleInitiateErrorIOS(dynamic response) {
    final String? errorCode = response?['errorCode'];
    final String? errorMessage = response?['errorMessage'];

    if (errorCode == null) {
      _showError("An unknown error occurred");
      return;
    }

    String userFriendlyMessage = "An error occurred";

    switch (errorCode) {
      case "7101":
        userFriendlyMessage = "Invalid phone number format";
        break;
      case "7102":
        userFriendlyMessage = "Invalid phone number";
        break;
      case "7103":
        userFriendlyMessage = "SMS delivery not available";
        break;
      case "7106":
        userFriendlyMessage = "Invalid phone number";
        break;
      case "5900":
        userFriendlyMessage = "Feature requires a newer iOS version";
        break;
      case "7025":
      case "401":
        userFriendlyMessage = "Service not available for your region";
        break;
      case "7020":
      case "7022":
      case "7023":
      case "7024":
        userFriendlyMessage = "Too many requests. Please try again later";
        break;
      case "9110":
        userFriendlyMessage = "Request cancelled";
        break;
      case "9100":
      case "9101":
      case "9102":
      case "9103":
      case "9104":
      case "9105":
        userFriendlyMessage =
            "Network error. Please check your internet connection";
        break;
      default:
        userFriendlyMessage = errorMessage ?? "Failed to send OTP";
    }

    LoggerService.logInfo("OTPless Error: $errorCode - $errorMessage");
    _showError(userFriendlyMessage);
  }

  void handleVerifyErrorIOS(dynamic response) {
    final String? errorCode = response?['errorCode'];
    final String? errorMessage = response?['errorMessage'];

    if (errorCode == null) {
      _showError("Verification failed");
      return;
    }

    String userFriendlyMessage = "Verification failed";

    switch (errorCode) {
      case "7112":
        userFriendlyMessage = "Please enter the OTP";
        break;
      case "7118":
        userFriendlyMessage = "Incorrect OTP. Please try again";
        break;
      case "7303":
        userFriendlyMessage = "OTP expired. Please request a new one";
        break;
      case "9110":
        userFriendlyMessage = "Request cancelled";
        break;
      case "9100":
      case "9101":
      case "9102":
      case "9103":
      case "9104":
      case "9105":
        userFriendlyMessage =
            "Network error. Please check your internet connection";
        break;
      default:
        userFriendlyMessage = errorMessage ?? "Verification failed";
    }

    LoggerService.logInfo("OTPless Verify Error: $errorCode - $errorMessage");
    _showError(userFriendlyMessage);
  }

  void _showError(String message) {
    errorMessage.value = message;
    showError.value = message.isNotEmpty;
  }

  void _handleVerificationSuccess(dynamic token) {
    LoggerService.logInfo("Verification successful. Token: $token");
    // Navigate to home or next screen
    // Get.offAllNamed('/home');
  }

  void sendOTP() async {
    if (!isValidPhoneNumber) {
      _showError("Please enter a valid 10-digit phone number");
      return;
    }

    isSendingOtp.value = true;
    _showError(""); // Clear previous errors

    try {
      final bool isSdkReady = await _otplessHeadlessPlugin.isSdkReady();

      if (isSdkReady) {
        String fullPhoneNumber = phoneNumber.value; // Without country code
        LoggerService.logInfo('Sending OTP to: +91$fullPhoneNumber');

        final Map<String, dynamic> args = {
          "phone": fullPhoneNumber,
          "countryCode": "+91",
        };

        _otplessHeadlessPlugin.start(onOtplessResponse, args);
        _startResendCooldown();
      } else {
        isSendingOtp.value = false;
        LoggerService.logInfo("SDK not ready for OTP initiation");
        _showError("Service not ready. Please try again.");
      }
    } catch (e) {
      isSendingOtp.value = false;
      LoggerService.logInfo("Error sending OTP: $e");
      _showError("Failed to send OTP. Please try again.");
    }
  }

  void verifyOTP() async {
    if (otp.value.length != 4) {
      _showError("Please enter a valid 6-digit OTP");
      return;
    }

    isVerifyingOtp.value = true;
    _showError(""); // Clear previous errors

    try {
      final Map<String, dynamic> verificationRequest = {
        "otp": otp.value,
        "phone": phoneNumber.value,
        "countryCode": "+91",
      };

      Get.toNamed(Routes.VERIFIED);

      LoggerService.logInfo("Verifying OTP: $verificationRequest");
      _otplessHeadlessPlugin.start(onOtplessResponse, verificationRequest);
    } catch (e) {
      isVerifyingOtp.value = false;
      LoggerService.logInfo("Error verifying OTP: $e");
      _showError("Failed to verify OTP. Please try again.");
    }
  }

  void resendOTP() {
    if (!canResendOtp.value) {
      _showError(
        "Please wait ${resendCooldown.value} seconds before resending",
      );
      return;
    }
    _showError(""); // Clear previous errors
    otp.value = ""; // Clear OTP field
    sendOTP();
  }

  void _startResendCooldown() {
    canResendOtp.value = false;
    resendCooldown.value = 30;

    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 1));
      resendCooldown.value--;

      if (resendCooldown.value <= 0) {
        canResendOtp.value = true;
        return false;
      }
      return true;
    });
  }

  void goBackToPhoneInput() {
    isOtpSent.value = false;
    otp.value = "";
    _showError("");
    phoneNumber.value = "";
    resendCooldown.value = 0;
    canResendOtp.value = true;
    isSendingOtp.value = false;
  }
}
