import 'package:campus_crush_app/app/utils/app_colors.dart';
import 'package:campus_crush_app/constants/assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../controllers/navbar_controller.dart';

class NavbarView extends GetView<NavbarController> {
  const NavbarView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: Obx(() => controller.pages[controller.selectedIndex.value]),
      bottomNavigationBar: Container(
        color: Colors.white,
        child: Obx(
          () => Container(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(10),
                  blurRadius: 8,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.only(
                top: 5.0,
                left: 10,
                right: 10,
                bottom: 20,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildNavItem(
                    svgPath: Assets.iconsHome,
                    label: 'My Feed',
                    index: 0,
                  ),
                  _buildNavItem(
                    svgPath: Assets.iconsHeart,
                    label: 'Crush',
                    index: 1,
                  ),
                  _buildCenterItem(),
                  _buildNavItem(
                    svgPath: Assets.iconsChats,
                    label: 'Chart',
                    index: 3,
                  ),
                  _buildNavItem(
                    svgPath: Assets.iconsProfile,
                    label: 'Profile',
                    index: 4,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required String svgPath,
    required String label,
    required int index,
  }) {
    return GestureDetector(
      onTap: () => controller.onItemTapped(index),
      child: Container(
        width: 18.w,
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(
              svgPath,
              width: 24,
              height: 24,
              colorFilter: ColorFilter.mode(
                controller.selectedIndex.value == index
                    ? AppColors.primary
                    : AppColors.grayMedium,
                BlendMode.srcIn,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                color: controller.selectedIndex.value == index
                    ? AppColors.primary
                    : AppColors.grayMedium,
                fontWeight: controller.selectedIndex.value == index
                    ? FontWeight.w600
                    : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCenterItem() {
    return GestureDetector(
      onTap: () => controller.onItemTapped(2),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 18.w,
            padding: const EdgeInsets.only(
              left: 4,
              right: 4,
              top: 4,
              bottom: 8,
            ),
            child: SizedBox(
              width: 48,
              height: 48,
              child: Lottie.asset(
                Assets.animationsFind,
                fit: BoxFit.contain,
                repeat: true,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
