import 'package:get/get.dart';

import '../modules/chats/bindings/chats_binding.dart';
import '../modules/chats/views/chats_view.dart';
import '../modules/choose_college/bindings/college_binding.dart';
import '../modules/choose_college/views/college_view.dart';
import '../modules/choose_gender/bindings/choose_gender_binding.dart';
import '../modules/choose_gender/views/choose_gender_view.dart';
import '../modules/choose_username/bindings/choose_username_binding.dart';
import '../modules/choose_username/views/choose_username_view.dart';
import '../modules/crush/bindings/crush_binding.dart';
import '../modules/crush/views/crush_view.dart';
import '../modules/explore/bindings/explore_binding.dart';
import '../modules/explore/views/explore_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/login/bindings/login_binding.dart';
import '../modules/login/views/login_view.dart';
import '../modules/navbar/bindings/navbar_binding.dart';
import '../modules/navbar/views/navbar_view.dart';
import '../modules/onboarding/bindings/onboarding_binding.dart';
import '../modules/onboarding/views/onboarding_view.dart';
import '../modules/profile/bindings/profile_binding.dart';
import '../modules/profile/views/profile_view.dart';
import '../modules/profile_complete/bindings/profile_complete_binding.dart';
import '../modules/profile_complete/views/profile_complete_view.dart';
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
    GetPage(
      name: _Paths.CHOOSE_USERNAME,
      page: () => const ChooseUsernameView(),
      binding: ChooseUsernameBinding(),
    ),
    GetPage(
      name: _Paths.PROFILE_COMPLETE,
      page: () => const ProfileCompleteView(),
      binding: ProfileCompleteBinding(),
    ),
    GetPage(
      name: _Paths.CHATS,
      page: () => const ChatsView(),
      binding: ChatsBinding(),
    ),
    GetPage(
      name: _Paths.PROFILE,
      page: () => const ProfileView(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: _Paths.EXPLORE,
      page: () => const ExploreView(),
      binding: ExploreBinding(),
    ),
    GetPage(
      name: _Paths.CRUSH,
      page: () => const CrushView(),
      binding: CrushBinding(),
    ),
  ];
}
