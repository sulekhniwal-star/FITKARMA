import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../../core/constants/hive_boxes.dart';
import '../../../core/constants/api_endpoints.dart';
import '../../../core/network/sync_queue.dart';
import '../../../core/network/sync_queue_item.dart';
import '../../../core/di/providers.dart';
import '../domain/sleep_log_model.dart';

class SleepRepository {
  final SyncQueue _syncQueue;

  SleepRepository(this._syncQueue);

  /// Log a new sleep entry
  Future<void> logSleep(SleepLog log) async {
    // 1. Save locally to Hive
    final box = Hive.box(HiveBoxes.sleepLogs);
    await box.put(log.id, log.toMap());

    // 2. Queue for Appwrite sync
    final queueItem = SyncQueueItem.create(
      collectionId: AW.sleepLogs,
      operation: 'create',
      localId: log.id,
      payload: log.toMap(),
    );
    await _syncQueue.addItem(queueItem);
  }

  /// Get sleep history from local storage
  Future<List<SleepLog>> getHistory() async {
    final box = Hive.box(HiveBoxes.sleepLogs);
    final logs = box.values
        .map((data) => SleepLog.fromMap(Map<String, dynamic>.from(data)))
        .toList();
    logs.sort((a, b) => b.date.compareTo(a.date));
    return logs;
  }

  /// Get sleep for a specific date
  Future<SleepLog?> getForDate(DateTime date) async {
    final logs = await getHistory();
    final dateOnly = DateTime(date.year, date.month, date.day);
    try {
      return logs.firstWhere((log) {
        final logDate = DateTime(log.date.year, log.date.month, log.date.day);
        return logDate == dateOnly;
      });
    } catch (_) {
      return null;
    }
  }

  /// Get latest sleep log
  Future<SleepLog?> getLatest() async {
    final logs = await getHistory();
    return logs.isNotEmpty ? logs.first : null;
  }

  /// Get average sleep duration for last N days
  Future<double?> getAverageDuration(int days) async {
    final now = DateTime.now();
    final start = now.subtract(Duration(days: days));
    final logs = await getHistory();
    final filtered = logs
        .where((log) => log.date.isAfter(start) && log.date.isBefore(now))
        .toList();
    if (filtered.isEmpty) return null;
    final sum = filtered.fold<int>(0, (sum, log) => sum + log.durationMin);
    return sum / filtered.length;
  }

  /// Get average quality score for last N days
  Future<double?> getAverageQuality(int days) async {
    final now = DateTime.now();
    final start = now.subtract(Duration(days: days));
    final logs = await getHistory();
    final filtered = logs
        .where((log) => log.date.isAfter(start) && log.date.isBefore(now))
        .toList();
    if (filtered.isEmpty) return null;
    final sum = filtered.fold<int>(0, (sum, log) => sum + log.qualityScore);
    return sum / filtered.length;
  }

  /// Calculate total sleep debt over last 7 days
  Future<int> getSleepDebt7Days() async {
    final logs = await getHistory();
    final now = DateTime.now();
    final weekAgo = now.subtract(const Duration(days: 7));
    final recent = logs
        .where((log) => log.date.isAfter(weekAgo) && log.date.isBefore(now))
        .toList();

    int debt = 0;
    for (final log in recent) {
      debt += log.sleepDebtMin;
    }
    return debt;
  }

  /// Get weekly average vs recommended (7-9h)
  Future<Map<String, dynamic>> getWeeklyInsight() async {
    final avgDuration = await getAverageDuration(7);
    final avgQuality = await getAverageQuality(7);
    final debt = await getSleepDebt7Days();

    String recommendation;
    if (avgDuration == null) {
      recommendation = 'Start logging your sleep to get insights';
    } else if (avgDuration < 420) {
      recommendation =
          'Your sleep is below the recommended 7-9 hours. Try going to bed 30 minutes earlier.';
    } else if (avgDuration > 540) {
      recommendation =
          'You\'re getting more sleep than average. Quality matters more than quantity!';
    } else {
      recommendation = 'Great! Your sleep is in the healthy range.';
    }

    return {
      'avgDuration': avgDuration,
      'avgQuality': avgQuality,
      'sleepDebtMin': debt,
      'recommendation': recommendation,
    };
  }

  /// Mark as synced
  Future<void> markSynced(String logId) async {
    final box = Hive.box(HiveBoxes.sleepLogs);
    final data = box.get(logId);
    if (data != null) {
      final log = SleepLog.fromMap(Map<String, dynamic>.from(data));
      final updated = log.copyWith(syncStatus: 'synced');
      await box.put(logId, updated.toMap());
    }
  }

  /// Delete a log
  Future<void> deleteLog(String logId) async {
    final box = Hive.box(HiveBoxes.sleepLogs);
    await box.delete(logId);

    final queueItem = SyncQueueItem.create(
      collectionId: AW.sleepLogs,
      operation: 'delete',
      localId: logId,
      payload: {},
    );
    await _syncQueue.addItem(queueItem);
  }
}

final sleepRepositoryProvider = Provider<SleepRepository>((ref) {
  final syncQueue = ref.watch(syncQueueProvider);
  return SleepRepository(syncQueue);
});
