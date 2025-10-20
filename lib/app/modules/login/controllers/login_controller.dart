import 'dart:async';
import 'dart:io';
import 'package:campus_crush_app/app/routes/app_pages.dart';
import 'package:campus_crush_app/app/services/logger_service.dart';
import 'package:campus_crush_app/app/services/login_manager.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:package_info_plus/package_info_plus.dart';

class LoginController extends GetxController {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final LoginManager _loginManager = LoginManager.instance;
  final DeviceInfoPlugin _deviceInfo = DeviceInfoPlugin();
  final Connectivity _connectivity = Connectivity();

  RxString phoneNumber = ''.obs;
  RxBool agreeToTerms = false.obs;
  bool get isValidPhoneNumber => phoneNumber.value.length == 10;

  RxBool isOtpSent = false.obs;
  RxString otp = ''.obs;
  RxBool isVerifyingOtp = false.obs;
  RxString errorMessage = ''.obs;
  RxBool showError = false.obs;
  RxBool isSendingOtp = false.obs;
  RxInt resendCooldown = 0.obs;
  RxBool canResendOtp = true.obs;

  late String _verificationId;
  Timer? _resendTimer;

  @override
  void onClose() {
    _resendTimer?.cancel();
    super.onClose();
  }

  void _showError(String message) {
    errorMessage.value = message;
    showError.value = message.isNotEmpty;
  }

  void sendOTP() async {
    if (!isValidPhoneNumber) {
      _showError("Please enter a valid 10-digit phone number");
      return;
    }

    if (!agreeToTerms.value) {
      _showError("Please agree to Terms & Conditions and Privacy Policy");
      return;
    }

    isSendingOtp.value = true;
    _showError("");

    try {
      String fullPhoneNumber = "+91${phoneNumber.value}";
      LoggerService.logInfo('Sending OTP to: $fullPhoneNumber');

      await _firebaseAuth.verifyPhoneNumber(
        phoneNumber: fullPhoneNumber,
        timeout: const Duration(seconds: 60),
        verificationCompleted: _handleVerificationCompleted,
        verificationFailed: _handleVerificationFailed,
        codeSent: _handleCodeSent,
        codeAutoRetrievalTimeout: _handleCodeAutoRetrievalTimeout,
      );
    } catch (e) {
      isSendingOtp.value = false;
      LoggerService.logInfo("Error sending OTP: $e");
      _showError("Failed to send OTP. Please try again.");
    }
  }

  void _handleVerificationCompleted(PhoneAuthCredential credential) async {
    LoggerService.logInfo("Verification completed automatically");
    await _signInWithCredential(credential);
  }

  void _handleVerificationFailed(FirebaseAuthException e) {
    isSendingOtp.value = false;
    LoggerService.logInfo("Verification failed: ${e.message}");

    String userFriendlyMessage = "Verification failed";

    switch (e.code) {
      case 'invalid-phone-number':
        userFriendlyMessage = "Invalid phone number format";
        break;
      case 'too-many-requests':
        userFriendlyMessage = "Too many requests. Please try again later";
        break;
      case 'network-request-failed':
        userFriendlyMessage =
            "Network error. Please check your internet connection";
        break;
      case 'app-not-authorized':
        userFriendlyMessage = "App not authorized for this operation";
        break;
      default:
        userFriendlyMessage = e.message ?? "Verification failed";
    }

    _showError(userFriendlyMessage);
  }

  void _handleCodeSent(String verificationId, int? resendToken) {
    LoggerService.logInfo("OTP sent successfully");
    _verificationId = verificationId;
    isOtpSent.value = true;
    isSendingOtp.value = false;
    _showError("");
    _startResendCooldown();
  }

  void _handleCodeAutoRetrievalTimeout(String verificationId) {
    LoggerService.logInfo("Code auto-retrieval timeout");
    _verificationId = verificationId;
  }

  void verifyOTP() async {
    if (otp.value.length != 6) {
      _showError("Please enter a valid 6-digit OTP");
      return;
    }

    isVerifyingOtp.value = true;
    _showError("");

    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: _verificationId,
        smsCode: otp.value,
      );

      await _signInWithCredential(credential);
    } catch (e) {
      isVerifyingOtp.value = false;
      LoggerService.logInfo("Error verifying OTP: $e");

      if (e is FirebaseAuthException) {
        if (e.code == 'invalid-verification-code') {
          _showError("Incorrect OTP. Please try again");
        } else {
          _showError(e.message ?? "Verification failed");
        }
      } else {
        _showError("Failed to verify OTP. Please try again.");
      }
    }
  }

  Future<void> _signInWithCredential(PhoneAuthCredential credential) async {
    try {
      final UserCredential userCredential = await _firebaseAuth
          .signInWithCredential(credential);

      // Update LoginManager with user data
      if (userCredential.user != null) {
        _loginManager.updateUserOnLogin(userCredential.user!);

        LoggerService.logInfo("User signed in successfully");
        await checkAndWriteInitialData();
        isVerifyingOtp.value = false;

        // Navigate to home or next screen
        Get.offAllNamed(Routes.VERIFIED);
      }
    } catch (e) {
      isVerifyingOtp.value = false;
      LoggerService.logInfo("Sign in error: $e");
      _showError("Failed to sign in. Please try again.");
    }
  }

  Future<void> checkAndWriteInitialData() async {
    final data = await FirebaseFirestore.instance
        .collection("auth")
        .doc(LoginManager.instance.userId.value)
        .get();

    final DateTime now = DateTime.now();
    final Map<String, dynamic> deviceInfo = await getDeviceInfo();
    final PackageInfo packageInfo = await PackageInfo.fromPlatform();

    if (data.exists) {
      // User exists - update necessary fields
      await FirebaseFirestore.instance
          .collection("auth")
          .doc(LoginManager.instance.currentUserId)
          .update({"deviceInfo": deviceInfo, "updatedAt": now});

      await FirebaseFirestore.instance
          .collection("user")
          .doc(LoginManager.instance.currentUserId)
          .update({
            "version": packageInfo.version,
            "buildNumber": packageInfo.buildNumber,
            "platform": Platform.isAndroid ? "android" : "ios",
            "updatedAt": now,
          });
    } else {
      await FirebaseFirestore.instance
          .collection("auth")
          .doc(LoginManager.instance.currentUserId)
          .set({
            "phoneNo": LoginManager.instance.currentPhoneNumber,
            "userId": LoginManager.instance.currentUserId,
            "createdAt": now,
            "updatedAt": now,
            "deviceInfo": deviceInfo,
          });

      await FirebaseFirestore.instance
          .collection("user")
          .doc(LoginManager.instance.currentUserId)
          .set({
            "userId": LoginManager.instance.currentUserId,
            "phoneNo": LoginManager.instance.currentPhoneNumber,
            "createdAt": now,
            "updatedAt": now,
            "version": packageInfo.version,
            "buildNumber": packageInfo.buildNumber,
            "platform": Platform.isAndroid ? "android" : "ios",
          });
    }
  }

  Future<Map<String, dynamic>> getDeviceInfo() async {
    try {
      final connectivityResult = await _connectivity.checkConnectivity();

      if (Platform.isAndroid) {
        final AndroidDeviceInfo androidInfo = await _deviceInfo.androidInfo;

        return {
          "platform": "android",
          "deviceId": androidInfo.id,
          "deviceModel": androidInfo.model,
          "manufacturer": androidInfo.manufacturer,
          "osVersion": androidInfo.version.release,
          "sdkVersion": androidInfo.version.sdkInt,
          "isPhysicalDevice": androidInfo.isPhysicalDevice,
          "networkType": connectivityResult.toString(),
          "timestamp": DateTime.now().toIso8601String(),
        };
      } else if (Platform.isIOS) {
        final IosDeviceInfo iosInfo = await _deviceInfo.iosInfo;

        return {
          "platform": "ios",
          "deviceId": iosInfo.identifierForVendor,
          "deviceModel": iosInfo.model,
          "osVersion": iosInfo.systemVersion,
          "isPhysicalDevice": iosInfo.isPhysicalDevice,
          "networkType": connectivityResult.toString(),
          "timestamp": DateTime.now().toIso8601String(),
        };
      }
    } catch (e) {
      LoggerService.logError("Error getting device info: $e");
    }
    return {};
  }

  void resendOTP() {
    if (!canResendOtp.value) {
      return;
    }
    _showError("");
    otp.value = "";
    sendOTP();
  }

  void _startResendCooldown() {
    canResendOtp.value = false;
    resendCooldown.value = 30;

    _resendTimer?.cancel();
    _resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      resendCooldown.value--;

      if (resendCooldown.value <= 0) {
        canResendOtp.value = true;
        timer.cancel();
      }
    });
  }

  void goBackToPhoneInput() {
    _resendTimer?.cancel();
    isOtpSent.value = false;
    otp.value = "";
    _showError("");
    phoneNumber.value = "";
    resendCooldown.value = 0;
    canResendOtp.value = true;
    isSendingOtp.value = false;
    agreeToTerms.value = false;
  }
}
