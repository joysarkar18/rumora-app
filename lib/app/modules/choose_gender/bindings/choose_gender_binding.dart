import 'package:get/get.dart';

import '../controllers/choose_gender_controller.dart';

class ChooseGenderBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ChooseGenderController>(
      () => ChooseGenderController(),
    );
  }
}
