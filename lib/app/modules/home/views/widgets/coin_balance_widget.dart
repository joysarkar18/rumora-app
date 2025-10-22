import 'package:campus_crush_app/app/utils/app_colors.dart';
import 'package:campus_crush_app/app/utils/text_styles.dart';
import 'package:campus_crush_app/constants/assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:glossy/glossy.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

/// Coin balance display widget with glossy effect
class CoinBalanceWidget extends StatelessWidget {
  const CoinBalanceWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GlossyContainer(
      height: 40,
      width: 20.w,
      borderRadius: BorderRadius.circular(20),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(Assets.iconsCoin, height: 22, width: 22),
            SizedBox(width: 3),
            Text(
              "200",
              style: AppTextStyles.style16w800(color: AppColors.primary),
            ),
          ],
        ),
      ),
    );
  }
}
