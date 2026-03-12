import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../../core/constants/hive_boxes.dart';
import '../../../core/constants/api_endpoints.dart';
import '../../../core/network/sync_queue.dart';
import '../../../core/network/sync_queue_item.dart';
import '../../../core/di/providers.dart';
import '../domain/mood_log_model.dart';

class MoodRepository {
  final SyncQueue _syncQueue;

  MoodRepository(this._syncQueue);

  /// Log a new mood entry
  /// Voice notes are stored locally only - never synced to Appwrite
  Future<void> logMood(MoodLog log) async {
    // 1. Save locally to Hive (excluding voice note path for privacy)
    final box = Hive.box(HiveBoxes.moodLogs);
    await box.put(log.id, log.toMap());

    // 2. Queue for Appwrite sync (without voice note path)
    final syncData = Map<String, dynamic>.from(log.toMap());
    syncData.remove('voiceNotePath'); // Never upload voice notes

    final queueItem = SyncQueueItem.create(
      collectionId: AW.moodLogs,
      operation: 'create',
      localId: log.id,
      payload: syncData,
    );
    await _syncQueue.addItem(queueItem);
  }

  /// Get mood history from local storage
  Future<List<MoodLog>> getHistory() async {
    final box = Hive.box(HiveBoxes.moodLogs);
    final logs = box.values
        .map((data) => MoodLog.fromMap(Map<String, dynamic>.from(data)))
        .toList();
    logs.sort((a, b) => b.loggedAt.compareTo(a.loggedAt));
    return logs;
  }

  /// Get mood for a specific date
  Future<MoodLog?> getForDate(DateTime date) async {
    final logs = await getHistory();
    final dateOnly = DateTime(date.year, date.month, date.day);
    try {
      return logs.firstWhere((log) {
        final logDate = DateTime(
          log.loggedAt.year,
          log.loggedAt.month,
          log.loggedAt.day,
        );
        return logDate == dateOnly;
      });
    } catch (_) {
      return null;
    }
  }

  /// Get latest mood log
  Future<MoodLog?> getLatest() async {
    final logs = await getHistory();
    return logs.isNotEmpty ? logs.first : null;
  }

  /// Get average mood for last N days
  Future<double?> getAverageMood(int days) async {
    final now = DateTime.now();
    final start = now.subtract(Duration(days: days));
    final logs = await getHistory();
    final filtered = logs
        .where(
          (log) => log.loggedAt.isAfter(start) && log.loggedAt.isBefore(now),
        )
        .toList();
    if (filtered.isEmpty) return null;
    final sum = filtered.fold<int>(0, (sum, log) => sum + log.moodScore);
    return sum / filtered.length;
  }

  /// Get average energy for last N days
  Future<double?> getAverageEnergy(int days) async {
    final now = DateTime.now();
    final start = now.subtract(Duration(days: days));
    final logs = await getHistory();
    final filtered = logs
        .where(
          (log) => log.loggedAt.isAfter(start) && log.loggedAt.isBefore(now),
        )
        .toList();
    if (filtered.isEmpty) return null;
    final sum = filtered.fold<int>(0, (sum, log) => sum + log.energyLevel);
    return sum / filtered.length;
  }

  /// Get average stress for last N days
  Future<double?> getAverageStress(int days) async {
    final now = DateTime.now();
    final start = now.subtract(Duration(days: days));
    final logs = await getHistory();
    final filtered = logs
        .where(
          (log) => log.loggedAt.isAfter(start) && log.loggedAt.isBefore(now),
        )
        .toList();
    if (filtered.isEmpty) return null;
    final sum = filtered.fold<int>(0, (sum, log) => sum + log.stressLevel);
    return sum / filtered.length;
  }

  /// Check for burnout indicators (7+ days of low mood + low energy + high stress)
  Future<bool> isBurnoutDetected() async {
    final now = DateTime.now();
    final weekAgo = now.subtract(const Duration(days: 7));
    final logs = await getHistory();
    final recent = logs
        .where(
          (log) => log.loggedAt.isAfter(weekAgo) && log.loggedAt.isBefore(now),
        )
        .toList();

    if (recent.length < 7) return false;

    final burnoutCount = recent.where((log) => log.indicatesBurnout).length;
    return burnoutCount >= 7;
  }

  /// Get mood heatmap data for calendar view
  Future<Map<DateTime, int>> getMoodHeatmap(int days) async {
    final now = DateTime.now();
    final start = now.subtract(Duration(days: days));
    final logs = await getHistory();
    final Map<DateTime, int> heatmap = {};

    for (final log in logs) {
      if (log.loggedAt.isAfter(start)) {
        final dateOnly = DateTime(
          log.loggedAt.year,
          log.loggedAt.month,
          log.loggedAt.day,
        );
        heatmap[dateOnly] = log.moodScore;
      }
    }
    return heatmap;
  }

  /// Get most common tags
  Future<List<String>> getTopTags(int days) async {
    final now = DateTime.now();
    final start = now.subtract(Duration(days: days));
    final logs = await getHistory();
    final filtered = logs
        .where(
          (log) => log.loggedAt.isAfter(start) && log.loggedAt.isBefore(now),
        )
        .toList();

    final tagCounts = <String, int>{};
    for (final log in filtered) {
      for (final tag in log.tags) {
        tagCounts[tag] = (tagCounts[tag] ?? 0) + 1;
      }
    }

    final sortedTags = tagCounts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    return sortedTags.take(5).map((e) => e.key).toList();
  }

  /// Mark as synced
  Future<void> markSynced(String logId) async {
    final box = Hive.box(HiveBoxes.moodLogs);
    final data = box.get(logId);
    if (data != null) {
      final log = MoodLog.fromMap(Map<String, dynamic>.from(data));
      final updated = log.copyWith(syncStatus: 'synced');
      await box.put(logId, updated.toMap());
    }
  }

  /// Delete a log
  Future<void> deleteLog(String logId) async {
    final box = Hive.box(HiveBoxes.moodLogs);
    await box.delete(logId);

    final queueItem = SyncQueueItem.create(
      collectionId: AW.moodLogs,
      operation: 'delete',
      localId: logId,
      payload: {},
    );
    await _syncQueue.addItem(queueItem);
  }
}

final moodRepositoryProvider = Provider<MoodRepository>((ref) {
  final syncQueue = ref.watch(syncQueueProvider);
  return MoodRepository(syncQueue);
});
