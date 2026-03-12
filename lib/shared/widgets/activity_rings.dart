import 'package:flutter/material.dart';
import 'dart:math';
import '../theme/app_colors.dart';

class ActivityRingsWidget extends StatelessWidget {
  final double caloriesProgress; // 0.0 - 1.0 (Orange)
  final double stepsProgress;    // 0.0 - 1.0 (Green)
  final double waterProgress;    // 0.0 - 1.0 (Teal)
  final double activeMinProgress;// 0.0 - 1.0 (Purple)
  final double size;
  final double strokeWidth;

  const ActivityRingsWidget({
    super.key,
    required this.caloriesProgress,
    required this.stepsProgress,
    required this.waterProgress,
    required this.activeMinProgress,
    this.size = 200.0,
    this.strokeWidth = 10.0,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _ActivityRingsPainter(
          caloriesProgress: caloriesProgress.clamp(0.0, 1.0),
          stepsProgress: stepsProgress.clamp(0.0, 1.0),
          waterProgress: waterProgress.clamp(0.0, 1.0),
          activeMinProgress: activeMinProgress.clamp(0.0, 1.0),
          strokeWidth: strokeWidth,
        ),
      ),
    );
  }
}

class _ActivityRingsPainter extends CustomPainter {
  final double caloriesProgress;
  final double stepsProgress;
  final double waterProgress;
  final double activeMinProgress;
  final double strokeWidth;

  _ActivityRingsPainter({
    required this.caloriesProgress,
    required this.stepsProgress,
    required this.waterProgress,
    required this.activeMinProgress,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    // Radii of the four concentric rings
    // Spacing between rings is usually strokeWidth + small gap
    final double outermostRadius = (size.width / 2) - (strokeWidth / 2);
    final double radius2 = outermostRadius - strokeWidth - 4;
    final double radius3 = radius2 - strokeWidth - 4;
    final double innermostRadius = radius3 - strokeWidth - 4;

    // Helper to draw a full track ring and then the progress arc
    void drawRing(double ringRadius, double progress, Color activeColor) {
      final rect = Rect.fromCircle(center: center, radius: ringRadius);

      final trackPaint = Paint()
        ..color = activeColor.withValues(alpha: 0.2)
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth;

      canvas.drawCircle(center, ringRadius, trackPaint);

      final progressPaint = Paint()
        ..color = activeColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round;

      final sweepAngle = 2 * pi * progress;

      canvas.drawArc(rect, -pi / 2, sweepAngle, false, progressPaint);
    }

    // Draw from outermost to innermost
    drawRing(outermostRadius, caloriesProgress, AppColors.primary);
    drawRing(radius2, stepsProgress, AppColors.success);
    drawRing(radius3, waterProgress, AppColors.teal);
    drawRing(innermostRadius, activeMinProgress, AppColors.purple);
  }

  @override
  bool shouldRepaint(covariant _ActivityRingsPainter oldDelegate) {
    return oldDelegate.caloriesProgress != caloriesProgress ||
        oldDelegate.stepsProgress != stepsProgress ||
        oldDelegate.waterProgress != waterProgress ||
        oldDelegate.activeMinProgress != activeMinProgress ||
        oldDelegate.strokeWidth != strokeWidth;
  }
}
