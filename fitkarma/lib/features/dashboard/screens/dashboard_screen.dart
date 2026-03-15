// lib/features/dashboard/screens/dashboard_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/theme/app_colors.dart';
import '../../../shared/theme/app_text_styles.dart';
import '../../../shared/widgets/activity_rings.dart';
import '../../../shared/widgets/insight_card.dart';
import '../../../shared/widgets/quick_log_fab.dart';
import '../../../shared/widgets/karma_level_card.dart';
import '../../../shared/widgets/meal_tab_bar.dart';
import '../providers/dashboard_providers.dart';

/// Main dashboard screen
///
/// Reads from Hive only on first render (no Appwrite calls)
/// Background sync with Appwrite happens after initial render
class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    // Trigger background sync after initial render
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(dashboardProvider.notifier).syncWithAppwrite();
    });
  }

  @override
  Widget build(BuildContext context) {
    final dashboard = ref.watch(dashboardProvider);

    if (dashboard.isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            await ref.read(dashboardProvider.notifier).loadDashboardData();
          },
          child: CustomScrollView(
            slivers: [
              // Header with avatar, greeting, karma XP and level badge
              SliverToBoxAdapter(child: _buildHeader(dashboard)),

              // Karma Level Card
              SliverToBoxAdapter(
                child: KarmaLevelCard(
                  level: dashboard.karmaLevel,
                  levelTitle: dashboard.levelTitle,
                  currentXp: dashboard.currentXp,
                  xpForNextLevel: 500,
                  totalXp: dashboard.currentXp,
                  onTap: () {
                    // Navigate to karma details
                  },
                ),
              ),

              // Activity Rings
              SliverToBoxAdapter(child: _buildActivityRings(dashboard)),

              // Insight Card
              SliverToBoxAdapter(
                child: InsightCard(
                  message: _getInsightMessage(dashboard),
                  icon: Icons.lightbulb_outline,
                  onThumbsUp: () {
                    // Handle positive feedback
                  },
                  onThumbsDown: () {
                    // Handle negative feedback
                  },
                ),
              ),

              // Today's Meals Section
              SliverToBoxAdapter(child: _buildMealsSection(dashboard)),

              // Workout Summary Card
              SliverToBoxAdapter(child: _buildWorkoutCard(dashboard)),

              // Sleep Recovery Card
              SliverToBoxAdapter(child: _buildSleepCard(dashboard)),

              // Bottom padding
              const SliverToBoxAdapter(child: SizedBox(height: 100)),
            ],
          ),
        ),
      ),
      floatingActionButton: QuickLogFab(
        isExtended: false,
        icon: Icons.add,
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        actions: [
          SpeedDialAction(
            icon: Icons.restaurant,
            label: 'Log Food',
            onPressed: () => _showQuickLogDialog(QuickLogType.food),
          ),
          SpeedDialAction(
            icon: Icons.water_drop,
            label: 'Log Water',
            onPressed: () => _showQuickLogDialog(QuickLogType.water),
          ),
          SpeedDialAction(
            icon: Icons.fitness_center,
            label: 'Log Workout',
            onPressed: () => _showQuickLogDialog(QuickLogType.workout),
          ),
          SpeedDialAction(
            icon: Icons.mood,
            label: 'Log Mood',
            onPressed: () => _showQuickLogDialog(QuickLogType.mood),
          ),
          SpeedDialAction(
            icon: Icons.monitor_heart,
            label: 'Log Vitals',
            onPressed: () => _showQuickLogDialog(QuickLogType.bloodPressure),
          ),
        ],
      ),
    );
  }

  /// Build header with avatar, greeting, karma XP and level badge
  Widget _buildHeader(DashboardState dashboard) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          // Avatar
          CircleAvatar(
            radius: 28,
            backgroundColor: AppColors.primary.withValues(alpha: 0.2),
            child: const Icon(Icons.person, size: 32, color: AppColors.primary),
          ),
          const SizedBox(width: 12),

          // Greeting and name
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _getGreeting(),
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  dashboard.userName ?? 'User',
                  style: AppTextStyles.titleLarge.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          // Karma XP badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.accent.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.star, size: 16, color: AppColors.accent),
                const SizedBox(width: 4),
                Text(
                  '${dashboard.currentXp} XP',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.accent,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          // Level badge
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.primary, AppColors.secondary],
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              'Lvl ${dashboard.karmaLevel}',
              style: AppTextStyles.bodyMedium.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Build activity rings section
  Widget _buildActivityRings(DashboardState dashboard) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Today's Activity",
            style: AppTextStyles.titleLarge.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Center(
            child: ActivityRings(
              caloriesProgress: dashboard.caloriesProgress,
              caloriesTarget: dashboard.caloriesTarget,
              caloriesValue: dashboard.caloriesValue,
              stepsProgress: dashboard.stepsProgress,
              stepsTarget: dashboard.stepsTarget,
              stepsValue: dashboard.stepsValue,
              waterProgress: dashboard.waterProgress,
              waterTarget: dashboard.waterTarget,
              waterValue: dashboard.waterValue,
              activeMinutesProgress: dashboard.activeMinutesProgress,
              activeMinutesTarget: dashboard.activeMinutesTarget,
              activeMinutesValue: dashboard.activeMinutesValue,
            ),
          ),
        ],
      ),
    );
  }

  /// Build meals section
  Widget _buildMealsSection(DashboardState dashboard) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Today's Meals",
                style: AppTextStyles.titleLarge.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '${(dashboard.mealsCalories.values.fold(0.0, (a, b) => a + b)).toInt()} kcal',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          MealTypeTabBar(
            selectedMeal: MealType.breakfast,
            onMealSelected: (meal) {
              // Handle meal selection
            },
          ),
          const SizedBox(height: 16),
          // Show meal items based on selected tab
          _buildMealItems(dashboard),
        ],
      ),
    );
  }

  /// Build meal items list
  Widget _buildMealItems(DashboardState dashboard) {
    return Column(
      children: [
        _buildMealItem(
          'Oatmeal with Berries',
          '350 kcal',
          Icons.breakfast_dining,
        ),
        _buildMealItem('Grilled Chicken Salad', '450 kcal', Icons.lunch_dining),
        _buildMealItem('Vegetable Soup', '200 kcal', Icons.dinner_dining),
      ],
    );
  }

  /// Build a single meal item
  Widget _buildMealItem(String name, String calories, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: AppColors.primary, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: AppTextStyles.bodyLarge.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          Text(
            calories,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  /// Build workout summary card
  Widget _buildWorkoutCard(DashboardState dashboard) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Latest Workout',
                style: AppTextStyles.titleLarge.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.green.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  dashboard.latestWorkoutDate ?? 'Today',
                  style: AppTextStyles.bodyMedium.copyWith(color: Colors.green),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.orange.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.fitness_center,
                  color: Colors.orange,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      dashboard.latestWorkoutName ?? 'No workout yet',
                      style: AppTextStyles.bodyLarge.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${dashboard.latestWorkoutDuration ?? 0} minutes',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: AppColors.textSecondary),
            ],
          ),
        ],
      ),
    );
  }

  /// Build sleep recovery card
  Widget _buildSleepCard(DashboardState dashboard) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Sleep & Recovery',
                style: AppTextStyles.titleLarge.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.secondary.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${dashboard.sleepScore ?? 0}%',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.secondary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.secondary.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.bedtime,
                  color: AppColors.secondary,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${dashboard.sleepHours ?? 0} hours of sleep',
                      style: AppTextStyles.bodyLarge.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _getSleepMessage(dashboard.sleepScore ?? 0),
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: AppColors.textSecondary),
            ],
          ),
        ],
      ),
    );
  }

  /// Get greeting based on time of day
  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning';
    if (hour < 17) return 'Good afternoon';
    return 'Good evening';
  }

  /// Get insight message based on current progress
  String _getInsightMessage(DashboardState dashboard) {
    if (dashboard.waterValue < dashboard.waterTarget / 2) {
      return "You're halfway to your water goal! Keep drinking 💧";
    }
    if (dashboard.stepsProgress < 0.5) {
      return "Only ${(dashboard.stepsTarget - dashboard.stepsValue).toInt()} steps to reach your daily goal. Let's move!";
    }
    if (dashboard.caloriesProgress > 0.8) {
      return "Great job! You've hit 80% of your calorie target today! 🎉";
    }
    return "Complete your morning workout to earn +25 XP!";
  }

  /// Get sleep message based on score
  String _getSleepMessage(int score) {
    if (score >= 80) return 'Excellent recovery!';
    if (score >= 60) return 'Good rest, keep it up!';
    return 'Try to get more sleep tonight';
  }

  /// Show quick log dialog
  void _showQuickLogDialog(QuickLogType type) {
    // TODO: Implement quick log dialogs
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Quick log: ${type.name}'),
        duration: const Duration(seconds: 1),
      ),
    );
  }
}
