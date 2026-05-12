import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_gradients.dart';
import '../../core/theme/app_typography.dart';
import '../../shared/widgets/scaffold_patterns.dart';

/// WelcomeScreen — The first touchpoint after the splash screen.
/// Designed to be high-impact and welcoming.
class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold.patternC(
      gradient: AppGradients.heroDeep,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0),
        child: Column(
          children: [
            const Spacer(flex: 2),

            // App Logo
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColorsDark.primary,
                    AppColorsDark.accent,
                  ],
                ),
                borderRadius: BorderRadius.circular(28),
                boxShadow: [
                  BoxShadow(
                    color: AppColorsDark.primary.withValues(alpha: 0.3),
                    blurRadius: 30,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: const Icon(
                Icons.fitbit_rounded,
                size: 60,
                color: Colors.white,
              ),
            ),

            const SizedBox(height: 32),

            // Brand & Tagline
            Text(
              'FitKarma',
              style: AppTypography.heroDisplay(color: Colors.white),
            ),
            const SizedBox(height: 16),
            Text(
              'Elevate your life through\nancient wisdom & modern science.',
              textAlign: TextAlign.center,
              style: AppTypography.bodyLg(color: AppColorsDark.textSecondary).copyWith(
                height: 1.5,
              ),
            ),

            const Spacer(flex: 3),

            // CTA Button
            _PrimaryButton(
              text: 'Get Started',
              onPressed: () => context.go('/onboarding/signup'), // Assuming next step is signup
            ),

            const SizedBox(height: 24),

            // Sign In Link
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Already have an account? ',
                  style: AppTypography.bodyMd(color: AppColorsDark.textSecondary),
                ),
                GestureDetector(
                  onTap: () => context.go('/onboarding/login'), // Assuming login route
                  child: Text(
                    'Sign in',
                    style: AppTypography.bodyMd(color: AppColorsDark.primary).copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 48),
          ],
        ),
      ),
    );
  }
}

class _PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const _PrimaryButton({
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColorsDark.primary.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColorsDark.primary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 0,
        ),
        child: Text(
          text,
          style: AppTypography.h3(color: Colors.white).copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
