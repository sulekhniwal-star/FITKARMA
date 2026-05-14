import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/theme/app_spacing.dart';
import '../../shared/widgets/scaffold_patterns.dart';
import '../../shared/widgets/bento_card.dart';
import '../onboarding/onboarding_providers.dart';

class WorkoutScreen extends ConsumerWidget {
  const WorkoutScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authProvider).value;

    return AppScaffold.patternA(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text('${user?.name.split(' ').first ?? "Your"} Workouts', style: AppTypography.h1(color: Colors.white)),
        actions: [
          IconButton(
            icon: const Icon(Icons.history_rounded, color: Colors.white),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Workout history engine synchronized.'),
                  backgroundColor: AppColorsDark.teal,
                ),
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),

            // Hero Premium Custom Starter Banner
            GlassCard(
              customRadius: AppRadius.xl,
              glowColor: AppColorsDark.accentGlow,
              padding: const EdgeInsets.all(24),
              onTap: () => context.push('/workout/active/wkt_custom_Freestyle Session'),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColorsDark.accent.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.bolt_rounded, color: AppColorsDark.accent, size: 36),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Quick Start', style: AppTypography.labelSm(color: AppColorsDark.accent)),
                        const SizedBox(height: 4),
                        Text('Freestyle Session', style: AppTypography.h2(color: Colors.white)),
                        const SizedBox(height: 4),
                        Text(
                          'Log ad-hoc weights, sets, and custom lifts instantly.',
                          style: AppTypography.bodySm(color: AppColorsDark.textSecondary),
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.arrow_forward_ios_rounded, color: Colors.white, size: 16),
                ],
              ),
            ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.1, end: 0),

            const SizedBox(height: AppSpacing.lg),

            // Section: Ayurvedic Dosha Flows
            Text('Dosha Personalized Flows', style: AppTypography.h2(color: Colors.white)),
            const SizedBox(height: 4),
            Text(
              'Tailored to align physical conditioning with active Prakriti balances.',
              style: AppTypography.bodySm(color: AppColorsDark.textMuted),
            ),
            const SizedBox(height: 16),

            _buildRoutineCard(
              context,
              title: 'Vata Grounding Yoga & Core',
              category: 'Slow cadence • Joint stability',
              color: AppColorsDark.teal,
              icon: Icons.self_improvement_rounded,
              routineId: 'wkt_routine_Vata Grounding Yoga',
              delayMs: 100,
            ),
            const SizedBox(height: 12),
            _buildRoutineCard(
              context,
              title: 'Pitta Cooling Strength',
              category: 'Moderate volume • Heat dissipation',
              color: AppColorsDark.secondary,
              icon: Icons.fitness_center_rounded,
              routineId: 'wkt_routine_Pitta Cooling Strength',
              delayMs: 200,
            ),
            const SizedBox(height: 12),
            _buildRoutineCard(
              context,
              title: 'Kapha Stimulating HIIT',
              category: 'High metabolic output • Vigorous pace',
              color: AppColorsDark.rose,
              icon: Icons.local_fire_department_rounded,
              routineId: 'wkt_routine_Kapha Stimulating HIIT',
              delayMs: 300,
            ),

            const SizedBox(height: AppSpacing.xl),

            // Section: Western Strength & Hypertrophy Splits
            Text('Targeted Western Splits', style: AppTypography.h2(color: Colors.white)),
            const SizedBox(height: 4),
            Text(
              'Progressive overload templates for localized structural adaptations.',
              style: AppTypography.bodySm(color: AppColorsDark.textMuted),
            ),
            const SizedBox(height: 16),

            _buildRoutineCard(
              context,
              title: 'Upper Body Hypertrophy (Push)',
              category: 'Chest • Anterior Deltoids • Triceps',
              color: AppColorsDark.primary,
              icon: Icons.sports_gymnastics_rounded,
              routineId: 'wkt_split_Upper Body Push Focus',
              delayMs: 400,
            ),
            const SizedBox(height: 12),
            _buildRoutineCard(
              context,
              title: 'Posterior Chain Power (Pull)',
              category: 'Lats • Rhomboids • Biceps • Hamstrings',
              color: AppColorsDark.purple,
              icon: Icons.rowing_rounded,
              routineId: 'wkt_split_Posterior Pull Focus',
              delayMs: 500,
            ),
            const SizedBox(height: 12),
            _buildRoutineCard(
              context,
              title: 'Lower Body Athletic Engine',
              category: 'Quadriceps • Glutes • Calves',
              color: AppColorsDark.accent,
              icon: Icons.directions_run_rounded,
              routineId: 'wkt_split_Lower Body Engine',
              delayMs: 600,
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildRoutineCard(
    BuildContext context, {
    required String title,
    required String category,
    required Color color,
    required IconData icon,
    required String routineId,
    required int delayMs,
  }) {
    return GlassCard(
      onTap: () => context.push('/workout/active/$routineId'),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTypography.h3(color: Colors.white)),
                const SizedBox(height: 2),
                Text(category, style: AppTypography.labelSm(color: AppColorsDark.textSecondary)),
              ],
            ),
          ),
          const Icon(Icons.play_circle_fill_rounded, color: Colors.white54, size: 28),
        ],
      ),
    ).animate().fadeIn(delay: delayMs.ms, duration: 400.ms).slideX(begin: 0.05, end: 0);
  }
}
