import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/widgets/activity_rings.dart';
import '../../../shared/widgets/bilingual_label.dart';
import '../../../shared/widgets/insight_card.dart';
import '../../../shared/widgets/meal_tab_bar.dart';
import 'dashboard_controller.dart';
import 'greeting_provider.dart';
import 'widgets/add_metric_dialog.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashboardAsync = ref.watch(dashboardControllerProvider);
    final greeting = ref.watch(randomGreetingProvider);

    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () => ref.refresh(dashboardControllerProvider.future),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      const CircleAvatar(
                        radius: 20,
                        backgroundColor: AppColors.secondaryIndigo,
                        child: Icon(Icons.person, color: Colors.white),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            BilingualLabel(
                              english: '${greeting.english}, Suresh',
                              hindi: '${greeting.hindi}, सुरेश 🙏',
                              englishSize: 18,
                            ),
                            const Text(
                              'Level 12 Warrior',
                              style: TextStyle(fontSize: 12, color: AppColors.textGrey),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppColors.accentAmber.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Icon(Icons.monetization_on, color: AppColors.accentAmber, size: 16),
                            SizedBox(width: 4),
                            Text(
                              '1,250 XP',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textBlack,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // Activity Rings Card
                dashboardAsync.when(
                  data: (state) => Card(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        children: [
                          ActivityRingsWidget(
                            caloriesProgress: state.caloriesProgress,
                            stepsProgress: state.stepsProgress,
                            waterProgress: state.waterProgress,
                            minutesProgress: state.minutesProgress,
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              _MetricInfo(
                                value: '${state.calories.toInt()}',
                                goal: '${state.caloriesGoal.toInt()} kcal',
                                color: AppColors.primaryOrange,
                              ),
                              _MetricInfo(
                                value: '${state.steps}',
                                goal: '${state.stepsGoal} steps',
                                color: AppColors.successGreen,
                              ),
                              _MetricInfo(
                                value: '${state.water} / ${state.waterGoal}',
                                goal: 'glasses',
                                color: Colors.teal,
                              ),
                              _MetricInfo(
                                value: '${state.minutes} / ${state.minutesGoal}',
                                goal: 'mins',
                                color: Colors.purple,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  loading: () => const Center(
                    child: Padding(
                      padding: EdgeInsets.all(40.0),
                      child: CircularProgressIndicator(),
                    ),
                  ),
                  error: (e, st) => Center(child: Text('Error: $e')),
                ),

                const SizedBox(height: 16),

                // Insight Card
                const InsightCard(
                  content: "You're 18g protein short today. Adding a katori of dal to dinner will help!",
                ),

                const Padding(
                  padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
                  child: BilingualLabel(
                    english: "Today's Meals",
                    hindi: "आज का भोजन",
                    englishSize: 18,
                  ),
                ),

                // Meal Tracker
                MealTypeTabBar(
                  onTabChanged: (meal) {
                    debugPrint('Tab changed to: $meal');
                  },
                ),
                
                const SizedBox(height: 80), // Space for FAB
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => const AddMetricDialog(),
          );
        },
        backgroundColor: AppColors.primaryOrange,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}

class _MetricInfo extends StatelessWidget {
  final String value;
  final String goal;
  final Color color;

  const _MetricInfo({
    required this.value,
    required this.goal,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          goal,
          style: const TextStyle(fontSize: 10, color: AppColors.textGrey),
        ),
      ],
    );
  }
}
