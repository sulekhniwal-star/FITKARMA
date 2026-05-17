import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../shared/widgets/scaffold_patterns.dart';
import '../../shared/widgets/bento_card.dart';
import 'package:flutter_animate/flutter_animate.dart';
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
    final state = ref.read(karmaStateProvider);
    final now = DateTime.now();
    final claimed = state.lastDailyBonusClaimedAt;
    final alreadyClaimedToday = claimed != null &&
        claimed.year == now.year &&
        claimed.month == now.month &&
        claimed.day == now.day;

    if (alreadyClaimedToday) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Daily bonus already claimed today. Come back tomorrow!'),
          backgroundColor: AppColorsDark.surface2,
        ),
      );
      return;
    }

    final awarded = ref.read(karmaStateProvider.notifier).claimDailyBonus();
    if (!awarded) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('⚡ +35 Karma XP Earned! Level progression increased.'),
        backgroundColor: AppColorsDark.accent,
      ),
    );
  }

  void _showLevelUpOverlay(int newLevel, String title) {
    showDialog(
      context: context,
      builder: (context) => Center(
        child: Material(
          color: Colors.transparent,
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 32),
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColorsDark.heroDeepEnd, AppColorsDark.rose, AppColorsDark.primary],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(28),
              boxShadow: [
                BoxShadow(
                  color: AppColorsDark.accent.withValues(alpha: 0.4),
                  blurRadius: 30,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.bolt_rounded, color: Colors.white, size: 64)
                    .animate(onPlay: (controller) => controller.repeat(reverse: true))
                    .scale(begin: const Offset(0.9, 0.9), end: const Offset(1.2, 1.2), duration: 600.ms),
                const SizedBox(height: 16),
                Text(
                  'LEVEL UP!',
                  style: AppTypography.displayLg(color: Colors.white).copyWith(fontSize: 32, fontWeight: FontWeight.bold),
                ).animate().fadeIn().slideY(begin: 0.5, end: 0, duration: 400.ms),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(color: Colors.black.withValues(alpha: 0.25), borderRadius: BorderRadius.circular(100)),
                  child: Text(title, style: AppTypography.labelLg(color: AppColorsDark.accent).copyWith(fontWeight: FontWeight.bold)),
                ),
                const SizedBox(height: 16),
                Text(
                  'Your cumulative dedication unlocks new spiritual dimensions. Keep the fire burning bright.',
                  style: AppTypography.bodySm(color: Colors.white.withValues(alpha: 0.9)),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  onPressed: () => context.pop(),
                  child: const Text('Embrace Karma Matrix', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ).animate().scale(duration: 500.ms, curve: Curves.easeOutBack),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<KarmaState>(karmaStateProvider, (prev, next) {
      if (prev != null && next.currentLevel > prev.currentLevel) {
        _showLevelUpOverlay(next.currentLevel, next.badgeTitle);
      }
    });

    final state = ref.watch(karmaStateProvider);
    final formattedXp = NumberFormat('#,###').format(state.totalXp);

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
              color: AppColorsDark.surface0.withValues(alpha: 0.4),
              borderRadius: BorderRadius.circular(100),
              border: Border.all(color: AppColorsDark.accent.withValues(alpha: 0.5)),
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
                      backgroundColor: AppColorsDark.surface0.withValues(alpha: 0.5),
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
                border: Border.all(color: AppColorsDark.accent.withValues(alpha: 0.3)),
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
                decoration: BoxDecoration(color: color.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(10)),
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
                        color: AppColorsDark.accent.withValues(alpha: 0.15),
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
                  decoration: BoxDecoration(color: color.withValues(alpha: 0.15), shape: BoxShape.circle),
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
    return LayoutBuilder(
      builder: (context, constraints) {
        final double width = constraints.maxWidth;
        
        // Dynamically calculate column count and aspect ratio based on available width
        int crossAxisCount = 2;
        double childAspectRatio = 0.85;

        if (width > 750) {
          crossAxisCount = 4;
          childAspectRatio = 1.0;
        } else if (width > 480) {
          crossAxisCount = 3;
          childAspectRatio = 0.95;
        } else {
          // On small mobile screens, keep 2 columns but make them slightly shorter/wider
          crossAxisCount = 2;
          childAspectRatio = 0.95;
        }

        return GridView.builder(
          padding: const EdgeInsets.only(top: 8),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: childAspectRatio,
          ),
          itemCount: achievements.length,
          itemBuilder: (context, index) {
            final ach = achievements[index];
            return GlassCard(
              padding: const EdgeInsets.all(12),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: ach.isUnlocked ? AppColorsDark.accent.withValues(alpha: 0.2) : AppColorsDark.surface2,
                      shape: BoxShape.circle,
                    ),
                    child: Text(ach.icon, style: const TextStyle(fontSize: 24)),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    ach.title,
                    style: AppTypography.labelSm(color: ach.isUnlocked ? Colors.white : AppColorsDark.textMuted).copyWith(fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Expanded(
                    child: Text(
                      ach.description,
                      style: AppTypography.labelSm(color: AppColorsDark.textMuted).copyWith(fontSize: 10),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(height: 6),
                  if (ach.isUnlocked)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(color: AppColorsDark.teal.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(4)),
                      child: const Text('UNLOCKED', style: TextStyle(color: AppColorsDark.teal, fontSize: 8, fontWeight: FontWeight.bold)),
                    )
                  else
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: ach.progressRatio,
                        backgroundColor: AppColorsDark.surface2,
                        valueColor: const AlwaysStoppedAnimation<Color>(AppColorsDark.purple),
                      ),
                    ),
                ],
              ),
            );
          },
        );
      },
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
              color: AppColorsDark.purple.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColorsDark.purple.withValues(alpha: 0.3)),
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
