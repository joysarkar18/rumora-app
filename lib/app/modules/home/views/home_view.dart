import 'package:avatar_plus/avatar_plus.dart';
import 'package:campus_crush_app/app/utils/app_colors.dart';
import 'package:campus_crush_app/app/utils/text_styles.dart';
import 'package:campus_crush_app/constants/assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:get/get.dart';
import 'package:glossy/glossy.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 16, right: 16),
          child: ListView(
            children: [
              SizedBox(height: 14),
              Row(
                children: [
                  AvatarPlus("joysarkaraswa", height: 14.w, width: 14.w),
                  SizedBox(width: 12),
                  // Beautiful Search Input
                  Expanded(
                    child: Container(
                      height: 45,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withOpacity(0.1),
                            blurRadius: 2,
                            offset: Offset(0, 1),
                          ),
                        ],
                      ),
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Search anything...',
                          hintStyle: AppTextStyles.style14w400(
                            color: AppColors.grayBlue.withOpacity(0.6),
                          ),
                          prefixIcon: Padding(
                            padding: EdgeInsets.only(left: 16, right: 10),
                            child: SvgPicture.asset(
                              Assets.iconsSearch,
                              height: 18,
                              width: 18,
                              colorFilter: ColorFilter.mode(
                                AppColors.primary.withOpacity(0.6),
                                BlendMode.srcIn,
                              ),
                            ),
                          ),

                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide.none,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide(
                              color: AppColors.primary,
                              width: 1.5,
                            ),
                          ),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                        ),
                        style: AppTextStyles.style14w500(
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 12),
                  // Coin Balance Container
                  GlossyContainer(
                    height: 40,
                    width: 20.w,
                    borderRadius: BorderRadius.circular(20),
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            Assets.iconsCoin,
                            height: 22,
                            width: 22,
                          ),
                          SizedBox(width: 3),
                          Text(
                            "200",
                            style: AppTextStyles.style16w800(
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
