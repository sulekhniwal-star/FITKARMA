import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

class KarmaLevelCard extends StatelessWidget {
  final int level;
  final String levelTitle;
  final int currentXp;
  final int xpForNextLevel;
  final bool compact;

  const KarmaLevelCard({
    super.key,
    required this.level,
    required this.levelTitle,
    required this.currentXp,
    required this.xpForNextLevel,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    if (compact) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: AppColors.secondaryDark,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text('Lv.$level', style: AppTextStyles.captionOnDark.copyWith(fontWeight: FontWeight.w600)),
      );
    }

    final double progress = (currentXp / xpForNextLevel).clamp(0.0, 1.0);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: AppGradients.heroGradient,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.secondaryDark.withValues(alpha: 0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Karma Level', style: AppTextStyles.captionOnDark),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.accentLight,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.bolt, color: AppColors.accentDark, size: 14),
                    const SizedBox(width: 4),
                    Text('$currentXp XP', style: AppTextStyles.labelSmall.copyWith(color: AppColors.accentDark)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(levelTitle, style: AppTextStyles.displayMedium.copyWith(color: AppColors.white)),
          const SizedBox(height: 4),
          Text('Level $level', style: AppTextStyles.bodyOnDark),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              backgroundColor: AppColors.white.withValues(alpha: 0.2),
              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.accent),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${xpForNextLevel - currentXp} XP needed for Level ${level + 1}',
            style: AppTextStyles.captionOnDark,
          ),
        ],
      ),
    );
  }
}
