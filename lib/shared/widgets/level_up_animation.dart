import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';

/// LevelUpAnimation — A celebratory overlay for XP level-ups.
class LevelUpAnimation extends StatelessWidget {
  final int newLevel;
  final VoidCallback onComplete;

  const LevelUpAnimation({
    super.key,
    required this.newLevel,
    required this.onComplete,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black.withOpacity(0.8),
      child: InkWell(
        onTap: onComplete,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.auto_awesome,
                size: 80,
                color: AppColorsDark.accent,
              )
                  .animate()
                  .scale(duration: 600.ms, curve: Curves.elasticOut)
                  .shimmer(delay: 400.ms, duration: 1200.ms),
              const SizedBox(height: 24),
              Text(
                'LEVEL UP!',
                style: AppTypography.displayLg(color: AppColorsDark.accent),
              ).animate().fade(delay: 200.ms).slideY(begin: 0.2, end: 0),
              const SizedBox(height: 12),
              Text(
                'You reached Level $newLevel',
                style: AppTypography.h2(color: Colors.white),
              ).animate().fade(delay: 400.ms).slideY(begin: 0.2, end: 0),
              const SizedBox(height: 48),
              Text(
                'Tap to continue',
                style: AppTypography.labelMd(color: Colors.white54),
              ).animate(onPlay: (c) => c.repeat(reverse: true)).fade(duration: 800.ms),
            ],
          ),
        ),
      ),
    );
  }
}
