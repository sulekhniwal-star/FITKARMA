import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';
import '../../../core/constants/hive_boxes.dart';
import '../../../core/constants/api_endpoints.dart';
import '../../../core/network/sync_queue.dart';
import '../../../core/network/sync_queue_item.dart';
import '../../../core/di/providers.dart';
import '../domain/habit_model.dart';

class HabitsRepository {
  final SyncQueue _syncQueue;

  HabitsRepository(this._syncQueue);

  /// Get all habits for a user
  Future<List<Habit>> getHabits(String userId) async {
    final box = Hive.box(HiveBoxes.habits);
    final habits = box.values
        .map((data) => Habit.fromMap(Map<String, dynamic>.from(data)))
        .where((habit) => habit.userId == userId)
        .toList();

    // Sort by created date, presets first
    habits.sort((a, b) {
      if (a.isPreset && !b.isPreset) return -1;
      if (!a.isPreset && b.isPreset) return 1;
      return a.createdAt.compareTo(b.createdAt);
    });

    return habits;
  }

  /// Create a new habit
  Future<Habit> createHabit(Habit habit) async {
    final box = Hive.box(HiveBoxes.habits);
    final newHabit = habit.copyWith(
      id: const Uuid().v4(),
      createdAt: DateTime.now(),
    );

    await box.put(newHabit.id, newHabit.toMap());

    // Add to sync queue
    final queueItem = SyncQueueItem.create(
      collectionId: AW.habits,
      operation: 'create',
      localId: newHabit.id,
      payload: newHabit.toMap(),
    );
    await _syncQueue.addItem(queueItem);

    return newHabit;
  }

  /// Update a habit
  Future<void> updateHabit(Habit habit) async {
    final box = Hive.box(HiveBoxes.habits);
    await box.put(habit.id, habit.toMap());

    // Add to sync queue
    final queueItem = SyncQueueItem.create(
      collectionId: AW.habits,
      operation: 'update',
      localId: habit.id,
      payload: habit.toMap(),
    );
    await _syncQueue.addItem(queueItem);
  }

  /// Delete a habit
  Future<void> deleteHabit(String habitId) async {
    final box = Hive.box(HiveBoxes.habits);
    await box.delete(habitId);

    // Add to sync queue
    final queueItem = SyncQueueItem.create(
      collectionId: AW.habits,
      operation: 'delete',
      localId: habitId,
      payload: {},
    );
    await _syncQueue.addItem(queueItem);
  }

  /// Get habit completions for a specific date range
  Future<List<HabitCompletion>> getCompletions(
    String userId,
    DateTime startDate,
    DateTime endDate,
  ) async {
    final box = Hive.box('${HiveBoxes.habits}_completions');
    final completions = box.values
        .map((data) => HabitCompletion.fromMap(Map<String, dynamic>.from(data)))
        .where(
          (c) =>
              c.userId == userId &&
              c.date.isAfter(startDate.subtract(const Duration(days: 1))) &&
              c.date.isBefore(endDate.add(const Duration(days: 1))),
        )
        .toList();

    return completions;
  }

  /// Get today's completion for a habit
  Future<HabitCompletion?> getTodayCompletion(String habitId) async {
    final box = Hive.box('${HiveBoxes.habits}_completions');
    final today = DateTime.now().toIso8601String().split('T')[0];

    final completions = box.values
        .map((data) => HabitCompletion.fromMap(Map<String, dynamic>.from(data)))
        .where(
          (c) =>
              c.habitId == habitId &&
              c.date.toIso8601String().split('T')[0] == today,
        );

    return completions.isNotEmpty ? completions.first : null;
  }

  /// Log habit completion
  Future<HabitCompletion> logCompletion({
    required String habitId,
    required String userId,
    required int count,
    required Habit habit,
  }) async {
    final box = Hive.box('${HiveBoxes.habits}_completions');
    final today = DateTime.now();
    final todayStr = today.toIso8601String().split('T')[0];

    // Check if already completed today
    final existingKey = '${habitId}_$todayStr';
    final existing = box.get(existingKey);

    int newStreak = habit.currentStreak;
    int longestStreak = habit.longestStreak;

    if (existing != null) {
      final existingCompletion = HabitCompletion.fromMap(
        Map<String, dynamic>.from(existing),
      );
      final newCount = existingCompletion.completedCount + count;
      final isNowCompleted =
          newCount >= habit.targetCount && !existingCompletion.isCompleted;

      final updatedCompletion = HabitCompletion(
        id: existingCompletion.id,
        habitId: habitId,
        userId: userId,
        date: today,
        completedCount: newCount,
        isCompleted: newCount >= habit.targetCount,
        completedAt: isNowCompleted
            ? DateTime.now()
            : existingCompletion.completedAt,
      );

      await box.put(existingKey, updatedCompletion.toMap());

      // If just completed, update streak
      if (isNowCompleted) {
        newStreak = habit.currentStreak + 1;
        if (newStreak > longestStreak) {
          longestStreak = newStreak;
        }
      }

      return updatedCompletion;
    } else {
      // New completion for today
      final isCompleted = count >= habit.targetCount;

      final completion = HabitCompletion(
        id: const Uuid().v4(),
        habitId: habitId,
        userId: userId,
        date: today,
        completedCount: count,
        isCompleted: isCompleted,
        completedAt: isCompleted ? DateTime.now() : null,
      );

      await box.put(existingKey, completion.toMap());

      // If completed, update streak
      if (isCompleted) {
        newStreak = habit.currentStreak + 1;
        if (newStreak > longestStreak) {
          longestStreak = newStreak;
        }

        // Update habit streak
        final updatedHabit = habit.copyWith(
          currentStreak: newStreak,
          longestStreak: longestStreak,
        );
        await updateHabit(updatedHabit);
      }

      return completion;
    }
  }

  /// Get streak data for a habit
  Future<int> calculateCurrentStreak(String habitId) async {
    final box = Hive.box('${HiveBoxes.habits}_completions');

    int streak = 0;
    DateTime checkDate = DateTime.now();

    // Check up to 365 days back
    for (int i = 0; i < 365; i++) {
      final dateStr = checkDate.toIso8601String().split('T')[0];
      final key = '${habitId}_$dateStr';
      final data = box.get(key);

      if (data != null) {
        final completion = HabitCompletion.fromMap(
          Map<String, dynamic>.from(data),
        );
        if (completion.isCompleted) {
          streak++;
          checkDate = checkDate.subtract(const Duration(days: 1));
        } else {
          break;
        }
      } else {
        // If it's today and no entry, don't break yet
        if (i == 0) {
          checkDate = checkDate.subtract(const Duration(days: 1));
          continue;
        }
        break;
      }
    }

    return streak;
  }

  /// Get weekly completion data (for heatmap)
  Future<Map<DateTime, List<HabitCompletion>>> getWeeklyCompletions(
    String userId,
    DateTime weekStart,
  ) async {
    final completions = await getCompletions(
      userId,
      weekStart,
      weekStart.add(const Duration(days: 6)),
    );

    final Map<DateTime, List<HabitCompletion>> weeklyData = {};
    for (var completion in completions) {
      final dateKey = DateTime(
        completion.date.year,
        completion.date.month,
        completion.date.day,
      );
      weeklyData.putIfAbsent(dateKey, () => []).add(completion);
    }

    return weeklyData;
  }

  /// Initialize preset habits for a new user
  Future<void> initializePresetHabits(String userId) async {
    final existingHabits = await getHabits(userId);
    final hasPresets = existingHabits.any((h) => h.isPreset);

    if (!hasPresets) {
      for (var preset in Habit.presetHabits) {
        await createHabit(preset.copyWith(userId: userId));
      }
    }
  }
}

// Provider
final habitsRepositoryProvider = Provider<HabitsRepository>((ref) {
  final syncQueue = ref.watch(syncQueueProvider);
  return HabitsRepository(syncQueue);
});
