import 'dart:math';
import 'package:flutter/material.dart';

class DoshaDonutChart extends StatelessWidget {
  final double vata;
  final double pitta;
  final double kapha;

  const DoshaDonutChart({
    super.key,
    required this.vata,
    required this.pitta,
    required this.kapha,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(120, 120),
      painter: _DoshaPainter(vata, pitta, kapha),
    );
  }
}

class _DoshaPainter extends CustomPainter {
  final double vata;
  final double pitta;
  final double kapha;

  _DoshaPainter(this.vata, this.pitta, this.kapha);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    const strokeWidth = 12.0;
    
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final total = vata + pitta + kapha;
    if (total == 0) return;

    final vataAngle = (vata / total) * 2 * pi;
    final pittaAngle = (pitta / total) * 2 * pi;
    final kaphaAngle = (kapha / total) * 2 * pi;

    var startAngle = -pi / 2;

    // Vata (Indigo)
    paint.color = Colors.indigo;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius - strokeWidth/2),
      startAngle,
      vataAngle - 0.1, // Small gap
      false,
      paint,
    );
    startAngle += vataAngle;

    // Pitta (Red)
    paint.color = Colors.redAccent;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius - strokeWidth/2),
      startAngle,
      pittaAngle - 0.1,
      false,
      paint,
    );
    startAngle += pittaAngle;

    // Kapha (Green)
    paint.color = Colors.green;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius - strokeWidth/2),
      startAngle,
      kaphaAngle - 0.1,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
