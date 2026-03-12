import 'package:flutter/material.dart';
import '../../../../shared/theme/app_colors.dart';
import '../../../../shared/theme/app_text_styles.dart';

class DayDetailCard extends StatelessWidget {
  final DateTime date;
  final bool hasWorkout;
  final String workoutName;
  final String duration;
  final String calories;
  final bool isCompleted;

  const DayDetailCard({
    super.key,
    required this.date,
    required this.hasWorkout,
    this.workoutName = '',
    this.duration = '',
    this.calories = '',
    this.isCompleted = false,
  });

  @override
  Widget build(BuildContext context) {
    if (!hasWorkout) {
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppColors.surfaceVariant,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.divider, style: BorderStyle.none),
        ),
        child: Center(
          child: Column(
            children: [
              const Icon(Icons.airline_seat_recline_extra, size: 32, color: AppColors.textSecondary),
              const SizedBox(height: 12),
              Text('Rest Day', style: AppTextStyles.h4.copyWith(color: AppColors.textSecondary)),
              Text('Recovery is important!', style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary)),
            ],
          ),
        ),
      );
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isCompleted ? AppColors.success.withValues(alpha: 0.5) : AppColors.primary.withValues(alpha: 0.5),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isCompleted ? AppColors.success.withValues(alpha: 0.1) : AppColors.primarySurface,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              isCompleted ? Icons.check_circle : Icons.fitness_center,
              color: isCompleted ? AppColors.success : AppColors.primary,
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(workoutName, style: AppTextStyles.h4),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.timer, size: 12, color: AppColors.textSecondary),
                    const SizedBox(width: 4),
                    Text(duration, style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary)),
                    if (isCompleted) ...[
                      const SizedBox(width: 12),
                      const Icon(Icons.local_fire_department, size: 12, color: AppColors.primary),
                      const SizedBox(width: 4),
                      Text('$calories kcal', style: AppTextStyles.caption.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold)),
                    ],
                  ],
                ),
              ],
            ),
          ),
          if (!isCompleted)
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                elevation: 0,
              ),
              child: const Text('Start'),
            ),
        ],
      ),
    );
  }
}
