// lib/features/food/widgets/nutrition_ring_chart.dart

import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../domain/nutrition_goal_model.dart';

/// Circular ring chart widget for displaying nutrition progress
class NutritionRingChart extends StatelessWidget {
  final double progress; // 0.0 to 1.0+
  final NutritionStatus status;
  final String label;
  final String value;
  final String unit;
  final double size;
  final double strokeWidth;

  const NutritionRingChart({
    super.key,
    required this.progress,
    required this.status,
    required this.label,
    required this.value,
    required this.unit,
    this.size = 80,
    this.strokeWidth = 8,
  });

  @override
  Widget build(BuildContext context) {
    final color = _getStatusColor();
    final clampedProgress = progress.clamp(0.0, 1.0);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: size,
          height: size,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Background ring
              CustomPaint(
                size: Size(size, size),
                painter: _RingPainter(
                  progress: 1.0,
                  color: color.withOpacity(0.2),
                  strokeWidth: strokeWidth,
                ),
              ),
              // Progress ring
              CustomPaint(
                size: Size(size, size),
                painter: _RingPainter(
                  progress: clampedProgress,
                  color: color,
                  strokeWidth: strokeWidth,
                ),
              ),
              // Status indicator
              Positioned(
                bottom: 0,
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    status.emoji,
                    style: const TextStyle(fontSize: 12),
                  ),
                ),
              ),
              // Center text
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    value,
                    style: TextStyle(
                      fontSize: size * 0.18,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).textTheme.bodyLarge?.color,
                    ),
                  ),
                  Text(
                    unit,
                    style: TextStyle(
                      fontSize: size * 0.12,
                      color: Theme.of(context).textTheme.bodySmall?.color,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: Theme.of(context).textTheme.bodyMedium?.color,
          ),
        ),
      ],
    );
  }

  Color _getStatusColor() {
    switch (status) {
      case NutritionStatus.good:
        return const Color(0xFF4CAF50); // Green
      case NutritionStatus.warning:
        return const Color(0xFFFFC107); // Yellow/Amber
      case NutritionStatus.bad:
        return const Color(0xFFF44336); // Red
    }
  }
}

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

    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    // Draw arc from top (-90 degrees) clockwise
    final sweepAngle = 2 * math.pi * progress;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2, // Start from top
      sweepAngle,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(_RingPainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.color != color;
  }
}

/// Row of nutrition ring charts
class NutritionRingRow extends StatelessWidget {
  final double caloriesProgress;
  final NutritionStatus calorieStatus;
  final double calories;
  final double calorieTarget;

  final double proteinProgress;
  final NutritionStatus proteinStatus;
  final double protein;
  final double proteinTarget;

  final double carbsProgress;
  final NutritionStatus carbsStatus;
  final double carbs;
  final double carbsTarget;

  final double fatProgress;
  final NutritionStatus fatStatus;
  final double fat;
  final double fatTarget;

  const NutritionRingRow({
    super.key,
    required this.caloriesProgress,
    required this.calorieStatus,
    required this.calories,
    required this.calorieTarget,
    required this.proteinProgress,
    required this.proteinStatus,
    required this.protein,
    required this.proteinTarget,
    required this.carbsProgress,
    required this.carbsStatus,
    required this.carbs,
    required this.carbsTarget,
    required this.fatProgress,
    required this.fatStatus,
    required this.fat,
    required this.fatTarget,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        NutritionRingChart(
          progress: caloriesProgress,
          status: calorieStatus,
          label: 'Calories',
          value: calories.toInt().toString(),
          unit: '/${calorieTarget.toInt()}',
          size: 75,
        ),
        NutritionRingChart(
          progress: proteinProgress,
          status: proteinStatus,
          label: 'Protein',
          value: protein.toInt().toString(),
          unit: 'g',
          size: 75,
        ),
        NutritionRingChart(
          progress: carbsProgress,
          status: carbsStatus,
          label: 'Carbs',
          value: carbs.toInt().toString(),
          unit: 'g',
          size: 75,
        ),
        NutritionRingChart(
          progress: fatProgress,
          status: fatStatus,
          label: 'Fat',
          value: fat.toInt().toString(),
          unit: 'g',
          size: 75,
        ),
      ],
    );
  }
}

/// Micronutrient ring chart for tracking vitamins and minerals
class MicronutrientRingChart extends StatelessWidget {
  final double current;
  final double target;
  final NutritionStatus status;
  final String label;
  final String unit;

  const MicronutrientRingChart({
    super.key,
    required this.current,
    required this.target,
    required this.status,
    required this.label,
    required this.unit,
  });

  @override
  Widget build(BuildContext context) {
    final progress = target > 0 ? current / target : 0.0;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          NutritionRingChart(
            progress: progress,
            status: status,
            label: label,
            value: current.toStringAsFixed(1),
            unit: unit,
            size: 60,
            strokeWidth: 6,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${current.toStringAsFixed(1)} / ${target.toStringAsFixed(0)} $unit',
                  style: TextStyle(
                    fontSize: 12,
                    color: Theme.of(context).textTheme.bodySmall?.color,
                  ),
                ),
                const SizedBox(height: 4),
                LinearProgressIndicator(
                  value: progress.clamp(0.0, 1.0),
                  backgroundColor: _getStatusColor().withOpacity(0.2),
                  valueColor: AlwaysStoppedAnimation(_getStatusColor()),
                  minHeight: 4,
                  borderRadius: BorderRadius.circular(2),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor() {
    switch (status) {
      case NutritionStatus.good:
        return const Color(0xFF4CAF50);
      case NutritionStatus.warning:
        return const Color(0xFFFFC107);
      case NutritionStatus.bad:
        return const Color(0xFFF44336);
    }
  }
}

/// Status legend showing traffic light colors
class NutritionStatusLegend extends StatelessWidget {
  const NutritionStatusLegend({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _LegendItem(
          emoji: '🟢',
          label: 'On Track',
          color: const Color(0xFF4CAF50),
        ),
        const SizedBox(width: 16),
        _LegendItem(
          emoji: '🟡',
          label: 'Slightly Off',
          color: const Color(0xFFFFC107),
        ),
        const SizedBox(width: 16),
        _LegendItem(
          emoji: '🔴',
          label: 'Off Track',
          color: const Color(0xFFF44336),
        ),
      ],
    );
  }
}

class _LegendItem extends StatelessWidget {
  final String emoji;
  final String label;
  final Color color;

  const _LegendItem({
    required this.emoji,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: Theme.of(context).textTheme.bodySmall?.color,
          ),
        ),
      ],
    );
  }
}
