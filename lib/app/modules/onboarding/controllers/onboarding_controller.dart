import 'dart:async';
import 'package:campus_crush_app/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OnboardingController extends GetxController {
  late PageController pageController;
  RxInt currentPage = 0.obs;
  Timer? _timer;

  final List<Map<String, String>> onboardingData = [
    {
      'title': 'Match maker for tea lover',
      'subtitle':
          'Something happens here, not like regular app, this is different, lorem ipsum',
    },
    {
      'title': 'Connect with Your Campus',
      'subtitle':
          'Find your perfect match within your university community and share memorable moments',
    },
    {
      'title': 'Start Your Love Story',
      'subtitle':
          'Begin meaningful conversations and create lasting connections with verified students',
    },
  ];

  @override
  void onInit() {
    super.onInit();
    pageController = PageController(initialPage: 0);
    startAutoScroll();
  }

  @override
  void onClose() {
    pageController.dispose();
    _timer?.cancel();
    super.onClose();
  }

  void startAutoScroll() {
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (currentPage.value < onboardingData.length - 1) {
        pageController.nextPage(
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      } else {
        pageController.animateToPage(
          0,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  void onPageChanged(int index) {
    currentPage.value = index;
    update();
  }

  void onGetStarted() {
    Get.toNamed(Routes.LOGIN);
  }
}
