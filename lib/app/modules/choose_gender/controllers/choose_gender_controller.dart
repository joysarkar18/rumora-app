import 'package:campus_crush_app/app/routes/app_pages.dart';
import 'package:campus_crush_app/app/services/login_manager.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class ChooseGenderController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // State variables
  final Rx<String?> selectedGender = Rx<String?>(null);
  final Rx<DateTime?> selectedDate = Rx<DateTime?>(null);
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  /// Select gender option
  void selectGender(String gender) {
    selectedGender.value = gender;
  }

  /// Update selected date
  void updateDate(DateTime date) {
    selectedDate.value = date;
  }

  /// Check if both gender and date are selected
  bool isFormValid() {
    return selectedGender.value != null && selectedDate.value != null;
  }

  /// Save gender and birthday to Firebase
  Future<void> saveGenderAndBirthday() async {
    if (!isFormValid()) {
      Get.snackbar(
        'Error',
        'Please select both gender and birthday',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );
      return;
    }

    try {
      isLoading.value = true;

      final userId = LoginManager.instance.currentUserId;
      if (userId.isEmpty) {
        Get.snackbar(
          'Error',
          'User not authenticated',
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }

      // Save to Firestore
      await _firestore.collection('user').doc(userId).update({
        'gender': selectedGender.value,
        'dob': selectedDate.value,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      // Navigate to next screen
      Get.offNamed(Routes.CHOOSE_USERNAME);
    } on FirebaseException catch (e) {
      Get.snackbar(
        'Error',
        e.message ?? 'Failed to save data',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'An unexpected error occurred',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
