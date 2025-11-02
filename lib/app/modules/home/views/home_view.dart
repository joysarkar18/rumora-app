import 'package:campus_crush_app/app/modules/home/views/widgets/breating_fba.dart';
import 'package:campus_crush_app/app/modules/home/views/widgets/home_header.dart';
import 'package:campus_crush_app/app/modules/home/views/widgets/home_shimmer.dart';
import 'package:campus_crush_app/app/modules/home/views/widgets/home_tab_bar.dart';
import 'package:campus_crush_app/app/modules/home/views/widgets/tab_bar_view.dart';
import 'package:campus_crush_app/app/routes/app_pages.dart';
import 'package:campus_crush_app/app/utils/app_colors.dart';
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
        child: Obx(() {
          if (controller.isLoading.value) {
            return buildFeedShimmerLoading();
          }

          if (controller.hasError.value) {
            return _buildErrorState();
          }

          return RefreshIndicator(
            color: AppColors.primary,

            onRefresh: controller.refreshPosts,
            child: Column(
              children: [
                HomeHeader(),
                SizedBox(height: 20),
                HomeTabBar(controller: controller),
                SizedBox(height: 12),
                Expanded(child: HomeTabBarView(controller: controller)),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 80, color: Colors.red.shade300),
            SizedBox(height: 24),
            Text(
              'Oops! Something went wrong',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.darkBlue,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 12),
            Text(
              controller.errorMessage.value,
              style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () => controller.getInitData(),
              icon: Icon(Icons.refresh),
              label: Text('Try Again'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
