import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../../shared/theme/app_colors.dart';
import '../../../../shared/theme/app_text_styles.dart';

class WeeklyStepsChart extends StatelessWidget {
  final List<double> weeklyData; // 7 days of raw step counts
  final double goal;

  const WeeklyStepsChart({
    super.key,
    required this.weeklyData,
    required this.goal,
  });

  @override
  Widget build(BuildContext context) {
    if (weeklyData.length != 7) return const SizedBox.shrink();

    final maxVal = weeklyData.reduce((curr, next) => curr > next ? curr : next) > goal 
                 ? weeklyData.reduce((curr, next) => curr > next ? curr : next) * 1.2 
                 : goal * 1.5;

    return Container(
      height: 200,
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
      child: BarChart(
        BarChartData(
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: goal,
            getDrawingHorizontalLine: (value) {
              if (value == goal) {
                return FlLine(
                  color: AppColors.textSecondary.withValues(alpha: 0.5),
                  strokeWidth: 1,
                  dashArray: [4, 4], // Dashed goal line
                );
              }
              return const FlLine(color: Colors.transparent);
            },
          ),
          alignment: BarChartAlignment.spaceAround,
          maxY: maxVal,
          barTouchData: BarTouchData(enabled: false), // Static layout for mock
          titlesData: FlTitlesData(
            show: true,
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (val, _) {
                  final days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
                  return Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(days[val.toInt()], style: AppTextStyles.caption),
                  );
                },
              ),
            ),
            leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)), // Hide left axis
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          borderData: FlBorderData(show: false),
          barGroups: List.generate(7, (i) {
            final val = weeklyData[i];
            final metGoal = val >= goal;
            return BarChartGroupData(
              x: i,
              barRods: [
                BarChartRodData(
                  toY: val,
                  color: metGoal ? AppColors.success : AppColors.primary, // Green if met, Orange if below
                  width: 16,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
                  backDrawRodData: BackgroundBarChartRodData(
                    show: true,
                    toY: maxVal,
                    color: AppColors.surfaceVariant, // Background track
                  ),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}
