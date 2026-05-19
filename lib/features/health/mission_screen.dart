import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import 'readiness_provider.dart';

class MissionScreen extends ConsumerWidget {
  const MissionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final missionAsync = ref.watch(currentDailyMissionProvider);

    return Scaffold(
      backgroundColor: AppColorsDark.bg0,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColorsDark.textPrimary),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Daily Coaching Mission',
          style: AppTypography.h2(color: AppColorsDark.textPrimary),
        ),
      ),
      body: missionAsync.when(
        loading: () => const Center(child: CircularProgressIndicator(color: AppColorsDark.primary)),
        error: (e, _) => Center(child: Text('Error: $e', style: AppTypography.bodyMd(color: AppColorsDark.error))),
        data: (mission) {
          if (mission == null) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.lock_clock, color: AppColorsDark.textMuted, size: 64),
                    const SizedBox(height: 16),
                    Text(
                      'No Mission Active Yet',
                      style: AppTypography.h2(color: AppColorsDark.textPrimary),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Complete your morning check-in to generate today\'s dynamic coaching targets.',
                      textAlign: TextAlign.center,
                      style: AppTypography.bodyMd(color: AppColorsDark.textSecondary),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () => context.push('/recovery'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColorsDark.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppRadius.md),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      ),
                      child: const Text('Go to Morning Check-In'),
                    ),
                  ],
                ),
              ),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.screenH),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppColorsDark.heroDeepStart, AppColorsDark.heroDeepEnd],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(AppRadius.lg),
                    border: Border.all(color: AppColorsDark.glassBorder),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColorsDark.primary.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: AppColorsDark.primary.withValues(alpha: 0.3)),
                            ),
                            child: Text(
                              'ACTIVE MISSION',
                              style: AppTypography.labelSm(color: AppColorsDark.primary).copyWith(fontWeight: FontWeight.bold),
                            ),
                          ),
                          const Icon(Icons.star, color: AppColorsDark.accent),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        mission.title,
                        style: AppTypography.h1(color: AppColorsDark.textPrimary),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        mission.description,
                        style: AppTypography.bodyMd(color: AppColorsDark.textSecondary),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                Text(
                  'Today\'s Core Targets',
                  style: AppTypography.h2(color: AppColorsDark.textPrimary),
                ),
                const SizedBox(height: 12),

                // Target cards list
                _buildTargetTile(
                  icon: Icons.fitness_center,
                  title: 'Workout Level',
                  value: mission.workoutIntensity.toUpperCase(),
                  description: 'Recommended workout load based on HRV & soreness.',
                  color: AppColorsDark.secondary,
                ),
                const SizedBox(height: 12),
                _buildTargetTile(
                  icon: Icons.water_drop,
                  title: 'Hydration Target',
                  value: '${mission.waterTargetMl} mL',
                  description: 'Drink water consistently throughout the day.',
                  color: AppColorsDark.teal,
                ),
                const SizedBox(height: 12),
                _buildTargetTile(
                  icon: Icons.directions_walk,
                  title: 'Step Goal',
                  value: '${mission.stepTarget} steps',
                  description: 'Active recovery walking or general activity target.',
                  color: AppColorsDark.accent,
                ),
                const SizedBox(height: 12),
                _buildTargetTile(
                  icon: Icons.restaurant_menu,
                  title: 'Nutrition Limit',
                  value: '${mission.calorieTarget} kcal',
                  description: 'Estimated energy target for physical activities.',
                  color: AppColorsDark.rose,
                ),

                const SizedBox(height: 24),
                // AI Coach Insight Card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColorsDark.surface1,
                    borderRadius: BorderRadius.circular(AppRadius.lg),
                    border: Border.all(color: AppColorsDark.glassBorder),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.auto_awesome, color: AppColorsDark.accent, size: 20),
                          const SizedBox(width: 8),
                          Text(
                            'AI Adaptations Today',
                            style: AppTypography.h3(color: AppColorsDark.textPrimary),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Your target metrics have been updated dynamically to accommodate your current recovery score. Staying within these guardrails will yield +50 Karma XP.',
                        style: AppTypography.bodyMd(color: AppColorsDark.textSecondary),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildTargetTile({
    required IconData icon,
    required String title,
    required String value,
    required String description,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColorsDark.surface1,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: AppColorsDark.glassBorder),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      title,
                      style: AppTypography.bodyMd(color: AppColorsDark.textPrimary).copyWith(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      value,
                      style: AppTypography.bodyMd(color: color).copyWith(fontWeight: FontWeight.w800),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: AppTypography.labelSm(color: AppColorsDark.textSecondary),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
