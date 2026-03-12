import 'package:flutter/material.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/theme/app_text_styles.dart';
import '../../../shared/widgets/section_header.dart';
import '../../../shared/widgets/stat_mini_card.dart';
import '../../../shared/widgets/insight_card.dart';
import 'widgets/large_step_ring.dart';
import 'widgets/inactivity_nudge_banner.dart';
import 'widgets/weekly_steps_chart.dart';
import 'widgets/month_heatmap.dart';

class StepsHomeScreen extends StatefulWidget {
  const StepsHomeScreen({super.key});

  @override
  State<StepsHomeScreen> createState() => _StepsHomeScreenState();
}

class _StepsHomeScreenState extends State<StepsHomeScreen> {
  bool _showNudge = true; // State to handle dismissible banner

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Column(
          children: [
            const Text('Steps / कदम', style: AppTextStyles.h3),
            Text('Today', style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary)),
          ],
        ),
      ),
      body: CustomScrollView(
        slivers: [
          // 1. Large Step Ring
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 24.0),
              child: Center(
                child: LargeStepRing(
                  currentSteps: 7450,
                  goalSteps: 10000,
                ),
              ),
            ),
          ),
          
          // 2. Stat mini cards
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Expanded(
                    child: StatMiniCard(
                      icon: Icons.map,
                      value: '4.5 km',
                      label: 'Distance',
                      iconColor: AppColors.success,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: StatMiniCard(
                      icon: Icons.local_fire_department,
                      value: '350 kcal',
                      label: 'Burned',
                      iconColor: AppColors.primary,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: StatMiniCard(
                      icon: Icons.timer,
                      value: '45 min',
                      label: 'Active',
                      iconColor: AppColors.accentDark,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SliverPadding(padding: EdgeInsets.only(bottom: 24)),

          // 3. Inactivity Banner (dismissible)
          if (_showNudge)
            SliverToBoxAdapter(
              child: InactivityNudgeBanner(
                minutesInactive: 90,
                onDismiss: () => setState(() => _showNudge = false),
              ),
            ),

          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SectionHeader(
                  englishTitle: 'This Week',
                  hindiSubtitle: 'इस सप्ताह',
                ),

                // 4. Weekly Bar Chart
                const SizedBox(
                  height: 250,
                  child: WeeklyStepsChart(
                    weeklyData: [8500, 10200, 11500, 7800, 9900, 4500, 7450],
                    goal: 10000,
                  ),
                ),

                // 5. Adaptive Goal Insight Card
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: InsightCard(
                    text: "Based on your 7-day average, we recommend a new goal of 9,500 steps. Accept?",
                    onDismiss: () {},
                  ),
                ),

                const SectionHeader(
                  englishTitle: 'History',
                  hindiSubtitle: 'इतिहास',
                ),

                // 6. Calendar Heatmap
                const MonthHeatmap(),
                
                const SizedBox(height: 100), // Bottom breathing room / FAB clearance
              ],
            ),
          ),
        ],
      ),
    );
  }
}

