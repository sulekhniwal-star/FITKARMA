import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

/// Karma level card widget
///
/// Dark purple/indigo gradient card showing karma level, progress bar,
/// XP count, and level title
/// Per Section 2.1 Karma & Ayurveda Screen
class KarmaLevelCard extends StatelessWidget {
  /// Current karma level (1-50)
  final int level;

  /// Level title (e.g., "Warrior", "Champion")
  final String levelTitle;

  /// Current XP
  final int currentXp;

  /// XP needed for next level
  final int xpForNextLevel;

  /// Total XP accumulated
  final int totalXp;

  /// Callback when card is tapped
  final VoidCallback? onTap;

  const KarmaLevelCard({
    super.key,
    required this.level,
    required this.levelTitle,
    required this.currentXp,
    required this.xpForNextLevel,
    required this.totalXp,
    this.onTap,
  });

  /// Progress percentage (0.0 - 1.0)
  double get progress => currentXp / xpForNextLevel;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppColors.secondary, AppColors.secondaryDark],
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppColors.secondary.withValues(alpha: 0.4),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Karma Level',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  // XP badge
                  Row(
                    children: [
                      const Icon(
                        Icons.stars,
                        color: AppColors.accent,
                        size: 18,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${totalXp.toString()} XP',
                        style: const TextStyle(
                          color: AppColors.accent,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Level title
              Text(levelTitle, style: AppTextStyles.karmaLevel),
              const SizedBox(height: 8),
              // Level number
              Text(
                'Level $level',
                style: const TextStyle(color: Colors.white70, fontSize: 14),
              ),
              const SizedBox(height: 16),
              // Progress bar
              _ProgressBar(progress: progress),
              const SizedBox(height: 8),
              // XP text
              Text(
                '$currentXp / $xpForNextLevel XP to Level ${level + 1}',
                style: const TextStyle(color: Colors.white60, fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Progress bar widget
class _ProgressBar extends StatelessWidget {
  final double progress;

  const _ProgressBar({required this.progress});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 8,
      decoration: BoxDecoration(
        color: Colors.white24,
        borderRadius: BorderRadius.circular(4),
      ),
      child: FractionallySizedBox(
        alignment: Alignment.centerLeft,
        widthFactor: progress.clamp(0.0, 1.0),
        child: Container(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AppColors.accent, AppColors.accentLight],
            ),
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ),
    );
  }
}

/// Compact karma level badge for header
class KarmaLevelBadge extends StatelessWidget {
  final int level;
  final String levelTitle;
  final int xp;
  final double size;

  const KarmaLevelBadge({
    super.key,
    required this.level,
    required this.levelTitle,
    required this.xp,
    this.size = 40,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.secondary, AppColors.secondaryDark],
        ),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: AppColors.secondary.withValues(alpha: 0.4),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '$level',
            style: TextStyle(
              color: Colors.white,
              fontSize: size * 0.35,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

/// Karma coin widget
class KarmaCoin extends StatelessWidget {
  final int amount;
  final double size;

  const KarmaCoin({super.key, required this.amount, this.size = 24});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.stars, color: AppColors.accent, size: size),
        const SizedBox(width: 4),
        Text(
          '$amount XP',
          style: AppTextStyles.labelMedium.copyWith(
            color: AppColors.accent,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
