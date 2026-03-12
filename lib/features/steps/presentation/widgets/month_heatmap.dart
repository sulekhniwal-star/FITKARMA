import 'package:flutter/material.dart';
import '../../../../shared/theme/app_colors.dart';
import '../../../../shared/theme/app_text_styles.dart';

class MonthHeatmap extends StatelessWidget {
  const MonthHeatmap({super.key});

  @override
  Widget build(BuildContext context) {
    // Generates 30 random days of step mock data coloring
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('March', style: AppTextStyles.h4),
              Row(
                children: [
                  _buildLegendBoxColor(AppColors.primaryLight),
                  const SizedBox(width: 4),
                  _buildLegendBoxColor(AppColors.success.withValues(alpha: 0.3)),
                  const SizedBox(width: 4),
                  _buildLegendBoxColor(AppColors.success.withValues(alpha: 0.6)),
                  const SizedBox(width: 4),
                  _buildLegendBoxColor(AppColors.success),
                  const SizedBox(width: 8),
                  Text('Less / More', style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7, // 7 days of week
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            itemCount: 30, // Days in month
            itemBuilder: (context, index) {
              // Procedural coloring mock
              Color cellColor;
              if (index % 7 == 6 || index % 7 == 5) { // Weekend (often low)
                cellColor = AppColors.primaryLight.withValues(alpha: 0.5); // Soft orange (below goal)
              } else if (index % 4 == 0) {
                cellColor = AppColors.success; // High intent green
              } else if (index % 3 == 0) {
                cellColor = AppColors.success.withValues(alpha: 0.6); // Med green
              } else {
                cellColor = AppColors.success.withValues(alpha: 0.3); // Light green
              }

              return Container(
                decoration: BoxDecoration(
                  color: cellColor,
                  borderRadius: BorderRadius.circular(4),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildLegendBoxColor(Color color) {
    return Container(
      width: 12,
      height: 12,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }
}
