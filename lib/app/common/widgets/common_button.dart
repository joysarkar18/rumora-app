import 'package:campus_crush_app/app/utils/app_colors.dart';
import 'package:flutter/material.dart';

class CommonButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final double? width;
  final double height;
  final Color backgroundColor;
  final Color? disabledColor;
  final Color? splashColor;
  final Color? shadowColor;
  final Color? textColor;
  final double fontSize;
  final FontWeight fontWeight;
  final String? fontFamily;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry? margin;
  final double borderRadius;
  final BorderSide? borderSide;
  final Widget? child;
  final Widget? leadingIcon;
  final Widget? trailingIcon;
  final double iconSpacing;
  final bool isLoading;
  final Widget? loadingWidget;
  final double elevation;
  final double pressedElevation;
  final Duration animationDuration;
  final Gradient? gradient;
  final AlignmentGeometry alignment;
  final bool enabled;
  final TextStyle? textStyle;
  final double? minWidth;
  final double? maxWidth;
  final double? minHeight;
  final double? maxHeight;
  final bool expandWidth;

  const CommonButton({
    super.key,
    this.text = 'Button',
    this.onPressed,
    this.width,
    this.height = 52.0,
    this.backgroundColor = AppColors.primary,
    this.disabledColor,
    this.splashColor = AppColors.darkRed,
    this.shadowColor,
    this.textColor,
    this.fontSize = 18.0,
    this.fontWeight = FontWeight.w600,
    this.fontFamily,
    this.padding = const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
    this.margin,
    this.borderRadius = 28.0,
    this.borderSide,
    this.child,
    this.leadingIcon,
    this.trailingIcon,
    this.iconSpacing = 8.0,
    this.isLoading = false,
    this.loadingWidget,
    this.elevation = 4.0,
    this.pressedElevation = 1.0,
    this.animationDuration = const Duration(milliseconds: 150),
    this.gradient,
    this.alignment = Alignment.center,
    this.enabled = true,
    this.textStyle,
    this.minWidth,
    this.maxWidth,
    this.minHeight,
    this.maxHeight,
    this.expandWidth = false,
  });

  @override
  State<CommonButton> createState() => _CommonButtonState();
}

class _CommonButtonState extends State<CommonButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _elevationAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: widget.animationDuration,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.98).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _elevationAnimation =
        Tween<double>(
          begin: widget.elevation,
          end: widget.pressedElevation,
        ).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Curves.easeInOut,
          ),
        );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    if (!widget.enabled || widget.isLoading) return;
    setState(() {});
    _animationController.forward();
  }

  void _handleTapUp(TapUpDetails details) {
    if (!widget.enabled || widget.isLoading) return;
    setState(() {});
    _animationController.reverse();
  }

  void _handleTapCancel() {
    if (!widget.enabled || widget.isLoading) return;
    setState(() {});
    _animationController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    // Button is enabled only if: enabled property is true AND not loading AND onPressed is not null
    final bool isEnabled =
        widget.enabled && !widget.isLoading && widget.onPressed != null;

    final Color effectiveBackgroundColor = widget.backgroundColor;

    final Color effectiveDisabledColor =
        widget.disabledColor ?? theme.disabledColor.withValues(alpha: 0.6);

    final Color effectiveTextColor =
        widget.textColor ??
        (effectiveBackgroundColor.computeLuminance() > 0.5
            ? Colors.black87
            : Colors.white);

    final Color effectiveSplashColor =
        widget.splashColor ?? effectiveTextColor.withValues(alpha: 0.1);

    final Color effectiveShadowColor =
        widget.shadowColor ?? Colors.black.withValues(alpha: 0.2);

    Widget buttonContent =
        widget.child ??
        Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (widget.leadingIcon != null) ...[
              widget.leadingIcon!,
              SizedBox(width: widget.iconSpacing),
            ],
            Flexible(
              child: Text(
                widget.text,
                style:
                    widget.textStyle ??
                    TextStyle(
                      color: isEnabled
                          ? effectiveTextColor
                          : effectiveTextColor.withValues(alpha: 0.6),
                      fontSize: widget.fontSize,
                      fontWeight: widget.fontWeight,
                      fontFamily: widget.fontFamily,
                    ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (widget.trailingIcon != null) ...[
              SizedBox(width: widget.iconSpacing),
              widget.trailingIcon!,
            ],
          ],
        );

    if (widget.isLoading) {
      buttonContent =
          widget.loadingWidget ??
          SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(
              strokeWidth: 2.5,
              valueColor: AlwaysStoppedAnimation<Color>(effectiveTextColor),
            ),
          );
    }

    return Container(
      margin: widget.margin,
      constraints: BoxConstraints(
        minWidth: widget.minWidth ?? 0,
        maxWidth: widget.maxWidth ?? double.infinity,
        minHeight: widget.minHeight ?? 0,
        maxHeight: widget.maxHeight ?? double.infinity,
      ),
      width: widget.expandWidth ? double.infinity : widget.width,
      height: widget.height,
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(widget.borderRadius),
                boxShadow: isEnabled
                    ? [
                        BoxShadow(
                          color: effectiveShadowColor,
                          blurRadius: _elevationAnimation.value * 2,
                          offset: Offset(0, _elevationAnimation.value),
                          spreadRadius: 0,
                        ),
                      ]
                    : [],
              ),
              child: Material(
                color: Colors.transparent,
                child: Ink(
                  decoration: BoxDecoration(
                    gradient: widget.gradient,
                    color: widget.gradient == null
                        ? (isEnabled
                              ? effectiveBackgroundColor
                              : effectiveDisabledColor)
                        : null,
                    borderRadius: BorderRadius.circular(widget.borderRadius),
                    border: widget.borderSide != null
                        ? Border.all(
                            color: widget.borderSide!.color,
                            width: widget.borderSide!.width,
                            style: widget.borderSide!.style,
                          )
                        : null,
                  ),
                  child: InkWell(
                    onTap: isEnabled ? widget.onPressed : null,
                    onTapDown: _handleTapDown,
                    onTapUp: _handleTapUp,
                    onTapCancel: _handleTapCancel,
                    splashColor: effectiveSplashColor,
                    highlightColor: effectiveSplashColor.withValues(
                      alpha: 0.05,
                    ),
                    borderRadius: BorderRadius.circular(widget.borderRadius),
                    child: Container(
                      padding: widget.padding,
                      alignment: widget.alignment,
                      child: buttonContent,
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
