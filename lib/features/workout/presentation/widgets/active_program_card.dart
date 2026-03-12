import 'package:flutter/material.dart';
import '../../../../shared/theme/app_colors.dart';
import '../../../../shared/theme/app_text_styles.dart';

class ActiveProgramCard extends StatelessWidget {
  final String title;
  final String progressText;
  final double progressValue;
  final String nextWorkoutTitle;
  final VoidCallback onResume;

  const ActiveProgramCard({
    super.key,
    required this.title,
    required this.progressText,
    required this.progressValue,
    required this.nextWorkoutTitle,
    required this.onResume,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: const Border(
          left: BorderSide(color: AppColors.secondary, width: 6),
          top: BorderSide(color: AppColors.divider),
          right: BorderSide(color: AppColors.divider),
          bottom: BorderSide(color: AppColors.divider),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Active Program', style: AppTextStyles.labelMedium.copyWith(color: AppColors.secondary)),
                Text(progressText, style: AppTextStyles.labelSmall.copyWith(color: AppColors.textSecondary)),
              ],
            ),
            const SizedBox(height: 8),
            Text(title, style: AppTextStyles.h3),
            const SizedBox(height: 16),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: progressValue,
                backgroundColor: AppColors.divider,
                valueColor: const AlwaysStoppedAnimation<Color>(AppColors.secondary),
                minHeight: 6,
              ),
            ),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Up Next', style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary)),
                      const SizedBox(height: 4),
                      Text(nextWorkoutTitle, style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: onResume,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    elevation: 0,
                  ),
                  child: const Text('Resume'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
