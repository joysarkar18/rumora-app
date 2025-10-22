import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:campus_crush_app/app/utils/app_colors.dart';

class BreathingFAB extends StatefulWidget {
  final VoidCallback? onPressed;
  final double? size;
  final Color? backgroundColor;
  final Color? iconColor;
  final IconData? icon;
  final double? iconSize;

  const BreathingFAB({
    super.key,
    this.onPressed,
    this.size,
    this.backgroundColor,
    this.iconColor,
    this.icon = Icons.add,
    this.iconSize,
  });

  @override
  State<BreathingFAB> createState() => _BreathingFABState();
}

class _BreathingFABState extends State<BreathingFAB>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);

    // Bouncy curve for more playful effect
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.08).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.elasticInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final fabSize = widget.size ?? 13.w;
    final bgColor = widget.backgroundColor ?? AppColors.primary;
    final iconColor = widget.iconColor ?? AppColors.cream;
    final iconSize = widget.iconSize ?? 28.0;

    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Container(
            height: fabSize,
            width: fabSize,
            decoration: BoxDecoration(color: bgColor, shape: BoxShape.circle),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: widget.onPressed,
                customBorder: const CircleBorder(),
                child: Center(
                  child: Icon(
                    widget.icon,
                    color: iconColor,
                    size: iconSize,
                    weight: 4,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
