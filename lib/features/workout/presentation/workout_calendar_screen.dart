import 'package:flutter/material.dart';
import '../../../shared/theme/app_colors.dart';

import '../../../shared/widgets/section_header.dart';
import 'widgets/month_calendar_grid.dart';
import 'widgets/day_detail_card.dart';
import 'widgets/week_summary_row.dart';

class WorkoutCalendarScreen extends StatefulWidget {
  const WorkoutCalendarScreen({super.key});

  @override
  State<WorkoutCalendarScreen> createState() => _WorkoutCalendarScreenState();
}

class _WorkoutCalendarScreenState extends State<WorkoutCalendarScreen> {
  DateTime _selectedDate = DateTime(2026, 3, 10); // Mock current day

  @override
  Widget build(BuildContext context) {
    // Basic reactive mock switching logic for detail card
    final isRestDay = _selectedDate.day % 5 == 0;
    final isDone = _selectedDate.day < 15 && !isRestDay;
    final hasWorkoutToStart = _selectedDate.day >= 15 && _selectedDate.day % 2 != 0;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Calendar / कैलेंडर'),
      ),
      body: CustomScrollView(
        slivers: [
          // 1. Month Calendar Header block
          SliverToBoxAdapter(
            child: MonthCalendarGrid(
              currentMonth: DateTime(2026, 3), // Fixed mock
              selectedDay: _selectedDate,
              onDaySelected: (day) {
                setState(() => _selectedDate = day);
              },
            ),
          ),
          
          // 2. Selected Day Detail
          SliverToBoxAdapter(
            child: DayDetailCard(
              date: _selectedDate,
              hasWorkout: !isRestDay && (isDone || hasWorkoutToStart),
              isCompleted: isDone,
              workoutName: 'Upper Body Power',
              duration: '45m',
              calories: '320',
            ),
          ),
          
          // 3. Section Header
          const SliverToBoxAdapter(
            child: SectionHeader(
              englishTitle: 'This Week',
              hindiSubtitle: 'इस सप्ताह',
            ),
          ),
          
          // 4. Summary Row Stats
          const SliverToBoxAdapter(
            child: WeekSummaryRow(
              totalWorkouts: 3,
              totalMinutes: 135,
            ),
          ),
          
          const SliverPadding(padding: EdgeInsets.only(bottom: 80)), // safe area clear
        ],
      ),
    );
  }
}
