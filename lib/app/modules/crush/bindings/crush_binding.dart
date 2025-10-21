import 'package:get/get.dart';

import '../controllers/crush_controller.dart';

class CrushBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CrushController>(
      () => CrushController(),
    );
  }
}
