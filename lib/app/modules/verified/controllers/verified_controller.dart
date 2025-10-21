import 'package:campus_crush_app/app/data/models/user_model.dart';
import 'package:campus_crush_app/app/routes/app_pages.dart';
import 'package:campus_crush_app/app/services/logger_service.dart';
import 'package:campus_crush_app/app/services/login_manager.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class VerifiedController extends GetxController {
  final count = 0.obs;

  @override
  void onInit() {
    super.onInit();
    print("VerifiedController onInit called");
  }

  @override
  void onReady() {
    super.onReady();
    print("VerifiedController onReady called");
    _initializeVerification();
  }

  Future<void> _initializeVerification() async {
    try {
      print("Starting verification check");
      final bool isDataAvailable = await checkData();
      print("Data available: $isDataAvailable");

      await Future.delayed(Duration(seconds: 1));
      LoggerService.logInfo("Data available $isDataAvailable");

      if (isDataAvailable) {
        print("Navigating to NAVBAR");
        Get.offAllNamed(Routes.NAVBAR);
      } else {
        print("Navigating to COLLEGE");
        Get.offAllNamed(Routes.COLLEGE);
      }
    } catch (e) {
      print("Error in verification: $e");
    }
  }

  Future<bool> checkData() async {
    try {
      LoggerService.logInfo("User id ${LoginManager.instance.currentUserId}");

      final userDoc = await FirebaseFirestore.instance
          .collection("user")
          .doc(LoginManager.instance.currentUserId)
          .get();

      if (!userDoc.exists) {
        print("User document does not exist");
        return false;
      }

      final UserModel user = UserModel.fromFirestoreSnapshot(userDoc);
      LoggerService.logInfo("Username ${user.username}");
      return user.username.isNotEmpty;
    } catch (e) {
      print("Error checking data: $e");
      return false;
    }
  }

  @override
  void onClose() {
    super.onClose();
    print("VerifiedController onClose called");
  }

  void increment() => count.value++;
}
