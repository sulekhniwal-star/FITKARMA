import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import '../../core/database/app_database.dart';
import '../health/readiness_engine.dart';

class DailyBriefingCard extends StatelessWidget {
  final ReadinessLog? log;
  final VoidCallback onCheckInTap;

  const DailyBriefingCard({
    super.key,
    required this.log,
    required this.onCheckInTap,
  });

  @override
  Widget build(BuildContext context) {
    if (log == null) {
      return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppRadius.lg),
          gradient: const LinearGradient(
            colors: [AppColorsDark.surface1, AppColorsDark.surface0],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          border: Border.all(color: AppColorsDark.glassBorder),
        ),
        padding: const EdgeInsets.all(AppSpacing.cardInner),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColorsDark.primaryMuted,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.wb_sunny, color: AppColorsDark.primary, size: 20),
                ),
                const SizedBox(width: 12),
                Text(
                  'Morning Briefing',
                  style: AppTypography.h2(color: AppColorsDark.textPrimary),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              'How did you sleep? Check in to unlock today\'s customized readiness score and adaptive targets.',
              style: AppTypography.bodyMd(color: AppColorsDark.textSecondary),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: onCheckInTap,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColorsDark.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppRadius.md),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Text('Start Check-In'),
                  SizedBox(width: 8),
                  Icon(Icons.arrow_forward, size: 16),
                ],
              ),
            ),
          ],
        ),
      );
    }

    final score = log!.score;
    // Map log zone string to ReadinessZone enum
    final zoneEnum = ReadinessZone.values.firstWhere(
      (e) => e.name == log!.zone,
      orElse: () => ReadinessZone.moderate,
    );
    
    final result = ReadinessEngine.calculate(
      sleepMinutes: log!.sleepMinutes ?? 420,
      sleepQuality: log!.sleepQuality ?? 7,
      sorenessLevel: log!.sorenessLevel ?? 3,
      stressLevel: log!.stressLevel ?? 3,
      energyLevel: log!.energyLevel ?? 7,
      restingHr: log!.restingHr,
    );

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.lg),
        color: AppColorsDark.surface1,
        border: Border.all(color: AppColorsDark.glassBorder),
      ),
      padding: const EdgeInsets.all(AppSpacing.cardInner),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: result.color,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: result.color.withValues(alpha: 0.4),
                          blurRadius: 6,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'Readiness: ${result.zoneLabel}',
                    style: AppTypography.h2(color: AppColorsDark.textPrimary),
                  ),
                ],
              ),
              Text(
                '$score/100',
                style: AppTypography.h2(color: result.color),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            result.recommendation,
            style: AppTypography.bodyMd(color: AppColorsDark.textSecondary),
          ),
          const Divider(color: AppColorsDark.divider, height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _BriefingMetric(
                icon: Icons.fitness_center,
                title: 'Workout',
                value: result.workoutIntensity.toUpperCase(),
                color: AppColorsDark.secondary,
              ),
              _BriefingMetric(
                icon: Icons.water_drop,
                title: 'Hydration',
                value: '${result.waterTargetMl} mL',
                color: AppColorsDark.teal,
              ),
              _BriefingMetric(
                icon: Icons.directions_walk,
                title: 'Steps',
                value: '${result.stepTarget}',
                color: AppColorsDark.accent,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _BriefingMetric extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final Color color;

  const _BriefingMetric({
    required this.icon,
    required this.title,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: color, size: 22),
        const SizedBox(height: 6),
        Text(
          title,
          style: AppTypography.labelSm(color: AppColorsDark.textMuted),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: AppTypography.bodyMd(color: AppColorsDark.textPrimary).copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}
