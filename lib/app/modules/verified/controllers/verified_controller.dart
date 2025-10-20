import 'package:campus_crush_app/app/data/models/user_model.dart';
import 'package:campus_crush_app/app/routes/app_pages.dart';
import 'package:campus_crush_app/app/services/login_manager.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class VerifiedController extends GetxController {
  final count = 0.obs;

  @override
  void onInit() {
    super.onInit();
    _initializeVerification();
  }

  Future<void> _initializeVerification() async {
    final bool isDataAvailable = await checkData();
    await Future.delayed(Duration(seconds: 3));
    if (isDataAvailable) {
      Get.offAllNamed(Routes.NAVBAR);
    } else {
      Get.offAllNamed(Routes.COLLEGE);
    }
  }

  Future<bool> checkData() async {
    final userDoc = await FirebaseFirestore.instance
        .collection("user")
        .doc(LoginManager.instance.currentUserId)
        .get();

    final UserModel user = UserModel.fromFirestoreSnapshot(userDoc);
    return user.userName.isNotEmpty;
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void increment() => count.value++;
}
