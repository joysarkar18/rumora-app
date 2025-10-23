import 'package:campus_crush_app/app/modules/home/views/widgets/breating_fba.dart';
import 'package:campus_crush_app/app/modules/home/views/widgets/home_header.dart';
import 'package:campus_crush_app/app/modules/home/views/widgets/home_shimmer.dart';
import 'package:campus_crush_app/app/modules/home/views/widgets/home_tab_bar.dart';
import 'package:campus_crush_app/app/modules/home/views/widgets/tab_bar_view.dart';
import 'package:campus_crush_app/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: BreathingFAB(
        onPressed: () {
          Get.toNamed(Routes.ADD_POST);
        },
      ),
      body: SafeArea(
        child: Obx(
          () => controller.isLoading.value
              ? buildFeedShimmerLoading()
              : Column(
                  children: [
                    HomeHeader(),
                    SizedBox(height: 20),
                    HomeTabBar(controller: controller),
                    SizedBox(height: 12),
                    Expanded(child: HomeTabBarView(controller: controller)),
                  ],
                ),
        ),
      ),
    );
  }
}
