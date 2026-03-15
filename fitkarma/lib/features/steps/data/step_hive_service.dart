// lib/features/steps/data/step_hive_service.dart
import 'package:hive_flutter/hive_flutter.dart';
import '../../../core/constants/hive_boxes.dart';
import '../domain/step_log_model.dart';

/// Service for managing step logs in Hive local storage
class StepHiveService {
  static Box<StepLog>? _stepLogsBox;

  /// Initialize the step logs box
  static Future<void> init() async {
    if (!Hive.isAdapterRegistered(10)) {
      Hive.registerAdapter(StepLogAdapter());
    }
    _stepLogsBox = await Hive.openBox<StepLog>(HiveBoxes.stepLogs);
  }

  /// Get the step logs box
  static Box<StepLog> get box {
    if (_stepLogsBox == null) {
      throw StateError('StepHiveService not initialized. Call init() first.');
    }
    return _stepLogsBox!;
  }

  /// Save a step log entry
  static Future<void> saveStepLog(StepLog stepLog) async {
    await box.put(stepLog.id, stepLog);
  }

  /// Get step log for a specific date
  static StepLog? getStepLogForDate(DateTime date) {
    final key = _generateKey(date);
    return box.get(key);
  }

  /// Get today's step log
  static StepLog? getTodayStepLog() {
    return getStepLogForDate(DateTime.now());
  }

  /// Get step logs for a date range
  static List<StepLog> getStepLogsForRange(DateTime start, DateTime end) {
    final logs = <StepLog>[];
    var current = start;
    while (!current.isAfter(end)) {
      final log = getStepLogForDate(current);
      if (log != null) {
        logs.add(log);
      }
      current = current.add(const Duration(days: 1));
    }
    return logs;
  }

  /// Get step logs for the last N days
  static List<StepLog> getStepLogsForLastDays(int days) {
    final end = DateTime.now();
    final start = end.subtract(Duration(days: days - 1));
    return getStepLogsForRange(start, end);
  }

  /// Get step logs for the current week (last 7 days)
  static List<StepLog> getWeeklyStepLogs() {
    return getStepLogsForLastDays(7);
  }

  /// Calculate the 7-day rolling average steps
  static int calculate7DayAverage() {
    final logs = getStepLogsForLastDays(7);
    if (logs.isEmpty) return 0;

    final total = logs.fold<int>(0, (sum, log) => sum + log.stepCount);
    return (total / logs.length).round();
  }

  /// Update step count for today
  static Future<StepLog> updateTodaySteps({
    required String userId,
    required int stepCount,
    required int goalSteps,
    String source = 'health_connect',
  }) async {
    final today = DateTime.now();
    final existingLog = getStepLogForDate(today);

    if (existingLog != null) {
      final updatedLog = existingLog.copyWith(
        stepCount: stepCount,
        goalSteps: goalSteps,
        xpEarned: StepLog.calculateXP(stepCount),
        source: source,
        lastUpdated: DateTime.now(),
        syncStatus: 'pending',
      );
      await saveStepLog(updatedLog);
      return updatedLog;
    } else {
      final newLog = StepLog.create(
        userId: userId,
        stepCount: stepCount,
        date: today,
        goalSteps: goalSteps,
        source: source,
      );
      await saveStepLog(newLog);
      return newLog;
    }
  }

  /// Get pending sync logs
  static List<StepLog> getPendingSyncLogs() {
    return box.values.where((log) => log.syncStatus == 'pending').toList();
  }

  /// Mark logs as synced
  static Future<void> markAsSynced(List<String> ids) async {
    for (final id in ids) {
      final log = box.get(id);
      if (log != null) {
        await box.put(id, log.copyWith(syncStatus: 'synced'));
      }
    }
  }

  /// Generate key for a date
  static String _generateKey(DateTime date) {
    return '${date.year}_${date.month}_${date.day}';
  }

  /// Clear all step logs (for testing/reset)
  static Future<void> clearAll() async {
    await box.clear();
  }
}
