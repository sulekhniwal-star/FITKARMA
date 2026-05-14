import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/theme/app_spacing.dart';
import '../../shared/widgets/scaffold_patterns.dart';
import '../../shared/widgets/bento_card.dart';
import '../../shared/widgets/activity_rings.dart';
import '../../shared/widgets/streak_flame.dart';
import '../../shared/widgets/insight_card.dart';
import '../onboarding/onboarding_providers.dart';
import '../insights/correlation_engine.dart';
import '../streak/streak_providers.dart';
import '../karma/karma_providers.dart';
import '../health/steps_providers.dart';
import '../../core/providers/core_providers.dart';
import '../../core/database/app_database.dart';
import '../../core/services/home_widget_service.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authProvider).value;
    final insightsAsync = ref.watch(correlationEngineProvider);

    final karmaState = ref.watch(karmaStateProvider);
    final stepsAsync = ref.watch(stepsDataProvider);
    final isProAsync = ref.watch(isProProvider);

    final stepsVal = stepsAsync.value?.totalSteps ?? 0;
    final stepGoalVal = stepsAsync.value?.dailyGoal ?? 10000;
    final isProVal = isProAsync.value ?? false;

    ref.listen(karmaStateProvider, (prev, next) {
      HomeWidgetService.updateWidgets(steps: stepsVal, stepGoal: stepGoalVal, karmaXp: next.totalXp, isPro: isProVal);
    });
    ref.listen(stepsDataProvider, (prev, next) {
      final s = next.value?.totalSteps ?? 0;
      final g = next.value?.dailyGoal ?? 10000;
      HomeWidgetService.updateWidgets(steps: s, stepGoal: g, karmaXp: karmaState.totalXp, isPro: isProVal);
    });

    return AppScaffold.patternA(
      appBar: _buildAppBar(context, user),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 12),
          
          // Activity Rings Hero
          _buildActivityHero(context, ref),
          
          const SizedBox(height: AppSpacing.lg),

          // Primary Bento Grid
          _buildPrimaryBento(context, ref),

          const SizedBox(height: AppSpacing.lg),

          // Today's Meals
          _buildSectionHeader(context, 'Today\'s Meals', '/home/food'),
          const SizedBox(height: 12),
          _buildMealsScroll(context, ref),

          const SizedBox(height: AppSpacing.lg),

          // AI Insight Evaluation block
          insightsAsync.when(
            data: (insightsList) {
              if (insightsList.isEmpty) {
                // Display premium placeholder info card if logging limits pending
                return const InsightCard(
                  title: 'NUTRITION INSIGHT',
                  body: 'Log at least 7 days of synchronized physical metrics to automatically activate customized rule-based systemic correlations.',
                ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.1, end: 0);
              }
              final topInsight = insightsList.first;
              return InsightCard(
                title: '${topInsight.title} (${(topInsight.confidence * 100).toInt()}% Confidence)',
                body: topInsight.description,
                onUpvote: () {},
                onDownvote: () {},
              ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.1, end: 0);
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (_, _) => const SizedBox.shrink(),
          ),

          const SizedBox(height: AppSpacing.lg),

          // Quick Stats
          Text('Quick Stats', style: AppTypography.h1()),
          const SizedBox(height: 12),
          _buildQuickStats(context, ref),

          const SizedBox(height: AppSpacing.lg),

          // Challenges
          _buildChallengeCard(context),

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context, user) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leadingWidth: 64,
      leading: Padding(
        padding: const EdgeInsets.only(left: AppSpacing.screenH),
        child: GestureDetector(
          onTap: () => context.push('/profile'),
          child: CircleAvatar(
            backgroundColor: AppColorsDark.surface2,
            child: Text(
              user?.name.isNotEmpty == true ? user!.name[0].toUpperCase() : 'U',
              style: AppTypography.h3(color: AppColorsDark.primary),
            ),
          ),
        ),
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Good morning,',
            style: AppTypography.labelMd(color: AppColorsDark.textSecondary),
          ),
          Text(
            user?.name.split(' ').first ?? 'Friend',
            style: AppTypography.h1(color: Colors.white),
          ),
        ],
      ),
      actions: [
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.notifications_none_rounded, color: Colors.white),
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  Widget _buildActivityHero(BuildContext context, WidgetRef ref) {
    final stepsAsync = ref.watch(stepsDataProvider);
    final steps = stepsAsync.value?.totalSteps ?? 0;
    final goal = stepsAsync.value?.dailyGoal ?? 10000;
    final cals = stepsAsync.value?.caloriesBurned ?? 0;
    final dist = stepsAsync.value?.distanceKm ?? 0.0;
    final progress = (steps / goal).clamp(0.0, 1.0);

    return GlassCard(
      customRadius: AppRadius.xl,
      glowColor: AppColorsDark.primaryGlow,
      child: Row(
        children: [
          ActivityRings(
            stepsProgress: progress,
            caloriesProgress: (cals / 500).clamp(0.0, 1.0),
            minutesProgress: (dist / 8.0).clamp(0.0, 1.0),
            size: 140,
          ),
          const SizedBox(width: 24),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  NumberFormat.decimalPattern().format(steps),
                  style: AppTypography.metricLg(color: Colors.white),
                ),
                Text(
                  'STEPS TODAY',
                  style: AppTypography.labelMd(color: AppColorsDark.textSecondary).copyWith(
                    letterSpacing: 1.5,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    _buildMiniMetric('$cals', 'KCAL'),
                    const SizedBox(width: 16),
                    _buildMiniMetric(dist.toStringAsFixed(1), 'KM'),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMiniMetric(String value, String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(value, style: AppTypography.h3(color: Colors.white)),
        Text(
          label,
          style: AppTypography.labelSm(color: AppColorsDark.textMuted),
        ),
      ],
    );
  }

  Widget _buildPrimaryBento(BuildContext context, WidgetRef ref) {
    final streakState = ref.watch(streakStateProvider);
    final karmaState = ref.watch(karmaStateProvider);
    final isProAsync = ref.watch(isProProvider);
    final isPro = isProAsync.value ?? false;
    final db = ref.watch(appDatabaseProvider);

    final diffXp = karmaState.nextLevelXp - karmaState.totalXp;

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: StreamBuilder<List<FoodLog>>(
                stream: db.watchTodayFoodLogs(),
                builder: (context, snapshot) {
                  final logs = snapshot.data ?? [];
                  final totalKcal = logs.fold(0.0, (sum, item) => sum + item.calories).toInt();
                  final remaining = 2500 - totalKcal;
                  return _BentoItem(
                    title: 'Calories',
                    value: NumberFormat.decimalPattern().format(remaining > 0 ? remaining : 0),
                    subtitle: 'left',
                    icon: Icons.local_fire_department_rounded,
                    color: AppColorsDark.secondary,
                    onTap: () => context.push('/home/food'),
                  );
                },
              ),
            ),
            const SizedBox(width: AppSpacing.bentoGap),
            Expanded(
              child: StreamBuilder<int>(
                stream: db.watchTodayWaterMl(),
                builder: (context, snapshot) {
                  final ml = snapshot.data ?? 0;
                  return _BentoItem(
                    title: 'Water',
                    value: (ml / 1000).toStringAsFixed(1),
                    subtitle: 'liters',
                    icon: Icons.water_drop_rounded,
                    color: AppColorsDark.teal,
                    onTap: () => context.push('/water'),
                  );
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.bentoGap),
        GlassCard(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Current Streak', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
              StreakFlame(count: streakState.currentStreak),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.bentoGap),
        _BentoItem(
          title: 'Karma XP${isPro ? " (⚡ Pro Multiplier Active)" : ""}',
          value: NumberFormat.decimalPattern().format(karmaState.totalXp),
          subtitle: 'Level ${karmaState.currentLevel} • ${diffXp > 0 ? diffXp : 0} XP to next rank',
          icon: Icons.auto_awesome_rounded,
          color: AppColorsDark.accent,
          fullWidth: true,
          onTap: () => context.push('/karma'),
        ),
      ],
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title, String route) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: AppTypography.h1()),
        TextButton(
          onPressed: () => context.push(route),
          child: const Text('See All', style: TextStyle(color: AppColorsDark.primary)),
        ),
      ],
    );
  }

  Widget _buildMealsScroll(BuildContext context, WidgetRef ref) {
    final db = ref.watch(appDatabaseProvider);
    final timeFormat = DateFormat('h:mm a');

    return StreamBuilder<List<FoodLog>>(
      stream: db.watchTodayFoodLogs(),
      builder: (context, snapshot) {
        final meals = snapshot.data ?? [];
        if (meals.isEmpty) {
          return Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColorsDark.surface0,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              'No meals logged today. Add food to track calories.',
              style: AppTypography.labelMd(color: AppColorsDark.textMuted),
            ),
          );
        }

        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          clipBehavior: Clip.none,
          child: Row(
            children: meals.map((meal) => Container(
              width: 160,
              margin: const EdgeInsets.only(right: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColorsDark.surface0,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(meal.name, style: AppTypography.h4(color: Colors.white), maxLines: 1, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 4),
                  Text('${meal.calories.toInt()} kcal', style: AppTypography.labelMd(color: AppColorsDark.primary)),
                  const SizedBox(height: 12),
                  Text(timeFormat.format(meal.logDate), style: AppTypography.labelSm(color: AppColorsDark.textMuted)),
                ],
              ),
            )).toList(),
          ),
        );
      },
    );
  }

  Widget _buildQuickStats(BuildContext context, WidgetRef ref) {
    final db = ref.watch(appDatabaseProvider);

    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () => context.push('/blood-pressure'),
            child: StreamBuilder<List<BpReading>>(
              stream: db.watchRecentBpReadings(limit: 1),
              builder: (context, snapshot) {
                final reading = snapshot.data?.firstOrNull;
                final val = reading != null ? '${reading.systolic}/${reading.diastolic}' : '--/--';
                return _StatMiniCard(label: 'BP', value: val, unit: 'mmHg', color: AppColorsDark.error);
              },
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: GestureDetector(
            onTap: () => context.push('/glucose'),
            child: StreamBuilder<List<GlucoseReading>>(
              stream: db.watchRecentGlucoseReadings(limit: 1),
              builder: (context, snapshot) {
                final reading = snapshot.data?.firstOrNull;
                final val = reading != null ? '${reading.value.toInt()}' : '--';
                return _StatMiniCard(label: 'GLUCOSE', value: val, unit: 'mg/dL', color: AppColorsDark.teal);
              },
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: GestureDetector(
            onTap: () => context.push('/sleep'),
            child: StreamBuilder<List<SleepLog>>(
              stream: db.watchRecentSleepLogs(limit: 1),
              builder: (context, snapshot) {
                final reading = snapshot.data?.firstOrNull;
                final val = reading != null ? '${reading.quality * 10}' : '--';
                return _StatMiniCard(label: 'SLEEP', value: val, unit: '/100', color: AppColorsDark.purple);
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildChallengeCard(BuildContext context) {
    return GlassCard(
      glowColor: AppColorsDark.primaryGlow,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('WELLNESS CHALLENGES', style: AppTypography.labelMd(color: AppColorsDark.primary)),
              const Icon(Icons.emoji_events_rounded, color: AppColorsDark.primary, size: 20),
            ],
          ),
          const SizedBox(height: 12),
          Text('Ready for a new goal?', style: AppTypography.h2(color: Colors.white)),
          const SizedBox(height: 4),
          Text('Join seasonal community challenges to earn exclusive rank XP boosters.', style: AppTypography.labelMd(color: AppColorsDark.textSecondary)),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColorsDark.primary,
                side: const BorderSide(color: AppColorsDark.primary),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('Browse Challenges'),
            ),
          ),
        ],
      ),
    );
  }
}

class _BentoItem extends StatelessWidget {
  final String title;
  final String value;
  final String subtitle;
  final IconData icon;
  final Color color;
  final bool fullWidth;
  final VoidCallback onTap;

  const _BentoItem({
    required this.title,
    required this.value,
    required this.subtitle,
    required this.icon,
    required this.color,
    this.fullWidth = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      onTap: onTap,
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTypography.labelSm(color: AppColorsDark.textSecondary)),
                Text(value, style: AppTypography.h2(color: Colors.white)),
                Text(subtitle, style: AppTypography.labelSm(color: AppColorsDark.textMuted)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatMiniCard extends StatelessWidget {
  final String label;
  final String value;
  final String unit;
  final Color color;

  const _StatMiniCard({
    required this.label,
    required this.value,
    required this.unit,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColorsDark.surface0,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: AppTypography.labelSm(color: AppColorsDark.textMuted)),
          const SizedBox(height: 4),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(value, style: AppTypography.h3(color: Colors.white)),
              const SizedBox(width: 2),
              Text(unit, style: AppTypography.labelSm(color: AppColorsDark.textMuted)),
            ],
          ),
        ],
      ),
    );
  }
}
