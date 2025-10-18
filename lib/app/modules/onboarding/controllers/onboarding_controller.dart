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
      'title': '☕ Spill the Tea',
      'subtitle':
          'Anonymous confessions, juicy campus gossip, and unfiltered takes on your dating disasters 👀',
    },
    {
      'title': '💬 Roast or Be Roasted',
      'subtitle':
          'Share your worst date stories and get hilariously honest feedback from your campus crew 😂',
    },
    {
      'title': '🎭 The Anonymous Truth',
      'subtitle':
          'No filters, no shame, just real talk about crushes, exes, and awkward encounters 🤐',
    },
    {
      'title': '⚡ Campus Drama Central',
      'subtitle':
          'Where everyone\'s secrets come to play—find your people and laugh at the chaos together 🍿',
    },
    {
      'title': '💘 Match Madness',
      'subtitle':
          'Gossip, confess—connect with locals who get your vibe and your messy love life 😅',
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
