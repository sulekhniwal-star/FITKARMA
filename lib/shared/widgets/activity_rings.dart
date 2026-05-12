import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

/// ActivityRings — A 3-ring visualization of fitness progress.
///
/// Inner to Outer: Active Minutes (Purple), Calories (Secondary), Steps (Primary).
class ActivityRings extends StatelessWidget {
  final double stepsProgress; // 0.0 to 1.0
  final double caloriesProgress;
  final double minutesProgress;
  final double size;

  const ActivityRings({
    super.key,
    required this.stepsProgress,
    required this.caloriesProgress,
    required this.minutesProgress,
    this.size = 200,
  });

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: Semantics(
        label: 'Activity Progress Rings: '
            'Steps ${ (stepsProgress * 100).toInt() }%, '
            'Calories ${ (caloriesProgress * 100).toInt() }%, '
            'Active Minutes ${ (minutesProgress * 100).toInt() }%',
        child: SizedBox(
          width: size,
          height: size,
          child: CustomPaint(
            painter: _ActivityRingsPainter(
              stepsProgress: stepsProgress,
              caloriesProgress: caloriesProgress,
              minutesProgress: minutesProgress,
            ),
          ),
        ),
      ),
    );
  }
}

class _ActivityRingsPainter extends CustomPainter {
  final double stepsProgress;
  final double caloriesProgress;
  final double minutesProgress;

  _ActivityRingsPainter({
    required this.stepsProgress,
    required this.caloriesProgress,
    required this.minutesProgress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final strokeWidth = size.width * 0.12;
    final spacing = strokeWidth * 0.2;

    // Rings from outer to inner
    _drawRing(
      canvas,
      center,
      (size.width / 2) - strokeWidth / 2,
      strokeWidth,
      AppColorsDark.primary,
      AppColorsDark.primaryMuted,
      stepsProgress,
    );

    _drawRing(
      canvas,
      center,
      (size.width / 2) - strokeWidth * 1.5 - spacing,
      strokeWidth,
      AppColorsDark.secondary,
      AppColorsDark.secondaryGlow.withValues(alpha: 0.1),
      caloriesProgress,
    );

    _drawRing(
      canvas,
      center,
      (size.width / 2) - strokeWidth * 2.5 - spacing * 2,
      strokeWidth,
      AppColorsDark.purple,
      AppColorsDark.purple.withValues(alpha: 0.1),
      minutesProgress,
    );
  }

  void _drawRing(
    Canvas canvas,
    Offset center,
    double radius,
    double strokeWidth,
    Color color,
    Color backgroundColor,
    double progress,
  ) {
    final backgroundPaint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    final progressPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    // Draw background track
    canvas.drawCircle(center, radius, backgroundPaint);

    // Draw progress arc
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      2 * math.pi * progress.clamp(0.0, 1.0),
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _ActivityRingsPainter oldDelegate) {
    return oldDelegate.stepsProgress != stepsProgress ||
        oldDelegate.caloriesProgress != caloriesProgress ||
        oldDelegate.minutesProgress != minutesProgress;
  }
}
