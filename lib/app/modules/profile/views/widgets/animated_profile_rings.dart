import 'dart:math';

import 'package:avatar_plus/avatar_plus.dart';
import 'package:campus_crush_app/app/services/login_manager.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class AnimatedProfileRings extends StatefulWidget {
  final String? profileImageUrl;
  final int ringCount;
  final int bubbleCount;
  final Color primaryColor;
  final Color accentColor;
  final double rotationSpeed; // seconds per rotation

  const AnimatedProfileRings({
    super.key,
    this.profileImageUrl,
    this.ringCount = 3,
    this.bubbleCount = 3,
    this.primaryColor = const Color(0xFFE8D4F0),
    this.accentColor = const Color(0xFF8B6F9E),
    this.rotationSpeed = 20,
  });

  @override
  State<AnimatedProfileRings> createState() => _AnimatedProfileRingsState();
}

class _AnimatedProfileRingsState extends State<AnimatedProfileRings>
    with TickerProviderStateMixin {
  late AnimationController _rotationController;
  late AnimationController _bubbleController;
  late AnimationController _scaleController;

  @override
  void initState() {
    super.initState();

    // Controller for ring rotation
    _rotationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: widget.rotationSpeed.toInt()),
    )..repeat();

    // Controller for bubble pulsing animation
    _bubbleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    )..repeat(reverse: true);

    // Controller for initial scale animation
    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _scaleController.forward();
  }

  @override
  void dispose() {
    _rotationController.dispose();
    _bubbleController.dispose();
    _scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: CurvedAnimation(
        parent: _scaleController,
        curve: Curves.easeOutBack,
      ),
      child: SizedBox(
        width: 70.w,
        height: 70.w,
        child: AnimatedBuilder(
          animation: Listenable.merge([_rotationController, _bubbleController]),
          builder: (context, child) {
            return CustomPaint(
              painter: ProfileRingsPainter(
                rotationProgress: _rotationController.value,
                bubbleProgress: _bubbleController.value,
                ringCount: widget.ringCount,
                bubbleCount: widget.bubbleCount,
                primaryColor: widget.primaryColor,
                accentColor: widget.accentColor,
              ),
              child: Center(
                child: Container(
                  width: 24.w,
                  height: 24.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: widget.accentColor.withOpacity(0.2),
                        blurRadius: 25,
                        spreadRadius: 5,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(4),
                  child: ClipOval(
                    child: widget.profileImageUrl != null
                        ? AvatarPlus(
                            widget.profileImageUrl ??
                                LoginManager.instance.currentUserId,
                          )
                        : _buildPlaceholder(),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [widget.primaryColor, widget.accentColor.withOpacity(0.5)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Icon(Icons.person, size: 15.w, color: Colors.white),
    );
  }
}

class ProfileRingsPainter extends CustomPainter {
  final double rotationProgress;
  final double bubbleProgress;
  final int ringCount;
  final int bubbleCount;
  final Color primaryColor;
  final Color accentColor;

  ProfileRingsPainter({
    required this.rotationProgress,
    required this.bubbleProgress,
    required this.ringCount,
    required this.bubbleCount,
    required this.primaryColor,
    required this.accentColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final baseRadius = size.width * 0.2;

    // Draw multiple rings with gradient colors
    for (int i = 0; i < ringCount; i++) {
      final ringRadius = baseRadius + (i * size.width * 0.08);
      final opacity = 0.3 - (i * 0.05);

      final paint = Paint()
        ..color = primaryColor.withOpacity(opacity)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.0;

      canvas.drawCircle(center, ringRadius, paint);
    }

    // Calculate bubble positions
    final bubbles = _generateBubbles(size, baseRadius);

    // Draw rotating bubbles
    for (int i = 0; i < bubbles.length; i++) {
      final bubble = bubbles[i];
      final rotation = rotationProgress * 2 * pi + bubble.angle;

      final bubbleX = center.dx + bubble.radius * cos(rotation);
      final bubbleY = center.dy + bubble.radius * sin(rotation);

      // Pulsing effect with different phases for each bubble
      final phase = (i / bubbles.length) * 2 * pi;
      final scale = 0.7 + (sin(bubbleProgress * 2 * pi + phase) * 0.2);
      final bubbleSize = bubble.size * scale;

      // Draw bubble shadow
      final shadowPaint = Paint()
        ..color = Colors.black.withOpacity(0.1)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3);

      canvas.drawCircle(
        Offset(bubbleX + 1, bubbleY + 1),
        bubbleSize,
        shadowPaint,
      );

      // Draw main bubble
      final bubblePaint = Paint()
        ..color = bubble.color.withOpacity(0.8)
        ..style = PaintingStyle.fill;

      canvas.drawCircle(Offset(bubbleX, bubbleY), bubbleSize, bubblePaint);

      // Draw inner highlight for 3D effect
      final highlightPaint = Paint()
        ..color = Colors.white.withOpacity(0.4)
        ..style = PaintingStyle.fill;

      canvas.drawCircle(
        Offset(bubbleX - bubbleSize * 0.25, bubbleY - bubbleSize * 0.25),
        bubbleSize * 0.35,
        highlightPaint,
      );

      // Draw smaller highlight
      final smallHighlightPaint = Paint()
        ..color = Colors.white.withOpacity(0.6)
        ..style = PaintingStyle.fill;

      canvas.drawCircle(
        Offset(bubbleX - bubbleSize * 0.3, bubbleY - bubbleSize * 0.3),
        bubbleSize * 0.15,
        smallHighlightPaint,
      );
    }
  }

  List<BubbleData> _generateBubbles(Size size, double baseRadius) {
    final bubbles = <BubbleData>[];
    final random = Random(42); // Fixed seed for consistency

    for (int i = 0; i < bubbleCount; i++) {
      final angle = (i / bubbleCount) * 2 * pi + random.nextDouble() * 0.5;
      final ringIndex = i % ringCount;
      final radius =
          baseRadius + (ringIndex * size.width * 0.08) + (size.width * 0.04);
      final bubbleSize = 8.0 + random.nextDouble() * 6;

      // Generate color gradient between primary and accent
      final t = i / max(bubbleCount - 1, 1);
      final color = Color.lerp(accentColor, primaryColor, t) ?? accentColor;

      bubbles.add(
        BubbleData(
          angle: angle,
          radius: radius,
          size: bubbleSize,
          color: color,
        ),
      );
    }

    return bubbles;
  }

  @override
  bool shouldRepaint(ProfileRingsPainter oldDelegate) {
    return oldDelegate.rotationProgress != rotationProgress ||
        oldDelegate.bubbleProgress != bubbleProgress;
  }
}

class BubbleData {
  final double angle;
  final double radius;
  final double size;
  final Color color;

  BubbleData({
    required this.angle,
    required this.radius,
    required this.size,
    required this.color,
  });
}
