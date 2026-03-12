import 'package:flutter/material.dart';
import '../../../../shared/theme/app_colors.dart';
import '../../../../shared/theme/app_text_styles.dart';

class WorkoutGridCard extends StatelessWidget {
  final String title;
  final String duration;
  final String difficulty;
  final bool isPremium;
  final VoidCallback onTap;

  const WorkoutGridCard({
    super.key,
    required this.title,
    required this.duration,
    required this.difficulty,
    this.isPremium = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Color difficultyColor;
    if (difficulty.toLowerCase() == 'beginner') {
      difficultyColor = AppColors.success;
    } else if (difficulty.toLowerCase() == 'advanced') {
      difficultyColor = AppColors.error;
    } else {
      difficultyColor = AppColors.primary;
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.divider),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Thumbnail
            Expanded(
              flex: 5,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      color: AppColors.surfaceVariant,
                      borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
                    ),
                    child: const Center(
                      child: Icon(Icons.fitness_center, size: 40, color: AppColors.textMuted),
                    ),
                  ),
                  if (isPremium)
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.6),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.lock, size: 14, color: AppColors.accent),
                      ),
                    ),
                ],
              ),
            ),
            
            // Details
            Expanded(
              flex: 4,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      title,
                      style: AppTextStyles.labelLarge.copyWith(height: 1.2),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.timer, size: 12, color: AppColors.textSecondary),
                            const SizedBox(width: 4),
                            Text(duration, style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary)),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: difficultyColor.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            difficulty,
                            style: AppTextStyles.caption.copyWith(
                              color: difficultyColor, 
                              fontWeight: FontWeight.bold,
                              fontSize: 10,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
