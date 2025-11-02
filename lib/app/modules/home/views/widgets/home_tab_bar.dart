import 'package:campus_crush_app/app/modules/home/controllers/home_controller.dart';
import 'package:campus_crush_app/app/modules/home/views/widgets/filter_drop_down.dart';
import 'package:campus_crush_app/app/modules/home/views/widgets/tab_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

class HomeTabBar extends StatelessWidget {
  final HomeController controller;

  const HomeTabBar({required this.controller, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Obx(
        () => Row(
          children: [
            TabButton(
              label: 'New',
              isSelected: controller.selectedTab.value == 0,
              onTap: () => controller.selectTab(0),
            ),
            SizedBox(width: 24),
            TabButton(
              label: 'Hot',
              isSelected: controller.selectedTab.value == 1,
              onTap: () => controller.selectTab(1),
            ),
            Spacer(),
            FilterDropdown(controller: controller),
          ],
        ),
      ),
    );
  }
}
