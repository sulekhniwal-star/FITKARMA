import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../shared/widgets/scaffold_patterns.dart';
import '../../shared/widgets/bento_card.dart';
import 'karma_providers.dart';

class KarmaScreen extends ConsumerStatefulWidget {
  const KarmaScreen({super.key});

  @override
  ConsumerState<KarmaScreen> createState() => _KarmaScreenState();
}

class _KarmaScreenState extends ConsumerState<KarmaScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _triggerInstantXpReward(BuildContext context, WidgetRef ref) {
    ref.read(karmaStateProvider.notifier).addKarmaEvent(
          'Daily Wellness Affirmation',
          'streak',
          35,
        );
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('⚡ +35 Karma XP Earned! Level progression increased.'),
        backgroundColor: AppColorsDark.accent,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(karmaStateProvider);
    final formattedXp = NumberFormat('#,###').format(state.totalXp);
    final prevLvlTarget = (state.currentLevel - 1) * 600;

    return AppScaffold.patternB(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
          onPressed: () => context.pop(),
        ),
        title: Text('Karma XP Hub', style: AppTypography.h2(color: Colors.white)),
        centerTitle: true,
      ),
      heroGradient: const LinearGradient(
        colors: [Color(0xFF2E1E50), Color(0xFFD76D77), Color(0xFFF09819)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      hero: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 6),
          // Level / Tier Badge Tag
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            decoration: BoxDecoration(
              color: AppColorsDark.surface0.withOpacity(0.4),
              borderRadius: BorderRadius.circular(100),
              border: Border.all(color: AppColorsDark.accent.withOpacity(0.5)),
            ),
            child: Text(
              state.badgeTitle,
              style: AppTypography.labelLg(color: AppColorsDark.accent).copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 12),

          // displayLg XP total
          Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                formattedXp,
                style: AppTypography.displayLg(color: Colors.white).copyWith(fontSize: 64),
              ),
              const SizedBox(width: 6),
              Text('XP', style: AppTypography.h2(color: AppColorsDark.textSecondary)),
            ],
          ),
          const SizedBox(height: 16),

          // XP progress bar to next level
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Level ${state.currentLevel}', style: AppTypography.labelSm(color: AppColorsDark.textPrimary)),
                    Text(
                      '${state.totalXp} / ${state.nextLevelXp} XP',
                      style: AppTypography.labelSm(color: AppColorsDark.textSecondary),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: SizedBox(
                    height: 10,
                    child: LinearProgressIndicator(
                      value: state.levelProgressRatio,
                      backgroundColor: AppColorsDark.surface0.withOpacity(0.5),
                      valueColor: const AlwaysStoppedAnimation<Color>(AppColorsDark.accent),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 20),

          // Interactive Check-in Action CTA
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColorsDark.accent,
              foregroundColor: Colors.black,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              elevation: 4,
            ),
            icon: const Icon(Icons.bolt_rounded, size: 22, color: Colors.black),
            label: Text(
              'Claim Daily Karma Bonus',
              style: AppTypography.labelLg(color: Colors.black).copyWith(fontWeight: FontWeight.bold),
            ),
            onPressed: () => _triggerInstantXpReward(context, ref),
          ),
          const SizedBox(height: 28),

          // Multi-View Navigation Tabs
          Container(
            decoration: BoxDecoration(
              color: AppColorsDark.surface0,
              borderRadius: BorderRadius.circular(16),
            ),
            padding: const EdgeInsets.all(4),
            child: TabBar(
              controller: _tabController,
              indicator: BoxDecoration(
                color: AppColorsDark.surface1,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColorsDark.accent.withOpacity(0.3)),
              ),
              labelColor: AppColorsDark.accent,
              unselectedLabelColor: AppColorsDark.textSecondary,
              labelStyle: AppTypography.labelSm(color: AppColorsDark.accent).copyWith(fontWeight: FontWeight.bold),
              tabs: const [
                Tab(text: 'Overview'),
                Tab(text: 'Achievements'),
                Tab(text: 'Leaderboard'),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Tab Workspaces
          SizedBox(
            height: 850, // Static bound to accommodate embedded items cleanly inside overlapping body
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildOverviewTab(state),
                _buildAchievementsTab(state.achievements),
                _buildLeaderboardTab(state.leaderboard),
              ],
            ),
          ),
          const SizedBox(height: 48),
        ],
      ),
    );
  }

  Widget _buildOverviewTab(KarmaState state) {
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // XP breakdown bento (by category: food, workout, steps, etc.)
          Text('XP Distributions', style: AppTypography.h3(color: Colors.white)),
          const SizedBox(height: 12),
          _buildBreakdownBento(state.xpBreakdown),
          
          const SizedBox(height: 28),

          // Active Challenges card
          Text('Active Challenges', style: AppTypography.h3(color: Colors.white)),
          const SizedBox(height: 12),
          _buildChallengesList(state.activeChallenges),
          
          const SizedBox(height: 28),

          // Today's karma events list (each event: type, XP awarded, timestamp)
          Text('Today\'s Actions Log', style: AppTypography.h3(color: Colors.white)),
          const SizedBox(height: 12),
          _buildEventsList(state.todayEvents),
        ],
      ),
    );
  }

  Widget _buildBreakdownBento(Map<String, int> breakdown) {
    final int food = breakdown['food'] ?? 0;
    final int workout = breakdown['workout'] ?? 0;
    final int steps = breakdown['steps'] ?? 0;
    final int streak = breakdown['streak'] ?? 0;

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildBentoMetricCard(
                title: 'Nutrition',
                xp: food,
                icon: Icons.restaurant_rounded,
                color: AppColorsDark.teal,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildBentoMetricCard(
                title: 'Workouts',
                xp: workout,
                icon: Icons.fitness_center_rounded,
                color: AppColorsDark.primary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildBentoMetricCard(
                title: 'Daily Steps',
                xp: steps,
                icon: Icons.directions_walk_rounded,
                color: AppColorsDark.purple,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildBentoMetricCard(
                title: 'Streaks',
                xp: streak,
                icon: Icons.local_fire_department_rounded,
                color: AppColorsDark.accent,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildBentoMetricCard({
    required String title,
    required int xp,
    required IconData icon,
    required Color color,
  }) {
    return GlassCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: color.withOpacity(0.15), borderRadius: BorderRadius.circular(10)),
                child: Icon(icon, size: 16, color: color),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(title, style: AppTypography.labelSm(color: AppColorsDark.textSecondary), overflow: TextOverflow.ellipsis),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            '${NumberFormat('#,###').format(xp)} XP',
            style: AppTypography.metricLg(color: Colors.white).copyWith(fontSize: 20),
          ),
        ],
      ),
    );
  }

  Widget _buildChallengesList(List<Challenge> challenges) {
    return Column(
      children: challenges.map((chal) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12.0),
          child: GlassCard(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(chal.title, style: AppTypography.h3(color: Colors.white)),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColorsDark.accent.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(chal.reward, style: AppTypography.labelSm(color: AppColorsDark.accent)),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Progress', style: AppTypography.labelSm(color: AppColorsDark.textSecondary)),
                    Text('${chal.currentDays} / ${chal.targetDays} Units', style: AppTypography.labelSm(color: Colors.white)),
                  ],
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: LinearProgressIndicator(
                    value: chal.progressRatio,
                    backgroundColor: AppColorsDark.surface2,
                    valueColor: const AlwaysStoppedAnimation<Color>(AppColorsDark.teal),
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildEventsList(List<KarmaEvent> events) {
    if (events.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(16.0),
        child: Text('No actions logged today yet.', style: TextStyle(color: AppColorsDark.textMuted)),
      );
    }

    return Column(
      children: events.map((ev) {
        IconData icon = Icons.check_circle_outline_rounded;
        Color color = AppColorsDark.textSecondary;

        switch (ev.category) {
          case 'food':
            icon = Icons.restaurant_rounded;
            color = AppColorsDark.teal;
            break;
          case 'workout':
            icon = Icons.fitness_center_rounded;
            color = AppColorsDark.primary;
            break;
          case 'steps':
            icon = Icons.directions_walk_rounded;
            color = AppColorsDark.purple;
            break;
          case 'streak':
            icon = Icons.local_fire_department_rounded;
            color = AppColorsDark.accent;
            break;
        }

        return Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: GlassCard(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(color: color.withOpacity(0.15), shape: BoxShape.circle),
                  child: Icon(icon, size: 16, color: color),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(ev.title, style: AppTypography.labelLg(color: Colors.white)),
                      const SizedBox(height: 2),
                      Text(DateFormat('h:mm a').format(ev.timestamp), style: AppTypography.labelSm(color: AppColorsDark.textMuted)),
                    ],
                  ),
                ),
                Text('+${ev.xpAwarded} XP', style: AppTypography.monoMd(color: color).copyWith(fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildAchievementsTab(List<Achievement> achievements) {
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      child: Column(
        children: achievements.map((ach) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 12.0),
            child: GlassCard(
              padding: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: ach.isUnlocked ? AppColorsDark.accent.withOpacity(0.15) : AppColorsDark.surface2,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(ach.icon, style: const TextStyle(fontSize: 24)),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(ach.title, style: AppTypography.h3(color: ach.isUnlocked ? Colors.white : AppColorsDark.textMuted)),
                            if (ach.isUnlocked)
                              const Icon(Icons.star_rounded, color: AppColorsDark.accent, size: 18)
                            else
                              const Icon(Icons.lock_outline_rounded, color: AppColorsDark.textMuted, size: 16),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(ach.description, style: AppTypography.labelSm(color: AppColorsDark.textSecondary)),
                        
                        if (!ach.isUnlocked) ...[
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Progress Tracker', style: AppTypography.labelSm(color: AppColorsDark.textMuted)),
                              Text('${ach.currentProgress} / ${ach.maxProgress}', style: AppTypography.labelSm(color: AppColorsDark.textSecondary)),
                            ],
                          ),
                          const SizedBox(height: 6),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: LinearProgressIndicator(
                              value: ach.progressRatio,
                              backgroundColor: AppColorsDark.surface2,
                              valueColor: const AlwaysStoppedAnimation<Color>(AppColorsDark.purple),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildLeaderboardTab(List<KarmaLeaderboardUser> leaderboard) {
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColorsDark.purple.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColorsDark.purple.withOpacity(0.3)),
            ),
            child: Row(
              children: [
                const Icon(Icons.group_rounded, color: AppColorsDark.purple, size: 18),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Inner Circle League: Compete with family & wellness companions.',
                    style: AppTypography.labelSm(color: AppColorsDark.textSecondary),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: leaderboard.length,
            separatorBuilder: (_, _) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final user = leaderboard[index];
              final rank = index + 1;

              Color rankColor = AppColorsDark.textSecondary;
              if (rank == 1) rankColor = AppColorsDark.accent;
              if (rank == 2) rankColor = AppColorsDark.teal;
              if (rank == 3) rankColor = AppColorsDark.primary;

              return GlassCard(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  children: [
                    SizedBox(
                      width: 28,
                      child: Text(
                        '#$rank',
                        style: AppTypography.monoLg(color: rankColor).copyWith(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(width: 12),
                    CircleAvatar(
                      radius: 18,
                      backgroundColor: user.isCurrentUser ? AppColorsDark.accent : AppColorsDark.surface2,
                      foregroundColor: user.isCurrentUser ? Colors.black : Colors.white,
                      child: Text(user.avatarStr, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        user.name,
                        style: AppTypography.labelLg(color: user.isCurrentUser ? Colors.white : AppColorsDark.textSecondary).copyWith(
                          fontWeight: user.isCurrentUser ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    ),
                    Text(
                      '${NumberFormat('#,###').format(user.xp)} XP',
                      style: AppTypography.monoLg(color: user.isCurrentUser ? AppColorsDark.accent : Colors.white).copyWith(fontSize: 16),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
