import 'package:get/get.dart';

import '../controllers/choose_username_controller.dart';

class ChooseUsernameBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ChooseUsernameController>(
      () => ChooseUsernameController(),
    );
  }
}
