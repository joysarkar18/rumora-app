import 'package:campus_crush_app/app/routes/app_pages.dart';
import 'package:get/get.dart';

class ProfileCompleteController extends GetxController {
  final RxInt count = 0.obs;
  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
    _scheduleNavigation();
  }

  void _scheduleNavigation() {
    Get.offAllNamed(Routes.NAVBAR);
    Future.delayed(const Duration(seconds: 1), () {});
  }

  @override
  void onClose() {
    super.onClose();
  }
}
