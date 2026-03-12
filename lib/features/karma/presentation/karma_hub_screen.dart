import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/theme/app_text_styles.dart';
import '../../../shared/widgets/karma_level_card.dart';
import '../../../shared/widgets/section_header.dart';
import '../../../shared/widgets/challenge_carousel_card.dart';
import 'widgets/karma_store_card.dart';
import 'widgets/leaderboard_list.dart';

class KarmaHubScreen extends StatelessWidget {
  const KarmaHubScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // Dark Hero Section (Pattern B)
          SliverToBoxAdapter(
            child: Container(
              decoration: const BoxDecoration(
                gradient: AppGradients.heroGradient,
              ),
              child: SafeArea(
                bottom: false,
                child: Padding(
                  padding: const EdgeInsets.only(top: 16, bottom: 24),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Me / प्रोफ़ाइल',
                              style: AppTextStyles.h2.copyWith(
                                color: AppColors.white,
                              ),
                            ),
                            IconButton(
                              onPressed: () {},
                              icon: const Icon(
                                Icons.settings,
                                color: AppColors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      // We reuse the existing logic, but standard mock for now
                      const KarmaLevelCard(
                        level: 12,
                        levelTitle: 'Warrior',
                        currentXp: 1250,
                        xpForNextLevel: 2500,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Body Section
          SliverToBoxAdapter(
            child: Container(
              decoration: const BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
              ),
              transform: Matrix4.translationValues(
                0.0,
                -20.0,
                0.0,
              ), // pull up over hero
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),

                  // Streak Multiplier Banner (mock)
                  Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      gradient: AppGradients.orangeGradient,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        const Text('🔥', style: TextStyle(fontSize: 20)),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Text(
                            '7-day streak active!',
                            style: TextStyle(
                              color: AppColors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.white.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text(
                            '1.5x XP',
                            style: TextStyle(
                              color: AppColors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // CTA
                  KarmaStoreCard(onTap: () {}),

                  // Health Quick Access Grid
                  const SectionHeader(
                    englishTitle: 'Health Trackers',
                    hindiSubtitle: 'स्वास्थ्य ट्रैकर',
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 4,
                      mainAxisSpacing: 16,
                      children: [
                        _QuickAccessTile(
                          icon: Icons.medication,
                          label: 'Medications',
                          labelHi: 'दवाइयाँ',
                          color: AppColors.primary,
                          onTap: () => context.push('/home/me/medications'),
                        ),
                        _QuickAccessTile(
                          icon: Icons.favorite,
                          label: 'BP',
                          labelHi: 'ब्लड प्रेशर',
                          color: AppColors.rose,
                          onTap: () => context.push('/blood-pressure'),
                        ),
                        _QuickAccessTile(
                          icon: Icons.bloodtype,
                          label: 'Glucose',
                          labelHi: 'ग्लूकोज',
                          color: AppColors.teal,
                          onTap: () => context.push('/glucose'),
                        ),
                        _QuickAccessTile(
                          icon: Icons.air,
                          label: 'SpO2',
                          labelHi: 'ऑक्सीजन',
                          color: AppColors.purple,
                          onTap: () => context.push('/spo2'),
                        ),
                        _QuickAccessTile(
                          icon: Icons.bedtime,
                          label: 'Sleep',
                          labelHi: 'नींद',
                          color: AppColors.secondary,
                          onTap: () => context.push('/sleep'),
                        ),
                        _QuickAccessTile(
                          icon: Icons.mood,
                          label: 'Mood',
                          labelHi: 'मूड',
                          color: AppColors.accent,
                          onTap: () => context.push('/mood'),
                        ),
                        _QuickAccessTile(
                          icon: Icons.water_drop,
                          label: 'Period',
                          labelHi: 'मासिक धर्म',
                          color: AppColors.rose,
                          onTap: () => context.push('/period'),
                        ),
                        _QuickAccessTile(
                          icon: Icons.restaurant,
                          label: 'Nutrition',
                          labelHi: 'पोषण',
                          color: AppColors.success,
                          onTap: () => context.go('/home/food'),
                        ),
                        _QuickAccessTile(
                          icon: Icons.straighten,
                          label: 'Body',
                          labelHi: 'शरीर',
                          color: AppColors.secondary,
                          onTap: () => context.push('/body-metrics'),
                        ),
                      ],
                    ),
                  ),

                  // Leaderboard
                  const SectionHeader(
                    englishTitle: 'Leaderboard',
                    hindiSubtitle: 'लीडरबोर्ड',
                  ),

                  // Mock TabBar segment
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: DefaultTabController(
                      length: 3,
                      child: Column(
                        children: [
                          TabBar(
                            labelColor: AppColors.primary,
                            unselectedLabelColor: AppColors.textSecondary,
                            indicatorColor: AppColors.primary,
                            dividerColor: Colors.transparent,
                            tabs: <Widget>[
                              const Tab(text: 'Friends'),
                              const Tab(text: 'City'),
                              const Tab(text: 'National'),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Builder(
                            builder: (context) {
                              // Wrap list to prevent overlap layout since it's just mock content
                              return const LeaderboardList();
                            },
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SectionHeader(
                    englishTitle: 'Active Challenges',
                    hindiSubtitle: 'सक्रिय चुनौतियाँ',
                  ),

                  // Carousel
                  SizedBox(
                    height: 200,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.only(left: 16),
                      children: [
                        ChallengeCarouselCard(
                          icon: Icons.directions_walk,
                          title: '10k Steps Daily',
                          subtitle:
                              'Complete 10,000 steps for 5 days consecutively.',
                          participants: 4500,
                          reward: '500 XP',
                          onTap: () {},
                        ),
                        ChallengeCarouselCard(
                          icon: Icons.local_drink,
                          title: 'Hydration Hero',
                          subtitle:
                              'Log 3 liters of water every day for a week.',
                          participants: 2100,
                          reward: '350 XP',
                          onTap: () {},
                        ),
                      ],
                    ),
                  ),

                  const SectionHeader(
                    englishTitle: 'XP History',
                    hindiSubtitle: 'XP इतिहास',
                    trailing: Text(
                      'See all',
                      style: TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  // Mock transactions
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    itemCount: 3,
                    separatorBuilder: (context, index) => const Divider(),
                    itemBuilder: (context, index) {
                      final items = [
                        {
                          'title': 'Completed Workout',
                          'val': '+150 XP',
                          'color': AppColors.success,
                          'icon': Icons.fitness_center,
                        },
                        {
                          'title': 'Daily Steps Goal',
                          'val': '+50 XP',
                          'color': AppColors.success,
                          'icon': Icons.directions_walk,
                        },
                        {
                          'title': 'Store Reward Redeemed',
                          'val': '-500 XP',
                          'color': AppColors.error,
                          'icon': Icons.shopping_bag,
                        },
                      ];
                      final item = items[index];
                      return ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: CircleAvatar(
                          backgroundColor: (item['color'] as Color).withValues(
                            alpha: 0.1,
                          ),
                          child: Icon(
                            item['icon'] as IconData,
                            color: item['color'] as Color,
                            size: 20,
                          ),
                        ),
                        title: Text(
                          item['title'] as String,
                          style: AppTextStyles.bodyMedium,
                        ),
                        subtitle: const Text(
                          'Today',
                          style: AppTextStyles.caption,
                        ),
                        trailing: Text(
                          item['val'] as String,
                          style: AppTextStyles.labelLarge.copyWith(
                            color: item['color'] as Color,
                          ),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 100), // FAB scroll clearance
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Quick access tile widget for health trackers
class _QuickAccessTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String labelHi;
  final Color color;
  final VoidCallback onTap;

  const _QuickAccessTile({
    required this.icon,
    required this.label,
    required this.labelHi,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: AppTextStyles.caption.copyWith(
              fontWeight: FontWeight.w500,
              fontSize: 10,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            labelHi,
            style: AppTextStyles.caption.copyWith(
              fontSize: 8,
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
          ),
        ],
      ),
    );
  }
}
