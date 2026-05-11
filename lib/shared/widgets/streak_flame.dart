import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';

/// StreakFlame — An animated indicator of the user's daily streak.
class StreakFlame extends StatelessWidget {
  final int count;

  const StreakFlame({super.key, required this.count});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.local_fire_department_rounded,
          color: AppColorsDark.accent,
          size: 28,
        )
            .animate(onPlay: (controller) => controller.repeat())
            .scale(
              begin: const Offset(1.0, 1.0),
              end: const Offset(1.15, 1.15),
              duration: 800.ms,
              curve: Curves.easeInOut,
            )
            .then()
            .scale(
              begin: const Offset(1.15, 1.15),
              end: const Offset(1.0, 1.0),
              duration: 800.ms,
              curve: Curves.easeInOut,
            ),
        const SizedBox(width: 8),
        Text(
          '$count',
          style: AppTypography.metricLg(color: AppColorsDark.accent),
        ),
      ],
    );
  }
}
