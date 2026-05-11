import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';

/// LogoReveal — A smooth entrance animation for the app logo.
/// Designed for a 1.5s total reveal time.
class LogoReveal extends StatelessWidget {
  const LogoReveal({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Premium Logo Icon with Spring Reveal
        Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColorsDark.primary,
                AppColorsDark.accent,
              ],
            ),
            borderRadius: BorderRadius.circular(32),
            boxShadow: [
              BoxShadow(
                color: AppColorsDark.primary.withOpacity(0.4),
                blurRadius: 40,
                spreadRadius: 2,
              ),
              BoxShadow(
                color: AppColorsDark.accent.withOpacity(0.2),
                blurRadius: 20,
                offset: const Offset(10, 10),
              ),
            ],
          ),
          child: const Icon(
            Icons.fitbit_rounded, // Brand symbol placeholder
            size: 72,
            color: Colors.white,
          ),
        )
            .animate()
            .scale(
              duration: 1200.ms,
              curve: Curves.elasticOut,
              begin: const Offset(0, 0),
              end: const Offset(1, 1),
            )
            .shimmer(delay: 800.ms, duration: 700.ms, color: Colors.white24),

        const SizedBox(height: 32),

        // Brand Name
        Text(
          'FitKarma',
          style: AppTypography.displayLg(color: AppColorsDark.textPrimary).copyWith(
            letterSpacing: -0.5,
            fontWeight: FontWeight.bold,
          ),
        )
            .animate()
            .fadeIn(delay: 300.ms, duration: 600.ms)
            .slideY(begin: 0.3, end: 0, curve: Curves.easeOutCubic),

        const SizedBox(height: 12),

        // Tagline
        Text(
          'ELEVATE YOUR LIFE',
          style: AppTypography.bodySm(color: AppColorsDark.textSecondary).copyWith(
            letterSpacing: 6.0,
            fontWeight: FontWeight.w600,
          ),
        )
            .animate()
            .fadeIn(delay: 600.ms, duration: 600.ms)
            .slideY(begin: 0.5, end: 0, curve: Curves.easeOutCubic),
      ],
    );
  }
}
