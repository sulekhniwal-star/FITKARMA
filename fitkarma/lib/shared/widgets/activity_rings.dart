import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

/// Activity rings widget
///
/// Four concentric ring widgets arranged in a compact circle per Section 2.1 Dashboard Screen:
/// - Ring 1 (outermost, orange): Calories
/// - Ring 2 (green): Steps
/// - Ring 3 (teal): Water
/// - Ring 4 (purple): Active minutes
///
/// Ring stroke width: 10px with lineCap: round per Section 2.2
class ActivityRings extends StatelessWidget {
  /// Current value for calories ring (0.0 - 1.0)
  final double caloriesProgress;

  /// Target value for calories
  final double caloriesTarget;

  /// Current calories value
  final double caloriesValue;

  /// Current value for steps ring (0.0 - 1.0)
  final double stepsProgress;

  /// Target value for steps
  final double stepsTarget;

  /// Current steps value
  final double stepsValue;

  /// Current value for water ring (0.0 - 1.0)
  final double waterProgress;

  /// Target value for water (glasses)
  final double waterTarget;

  /// Current water value (glasses)
  final double waterValue;

  /// Current value for active minutes ring (0.0 - 1.0)
  final double activeMinutesProgress;

  /// Target value for active minutes
  final double activeMinutesTarget;

  /// Current active minutes value
  final double activeMinutesValue;

  /// Size of the widget
  final double size;

  /// Stroke width of the rings (default 10px per Section 2.2)
  final double strokeWidth;

  const ActivityRings({
    super.key,
    required this.caloriesProgress,
    this.caloriesTarget = 2000,
    required this.caloriesValue,
    required this.stepsProgress,
    this.stepsTarget = 10000,
    required this.stepsValue,
    required this.waterProgress,
    this.waterTarget = 8,
    required this.waterValue,
    required this.activeMinutesProgress,
    this.activeMinutesTarget = 60,
    required this.activeMinutesValue,
    this.size = 200,
    this.strokeWidth = 10,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Outer ring - Calories (Orange)
          _ActivityRing(
            progress: caloriesProgress,
            color: AppColors.ringCalories,
            strokeWidth: strokeWidth,
            size: size,
          ),
          // Second ring - Steps (Green)
          _ActivityRing(
            progress: stepsProgress,
            color: AppColors.ringSteps,
            strokeWidth: strokeWidth,
            size: size - (strokeWidth * 2.5),
          ),
          // Third ring - Water (Teal)
          _ActivityRing(
            progress: waterProgress,
            color: AppColors.ringWater,
            strokeWidth: strokeWidth,
            size: size - (strokeWidth * 5),
          ),
          // Inner ring - Active Minutes (Purple)
          _ActivityRing(
            progress: activeMinutesProgress,
            color: AppColors.ringActiveMinutes,
            strokeWidth: strokeWidth,
            size: size - (strokeWidth * 7.5),
          ),
          // Center content
          _CenterContent(
            caloriesValue: caloriesValue,
            caloriesTarget: caloriesTarget,
            stepsValue: stepsValue,
            stepsTarget: stepsTarget,
            waterValue: waterValue,
            waterTarget: waterTarget,
            activeMinutesValue: activeMinutesValue,
            activeMinutesTarget: activeMinutesTarget,
          ),
        ],
      ),
    );
  }
}

/// Individual activity ring painter
class _ActivityRing extends StatelessWidget {
  final double progress;
  final Color color;
  final double strokeWidth;
  final double size;

  const _ActivityRing({
    required this.progress,
    required this.color,
    required this.strokeWidth,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size),
      painter: _RingPainter(
        progress: progress,
        color: color,
        strokeWidth: strokeWidth,
      ),
    );
  }
}

/// Custom painter for the ring
class _RingPainter extends CustomPainter {
  final double progress;
  final Color color;
  final double strokeWidth;

  _RingPainter({
    required this.progress,
    required this.color,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    // Background ring (track)
    final trackPaint = Paint()
      ..color = color.withValues(alpha: 0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, trackPaint);

    // Progress ring
    final progressPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final sweepAngle = 2 * math.pi * progress.clamp(0.0, 1.0);

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2, // Start from top
      sweepAngle,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(_RingPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.color != color ||
        oldDelegate.strokeWidth != strokeWidth;
  }
}

/// Center content showing key metrics
class _CenterContent extends StatelessWidget {
  final double caloriesValue;
  final double caloriesTarget;
  final double stepsValue;
  final double stepsTarget;
  final double waterValue;
  final double waterTarget;
  final double activeMinutesValue;
  final double activeMinutesTarget;

  const _CenterContent({
    required this.caloriesValue,
    required this.caloriesTarget,
    required this.stepsValue,
    required this.stepsTarget,
    required this.waterValue,
    required this.waterTarget,
    required this.activeMinutesValue,
    required this.activeMinutesTarget,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Show the ring that's closest to completion
        _buildPrimaryMetric(),
      ],
    );
  }

  Widget _buildPrimaryMetric() {
    // Find which ring has highest progress percentage
    final caloriesPct = caloriesValue / caloriesTarget;
    final stepsPct = stepsValue / stepsTarget;
    final waterPct = waterValue / waterTarget;
    final activePct = activeMinutesValue / activeMinutesTarget;

    final maxPct = [
      caloriesPct,
      stepsPct,
      waterPct,
      activePct,
    ].reduce(math.max);

    if (maxPct == caloriesPct) {
      return _MetricDisplay(
        value: '${caloriesValue.toInt()}',
        unit: 'kcal',
        label: '${caloriesTarget.toInt()}',
        color: AppColors.ringCalories,
      );
    } else if (maxPct == stepsPct) {
      return _MetricDisplay(
        value: '${stepsValue.toInt()}',
        unit: 'steps',
        label: '${stepsTarget.toInt()}',
        color: AppColors.ringSteps,
      );
    } else if (maxPct == waterPct) {
      return _MetricDisplay(
        value: '${waterValue.toInt()}',
        unit: 'glasses',
        label: '${waterTarget.toInt()}',
        color: AppColors.ringWater,
      );
    } else {
      return _MetricDisplay(
        value: '${activeMinutesValue.toInt()}',
        unit: 'mins',
        label: '${activeMinutesTarget.toInt()}',
        color: AppColors.ringActiveMinutes,
      );
    }
  }
}

/// Metric display in center
class _MetricDisplay extends StatelessWidget {
  final String value;
  final String unit;
  final String label;
  final Color color;

  const _MetricDisplay({
    required this.value,
    required this.unit,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(value, style: AppTextStyles.headlineLarge.copyWith(color: color)),
        Text(unit, style: AppTextStyles.caption),
        Text('/ $label', style: AppTextStyles.captionSmall),
      ],
    );
  }
}

/// Compact activity rings for smaller spaces
class ActivityRingsCompact extends StatelessWidget {
  final double caloriesProgress;
  final double stepsProgress;
  final double waterProgress;
  final double activeMinutesProgress;
  final double size;

  const ActivityRingsCompact({
    super.key,
    required this.caloriesProgress,
    required this.stepsProgress,
    required this.waterProgress,
    required this.activeMinutesProgress,
    this.size = 60,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          _ActivityRing(
            progress: caloriesProgress,
            color: AppColors.ringCalories,
            strokeWidth: 4,
            size: size,
          ),
          _ActivityRing(
            progress: stepsProgress,
            color: AppColors.ringSteps,
            strokeWidth: 4,
            size: size - 10,
          ),
          _ActivityRing(
            progress: waterProgress,
            color: AppColors.ringWater,
            strokeWidth: 4,
            size: size - 20,
          ),
          _ActivityRing(
            progress: activeMinutesProgress,
            color: AppColors.ringActiveMinutes,
            strokeWidth: 4,
            size: size - 30,
          ),
        ],
      ),
    );
  }
}
