import 'package:flutter/material.dart';

import '../../../../shared/theme/app_colors.dart';
import '../../../../shared/theme/app_text_styles.dart';

class LargeStepRing extends StatelessWidget {
  final int currentSteps;
  final int goalSteps;

  const LargeStepRing({
    super.key,
    required this.currentSteps,
    required this.goalSteps,
  });

  @override
  Widget build(BuildContext context) {
    final double progress = (currentSteps / goalSteps).clamp(0.0, 1.0);
    final int percentage = (progress * 100).toInt();

    return SizedBox(
      height: 220,
      width: 220,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background Ring
          SizedBox(
            height: 200,
            width: 200,
            child: CircularProgressIndicator(
              value: 1.0,
              strokeWidth: 16,
              color: AppColors.success.withValues(alpha: 0.2), // Green track
            ),
          ),
          
          // Foreground Ring
          SizedBox(
            height: 200,
            width: 200,
            child: TweenAnimationBuilder<double>(
              tween: Tween<double>(begin: 0, end: progress),
              duration: const Duration(milliseconds: 1500),
              curve: Curves.easeOutCubic,
              builder: (context, value, _) {
                return CircularProgressIndicator(
                  value: value,
                  strokeWidth: 16,
                  strokeCap: StrokeCap.round,
                  color: AppColors.success, // Green fill
                );
              },
            ),
          ),
          
          // Inner content
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.directions_walk, color: AppColors.success, size: 32),
              const SizedBox(height: 8),
              Text(
                currentSteps.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},'),
                style: AppTextStyles.displayMedium.copyWith(color: AppColors.textPrimary),
              ),
              const SizedBox(height: 4),
              Text('/ $goalSteps steps', style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary)),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.success.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text('$percentage%', style: AppTextStyles.labelSmall.copyWith(color: AppColors.success, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
