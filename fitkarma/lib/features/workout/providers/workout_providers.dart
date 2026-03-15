// lib/features/workout/providers/workout_providers.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/workout_aw_service.dart';
import '../data/workout_hive_service.dart';
import '../domain/workout_model.dart';
import '../../karma/data/karma_hive_service.dart';
import '../../karma/domain/karma_model.dart';

/// Default user ID
const odId = 'default_user';

/// Workout state
class WorkoutState {
  final List<Workout> workouts;
  final List<WorkoutLog> logs;
  final List<CustomWorkout> customWorkouts;
  final List<PersonalRecord> personalRecords;
  final List<ScheduledWorkout> scheduledWorkouts;
  final Map<String, dynamic> weeklyStats;
  final int streak;
  final Workout? selectedWorkout;
  final WorkoutLog? activeWorkoutLog;
  final bool isLoading;
  final String? error;
  final String? selectedCategory;

  const WorkoutState({
    this.workouts = const [],
    this.logs = const [],
    this.customWorkouts = const [],
    this.personalRecords = const [],
    this.scheduledWorkouts = const [],
    this.weeklyStats = const {},
    this.streak = 0,
    this.selectedWorkout,
    this.activeWorkoutLog,
    this.isLoading = false,
    this.error,
    this.selectedCategory,
  });

  WorkoutState copyWith({
    List<Workout>? workouts,
    List<WorkoutLog>? logs,
    List<CustomWorkout>? customWorkouts,
    List<PersonalRecord>? personalRecords,
    List<ScheduledWorkout>? scheduledWorkouts,
    Map<String, dynamic>? weeklyStats,
    int? streak,
    Workout? selectedWorkout,
    WorkoutLog? activeWorkoutLog,
    bool? isLoading,
    String? error,
    String? selectedCategory,
    bool clearSelectedWorkout = false,
    bool clearActiveLog = false,
  }) {
    return WorkoutState(
      workouts: workouts ?? this.workouts,
      logs: logs ?? this.logs,
      customWorkouts: customWorkouts ?? this.customWorkouts,
      personalRecords: personalRecords ?? this.personalRecords,
      scheduledWorkouts: scheduledWorkouts ?? this.scheduledWorkouts,
      weeklyStats: weeklyStats ?? this.weeklyStats,
      streak: streak ?? this.streak,
      selectedWorkout: clearSelectedWorkout ? null : (selectedWorkout ?? this.selectedWorkout),
      activeWorkoutLog: clearActiveLog ? null : (activeWorkoutLog ?? this.activeWorkoutLog),
      isLoading: isLoading ?? this.isLoading,
      error: error,
      selectedCategory: selectedCategory ?? this.selectedCategory,
    );
  }

  /// Get workouts filtered by category
  List<Workout> get filteredWorkouts {
    if (selectedCategory == null || selectedCategory == 'all') {
      return workouts;
    }
    return workouts.where((w) => w.category == selectedCategory).toList();
  }
}

/// Workout notifier
class WorkoutNotifier extends StateNotifier<WorkoutState> {
  WorkoutNotifier() : super(const WorkoutState());

  /// Initialize workout data
  Future<void> init() async {
    state = state.copyWith(isLoading: true);

    try {
      // Try to seed workout data
      await WorkoutAwService.seedWorkoutData();

      // Fetch workouts from server
      var workouts = await WorkoutAwService.getAllWorkouts();

      // If no workouts from server, try cache
      if (workouts.isEmpty) {
        workouts = WorkoutHiveService.getCachedWorkouts();
      } else {
        // Cache workouts locally
        await WorkoutHiveService.cacheWorkouts(workouts);
      }

      // Get workout logs
      final logs = WorkoutHiveService.getWorkoutLogs(odId);

      // Get custom workouts
      final customWorkouts = WorkoutHiveService.getCustomWorkouts(odId);

      // Get personal records
      final personalRecords = WorkoutHiveService.getPersonalRecords(odId);

      // Get scheduled workouts
      final now = DateTime.now();
      final weekEnd = now.add(const Duration(days: 7));
      final scheduledWorkouts = WorkoutHiveService.getScheduledWorkoutsInRange(odId, now, weekEnd);

      // Get weekly stats
      final weeklyStats = WorkoutHiveService.getWeeklyStats(odId);

      // Get streak
      final streak = WorkoutHiveService.getStreak(odId);

      state = state.copyWith(
        workouts: workouts,
        logs: logs,
        customWorkouts: customWorkouts,
        personalRecords: personalRecords,
        scheduledWorkouts: scheduledWorkouts,
        weeklyStats: weeklyStats,
        streak: streak,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  /// Select a category
  void selectCategory(String? category) {
    state = state.copyWith(selectedCategory: category);
  }

  /// Select a workout
  void selectWorkout(Workout workout) {
    state = state.copyWith(selectedWorkout: workout);
  }

  /// Clear selected workout
  void clearSelectedWorkout() {
    state = state.copyWith(clearSelectedWorkout: true);
  }

  /// Start a workout
  void startWorkout(Workout workout) {
    final log = WorkoutLog.create(
      odId: odId,
      workoutId: workout.id,
      workoutTitle: workout.title,
      category: workout.category,
      difficulty: workout.difficulty,
    );
    state = state.copyWith(activeWorkoutLog: log);
  }

  /// Start custom workout
  void startCustomWorkout(CustomWorkout customWorkout) {
    final log = WorkoutLog.create(
      odId: odId,
      workoutId: customWorkout.id,
      workoutTitle: customWorkout.title,
      category: 'custom',
      difficulty: 'custom',
    );
    state = state.copyWith(activeWorkoutLog: log);
  }

  /// Complete the active workout
  Future<bool> completeWorkout({
    int? durationMinutes,
    int? caloriesBurned,
    String? notes,
    double? distanceKm,
  }) async {
    if (state.activeWorkoutLog == null) return false;

    final log = state.activeWorkoutLog!;
    log.complete(
      durationMinutes: durationMinutes,
      caloriesBurned: caloriesBurned,
      notes: notes,
      distanceKm: distanceKm,
    );

    // Save to local storage
    await WorkoutHiveService.addWorkoutLog(log);

    // Award XP (+20 XP for completing workout)
    await _awardWorkoutXP(log);

    // Check for personal records
    await _checkPersonalRecords(log);

    // Update state
    final logs = WorkoutHiveService.getWorkoutLogs(odId);
    final weeklyStats = WorkoutHiveService.getWeeklyStats(odId);
    final streak = WorkoutHiveService.getStreak(odId);

    state = state.copyWith(
      logs: logs,
      weeklyStats: weeklyStats,
      streak: streak,
      clearActiveLog: true,
    );

    return true;
  }

  /// Award XP for workout completion
  Future<void> _awardWorkoutXP(WorkoutLog log) async {
    // Calculate XP based on duration and difficulty
    int baseXP = 20;

    // Add bonus for longer workouts
    if (log.durationMinutes >= 30) {
      baseXP += 10;
    }
    if (log.durationMinutes >= 45) {
      baseXP += 15;
    }

    // Add bonus for harder workouts
    if (log.difficulty == 'intermediate') {
      baseXP += 5;
    } else if (log.difficulty == 'advanced') {
      baseXP += 10;
    }

    try {
      await KarmaHiveService.addXP(
        odId: odId,
        amount: baseXP,
        action: 'workout',
        description: 'Completed workout: ${log.workoutTitle}',
      );
    } catch (e) {
      print('Error awarding workout XP: $e');
    }
  }

  /// Check and update personal records
  Future<void> _checkPersonalRecords(WorkoutLog log) async {
    // This would check exercises if we tracked them
    // For now, we just mark that we completed a workout
  }

  /// Check for personal record on exercise
  Future<bool> checkExerciseRecord({
    required String exerciseName,
    double? weight,
    int? reps,
    int? duration,
  }) async {
    final isNewRecord = await WorkoutHiveService.checkAndUpdateRecord(
      odId: odId,
      exerciseName: exerciseName,
      weight: weight,
      reps: reps,
      duration: duration,
    );

    if (isNewRecord) {
      // Award bonus XP for personal record (+100 XP)
      try {
        await KarmaHiveService.addXP(
          odId: odId,
          amount: 100,
          action: 'personal_record',
          description: 'New personal record: $exerciseName',
        );
      } catch (e) {
        print('Error awarding personal record XP: $e');
      }

      // Refresh personal records
      final personalRecords = WorkoutHiveService.getPersonalRecords(odId);
      state = state.copyWith(personalRecords: personalRecords);
    }

    return isNewRecord;
  }

  /// Cancel active workout
  void cancelWorkout() {
    state = state.copyWith(clearActiveLog: true);
  }

  /// Add custom workout
  Future<void> addCustomWorkout(CustomWorkout workout) async {
    await WorkoutHiveService.addCustomWorkout(workout);
    final customWorkouts = WorkoutHiveService.getCustomWorkouts(odId);
    state = state.copyWith(customWorkouts: customWorkouts);
  }

  /// Delete custom workout
  Future<void> deleteCustomWorkout(String id) async {
    await WorkoutHiveService.deleteCustomWorkout(id);
    final customWorkouts = WorkoutHiveService.getCustomWorkouts(odId);
    state = state.copyWith(customWorkouts: customWorkouts);
  }

  /// Schedule a workout
  Future<void> scheduleWorkout(ScheduledWorkout workout) async {
    await WorkoutHiveService.addScheduledWorkout(workout);
    final now = DateTime.now();
    final weekEnd = now.add(const Duration(days: 7));
    final scheduledWorkouts = WorkoutHiveService.getScheduledWorkoutsInRange(odId, now, weekEnd);
    state = state.copyWith(scheduledWorkouts: scheduledWorkouts);
  }

  /// Delete scheduled workout
  Future<void> deleteScheduledWorkout(String id) async {
    await WorkoutHiveService.deleteScheduledWorkout(id);
    final now = DateTime.now();
    final weekEnd = now.add(const Duration(days: 7));
    final scheduledWorkouts = WorkoutHiveService.getScheduledWorkoutsInRange(odId, now, weekEnd);
    state = state.copyWith(scheduledWorkouts: scheduledWorkouts);
  }

  /// Mark scheduled workout as completed
  Future<void> markScheduledWorkoutCompleted(String id) async {
    await WorkoutHiveService.markScheduledWorkoutCompleted(id);
    final now = DateTime.now();
    final weekEnd = now.add(const Duration(days: 7));
    final scheduledWorkouts = WorkoutHiveService.getScheduledWorkoutsInRange(odId, now, weekEnd);
    state = state.copyWith(scheduledWorkouts: scheduledWorkouts);
  }

  /// Refresh data
  Future<void> refresh() async {
    state = state.copyWith(isLoading: true);

    try {
      final workouts = await WorkoutAwService.getAllWorkouts();
      if (workouts.isNotEmpty) {
        await WorkoutHiveService.cacheWorkouts(workouts);
      }

      final logs = WorkoutHiveService.getWorkoutLogs(odId);
      final customWorkouts = WorkoutHiveService.getCustomWorkouts(odId);
      final personalRecords = WorkoutHiveService.getPersonalRecords(odId);
      final now = DateTime.now();
      final weekEnd = now.add(const Duration(days: 7));
      final scheduledWorkouts = WorkoutHiveService.getScheduledWorkoutsInRange(odId, now, weekEnd);
      final weeklyStats = WorkoutHiveService.getWeeklyStats(odId);
      final streak = WorkoutHiveService.getStreak(odId);

      state = state.copyWith(
        workouts: workouts.isNotEmpty ? workouts : state.workouts,
        logs: logs,
        customWorkouts: customWorkouts,
        personalRecords: personalRecords,
        scheduledWorkouts: scheduledWorkouts,
        weeklyStats: weeklyStats,
        streak: streak,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }
}

/// Workout provider
final workoutProvider = StateNotifierProvider<WorkoutNotifier, WorkoutState>((ref) {
  return WorkoutNotifier();
});

/// Workouts by category
final workoutsByCategoryProvider = Provider.family<List<Workout>, String?>((ref, category) {
  final state = ref.watch(workoutProvider);
  if (category == null || category == 'all') {
    return state.workouts;
  }
  return state.workouts.where((w) => w.category == category).toList();
});

/// Workout by ID
final workoutByIdProvider = Provider.family<Workout?, String>((ref, id) {
  final state = ref.watch(workoutProvider);
  try {
    return state.workouts.firstWhere((w) => w.id == id);
  } catch (e) {
    return null;
  }
});

/// Today's workouts
final todaysWorkoutsProvider = Provider<List<WorkoutLog>>((ref) {
  final state = ref.watch(workoutProvider);
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  return state.logs.where((l) {
    final logDate = DateTime(l.startTime.year, l.startTime.month, l.startTime.day);
    return logDate == today;
  }).toList();
});

/// Weekly stats provider
final weeklyWorkoutStatsProvider = Provider<Map<String, dynamic>>((ref) {
  final state = ref.watch(workoutProvider);
  return state.weeklyStats;
});

/// Workout streak provider
final workoutStreakProvider = Provider<int>((ref) {
  final state = ref.watch(workoutProvider);
  return state.streak;
});

/// Active workout log provider
final activeWorkoutLogProvider = Provider<WorkoutLog?>((ref) {
  final state = ref.watch(workoutProvider);
  return state.activeWorkoutLog;
});

/// Custom workouts provider
final customWorkoutsProvider = Provider<List<CustomWorkout>>((ref) {
  final state = ref.watch(workoutProvider);
  return state.customWorkouts;
});

/// Personal records provider
final personalRecordsProvider = Provider<List<PersonalRecord>>((ref) {
  final state = ref.watch(workoutProvider);
  return state.personalRecords;
});

/// Scheduled workouts provider
final scheduledWorkoutsProvider = Provider<List<ScheduledWorkout>>((ref) {
  final state = ref.watch(workoutProvider);
  return state.scheduledWorkouts;
});
