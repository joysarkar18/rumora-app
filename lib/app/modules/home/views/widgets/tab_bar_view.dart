import 'package:campus_crush_app/app/modules/home/controllers/home_controller.dart';
import 'package:campus_crush_app/app/modules/home/views/widgets/post_card.dart';
import 'package:campus_crush_app/app/utils/app_colors.dart';
import 'package:campus_crush_app/app/utils/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

class HomeTabBarView extends StatelessWidget {
  final HomeController controller;

  const HomeTabBarView({required this.controller, super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => TabBarView(
        controller: TabController(
          length: 2,
          initialIndex: controller.selectedTab.value,
          vsync: Scaffold.of(context),
        ),
        children: [
          // New Tab Content
          NewTabContent(controller: controller),
          // Hot Tab Content
          HotTabContent(controller: controller),
        ],
      ),
    );
  }
}

/// New Tab Content Widget
class NewTabContent extends StatelessWidget {
  final HomeController controller;

  const NewTabContent({required this.controller, super.key});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        await controller.getInitData();
      },
      child: ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: 16),
        itemCount: controller.posts.length, // Replace with actual data count
        itemBuilder: (context, index) {
          return PostCard(post: controller.posts[index]);
        },
      ),
    );
  }
}

/// Hot Tab Content Widget
class HotTabContent extends StatelessWidget {
  final HomeController controller;

  const HotTabContent({required this.controller, super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 16),
      itemCount: 8, // Replace with actual data count
      itemBuilder: (context, index) {
        return Padding(
          padding: EdgeInsets.only(bottom: 12),
          child: Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 8,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Text(
              'Hot Item ${index + 1}',
              style: AppTextStyles.style14w500(color: AppColors.primary),
            ),
          ),
        );
      },
    );
  }
}
