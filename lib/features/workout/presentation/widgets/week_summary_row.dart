import 'package:flutter/material.dart';
import '../../../../shared/theme/app_colors.dart';
import '../../../../shared/theme/app_text_styles.dart';

class WeekSummaryRow extends StatelessWidget {
  final int totalWorkouts;
  final int totalMinutes;

  const WeekSummaryRow({
    super.key,
    required this.totalWorkouts,
    required this.totalMinutes,
  });

  @override
  Widget build(BuildContext context) {
    // 7 day circular indicators mimicking completed/missed logic
    final List<Map<String, dynamic>> mockDays = [
      {'d': 'M', 's': 'done'},
      {'d': 'T', 's': 'rest'},
      {'d': 'W', 's': 'done'},
      {'d': 'T', 's': 'missed'},
      {'d': 'F', 's': 'done'},
      {'d': 'S', 's': 'upcoming'},
      {'d': 'S', 's': 'upcoming'},
    ];

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.divider),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: mockDays.map((day) {
              Color ringColor;
              Color innerColor;
              if (day['s'] == 'done') {
                ringColor = AppColors.primary;
                innerColor = AppColors.primary;
              } else if (day['s'] == 'rest') {
                ringColor = AppColors.success;
                innerColor = AppColors.success;
              } else if (day['s'] == 'missed') {
                ringColor = AppColors.error;
                innerColor = Colors.transparent;
              } else {
                ringColor = AppColors.divider;
                innerColor = Colors.transparent;
              }

              return Column(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: ringColor, width: 2),
                    ),
                    child: Center(
                      child: Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: innerColor,
                        ),
                        child: day['s'] == 'done' || day['s'] == 'rest' 
                            ? const Icon(Icons.check, size: 16, color: AppColors.white)
                            : null,
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(day['d'], style: AppTextStyles.caption.copyWith(fontWeight: FontWeight.bold)),
                ],
              );
            }).toList(),
          ),
          const SizedBox(height: 20),
          Divider(color: AppColors.divider.withValues(alpha: 0.5)),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem('$totalWorkouts', 'Workouts'),
              _buildStatItem('$totalMinutes', 'Minutes'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String val, String label) {
    return Column(
      children: [
        Text(val, style: AppTextStyles.h3),
        Text(label, style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary)),
      ],
    );
  }
}
