import 'package:campus_crush_app/app/modules/home/controllers/home_controller.dart';
import 'package:campus_crush_app/app/modules/navbar/controllers/user_controller.dart';
import 'package:get/get.dart';

import '../controllers/navbar_controller.dart';

class NavbarBinding extends Bindings {
  @override
  void dependencies() {
    // Navbar controller should always be available
    Get.put<NavbarController>(NavbarController(), permanent: true);

    // User controller should persist across navigation
    Get.put<UserController>(UserController(), permanent: true);
    Get.put<HomeController>(HomeController(), permanent: true);
  }
}
