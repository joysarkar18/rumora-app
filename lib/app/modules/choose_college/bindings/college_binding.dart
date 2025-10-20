import 'package:get/get.dart';

import '../controllers/college_controller.dart';

class CollegeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CollegeController>(
      () => CollegeController(),
    );
  }
}
