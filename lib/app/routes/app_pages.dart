import 'package:campus_crush_app/app/modules/choose_gender/bindings/choose_gender_binding.dart';
import 'package:campus_crush_app/app/modules/choose_gender/views/choose_gender_view.dart';
import 'package:get/get.dart';

import '../modules/choose_college/bindings/college_binding.dart';
import '../modules/choose_college/views/college_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/login/bindings/login_binding.dart';
import '../modules/login/views/login_view.dart';
import '../modules/navbar/bindings/navbar_binding.dart';
import '../modules/navbar/views/navbar_view.dart';
import '../modules/onboarding/bindings/onboarding_binding.dart';
import '../modules/onboarding/views/onboarding_view.dart';
import '../modules/verified/bindings/verified_binding.dart';
import '../modules/verified/views/verified_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const initial = Routes.ONBOARDING;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
      transition: Transition.circularReveal,
      transitionDuration: Duration(milliseconds: 400),
    ),
    GetPage(
      name: _Paths.ONBOARDING,
      page: () => const OnboardingView(),
      binding: OnboardingBinding(),
    ),
    GetPage(
      name: _Paths.LOGIN,
      page: () => const LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: _Paths.VERIFIED,
      page: () => const VerifiedView(),
      binding: VerifiedBinding(),
    ),
    GetPage(
      name: _Paths.NAVBAR,
      page: () => const NavbarView(),
      binding: NavbarBinding(),
    ),
    GetPage(
      name: _Paths.COLLEGE,
      page: () => const CollegeView(),
      binding: CollegeBinding(),
    ),

    GetPage(
      name: _Paths.CHOOSE_GENDER,
      page: () => const ChooseGenderView(),
      binding: ChooseGenderBinding(),
    ),
  ];
}
