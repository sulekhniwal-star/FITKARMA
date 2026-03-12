import 'package:flutter/material.dart';
import '../../../../shared/theme/app_colors.dart';
import '../../../../shared/theme/app_text_styles.dart';

class MonthCalendarGrid extends StatelessWidget {
  final DateTime currentMonth;
  final ValueChanged<DateTime> onDaySelected;
  final DateTime selectedDay;

  const MonthCalendarGrid({
    super.key,
    required this.currentMonth,
    required this.onDaySelected,
    required this.selectedDay,
  });

  @override
  Widget build(BuildContext context) {
    // Generate dates for current month mock
    // Mocking 35 days grid (5 weeks)
    final List<String> weekDays = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
    
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
          // Month Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(onPressed: () {}, icon: const Icon(Icons.chevron_left)),
              Text('March 2026', style: AppTextStyles.h3),
              IconButton(onPressed: () {}, icon: const Icon(Icons.chevron_right)),
            ],
          ),
          const SizedBox(height: 16),
          
          // Weekday Labels
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: weekDays.map((day) => Text(day, style: AppTextStyles.caption.copyWith(fontWeight: FontWeight.bold, color: AppColors.textSecondary))).toList(),
          ),
          const SizedBox(height: 12),
          
          // Days Grid
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 35,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              childAspectRatio: 1,
            ),
            itemBuilder: (context, index) {
              final dayNum = index - 1; // offset mock
              final isCurrentMonth = dayNum > 0 && dayNum <= 31;
              final displayNum = isCurrentMonth ? dayNum.toString() : '';

              final isSelected = isCurrentMonth && dayNum == selectedDay.day;
              
              // Marker mock logic
              Color? markerColor;
              if (isCurrentMonth) {
                if (dayNum % 3 == 0 && dayNum < 15) {
                  markerColor = AppColors.primary; // Completed workout
                } else if (dayNum % 5 == 0 && dayNum < 15) {
                  markerColor = AppColors.success; // Rest day
                } else if (dayNum > 15 && dayNum % 4 == 0) {
                  markerColor = AppColors.accent; // Scheduled future
                }
              }

              return GestureDetector(
                onTap: () {
                  if (isCurrentMonth) {
                    onDaySelected(DateTime(2026, 3, dayNum));
                  }
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.primarySurface : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                    border: isSelected ? Border.all(color: AppColors.primary) : null,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        displayNum,
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: isCurrentMonth ? AppColors.textPrimary : Colors.transparent,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                      const SizedBox(height: 2),
                      if (markerColor != null)
                        Container(
                          width: 6,
                          height: 6,
                          decoration: BoxDecoration(
                            color: markerColor,
                            shape: BoxShape.circle,
                          ),
                        ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
