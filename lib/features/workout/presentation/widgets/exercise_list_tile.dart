import 'package:flutter/material.dart';
import '../../../../shared/theme/app_colors.dart';
import '../../../../shared/theme/app_text_styles.dart';

class ExerciseListTile extends StatelessWidget {
  final int index;
  final String title;
  final String setsReps;
  final String restTime;
  final IconData muscleGroupIcon;

  const ExerciseListTile({
    super.key,
    required this.index,
    required this.title,
    required this.setsReps,
    required this.restTime,
    required this.muscleGroupIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(
        color: AppColors.white,
        border: Border(bottom: BorderSide(color: AppColors.divider)),
      ),
      child: Row(
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: AppColors.surfaceVariant,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                '$index',
                style: AppTextStyles.labelMedium.copyWith(color: AppColors.textSecondary),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTextStyles.bodyLarge),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(muscleGroupIcon, size: 14, color: AppColors.textSecondary),
                    const SizedBox(width: 4),
                    Text(setsReps, style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary)),
                    const SizedBox(width: 12),
                    const Icon(Icons.timer_outlined, size: 14, color: AppColors.textSecondary),
                    const SizedBox(width: 4),
                    Text('Rest $restTime', style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary)),
                  ],
                ),
              ],
            ),
          ),
          const Icon(Icons.play_circle_outline, color: AppColors.primary),
        ],
      ),
    );
  }
}
