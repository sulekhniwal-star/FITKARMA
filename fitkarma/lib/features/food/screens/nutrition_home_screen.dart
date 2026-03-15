// lib/features/food/screens/nutrition_home_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/nutrition_goal_model.dart';
import '../providers/nutrition_providers.dart';
import '../widgets/nutrition_ring_chart.dart';

/// Main nutrition dashboard screen
class NutritionHomeScreen extends ConsumerWidget {
  const NutritionHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final goalAsync = ref.watch(nutritionGoalProvider);
    final todayAsync = ref.watch(todayNutritionProvider);
    final calorieStatus = ref.watch(calorieStatusProvider);
    final proteinStatus = ref.watch(proteinStatusProvider);
    final carbsStatus = ref.watch(carbsStatusProvider);
    final fatStatus = ref.watch(fatStatusProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Nutrition Goals'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ref.invalidate(nutritionGoalProvider);
              ref.invalidate(todayNutritionProvider);
            },
          ),
        ],
      ),
      body: goalAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(child: Text('Error: $e')),
        data: (goal) {
          if (goal == null) {
            return _buildEmptyState(context);
          }

          final today = todayAsync.valueOrNull;
          final calories = today?.consumedCalories ?? 0;
          final protein = today?.consumedProtein ?? 0;
          final carbs = today?.consumedCarbs ?? 0;
          final fat = today?.consumedFat ?? 0;

          return RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(nutritionGoalProvider);
              ref.invalidate(todayNutritionProvider);
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // TDEE Card
                  _buildTDEECard(context, goal),
                  const SizedBox(height: 20),

                  // Today's Progress Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Today's Progress",
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      _buildStatusBadge(context, calorieStatus),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Ring Charts
                  NutritionRingRow(
                    caloriesProgress: goal.targetCalories > 0
                        ? calories / goal.targetCalories
                        : 0,
                    calorieStatus: calorieStatus,
                    calories: calories,
                    calorieTarget: goal.targetCalories,

                    proteinProgress: goal.proteinGrams > 0
                        ? protein / goal.proteinGrams
                        : 0,
                    proteinStatus: proteinStatus,
                    protein: protein,
                    proteinTarget: goal.proteinGrams,

                    carbsProgress: goal.carbsGrams > 0
                        ? carbs / goal.carbsGrams
                        : 0,
                    carbsStatus: carbsStatus,
                    carbs: carbs,
                    carbsTarget: goal.carbsGrams,

                    fatProgress: goal.fatGrams > 0 ? fat / goal.fatGrams : 0,
                    fatStatus: fatStatus,
                    fat: fat,
                    fatTarget: goal.fatGrams,
                  ),
                  const SizedBox(height: 8),

                  // Status Legend
                  const NutritionStatusLegend(),
                  const SizedBox(height: 24),

                  // Micronutrients Section
                  _buildMicronutrientsSection(context, ref, goal, today),
                  const SizedBox(height: 24),

                  // Quick Actions
                  _buildQuickActions(context, ref),
                  const SizedBox(height: 24),

                  // Weekly Report Preview
                  _buildWeeklyReportPreview(context, ref),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.restaurant_menu, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            Text(
              'No Nutrition Goals Set',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            const Text(
              'Complete your profile to get personalized nutrition goals based on the Mifflin-St Jeor formula.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTDEECard(BuildContext context, NutritionGoal goal) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Daily Target',
                      style: Theme.of(
                        context,
                      ).textTheme.bodySmall?.copyWith(color: Colors.grey),
                    ),
                    Text(
                      '${goal.targetCalories.toInt()} kcal',
                      style: Theme.of(context).textTheme.headlineMedium
                          ?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColor,
                          ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'TDEE',
                      style: Theme.of(
                        context,
                      ).textTheme.bodySmall?.copyWith(color: Colors.grey),
                    ),
                    Text(
                      '${goal.tdee.toInt()} kcal',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ],
                ),
              ],
            ),
            const Divider(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildMacroChip(
                  'Carbs',
                  '${goal.carbsGrams.toInt()}g',
                  '55%',
                  Colors.orange,
                ),
                _buildMacroChip(
                  'Protein',
                  '${goal.proteinGrams.toInt()}g',
                  '20%',
                  Colors.red,
                ),
                _buildMacroChip(
                  'Fat',
                  '${goal.fatGrams.toInt()}g',
                  '25%',
                  Colors.blue,
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Activity: ${goal.activityLevel.replaceAll('_', ' ').toUpperCase()}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                Text(
                  'Goal: ${goal.fitnessGoal.replaceAll('_', ' ').toUpperCase()}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMacroChip(
    String label,
    String value,
    String percent,
    Color color,
  ) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(
            '$value ($percent)',
            style: TextStyle(color: color, fontWeight: FontWeight.w600),
          ),
        ),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    );
  }

  Widget _buildStatusBadge(BuildContext context, NutritionStatus status) {
    Color color;
    switch (status) {
      case NutritionStatus.good:
        color = const Color(0xFF4CAF50);
        break;
      case NutritionStatus.warning:
        color = const Color(0xFFFFC107);
        break;
      case NutritionStatus.bad:
        color = const Color(0xFFF44336);
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(status.emoji, style: const TextStyle(fontSize: 14)),
          const SizedBox(width: 4),
          Text(
            status.label,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMicronutrientsSection(
    BuildContext context,
    WidgetRef ref,
    NutritionGoal goal,
    DailyNutrition? today,
  ) {
    final ironStatus = ref.watch(ironStatusProvider);
    final b12Status = ref.watch(vitaminB12StatusProvider);
    final vitDStatus = ref.watch(vitaminDStatusProvider);
    final calciumStatus = ref.watch(calciumStatusProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Micronutrients',
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        MicronutrientRingChart(
          current: today?.consumedIron ?? 0,
          target: goal.ironMg,
          status: ironStatus,
          label: 'Iron',
          unit: 'mg',
        ),
        const SizedBox(height: 8),
        MicronutrientRingChart(
          current: today?.consumedVitaminB12 ?? 0,
          target: goal.vitaminB12Mcg,
          status: b12Status,
          label: 'Vitamin B12',
          unit: 'mcg',
        ),
        const SizedBox(height: 8),
        MicronutrientRingChart(
          current: today?.consumedVitaminD ?? 0,
          target: goal.vitaminDIU,
          status: vitDStatus,
          label: 'Vitamin D',
          unit: 'IU',
        ),
        const SizedBox(height: 8),
        MicronutrientRingChart(
          current: today?.consumedCalcium ?? 0,
          target: goal.calciumMg,
          status: calciumStatus,
          label: 'Calcium',
          unit: 'mg',
        ),
      ],
    );
  }

  Widget _buildQuickActions(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Actions',
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildActionCard(
                context,
                icon: Icons.shopping_cart,
                label: 'Grocery List',
                onTap: () => _showGroceryList(context, ref),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildActionCard(
                context,
                icon: Icons.analytics,
                label: 'Weekly Report',
                onTap: () => _showWeeklyReport(context, ref),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionCard(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Icon(icon, size: 32, color: Theme.of(context).primaryColor),
              const SizedBox(height: 8),
              Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWeeklyReportPreview(BuildContext context, WidgetRef ref) {
    final reportAsync = ref.watch(weeklyReportProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Weekly Analysis',
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        reportAsync.when(
          loading: () => const Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Center(child: CircularProgressIndicator()),
            ),
          ),
          error: (e, st) => Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text('Error loading report: $e'),
            ),
          ),
          data: (report) {
            if (report == null) {
              return const Card(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Text('No report available'),
                ),
              );
            }

            return Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Week of ${_formatDate(report.weekStart)}',
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: report.hasGaps
                                ? Colors.orange.withOpacity(0.1)
                                : Colors.green.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            report.hasGaps ? 'Needs Attention' : 'Good',
                            style: TextStyle(
                              fontSize: 12,
                              color: report.hasGaps
                                  ? Colors.orange
                                  : Colors.green,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    ...report.recommendations
                        .take(2)
                        .map(
                          (rec) => Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Text(
                              rec,
                              style: const TextStyle(fontSize: 13),
                            ),
                          ),
                        ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  void _showGroceryList(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.9,
        minChildSize: 0.5,
        expand: false,
        builder: (context, scrollController) {
          return _GroceryListSheet(scrollController: scrollController);
        },
      ),
    );
  }

  void _showWeeklyReport(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.8,
        maxChildSize: 0.95,
        minChildSize: 0.5,
        expand: false,
        builder: (context, scrollController) {
          return _WeeklyReportSheet(scrollController: scrollController);
        },
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.month}/${date.day}';
  }
}

/// Grocery List Bottom Sheet
class _GroceryListSheet extends ConsumerWidget {
  final ScrollController scrollController;

  const _GroceryListSheet({required this.scrollController});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final groceryListAsync = ref.watch(groceryListProvider);

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                const Icon(Icons.shopping_cart),
                const SizedBox(width: 8),
                Text(
                  'Grocery List',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ],
            ),
          ),
          Expanded(
            child: groceryListAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, st) => Center(child: Text('Error: $e')),
              data: (items) {
                if (items.isEmpty) {
                  return const Center(child: Text('No items in grocery list'));
                }

                // Group by category
                final grouped = <String, List<GroceryItem>>{};
                for (final item in items) {
                  grouped.putIfAbsent(item.category, () => []).add(item);
                }

                return ListView.builder(
                  controller: scrollController,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: grouped.length,
                  itemBuilder: (context, index) {
                    final category = grouped.keys.elementAt(index);
                    final categoryItems = grouped[category]!;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Text(
                            category,
                            style: Theme.of(context).textTheme.titleSmall
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).primaryColor,
                                ),
                          ),
                        ),
                        ...categoryItems.map(
                          (item) => ListTile(
                            dense: true,
                            leading: const Icon(Icons.check_box_outline_blank),
                            title: Text(item.name),
                            trailing: Text(
                              '${item.quantity.toInt()} ${item.unit}',
                              style: const TextStyle(color: Colors.grey),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

/// Weekly Report Bottom Sheet
class _WeeklyReportSheet extends ConsumerWidget {
  final ScrollController scrollController;

  const _WeeklyReportSheet({required this.scrollController});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reportAsync = ref.watch(weeklyReportProvider);

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                const Icon(Icons.analytics),
                const SizedBox(width: 8),
                Text(
                  'Weekly Micronutrient Report',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ],
            ),
          ),
          Expanded(
            child: reportAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, st) => Center(child: Text('Error: $e')),
              data: (report) {
                if (report == null) {
                  return const Center(child: Text('No report available'));
                }

                return ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  children: [
                    // Summary Card
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Week: ${_formatDateFull(report.weekStart)} - ${_formatDateFull(report.weekEnd)}',
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Icon(
                                  report.hasGaps
                                      ? Icons.warning_amber
                                      : Icons.check_circle,
                                  color: report.hasGaps
                                      ? Colors.orange
                                      : Colors.green,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  report.hasGaps
                                      ? 'Some nutrients need attention'
                                      : 'All nutrients on track!',
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Micronutrient Details
                    Text(
                      'Micronutrient Breakdown',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ...MicronutrientType.values.map((nutrient) {
                      final intake = report.averageIntake[nutrient] ?? 0;
                      final target = report.targets[nutrient] ?? nutrient.rda;
                      final gap = report.gaps[nutrient] ?? 0;

                      return Card(
                        child: ListTile(
                          title: Text(nutrient.displayName),
                          subtitle: LinearProgressIndicator(
                            value: (gap / 100).clamp(0, 1),
                            backgroundColor: _getGapColor(gap).withOpacity(0.2),
                            valueColor: AlwaysStoppedAnimation(
                              _getGapColor(gap),
                            ),
                          ),
                          trailing: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                '${intake.toStringAsFixed(1)} ${nutrient.unit}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                '${gap.toInt()}%',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: _getGapColor(gap),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),

                    const SizedBox(height: 16),

                    // Recommendations
                    Text(
                      'Recommendations',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ...report.recommendations.map(
                      (rec) => Card(
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('💡', style: TextStyle(fontSize: 20)),
                              const SizedBox(width: 12),
                              Expanded(child: Text(rec)),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  String _formatDateFull(DateTime date) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${months[date.month - 1]} ${date.day}';
  }

  Color _getGapColor(double gap) {
    if (gap >= 80) return Colors.green;
    if (gap >= 50) return Colors.orange;
    return Colors.red;
  }
}
