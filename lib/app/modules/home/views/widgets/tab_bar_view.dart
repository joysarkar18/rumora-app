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
        physics:
            NeverScrollableScrollPhysics(), // Add this line to disable swipe
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

class NewTabContent extends StatelessWidget {
  final HomeController controller;

  const NewTabContent({required this.controller, super.key});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: AppColors.primary,
      onRefresh: () async {
        await controller.getInitData();
      },
      child: Obx(() {
        // Show empty state if no posts
        if (controller.posts.isEmpty) {
          return ListView(
            physics: AlwaysScrollableScrollPhysics(),
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.6,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.post_add_outlined,
                        size: 64,
                        color: AppColors.primary.withOpacity(0.3),
                      ),
                      SizedBox(height: 16),
                      Text(
                        'No Posts Yet',
                        style: AppTextStyles.style18w600(
                          color: AppColors.primary,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Be the first to create a post!',
                        style: AppTextStyles.style14w500(
                          color: AppColors.primary.withOpacity(0.6),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        }

        // Show posts list
        return ListView.builder(
          physics: AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 16),
          itemCount: controller.posts.length,
          itemBuilder: (context, index) {
            return PostCard(postIndex: index);
          },
        );
      }),
    );
  }
}

/// Hot Tab Content Widget
class HotTabContent extends StatelessWidget {
  final HomeController controller;

  const HotTabContent({required this.controller, super.key});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: AppColors.primary,
      onRefresh: () async {
        await controller.getHotPosts();
      },
      child: Obx(() {
        // Show empty state if no hot posts
        if (controller.hotPosts.isEmpty) {
          return ListView(
            physics: AlwaysScrollableScrollPhysics(),
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.6,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.local_fire_department_outlined,
                        size: 64,
                        color: AppColors.primary.withOpacity(0.3),
                      ),
                      SizedBox(height: 16),
                      Text(
                        'No Hot Posts Yet',
                        style: AppTextStyles.style18w600(
                          color: AppColors.primary,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Hot posts will appear here!',
                        style: AppTextStyles.style14w500(
                          color: AppColors.primary.withOpacity(0.6),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        }

        // Show hot posts list
        return ListView.builder(
          physics: AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 16),
          itemCount: controller.hotPosts.length,
          itemBuilder: (context, index) {
            return PostCard(postIndex: index);
          },
        );
      }),
    );
  }
}
