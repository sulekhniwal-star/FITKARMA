// lib/features/workout/screens/workout_calendar_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../shared/theme/app_colors.dart';
import '../domain/workout_model.dart';
import '../providers/workout_providers.dart';

/// Workout calendar screen for scheduling workouts
class WorkoutCalendarScreen extends ConsumerStatefulWidget {
  const WorkoutCalendarScreen({super.key});

  @override
  ConsumerState<WorkoutCalendarScreen> createState() =>
      _WorkoutCalendarScreenState();
}

class _WorkoutCalendarScreenState extends ConsumerState<WorkoutCalendarScreen> {
  late DateTime _selectedDate;
  late DateTime _focusedMonth;

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
    _focusedMonth = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    final scheduledWorkouts = ref.watch(scheduledWorkoutsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Workout Calendar'),
        actions: [
          IconButton(
            icon: const Icon(Icons.today),
            onPressed: () {
              setState(() {
                _selectedDate = DateTime.now();
                _focusedMonth = DateTime.now();
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Calendar
          _buildCalendar(scheduledWorkouts),

          // Divider
          const Divider(height: 1),

          // Selected date info
          Expanded(child: _buildSelectedDayWorkouts(scheduledWorkouts)),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddWorkoutDialog(),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildCalendar(List<ScheduledWorkout> scheduledWorkouts) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Month navigation
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.chevron_left),
                onPressed: () {
                  setState(() {
                    _focusedMonth = DateTime(
                      _focusedMonth.year,
                      _focusedMonth.month - 1,
                    );
                  });
                },
              ),
              Text(
                '${_getMonthName(_focusedMonth.month)} ${_focusedMonth.year}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.chevron_right),
                onPressed: () {
                  setState(() {
                    _focusedMonth = DateTime(
                      _focusedMonth.year,
                      _focusedMonth.month + 1,
                    );
                  });
                },
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Day headers
          Row(
            children: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun']
                .map(
                  (day) => Expanded(
                    child: Center(
                      child: Text(
                        day,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[600],
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 8),

          // Calendar grid
          _buildCalendarGrid(scheduledWorkouts),
        ],
      ),
    );
  }

  Widget _buildCalendarGrid(List<ScheduledWorkout> scheduledWorkouts) {
    final firstDayOfMonth = DateTime(
      _focusedMonth.year,
      _focusedMonth.month,
      1,
    );
    final lastDayOfMonth = DateTime(
      _focusedMonth.year,
      _focusedMonth.month + 1,
      0,
    );

    // Adjust for Monday start (1 = Monday, 7 = Sunday)
    int startingWeekday = firstDayOfMonth.weekday;
    int daysToShow = lastDayOfMonth.day + startingWeekday - 1;
    int weeks = (daysToShow / 7).ceil();

    return Column(
      children: List.generate(weeks, (weekIndex) {
        return Row(
          children: List.generate(7, (dayIndex) {
            int dayNumber = weekIndex * 7 + dayIndex - startingWeekday + 2;

            if (dayNumber < 1 || dayNumber > lastDayOfMonth.day) {
              return const Expanded(child: SizedBox(height: 40));
            }

            final date = DateTime(
              _focusedMonth.year,
              _focusedMonth.month,
              dayNumber,
            );
            final isToday = _isSameDay(date, DateTime.now());
            final isSelected = _isSameDay(date, _selectedDate);
            final hasWorkout = _hasScheduledWorkout(scheduledWorkouts, date);
            final isRestDay = _isRestDay(scheduledWorkouts, date);

            return Expanded(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedDate = date;
                  });
                },
                child: Container(
                  height: 40,
                  margin: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.primary
                        : isToday
                        ? AppColors.primary.withOpacity(0.1)
                        : null,
                    borderRadius: BorderRadius.circular(8),
                    border: isToday && !isSelected
                        ? Border.all(color: AppColors.primary)
                        : null,
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Text(
                        '$dayNumber',
                        style: TextStyle(
                          color: isSelected ? Colors.white : null,
                          fontWeight: isToday ? FontWeight.bold : null,
                        ),
                      ),
                      if (hasWorkout || isRestDay)
                        Positioned(
                          bottom: 4,
                          child: Container(
                            width: 6,
                            height: 6,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: isRestDay
                                  ? Colors.orange
                                  : isSelected
                                  ? Colors.white
                                  : Colors.green,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            );
          }),
        );
      }),
    );
  }

  Widget _buildSelectedDayWorkouts(List<ScheduledWorkout> scheduledWorkouts) {
    final workoutsForDay = scheduledWorkouts.where((w) {
      return _isSameDay(w.scheduledDate, _selectedDate);
    }).toList();

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _isSameDay(_selectedDate, DateTime.now())
                    ? 'Today'
                    : _formatDate(_selectedDate),
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              TextButton.icon(
                onPressed: () => _markAsRestDay(),
                icon: const Icon(Icons.weekend, size: 18),
                label: const Text('Rest Day'),
              ),
            ],
          ),
          const SizedBox(height: 16),

          if (workoutsForDay.isEmpty)
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.event_available,
                      size: 64,
                      color: Colors.grey[300],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No workout scheduled',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                    const SizedBox(height: 8),
                    TextButton(
                      onPressed: () => _showAddWorkoutDialog(),
                      child: const Text('Add workout'),
                    ),
                  ],
                ),
              ),
            )
          else
            Expanded(
              child: ListView.builder(
                itemCount: workoutsForDay.length,
                itemBuilder: (context, index) {
                  final workout = workoutsForDay[index];
                  return _buildScheduledWorkoutItem(workout);
                },
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildScheduledWorkoutItem(ScheduledWorkout workout) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: workout.isRestDay
              ? Colors.orange.withOpacity(0.1)
              : AppColors.primary.withOpacity(0.1),
          child: Icon(
            workout.isRestDay ? Icons.weekend : Icons.fitness_center,
            color: workout.isRestDay ? Colors.orange : AppColors.primary,
          ),
        ),
        title: Text(workout.title),
        subtitle: workout.notes != null ? Text(workout.notes!) : null,
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (!workout.completed)
              Checkbox(
                value: false,
                onChanged: (value) {
                  if (value == true) {
                    ref
                        .read(workoutProvider.notifier)
                        .markScheduledWorkoutCompleted(workout.id);
                  }
                },
              )
            else
              const Icon(Icons.check_circle, color: Colors.green),
            IconButton(
              icon: const Icon(Icons.delete, size: 20),
              onPressed: () {
                ref
                    .read(workoutProvider.notifier)
                    .deleteScheduledWorkout(workout.id);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showAddWorkoutDialog() {
    final workouts = ref.read(workoutProvider).workouts;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        minChildSize: 0.4,
        maxChildSize: 0.9,
        expand: false,
        builder: (context, scrollController) => Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Schedule Workout',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView.builder(
                  controller: scrollController,
                  itemCount: workouts.length,
                  itemBuilder: (context, index) {
                    final workout = workouts[index];
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor: AppColors.primary.withOpacity(0.1),
                        child: const Icon(
                          Icons.fitness_center,
                          color: AppColors.primary,
                        ),
                      ),
                      title: Text(workout.title),
                      subtitle: Text(workout.formattedDuration),
                      onTap: () {
                        _scheduleWorkout(workout);
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _scheduleWorkout(Workout workout) {
    final scheduled = ScheduledWorkout.create(
      odId: odId,
      workoutId: workout.id,
      title: workout.title,
      scheduledDate: _selectedDate,
      workoutType: 'video',
    );

    ref.read(workoutProvider.notifier).scheduleWorkout(scheduled);
  }

  void _markAsRestDay() {
    final scheduled = ScheduledWorkout.restDay(
      odId: odId,
      scheduledDate: _selectedDate,
    );

    ref.read(workoutProvider.notifier).scheduleWorkout(scheduled);
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  bool _hasScheduledWorkout(List<ScheduledWorkout> workouts, DateTime date) {
    return workouts.any(
      (w) => _isSameDay(w.scheduledDate, date) && !w.isRestDay,
    );
  }

  bool _isRestDay(List<ScheduledWorkout> workouts, DateTime date) {
    return workouts.any(
      (w) => _isSameDay(w.scheduledDate, date) && w.isRestDay,
    );
  }

  String _getMonthName(int month) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return months[month - 1];
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
