import 'dart:math';
import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class StepArcPainter extends CustomPainter {
  final double progress; // 0.0 to 1.0
  final Color trackColor;
  final Color fillColor;
  final double strokeWidth;

  StepArcPainter({
    required this.progress,
    this.trackColor = AppColorsDark.surface2,
    this.fillColor = AppColorsDark.primary,
    this.strokeWidth = 16.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Define the bounding rectangle for the arc
    // Since it's a semi-circle arching upwards, the center is at the bottom middle.
    final center = Offset(size.width / 2, size.height);
    final radius = (size.width - strokeWidth) / 2;
    final rect = Rect.fromCircle(center: center, radius: radius);

    // Paint for background track
    final trackPaint = Paint()
      ..color = trackColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    // Draw base semicircle track: start angle is pi (180 deg), sweeping pi radians clockwise
    canvas.drawArc(rect, pi, pi, false, trackPaint);

    // Paint for filled progress arc
    // Adding gradient for premium aesthetics
    final fillPaint = Paint()
      ..shader = SweepGradient(
        center: Alignment.bottomCenter,
        startAngle: pi,
        endAngle: pi * 2,
        colors: [
          fillColor.withValues(alpha: 0.8),
          fillColor,
          Colors.orangeAccent,
        ],
      ).createShader(rect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    // Clamp progress between 0 and 1
    final clampedProgress = progress.clamp(0.0, 1.0);
    final sweepAngle = pi * clampedProgress;

    if (sweepAngle > 0) {
      // Draw shadow glow arc first
      final glowPaint = Paint()
        ..color = AppColorsDark.primaryGlow
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 12);
      canvas.drawArc(rect, pi, sweepAngle, false, glowPaint);

      // Draw primary filled arc
      canvas.drawArc(rect, pi, sweepAngle, false, fillPaint);
    }
  }

  @override
  bool shouldRepaint(covariant StepArcPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.trackColor != trackColor ||
        oldDelegate.fillColor != fillColor ||
        oldDelegate.strokeWidth != strokeWidth;
  }
}
