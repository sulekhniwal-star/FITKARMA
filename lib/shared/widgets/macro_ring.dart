import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';

/// MacroRing — A donut chart visualizing Protein, Carbs, and Fat.
class MacroRing extends StatelessWidget {
  final double protein; // grams
  final double carbs;
  final double fat;
  final double proteinGoal;
  final double carbsGoal;
  final double fatGoal;
  final String centerValue;
  final String centerLabel;
  final double size;

  const MacroRing({
    super.key,
    required this.protein,
    required this.carbs,
    required this.fat,
    required this.proteinGoal,
    required this.carbsGoal,
    required this.fatGoal,
    required this.centerValue,
    required this.centerLabel,
    this.size = 180,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            size: Size(size, size),
            painter: _MacroPainter(
              proteinProgress: (protein / proteinGoal).clamp(0.0, 1.0),
              carbsProgress: (carbs / carbsGoal).clamp(0.0, 1.0),
              fatProgress: (fat / fatGoal).clamp(0.0, 1.0),
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                centerValue,
                style: AppTypography.metricLg(color: Colors.white),
              ),
              Text(
                centerLabel,
                style: AppTypography.labelSm(color: AppColorsDark.textSecondary),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MacroPainter extends CustomPainter {
  final double proteinProgress;
  final double carbsProgress;
  final double fatProgress;

  _MacroPainter({
    required this.proteinProgress,
    required this.carbsProgress,
    required this.fatProgress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    final strokeWidth = size.width * 0.12;

    // Background track
    final bgPaint = Paint()
      ..color = AppColorsDark.surface2
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    canvas.drawCircle(center, radius - strokeWidth / 2, bgPaint);

    // Protein (Inner)
    _drawArc(canvas, center, radius - strokeWidth * 0.5, strokeWidth, AppColorsDark.primary, proteinProgress);
    
    // Carbs (Middle)
    _drawArc(canvas, center, radius - strokeWidth * 1.6, strokeWidth, AppColorsDark.secondary, carbsProgress);

    // Fat (Outer/actually just another ring)
    _drawArc(canvas, center, radius - strokeWidth * 2.7, strokeWidth, AppColorsDark.purple, fatProgress);
  }

  void _drawArc(Canvas canvas, Offset center, double radius, double strokeWidth, Color color, double progress) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      2 * math.pi * progress,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant _MacroPainter oldDelegate) => true;
}
