import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../../shared/theme/app_colors.dart';
import '../../../../shared/theme/app_text_styles.dart';

class DailyNutritionCard extends StatelessWidget {
  final int caloriesConsumed;
  final int caloriesGoal;
  final double proteinConsumed;
  final double proteinGoal;
  final double carbsConsumed;
  final double carbsGoal;
  final double fatConsumed;
  final double fatGoal;

  const DailyNutritionCard({
    super.key,
    required this.caloriesConsumed,
    required this.caloriesGoal,
    required this.proteinConsumed,
    required this.proteinGoal,
    required this.carbsConsumed,
    required this.carbsGoal,
    required this.fatConsumed,
    required this.fatGoal,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Daily Goal', style: AppTextStyles.h4),
              _buildTrafficLightChip(),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              SizedBox(
                height: 120,
                width: 120,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    PieChart(
                      PieChartData(
                        sectionsSpace: 4,
                        centerSpaceRadius: 40,
                        startDegreeOffset: -90,
                        sections: _buildPieSections(),
                      ),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('$caloriesConsumed', style: AppTextStyles.h2.copyWith(color: AppColors.primary)),
                        Text('/ $caloriesGoal', style: AppTextStyles.caption),
                        Text('kcal', style: AppTextStyles.caption),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 24),
              Expanded(
                child: Column(
                  children: [
                    _buildMacroRow('Protein', proteinConsumed, proteinGoal, AppColors.success),
                    const SizedBox(height: 12),
                    _buildMacroRow('Carbs', carbsConsumed, carbsGoal, AppColors.accentDark),
                    const SizedBox(height: 12),
                    _buildMacroRow('Fat', fatConsumed, fatGoal, AppColors.purple),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  List<PieChartSectionData> _buildPieSections() {
    return [
      PieChartSectionData(
        color: AppColors.success,
        value: proteinConsumed,
        title: '',
        radius: 12,
      ),
      PieChartSectionData(
        color: AppColors.accentDark,
        value: carbsConsumed,
        title: '',
        radius: 12,
      ),
      PieChartSectionData(
        color: AppColors.purple,
        value: fatConsumed,
        title: '',
        radius: 12,
      ),
      PieChartSectionData(
        color: AppColors.divider,
        value: ((proteinGoal + carbsGoal + fatGoal) - (proteinConsumed + carbsConsumed + fatConsumed)).clamp(0, double.infinity),
        title: '',
        radius: 12,
      ),
    ];
  }

  Widget _buildTrafficLightChip() {
    bool isOver = caloriesConsumed > caloriesGoal;
    bool isSlightlyOver = isOver && caloriesConsumed < (caloriesGoal * 1.1);

    Color chipColor;
    String chipText;

    if (isSlightlyOver) {
      chipColor = AppColors.warning;
      chipText = '🟡 Slightly Over';
    } else if (isOver) {
      chipColor = AppColors.error;
      chipText = '🔴 Exceeded';
    } else {
      chipColor = AppColors.success;
      chipText = '🟢 On Track';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: chipColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: chipColor.withValues(alpha: 0.5)),
      ),
      child: Text(
        chipText,
        style: AppTextStyles.caption.copyWith(color: chipColor, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildMacroRow(String label, double consumed, double goal, Color color) {
    double progress = (consumed / goal).clamp(0.0, 1.0);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: AppTextStyles.bodyMedium),
            Text('${consumed.toInt()}g / ${goal.toInt()}g', style: AppTextStyles.caption),
          ],
        ),
        const SizedBox(height: 4),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: progress,
            backgroundColor: AppColors.divider,
            valueColor: AlwaysStoppedAnimation<Color>(color),
            minHeight: 6,
          ),
        ),
      ],
    );
  }
}
