// lib/features/workout/data/workout_hive_service.dart
import 'package:hive_flutter/hive_flutter.dart';
import '../../../core/constants/hive_boxes.dart';
import '../domain/workout_model.dart';

/// Service for managing workout data in Hive local storage
class WorkoutHiveService {
  static Box<Workout>? _workoutsBox;
  static Box<WorkoutLog>? _workoutLogsBox;
  static Box<CustomWorkout>? _customWorkoutsBox;
  static Box<PersonalRecord>? _personalRecordsBox;
  static Box<ScheduledWorkout>? _scheduledWorkoutsBox;

  /// Initialize workout boxes
  static Future<void> init() async {
    if (!Hive.isAdapterRegistered(30)) {
      Hive.registerAdapter(WorkoutAdapter());
    }
    if (!Hive.isAdapterRegistered(31)) {
      Hive.registerAdapter(WorkoutExerciseAdapter());
    }
    if (!Hive.isAdapterRegistered(32)) {
      Hive.registerAdapter(CustomWorkoutAdapter());
    }
    if (!Hive.isAdapterRegistered(33)) {
      Hive.registerAdapter(WorkoutLogAdapter());
    }
    if (!Hive.isAdapterRegistered(34)) {
      Hive.registerAdapter(PersonalRecordAdapter());
    }
    if (!Hive.isAdapterRegistered(35)) {
      Hive.registerAdapter(ScheduledWorkoutAdapter());
    }

    _workoutsBox = await Hive.openBox<Workout>('workouts_cache');
    _workoutLogsBox = await Hive.openBox<WorkoutLog>(HiveBoxes.workoutLogs);
    _customWorkoutsBox = await Hive.openBox<CustomWorkout>('custom_workouts');
    _personalRecordsBox = await Hive.openBox<PersonalRecord>(
      HiveBoxes.personalRecords,
    );
    _scheduledWorkoutsBox = await Hive.openBox<ScheduledWorkout>(
      'scheduled_workouts',
    );
  }

  // ============ Workouts Cache ============

  /// Get workouts box
  static Box<Workout> get workoutsBox {
    if (_workoutsBox == null) {
      throw StateError(
        'WorkoutHiveService not initialized. Call init() first.',
      );
    }
    return _workoutsBox!;
  }

  /// Cache workouts locally
  static Future<void> cacheWorkouts(List<Workout> workouts) async {
    await workoutsBox.clear();
    for (final workout in workouts) {
      await workoutsBox.put(workout.id, workout);
    }
  }

  /// Get cached workouts
  static List<Workout> getCachedWorkouts() {
    return workoutsBox.values.toList();
  }

  /// Get cached workouts by category
  static List<Workout> getCachedWorkoutsByCategory(String category) {
    return workoutsBox.values.where((w) => w.category == category).toList();
  }

  /// Get cached workout by ID
  static Workout? getCachedWorkout(String id) {
    return workoutsBox.get(id);
  }

  // ============ Workout Logs ============

  /// Get workout logs box
  static Box<WorkoutLog> get workoutLogsBox {
    if (_workoutLogsBox == null) {
      throw StateError(
        'WorkoutHiveService not initialized. Call init() first.',
      );
    }
    return _workoutLogsBox!;
  }

  /// Add workout log
  static Future<void> addWorkoutLog(WorkoutLog log) async {
    await workoutLogsBox.put(log.id, log);
  }

  /// Get workout logs for user
  static List<WorkoutLog> getWorkoutLogs(String odId) {
    return workoutLogsBox.values.where((l) => l.odId == odId).toList()
      ..sort((a, b) => b.startTime.compareTo(a.startTime));
  }

  /// Get pending sync workout logs
  static List<WorkoutLog> getPendingSyncLogs() {
    return workoutLogsBox.values
        .where((l) => l.syncStatus == 'pending')
        .toList();
  }

  /// Mark workout log as synced
  static Future<void> markLogAsSynced(String id) async {
    final log = workoutLogsBox.get(id);
    if (log != null) {
      final syncedLog = WorkoutLog(
        id: log.id,
        odId: log.odId,
        workoutId: log.workoutId,
        workoutTitle: log.workoutTitle,
        startTime: log.startTime,
        endTime: log.endTime,
        durationMinutes: log.durationMinutes,
        caloriesBurned: log.caloriesBurned,
        notes: log.notes,
        syncStatus: 'synced',
        category: log.category,
        difficulty: log.difficulty,
        distanceKm: log.distanceKm,
      );
      await workoutLogsBox.put(id, syncedLog);
    }
  }

  /// Get today's workout logs
  static List<WorkoutLog> getTodaysWorkouts(String odId) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    return workoutLogsBox.values.where((l) => l.odId == odId).where((l) {
      final logDate = DateTime(
        l.startTime.year,
        l.startTime.month,
        l.startTime.day,
      );
      return logDate == today;
    }).toList();
  }

  /// Get workout count for date range
  static int getWorkoutCount(String odId, DateTime start, DateTime end) {
    return workoutLogsBox.values
        .where((l) => l.odId == odId)
        .where((l) => l.startTime.isAfter(start) && l.startTime.isBefore(end))
        .length;
  }

  // ============ Custom Workouts ============

  /// Get custom workouts box
  static Box<CustomWorkout> get customWorkoutsBox {
    if (_customWorkoutsBox == null) {
      throw StateError(
        'WorkoutHiveService not initialized. Call init() first.',
      );
    }
    return _customWorkoutsBox!;
  }

  /// Add custom workout
  static Future<void> addCustomWorkout(CustomWorkout workout) async {
    await customWorkoutsBox.put(workout.id, workout);
  }

  /// Get all custom workouts
  static List<CustomWorkout> getCustomWorkouts(String odId) {
    return customWorkoutsBox.values.where((w) => w.id.startsWith(odId)).toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  /// Get custom workout by ID
  static CustomWorkout? getCustomWorkout(String id) {
    return customWorkoutsBox.get(id);
  }

  /// Delete custom workout
  static Future<void> deleteCustomWorkout(String id) async {
    await customWorkoutsBox.delete(id);
  }

  /// Update custom workout
  static Future<void> updateCustomWorkout(CustomWorkout workout) async {
    await customWorkoutsBox.put(workout.id, workout);
  }

  // ============ Personal Records ============

  /// Get personal records box
  static Box<PersonalRecord> get personalRecordsBox {
    if (_personalRecordsBox == null) {
      throw StateError(
        'WorkoutHiveService not initialized. Call init() first.',
      );
    }
    return _personalRecordsBox!;
  }

  /// Add personal record
  static Future<void> addPersonalRecord(PersonalRecord record) async {
    await personalRecordsBox.put(record.id, record);
  }

  /// Get personal records for user
  static List<PersonalRecord> getPersonalRecords(String odId) {
    return personalRecordsBox.values.where((r) => r.odId == odId).toList()
      ..sort((a, b) => b.achievedAt.compareTo(a.achievedAt));
  }

  /// Get personal record for exercise
  static PersonalRecord? getPersonalRecord(String odId, String exerciseName) {
    try {
      return personalRecordsBox.values.firstWhere(
        (r) => r.odId == odId && r.exerciseName == exerciseName,
      );
    } catch (e) {
      return null;
    }
  }

  /// Check and update personal record
  /// Returns true if new record was set
  static Future<bool> checkAndUpdateRecord({
    required String odId,
    required String exerciseName,
    double? weight,
    int? reps,
    int? duration,
    String? workoutLogId,
  }) async {
    final existingRecord = getPersonalRecord(odId, exerciseName);
    bool isNewRecord = false;

    if (existingRecord == null) {
      // First record for this exercise
      final record = PersonalRecord.create(
        odId: odId,
        exerciseName: exerciseName,
        maxWeight: weight ?? 0,
        maxReps: reps ?? 0,
        maxDuration: duration ?? 0,
        workoutLogId: workoutLogId,
      );
      await addPersonalRecord(record);
      isNewRecord = true;
    } else {
      // Check if new record
      bool updated = false;
      double newWeight = existingRecord.maxWeight;
      int newReps = existingRecord.maxReps;
      int newDuration = existingRecord.maxDuration;

      if (weight != null && weight > existingRecord.maxWeight) {
        newWeight = weight;
        updated = true;
      }
      if (reps != null && reps > existingRecord.maxReps) {
        newReps = reps;
        updated = true;
      }
      if (duration != null && duration > existingRecord.maxDuration) {
        newDuration = duration;
        updated = true;
      }

      if (updated) {
        final newRecord = PersonalRecord(
          id: existingRecord.id,
          odId: odId,
          exerciseName: exerciseName,
          maxWeight: newWeight,
          maxReps: newReps,
          maxDuration: newDuration,
          achievedAt: DateTime.now(),
          workoutLogId: workoutLogId,
          recordType: existingRecord.recordType,
        );
        await addPersonalRecord(newRecord);
        isNewRecord = true;
      }
    }

    return isNewRecord;
  }

  // ============ Scheduled Workouts ============

  /// Get scheduled workouts box
  static Box<ScheduledWorkout> get scheduledWorkoutsBox {
    if (_scheduledWorkoutsBox == null) {
      throw StateError(
        'WorkoutHiveService not initialized. Call init() first.',
      );
    }
    return _scheduledWorkoutsBox!;
  }

  /// Add scheduled workout
  static Future<void> addScheduledWorkout(ScheduledWorkout workout) async {
    await scheduledWorkoutsBox.put(workout.id, workout);
  }

  /// Get scheduled workouts for user
  static List<ScheduledWorkout> getScheduledWorkouts(String odId) {
    return scheduledWorkoutsBox.values.where((w) => w.odId == odId).toList()
      ..sort((a, b) => a.scheduledDate.compareTo(b.scheduledDate));
  }

  /// Get scheduled workouts for date range
  static List<ScheduledWorkout> getScheduledWorkoutsInRange(
    String odId,
    DateTime start,
    DateTime end,
  ) {
    return scheduledWorkoutsBox.values.where((w) => w.odId == odId).where((w) {
      return w.scheduledDate.isAfter(start.subtract(const Duration(days: 1))) &&
          w.scheduledDate.isBefore(end.add(const Duration(days: 1)));
    }).toList()..sort((a, b) => a.scheduledDate.compareTo(b.scheduledDate));
  }

  /// Get scheduled workout for specific date
  static ScheduledWorkout? getScheduledWorkoutForDate(
    String odId,
    DateTime date,
  ) {
    final dateOnly = DateTime(date.year, date.month, date.day);
    try {
      return scheduledWorkoutsBox.values.firstWhere((w) {
        final scheduled = DateTime(
          w.scheduledDate.year,
          w.scheduledDate.month,
          w.scheduledDate.day,
        );
        return w.odId == odId && scheduled == dateOnly;
      });
    } catch (e) {
      return null;
    }
  }

  /// Delete scheduled workout
  static Future<void> deleteScheduledWorkout(String id) async {
    await scheduledWorkoutsBox.delete(id);
  }

  /// Mark scheduled workout as completed
  static Future<void> markScheduledWorkoutCompleted(String id) async {
    final workout = scheduledWorkoutsBox.get(id);
    if (workout != null) {
      workout.markCompleted();
      await scheduledWorkoutsBox.put(id, workout);
    }
  }

  // ============ Stats ============

  /// Get weekly workout stats
  static Map<String, dynamic> getWeeklyStats(String odId) {
    final now = DateTime.now();
    final weekAgo = now.subtract(const Duration(days: 7));

    final logs = workoutLogsBox.values
        .where((l) => l.odId == odId)
        .where((l) => l.startTime.isAfter(weekAgo))
        .toList();

    int totalDuration = 0;
    int totalCalories = 0;

    for (final log in logs) {
      totalDuration += log.durationMinutes;
      totalCalories += log.caloriesBurned;
    }

    return {
      'total_duration': totalDuration,
      'total_calories': totalCalories,
      'workout_count': logs.length,
    };
  }

  /// Get streak (consecutive days with workouts)
  static int getStreak(String odId) {
    final logs = getWorkoutLogs(odId);
    if (logs.isEmpty) return 0;

    int streak = 0;
    DateTime? lastWorkoutDate;

    // Sort by date descending
    final sortedLogs = logs.toList()
      ..sort((a, b) => b.startTime.compareTo(a.startTime));

    for (final log in sortedLogs) {
      final logDate = DateTime(
        log.startTime.year,
        log.startTime.month,
        log.startTime.day,
      );

      if (lastWorkoutDate == null) {
        final today = DateTime.now();
        final todayDate = DateTime(today.year, today.month, today.day);
        final diff = todayDate.difference(logDate).inDays;

        if (diff > 1) {
          // Streak is broken
          return 0;
        }
        streak = 1;
        lastWorkoutDate = logDate;
      } else {
        final diff = lastWorkoutDate.difference(logDate).inDays;
        if (diff == 1) {
          streak++;
          lastWorkoutDate = logDate;
        } else if (diff > 1) {
          // Streak broken
          break;
        }
      }
    }

    return streak;
  }

  /// Clear all workout data (for testing/reset)
  static Future<void> clearAll() async {
    await _workoutsBox?.clear();
    await _workoutLogsBox?.clear();
    await _customWorkoutsBox?.clear();
    await _personalRecordsBox?.clear();
    await _scheduledWorkoutsBox?.clear();
  }
}
