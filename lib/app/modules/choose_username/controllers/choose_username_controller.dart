import 'package:campus_crush_app/app/routes/app_pages.dart';
import 'package:campus_crush_app/app/services/login_manager.dart';
import 'package:campus_crush_app/app/services/username_service.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChooseUsernameController extends GetxController {
  final username = ''.obs;
  final isAnimating = false.obs;
  final isLoading = false.obs;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void onInit() {
    super.onInit();
    _generateNewUsername();
  }

  Future<void> onDiceTap() async {
    if (isAnimating.value) return;

    isAnimating.value = true;
    await Future.delayed(const Duration(milliseconds: 1410));
    _generateNewUsername();
    isAnimating.value = false;
  }

  void _generateNewUsername() {
    username.value = UsernameService.generateRandomUsername();
  }

  Future<void> saveUsername() async {
    if (username.value.isEmpty) {
      Get.snackbar('Error', 'Please generate a username first');
      return;
    }

    try {
      isLoading.value = true;

      final user = LoginManager.instance.isLoggedIn;
      if (!user.value) {
        Get.snackbar('Error', 'User not authenticated');
        return;
      }

      // Save username to Firestore
      await _firestore
          .collection('user')
          .doc(LoginManager.instance.currentUserId)
          .update({
            'username': username.value,
            'updatedAt': FieldValue.serverTimestamp(),
          });

      Get.toNamed(Routes.PROFILE_COMPLETE);
    } catch (e) {
      Get.snackbar('Error', 'Failed to save username: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }
}
