import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/providers/core_providers.dart';
import '../../shared/widgets/scaffold_patterns.dart';
import '../../shared/widgets/bento_card.dart';
import '../../shared/widgets/activity_rings.dart';
import '../../shared/widgets/streak_flame.dart';
import '../../shared/widgets/insight_card.dart';
import '../../shared/widgets/glowing_metric.dart';
import '../onboarding/onboarding_providers.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authProvider).value;
    final firstName = user?.name.split(' ').first ?? 'Friend';

    return AppScaffold.patternA(
      appBar: _buildAppBar(context, user),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 12),
          
          // Activity Rings Hero
          _buildActivityHero(context),
          
          const SizedBox(height: AppSpacing.lg),

          // Primary Bento Grid
          _buildPrimaryBento(context),

          const SizedBox(height: AppSpacing.lg),

          // Today's Meals
          _buildSectionHeader(context, 'Today\'s Meals', '/home/food'),
          const SizedBox(height: 12),
          _buildMealsScroll(context),

          const SizedBox(height: AppSpacing.lg),

          // AI Insight (Simulated check for 7 days + flag)
          const InsightCard(
            title: 'NUTRITION INSIGHT',
            body: 'You\'ve hit your protein goal 3 days in a row! Increasing your intake by 10g tomorrow could help with muscle recovery after your planned leg day.',
          ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.1, end: 0),

          const SizedBox(height: AppSpacing.lg),

          // Quick Stats
          Text('Quick Stats', style: AppTypography.h1()),
          const SizedBox(height: 12),
          _buildQuickStats(context),

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
              user?.name.characters.first ?? 'U',
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

  Widget _buildActivityHero(BuildContext context) {
    return GlassCard(
      customRadius: AppRadius.xl,
      glowColor: AppColorsDark.primaryGlow,
      child: Row(
        children: [
          const ActivityRings(
            stepsProgress: 0.7,
            caloriesProgress: 0.5,
            minutesProgress: 0.8,
            size: 140,
          ),
          const SizedBox(width: 24),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '7,432',
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
                    _buildMiniMetric('542', 'KCAL'),
                    const SizedBox(width: 16),
                    _buildMiniMetric('32', 'MIN'),
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

  Widget _buildPrimaryBento(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _BentoItem(
                title: 'Calories',
                value: '1,240',
                subtitle: 'left',
                icon: Icons.local_fire_department_rounded,
                color: AppColorsDark.secondary,
                onTap: () => context.push('/home/food'),
              ),
            ),
            const SizedBox(width: AppSpacing.bentoGap),
            Expanded(
              child: _BentoItem(
                title: 'Water',
                value: '1.2',
                subtitle: 'liters',
                icon: Icons.water_drop_rounded,
                color: AppColorsDark.teal,
                onTap: () => context.push('/water'),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.bentoGap),
        const GlassCard(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Current Streak', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
              StreakFlame(count: 12),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.bentoGap),
        _BentoItem(
          title: 'Karma XP',
          value: '2,450',
          subtitle: 'Level 12 • 50 XP to next level',
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

  Widget _buildMealsScroll(BuildContext context) {
    final meals = [
      {'name': 'Oatmeal & Berries', 'kcal': '320', 'time': '8:30 AM'},
      {'name': 'Chicken Salad', 'kcal': '450', 'time': '1:15 PM'},
      {'name': 'Protein Shake', 'kcal': '180', 'time': '4:00 PM'},
    ];

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
              Text(meal['name']!, style: AppTypography.h4(color: Colors.white), maxLines: 1, overflow: TextOverflow.ellipsis),
              const SizedBox(height: 4),
              Text('${meal['kcal']} kcal', style: AppTypography.labelMd(color: AppColorsDark.primary)),
              const SizedBox(height: 12),
              Text(meal['time']!, style: AppTypography.labelSm(color: AppColorsDark.textMuted)),
            ],
          ),
        )).toList(),
      ),
    );
  }

  Widget _buildQuickStats(BuildContext context) {
    return Row(
      children: [
        Expanded(child: _StatMiniCard(label: 'BP', value: '120/80', unit: 'mmHg', color: AppColorsDark.error)),
        const SizedBox(width: 12),
        Expanded(child: _StatMiniCard(label: 'GLUCOSE', value: '98', unit: 'mg/dL', color: AppColorsDark.teal)),
        const SizedBox(width: 12),
        Expanded(child: _StatMiniCard(label: 'SLEEP', value: '82', unit: '/100', color: AppColorsDark.purple)),
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
              Text('ACTIVE CHALLENGE', style: AppTypography.labelMd(color: AppColorsDark.primary)),
              const Icon(Icons.emoji_events_rounded, color: AppColorsDark.primary, size: 20),
            ],
          ),
          const SizedBox(height: 12),
          Text('7-Day Sugar Detox', style: AppTypography.h2(color: Colors.white)),
          const SizedBox(height: 8),
          const LinearProgressIndicator(
            value: 0.6,
            backgroundColor: AppColorsDark.surface2,
            valueColor: AlwaysStoppedAnimation(AppColorsDark.primary),
          ),
          const SizedBox(height: 8),
          Text('Day 4 of 7', style: AppTypography.labelSm(color: AppColorsDark.textMuted)),
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
              color: color.withOpacity(0.1),
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
