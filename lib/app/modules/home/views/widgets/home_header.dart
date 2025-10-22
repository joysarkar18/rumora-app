import 'package:avatar_plus/avatar_plus.dart';
import 'package:campus_crush_app/app/modules/home/views/widgets/coin_balance_widget.dart';
import 'package:campus_crush_app/app/modules/home/views/widgets/search_input_widget.dart';
import 'package:campus_crush_app/app/modules/navbar/controllers/user_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shimmer/shimmer.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<UserController>(
      builder: (controller) {
        return Obx(
          () => controller.isLoading.value
              ? _buildShimmerLoading()
              : Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: [
                      SizedBox(height: 14),
                      Row(
                        children: [
                          AvatarPlus(
                            controller.user.value?.username ?? "avatar",
                            height: 14.w,
                            width: 14.w,
                          ),
                          SizedBox(width: 12),
                          Expanded(child: SearchInputWidget()),
                          SizedBox(width: 12),
                          CoinBalanceWidget(),
                        ],
                      ),
                    ],
                  ),
                ),
        );
      },
    );
  }

  /// Builds shimmer loading skeleton
  Widget _buildShimmerLoading() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          SizedBox(height: 14),
          Row(
            children: [
              // Avatar shimmer
              Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                child: Container(
                  height: 14.w,
                  width: 14.w,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              SizedBox(width: 12),
              // Search input shimmer
              Expanded(
                child: Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: Container(
                    height: 45,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.grey[300],
                    ),
                  ),
                ),
              ),
              SizedBox(width: 12),
              // Coin balance shimmer
              Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                child: Container(
                  height: 40,
                  width: 20.w,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.grey[300],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
