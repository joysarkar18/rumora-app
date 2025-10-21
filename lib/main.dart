import 'package:campus_crush_app/app/services/login_manager.dart';
import 'package:campus_crush_app/app/services/typesence_service.dart';
import 'package:campus_crush_app/app/utils/app_colors.dart';
import 'package:campus_crush_app/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import 'app/routes/app_pages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  Get.put(LoginManager());
  // await TypeSenseInstance().initialize();

  runApp(
    ResponsiveSizer(
      builder: (context, orientation, screenType) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          title: "Application",
          theme: ThemeData(
            scaffoldBackgroundColor: AppColors.cream,
            primaryColor: AppColors.primary,
          ),
          initialRoute: LoginManager.instance.isLoggedIn.value
              ? Routes.NAVBAR
              : AppPages.initial,
          getPages: AppPages.routes,
        );
      },
    ),
  );
}
