import 'package:get/get.dart';

import '../controllers/profile_complete_controller.dart';

class ProfileCompleteBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProfileCompleteController>(() => ProfileCompleteController());
  }
}
