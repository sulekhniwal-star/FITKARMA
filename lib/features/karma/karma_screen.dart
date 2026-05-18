import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_gradients.dart';
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
      heroGradient: AppGradients.heroKarma,
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
                    height: 6,
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
      body: LayoutBuilder(
        builder: (context, constraints) {
          final double width = constraints.maxWidth;
          final double tabViewHeight = width > 600 ? 520 : 580;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),

              // Interactive Check-in Action CTA (Centered and constrained)
              Align(
                alignment: Alignment.center,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 320),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
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
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Multi-View Navigation Tabs (Centered and constrained)
              Align(
                alignment: Alignment.center,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 480),
                  child: Container(
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
                ),
              ),
              const SizedBox(height: 24),

              // Tab Workspaces
              SizedBox(
                height: tabViewHeight,
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildOverviewTab(state, width),
                    _buildAchievementsTab(state.achievements),
                    _buildLeaderboardTab(state.leaderboard, width),
                  ],
                ),
              ),
              const SizedBox(height: 32),
            ],
          );
        },
      ),
    );
  }

  Widget _buildOverviewTab(KarmaState state, double maxWidth) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // XP breakdown bento (by category: food, workout, steps, etc.)
          Text('XP Distributions', style: AppTypography.h3(color: Colors.white)),
          const SizedBox(height: 12),
          _buildBreakdownBento(state.xpBreakdown, maxWidth),
          
          const SizedBox(height: 28),

          // Active Challenges card
          Text('Active Challenges', style: AppTypography.h3(color: Colors.white)),
          const SizedBox(height: 12),
          _buildChallengesList(state.activeChallenges, maxWidth),
          
          const SizedBox(height: 28),

          // Today's karma events list (each event: type, XP awarded, timestamp)
          Text('Today\'s Actions Log', style: AppTypography.h3(color: Colors.white)),
          const SizedBox(height: 12),
          _buildEventsList(state.todayEvents, maxWidth),
        ],
      ),
    );
  }

  Widget _buildBreakdownBento(Map<String, int> breakdown, double maxWidth) {
    final int food = breakdown['food'] ?? 0;
    final int workout = breakdown['workout'] ?? 0;
    final int steps = breakdown['steps'] ?? 0;
    final int streak = breakdown['streak'] ?? 0;

    final cards = [
      _buildBentoMetricCard(
        title: 'Nutrition',
        xp: food,
        icon: Icons.restaurant_rounded,
        color: AppColorsDark.teal,
      ),
      _buildBentoMetricCard(
        title: 'Workouts',
        xp: workout,
        icon: Icons.fitness_center_rounded,
        color: AppColorsDark.primary,
      ),
      _buildBentoMetricCard(
        title: 'Daily Steps',
        xp: steps,
        icon: Icons.directions_walk_rounded,
        color: AppColorsDark.purple,
      ),
      _buildBentoMetricCard(
        title: 'Streaks',
        xp: streak,
        icon: Icons.local_fire_department_rounded,
        color: AppColorsDark.accent,
      ),
    ];

    if (maxWidth > 600) {
      return Row(
        children: [
          Expanded(child: cards[0]),
          const SizedBox(width: 12),
          Expanded(child: cards[1]),
          const SizedBox(width: 12),
          Expanded(child: cards[2]),
          const SizedBox(width: 12),
          Expanded(child: cards[3]),
        ],
      );
    }

    return Column(
      children: [
        Row(
          children: [
            Expanded(child: cards[0]),
            const SizedBox(width: 12),
            Expanded(child: cards[1]),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(child: cards[2]),
            const SizedBox(width: 12),
            Expanded(child: cards[3]),
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
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 16, color: color),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: AppTypography.labelSm(color: AppColorsDark.textSecondary).copyWith(fontSize: 11),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
                const SizedBox(height: 2),
                Text(
                  '${NumberFormat('#,###').format(xp)} XP',
                  style: AppTypography.metricLg(color: Colors.white).copyWith(fontSize: 15, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChallengesList(List<Challenge> challenges, double maxWidth) {
    if (challenges.isEmpty) {
      return GlassCard(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColorsDark.accent.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.star_outline_rounded, color: AppColorsDark.accent, size: 18),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('No Active Challenges', style: AppTypography.labelLg(color: Colors.white).copyWith(fontWeight: FontWeight.bold, fontSize: 13)),
                  const SizedBox(height: 1),
                  Text('Complete logs to trigger premium wellness events.', style: AppTypography.labelSm(color: AppColorsDark.textMuted).copyWith(fontSize: 10)),
                ],
              ),
            ),
          ],
        ),
      );
    }

    final cards = challenges.map((chal) {
      return GlassCard(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColorsDark.accent.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.bolt_rounded, size: 14, color: AppColorsDark.accent),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        chal.title,
                        style: AppTypography.labelLg(color: Colors.white).copyWith(fontWeight: FontWeight.bold, fontSize: 13),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Progress: ${chal.currentDays}/${chal.targetDays} days',
                        style: AppTypography.labelSm(color: AppColorsDark.textMuted).copyWith(fontSize: 10),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppColorsDark.accent.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    chal.reward,
                    style: AppTypography.labelSm(color: AppColorsDark.accent).copyWith(fontWeight: FontWeight.bold, fontSize: 9),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: LinearProgressIndicator(
                value: chal.progressRatio,
                backgroundColor: AppColorsDark.surface2,
                valueColor: const AlwaysStoppedAnimation<Color>(AppColorsDark.teal),
                minHeight: 5,
              ),
            ),
          ],
        ),
      );
    }).toList();

    if (maxWidth > 600) {
      return GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: cards.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 10,
          mainAxisExtent: 78,
        ),
        itemBuilder: (context, index) => cards[index],
      );
    }

    return Column(
      children: challenges.asMap().entries.map((entry) {
        final idx = entry.key;
        return Padding(
          padding: EdgeInsets.only(bottom: idx == challenges.length - 1 ? 0 : 10.0),
          child: cards[idx],
        );
      }).toList(),
    );
  }

  Widget _buildEventsList(List<KarmaEvent> events, double maxWidth) {
    if (events.isEmpty) {
      return GlassCard(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColorsDark.textMuted.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.history_rounded, color: AppColorsDark.textMuted, size: 18),
            ),
            const SizedBox(width: 12),
            Text(
              'No actions logged today yet.',
              style: AppTypography.labelSm(color: AppColorsDark.textMuted).copyWith(fontSize: 11),
            ),
          ],
        ),
      );
    }

    final cards = events.map((ev) {
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

      return GlassCard(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: color.withValues(alpha: 0.12), shape: BoxShape.circle),
              child: Icon(icon, size: 14, color: color),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    ev.title,
                    style: AppTypography.labelLg(color: Colors.white).copyWith(fontSize: 13, fontWeight: FontWeight.w600),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 1),
                  Text(
                    DateFormat('h:mm a').format(ev.timestamp),
                    style: AppTypography.labelSm(color: AppColorsDark.textMuted).copyWith(fontSize: 10),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Text(
              '+${ev.xpAwarded} XP',
              style: AppTypography.monoMd(color: color).copyWith(fontWeight: FontWeight.bold, fontSize: 13),
            ),
          ],
        ),
      );
    }).toList();

    if (maxWidth > 600) {
      return GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: cards.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 8,
          mainAxisExtent: 60,
        ),
        itemBuilder: (context, index) => cards[index],
      );
    }

    return Column(
      children: events.asMap().entries.map((entry) {
        final idx = entry.key;
        return Padding(
          padding: EdgeInsets.only(bottom: idx == events.length - 1 ? 0 : 8.0),
          child: cards[idx],
        );
      }).toList(),
    );
  }

  Widget _buildAchievementsTab(List<Achievement> achievements) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double width = constraints.maxWidth;
        
        int crossAxisCount = 1;
        double mainAxisExtent = 90.0;

        if (width > 600) {
          crossAxisCount = 2;
          mainAxisExtent = 94.0;
        }

        return GridView.builder(
          padding: const EdgeInsets.only(top: 8, bottom: 20),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 12,
            mainAxisSpacing: 10,
            mainAxisExtent: mainAxisExtent,
          ),
          itemCount: achievements.length,
          itemBuilder: (context, index) {
            final ach = achievements[index];
            return GlassCard(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              child: Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: ach.isUnlocked 
                          ? AppColorsDark.accent.withValues(alpha: 0.15) 
                          : AppColorsDark.surface2.withValues(alpha: 0.4),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: ach.isUnlocked 
                            ? AppColorsDark.accent.withValues(alpha: 0.3) 
                            : Colors.transparent,
                      ),
                    ),
                    child: Text(ach.icon, style: const TextStyle(fontSize: 22)),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                ach.title,
                                style: AppTypography.labelLg(
                                  color: ach.isUnlocked ? Colors.white : AppColorsDark.textSecondary,
                                ).copyWith(fontWeight: FontWeight.bold, fontSize: 13),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            if (ach.isUnlocked)
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: AppColorsDark.teal.withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  'UNLOCKED',
                                  style: AppTypography.labelSm(color: AppColorsDark.teal).copyWith(
                                    fontSize: 8,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 2),
                        Text(
                          ach.description,
                          style: AppTypography.labelSm(color: AppColorsDark.textMuted).copyWith(fontSize: 10),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 6),
                        if (!ach.isUnlocked)
                          Row(
                            children: [
                              Expanded(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(4),
                                  child: LinearProgressIndicator(
                                    value: ach.progressRatio,
                                    backgroundColor: AppColorsDark.surface2,
                                    valueColor: const AlwaysStoppedAnimation<Color>(AppColorsDark.purple),
                                    minHeight: 4,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                '${NumberFormat('#,###').format(ach.currentProgress)} / ${NumberFormat('#,###').format(ach.maxProgress)}',
                                style: AppTypography.monoMd(color: AppColorsDark.textMuted).copyWith(fontSize: 9),
                              ),
                            ],
                          ),
                      ],
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

  Widget _buildLeaderboardTab(List<KarmaLeaderboardUser> leaderboard, double maxWidth) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
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
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 28,
                          child: Text(
                            '#$rank',
                            style: AppTypography.monoLg(color: rankColor).copyWith(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(width: 10),
                        CircleAvatar(
                          radius: 16,
                          backgroundColor: user.isCurrentUser ? AppColorsDark.accent : AppColorsDark.surface2,
                          foregroundColor: user.isCurrentUser ? Colors.black : Colors.white,
                          child: Text(user.avatarStr, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            user.name,
                            style: AppTypography.labelLg(color: user.isCurrentUser ? Colors.white : AppColorsDark.textSecondary).copyWith(
                              fontSize: 13,
                              fontWeight: user.isCurrentUser ? FontWeight.bold : FontWeight.normal,
                            ),
                          ),
                        ),
                        Text(
                          '${NumberFormat('#,###').format(user.xp)} XP',
                          style: AppTypography.monoLg(color: user.isCurrentUser ? AppColorsDark.accent : Colors.white).copyWith(fontSize: 14),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
