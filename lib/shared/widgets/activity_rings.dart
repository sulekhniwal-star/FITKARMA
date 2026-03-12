import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../shared/theme/app_colors.dart';

class ActivityRingsWidget extends StatelessWidget {
  final double caloriesProgress;
  final double stepsProgress;
  final double waterProgress;
  final double minutesProgress;
  final double size;

  const ActivityRingsWidget({
    super.key,
    required this.caloriesProgress,
    required this.stepsProgress,
    required this.waterProgress,
    required this.minutesProgress,
    this.size = 200,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      padding: const EdgeInsets.all(16),
      child: CustomPaint(
        painter: _ActivityRingsPainter(
          calories: caloriesProgress,
          steps: stepsProgress,
          water: waterProgress,
          minutes: minutesProgress,
        ),
      ),
    );
  }
}

class _ActivityRingsPainter extends CustomPainter {
  final double calories;
  final double steps;
  final double water;
  final double minutes;

  _ActivityRingsPainter({
    required this.calories,
    required this.steps,
    required this.water,
    required this.minutes,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final fullRadius = size.width / 2;
    const strokeWidth = 12.0;
    const spacing = 4.0;

    // Rings from outside to inside: Calories (Orange), Steps (Green), Water (Teal), Minutes (Purple)
    _drawRing(canvas, center, fullRadius - (strokeWidth / 2), AppColors.primaryOrange, calories, Icons.bolt);
    _drawRing(canvas, center, fullRadius - (strokeWidth / 2) - (strokeWidth + spacing), AppColors.successGreen, steps, Icons.directions_walk);
    _drawRing(canvas, center, fullRadius - (strokeWidth / 2) - 2 * (strokeWidth + spacing), Colors.teal, water, Icons.water_drop);
    _drawRing(canvas, center, fullRadius - (strokeWidth / 2) - 3 * (strokeWidth + spacing), Colors.purple, minutes, Icons.timer);
  }

  void _drawRing(Canvas canvas, Offset center, double radius, Color color, double progress, IconData icon) {
    final bgPaint = Paint()
      ..color = color.withOpacity(0.15)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 12.0
      ..strokeCap = StrokeCap.round;

    final progressPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 12.0
      ..strokeCap = StrokeCap.round;

    // Draw background circle
    canvas.drawCircle(center, radius, bgPaint);

    // Draw progress arc
    final rect = Rect.fromCircle(center: center, radius: radius);
    const startAngle = -math.pi / 2;
    final sweepAngle = 2 * math.pi * progress.clamp(0.0, 1.0);
    
    canvas.drawArc(rect, startAngle, sweepAngle, false, progressPaint);

    // Draw small icon inside the ring path at the start point
    _drawIconOnRing(canvas, center, radius, icon, color);
  }

  void _drawIconOnRing(Canvas canvas, Offset center, double radius, IconData icon, Color color) {
    const iconSize = 9.0;
    final textPainter = TextPainter(textDirection: TextDirection.ltr);
    textPainter.text = TextSpan(
      text: String.fromCharCode(icon.codePoint),
      style: TextStyle(
        fontSize: iconSize,
        fontFamily: icon.fontFamily,
        package: icon.fontPackage,
        color: Colors.white,
      ),
    );
    textPainter.layout();

    // Position icon at top center of the ring
    final offset = Offset(
      center.dx - textPainter.width / 2,
      center.dy - radius - textPainter.height / 2,
    );
    
    // Draw a small background for the icon to make it clear
    final bgCirclePaint = Paint()..color = color;
    canvas.drawCircle(Offset(center.dx, center.dy - radius), iconSize * 0.7, bgCirclePaint);

    textPainter.paint(canvas, offset);
  }

  @override
  bool shouldRepaint(covariant _ActivityRingsPainter oldDelegate) {
    return oldDelegate.calories != calories ||
           oldDelegate.steps != steps ||
           oldDelegate.water != water ||
           oldDelegate.minutes != minutes;
  }
}
