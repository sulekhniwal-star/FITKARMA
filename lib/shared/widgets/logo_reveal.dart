import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';

/// LogoReveal — A smooth entrance animation for the app logo.
class LogoReveal extends StatelessWidget {
  const LogoReveal({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Placeholder Logo Icon
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            color: AppColorsDark.primary,
            borderRadius: BorderRadius.circular(24),
            boxShadow: const [
              BoxShadow(
                color: AppColorsDark.primaryGlow,
                blurRadius: 30,
                spreadRadius: 2,
              ),
            ],
          ),
          child: const Icon(
            Icons.fitbit_rounded, // Using fitbit as a placeholder logo
            size: 60,
            color: Colors.white,
          ),
        )
            .animate()
            .scale(
              duration: 800.ms,
              curve: Curves.elasticOut,
              begin: const Offset(0, 0),
              end: const Offset(1, 1),
            )
            .shimmer(delay: 1000.ms, duration: 1500.ms),
        const SizedBox(height: 24),
        Text(
          'FitKarma',
          style: AppTypography.displayLg(color: AppColorsDark.textPrimary),
        ).animate().fade(delay: 400.ms, duration: 600.ms).slideY(begin: 0.2, end: 0),
        const SizedBox(height: 8),
        Text(
          'Elevate your life',
          style: AppTypography.bodyMd(color: AppColorsDark.textSecondary).copyWith(
            letterSpacing: 4.0,
          ),
        ).animate().fade(delay: 800.ms, duration: 600.ms).slideY(begin: 0.2, end: 0),
      ],
    );
  }
}
