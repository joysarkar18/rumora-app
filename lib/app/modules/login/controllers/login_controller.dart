import 'package:campus_crush_app/app/services/logger_service.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  RxString phoneNumber = ''.obs;

  bool get isValidPhoneNumber => phoneNumber.value.length == 10;

  void sendOTP() {
    if (isValidPhoneNumber) {
      // Send OTP logic
      String fullPhoneNumber = '+91${phoneNumber.value}';
      LoggerService.logInfo('Sending OTP to: $fullPhoneNumber');

      // Navigate to OTP verification screen
      // Get.toNamed('/otp-verification', arguments: fullPhoneNumber);
    }
  }
}
