import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/providers/core_providers.dart';
import '../../../core/database/app_database.dart';
import '../../../shared/widgets/scaffold_patterns.dart';
import '../../../shared/widgets/bento_card.dart';
import '../../../shared/widgets/macro_ring.dart';
import 'food_search_sheet.dart';

class FoodHomeScreen extends ConsumerWidget {
  const FoodHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final foodLogsAsync = ref.watch(appDatabaseProvider.select((db) => db.watchTodayFoodLogs()));

    return AppScaffold.patternA(
      appBar: AppBar(
        title: Text('Food', style: AppTypography.h1()),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () => _showSearch(context),
            icon: const Icon(Icons.search_rounded, color: Colors.white),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: foodLogsAsync.when(
        data: (logs) => _buildContent(context, logs),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, s) => Center(child: Text('Error: $e')),
      ),
    );
  }

  void _showSearch(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const FoodSearchSheet(),
    );
  }

  Widget _buildContent(BuildContext context, List<FoodLog> logs) {
    final totalProtein = logs.fold(0.0, (sum, item) => sum + item.protein);
    final totalCarbs = logs.fold(0.0, (sum, item) => sum + item.carbs);
    final totalFat = logs.fold(0.0, (sum, item) => sum + item.fat);
    final totalKcal = logs.fold(0.0, (sum, item) => sum + item.calories);

    const kcalGoal = 2500.0;
    final remainingKcal = (kcalGoal - totalKcal).toInt();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 12),
        
        // Macro Hero
        GlassCard(
          glowColor: AppColorsDark.secondaryGlow,
          child: Row(
            children: [
              MacroRing(
                protein: totalProtein,
                carbs: totalCarbs,
                fat: totalFat,
                proteinGoal: 150,
                carbsGoal: 250,
                fatGoal: 80,
                centerValue: '$remainingKcal',
                centerLabel: 'KCAL LEFT',
                size: 150,
              ),
              const SizedBox(width: 24),
              Expanded(
                child: Column(
                  children: [
                    _MacroLabel(label: 'Protein', value: '${totalProtein.toInt()}g', color: AppColorsDark.primary),
                    const SizedBox(height: 8),
                    _MacroLabel(label: 'Carbs', value: '${totalCarbs.toInt()}g', color: AppColorsDark.secondary),
                    const SizedBox(height: 8),
                    _MacroLabel(label: 'Fat', value: '${totalFat.toInt()}g', color: AppColorsDark.purple),
                  ],
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: AppSpacing.lg),

        // Meal Sections
        _MealSection(title: 'Breakfast', icon: '🍳', logs: logs.where((l) => l.mealType == 'breakfast').toList(), onAdd: () => _showSearch(context)),
        const SizedBox(height: AppSpacing.md),
        _MealSection(title: 'Lunch', icon: '🥗', logs: logs.where((l) => l.mealType == 'lunch').toList(), onAdd: () => _showSearch(context)),
        const SizedBox(height: AppSpacing.md),
        _MealSection(title: 'Dinner', icon: '🥘', logs: logs.where((l) => l.mealType == 'dinner').toList(), onAdd: () => _showSearch(context)),
        const SizedBox(height: AppSpacing.md),
        _MealSection(title: 'Snacks', icon: '🍎', logs: logs.where((l) => l.mealType == 'snacks').toList(), onAdd: () => _showSearch(context)),

        const SizedBox(height: AppSpacing.xl),

        // Daily Totals
        Text('Daily Totals', style: AppTypography.h2()),
        const SizedBox(height: 12),
        _buildTotalsGrid(totalKcal, totalProtein, totalCarbs, totalFat),
        const SizedBox(height: 40),
      ],
    );
  }

  Widget _buildTotalsGrid(double kcal, double p, double c, double f) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColorsDark.surface0,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          _TotalRow(label: 'Calories', value: '${kcal.toInt()}', unit: 'kcal'),
          const Divider(color: AppColorsDark.surface2),
          _TotalRow(label: 'Protein', value: '${p.toInt()}', unit: 'g'),
          const Divider(color: AppColorsDark.surface2),
          _TotalRow(label: 'Carbs', value: '${c.toInt()}', unit: 'g'),
          const Divider(color: AppColorsDark.surface2),
          _TotalRow(label: 'Fat', value: '${f.toInt()}', unit: 'g'),
        ],
      ),
    );
  }
}

class _MacroLabel extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _MacroLabel({required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(width: 8, height: 8, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
            const SizedBox(width: 8),
            Text(label, style: AppTypography.labelMd(color: AppColorsDark.textSecondary)),
          ],
        ),
        Text(value, style: AppTypography.h4(color: Colors.white)),
      ],
    );
  }
}

class _MealSection extends StatelessWidget {
  final String title;
  final String icon;
  final List<FoodLog> logs;
  final VoidCallback onAdd;

  const _MealSection({required this.title, required this.icon, required this.logs, required this.onAdd});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Text(icon, style: const TextStyle(fontSize: 20)),
                const SizedBox(width: 12),
                Text(title, style: AppTypography.h3()),
              ],
            ),
            IconButton(
              onPressed: onAdd,
              icon: const Icon(Icons.add_circle_outline, color: AppColorsDark.primary),
            ),
          ],
        ),
        if (logs.isEmpty)
          Padding(
            padding: const EdgeInsets.only(left: 36.0, bottom: 8),
            child: Text('No entries yet', style: AppTypography.labelMd(color: AppColorsDark.textMuted)),
          )
        else
          ...logs.map((log) => _FoodRow(log: log)),
      ],
    );
  }
}

class _FoodRow extends StatelessWidget {
  final FoodLog log;

  const _FoodRow({required this.log});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColorsDark.surface1,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Center(child: Icon(Icons.restaurant_menu_rounded, color: AppColorsDark.textMuted, size: 20)),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(log.name, style: AppTypography.bodyLg(color: Colors.white)),
                Text('1 serving', style: AppTypography.labelSm(color: AppColorsDark.textMuted)),
              ],
            ),
          ),
          Text('${log.calories.toInt()} kcal', style: AppTypography.h4(color: Colors.white)),
        ],
      ),
    );
  }
}

class _TotalRow extends StatelessWidget {
  final String label;
  final String value;
  final String unit;

  const _TotalRow({required this.label, required this.value, required this.unit});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTypography.bodyMd(color: AppColorsDark.textSecondary)),
          Row(
            children: [
              Text(value, style: AppTypography.h3(color: Colors.white)),
              const SizedBox(width: 4),
              Text(unit, style: AppTypography.labelMd(color: AppColorsDark.textMuted)),
            ],
          ),
        ],
      ),
    );
  }
}
