import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';

class ReadinessRing extends StatefulWidget {
  final int score;
  final Color color;
  final double size;

  const ReadinessRing({
    super.key,
    required this.score,
    required this.color,
    this.size = 140,
  });

  @override
  State<ReadinessRing> createState() => _ReadinessRingState();
}

class _ReadinessRingState extends State<ReadinessRing> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _animation = Tween<double>(begin: 0, end: widget.score.toDouble()).animate(
      CurvedAnimation(parent: _controller, curve: Curves.fastOutSlowIn),
    );
    _controller.forward();
  }

  @override
  void didUpdateWidget(ReadinessRing oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.score != widget.score) {
      _animation = Tween<double>(begin: _animation.value, end: widget.score.toDouble()).animate(
        CurvedAnimation(parent: _controller, curve: Curves.fastOutSlowIn),
      );
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        final currentScore = _animation.value.round();
        return SizedBox(
          width: widget.size,
          height: widget.size,
          child: Stack(
            alignment: Alignment.center,
            children: [
              CustomPaint(
                size: Size(widget.size, widget.size),
                painter: _ReadinessRingPainter(
                  score: _animation.value,
                  color: widget.color,
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '$currentScore',
                    style: AppTypography.h1(color: AppColorsDark.textPrimary).copyWith(
                      fontSize: widget.size * 0.28,
                      fontWeight: FontWeight.w800,
                      height: 1.0,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'READINESS',
                    style: AppTypography.labelSm(color: AppColorsDark.textSecondary).copyWith(
                      fontSize: widget.size * 0.08,
                      letterSpacing: 1.5,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ReadinessRingPainter extends CustomPainter {
  final double score;
  final Color color;

  _ReadinessRingPainter({
    required this.score,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - 16) / 2;
    const strokeWidth = 10.0;

    // Draw background track (semi-transparent white)
    final bgPaint = Paint()
      ..color = AppColorsDark.surface2.withValues(alpha: 0.8)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi * 0.8,
      math.pi * 1.6,
      false,
      bgPaint,
    );

    // Draw active progress path
    final progressPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final progressAngle = (score / 100.0) * (math.pi * 1.6);

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi * 0.8,
      progressAngle,
      false,
      progressPaint,
    );

    // Add elegant glow effect if score is high
    if (score > 50) {
      final glowPaint = Paint()
        ..color = color.withValues(alpha: 0.15)
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth * 2.2
        ..strokeCap = StrokeCap.round
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        -math.pi * 0.8,
        progressAngle,
        false,
        glowPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _ReadinessRingPainter oldDelegate) {
    return oldDelegate.score != score || oldDelegate.color != color;
  }
}
