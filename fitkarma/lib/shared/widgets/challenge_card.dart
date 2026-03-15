import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

/// Challenge card widget
///
/// Horizontally scrollable cards showing active challenges
/// Per Section 2.1 Karma & Ayurveda Screen - Challenges Carousel
///
/// Shows: challenge name, progress bar, day count (e.g., "Day 3/7"), reward XP
class ChallengeCard extends StatelessWidget {
  /// Challenge name
  final String name;

  /// Challenge description (optional)
  final String? description;

  /// Current day number
  final int currentDay;

  /// Total days in challenge
  final int totalDays;

  /// XP reward for completing challenge
  final int xpReward;

  /// Progress percentage (0.0 - 1.0)
  final double progress;

  /// Whether the challenge is completed
  final bool isCompleted;

  /// Callback when card is tapped
  final VoidCallback? onTap;

  const ChallengeCard({
    super.key,
    required this.name,
    this.description,
    required this.currentDay,
    required this.totalDays,
    required this.xpReward,
    required this.progress,
    this.isCompleted = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 200,
        margin: const EdgeInsets.only(right: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: isCompleted
              ? const LinearGradient(
                  colors: [AppColors.success, Color(0xFF388E3C)],
                )
              : const LinearGradient(
                  colors: [AppColors.secondary, AppColors.secondaryDark],
                ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: (isCompleted ? AppColors.success : AppColors.secondary)
                  .withValues(alpha: 0.4),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Day indicator
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white24,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                'Day $currentDay/$totalDays',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 12),
            // Challenge name
            Text(
              name,
              style: AppTextStyles.titleMedium.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            // Description
            if (description != null) ...[
              const SizedBox(height: 4),
              Text(
                description!,
                style: const TextStyle(color: Colors.white70, fontSize: 12),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
            const Spacer(),
            // Progress bar
            _ProgressBar(progress: progress),
            const SizedBox(height: 8),
            // XP reward
            Row(
              children: [
                const Icon(Icons.stars, color: AppColors.accent, size: 16),
                const SizedBox(width: 4),
                Text(
                  '+$xpReward XP',
                  style: const TextStyle(
                    color: AppColors.accent,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                if (isCompleted)
                  const Icon(Icons.check_circle, color: Colors.white, size: 20),
              ],
            ),
          ],
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
      height: 6,
      decoration: BoxDecoration(
        color: Colors.white24,
        borderRadius: BorderRadius.circular(3),
      ),
      child: FractionallySizedBox(
        alignment: Alignment.centerLeft,
        widthFactor: progress.clamp(0.0, 1.0),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
      ),
    );
  }
}

/// Challenges carousel widget
class ChallengeCarousel extends StatelessWidget {
  /// List of challenges
  final List<ChallengeData> challenges;

  /// Height of each card
  final double cardHeight;

  const ChallengeCarousel({
    super.key,
    required this.challenges,
    this.cardHeight = 160,
  });

  @override
  Widget build(BuildContext context) {
    if (challenges.isEmpty) {
      return const SizedBox.shrink();
    }

    return SizedBox(
      height: cardHeight,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: challenges.length,
        itemBuilder: (context, index) {
          final challenge = challenges[index];
          return ChallengeCard(
            name: challenge.name,
            description: challenge.description,
            currentDay: challenge.currentDay,
            totalDays: challenge.totalDays,
            xpReward: challenge.xpReward,
            progress: challenge.progress,
            isCompleted: challenge.isCompleted,
            onTap: challenge.onTap,
          );
        },
      ),
    );
  }
}

/// Data class for challenge
class ChallengeData {
  final String name;
  final String? description;
  final int currentDay;
  final int totalDays;
  final int xpReward;
  final double progress;
  final bool isCompleted;
  final VoidCallback? onTap;

  const ChallengeData({
    required this.name,
    this.description,
    required this.currentDay,
    required this.totalDays,
    required this.xpReward,
    required this.progress,
    this.isCompleted = false,
    this.onTap,
  });
}

/// Empty challenge state
class ChallengeEmptyState extends StatelessWidget {
  final VoidCallback? onBrowseChallenges;

  const ChallengeEmptyState({super.key, this.onBrowseChallenges});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.emoji_events_outlined,
            size: 48,
            color: AppColors.textSecondary,
          ),
          const SizedBox(height: 12),
          Text('No Active Challenges', style: AppTextStyles.titleMedium),
          const SizedBox(height: 4),
          Text('Join a challenge to earn XP!', style: AppTextStyles.bodySmall),
          if (onBrowseChallenges != null) ...[
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: onBrowseChallenges,
              child: const Text('Browse Challenges'),
            ),
          ],
        ],
      ),
    );
  }
}
