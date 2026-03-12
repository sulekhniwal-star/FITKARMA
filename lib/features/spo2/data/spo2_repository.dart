import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../../core/constants/hive_boxes.dart';
import '../../../core/constants/api_endpoints.dart';
import '../../../core/network/sync_queue.dart';
import '../../../core/network/sync_queue_item.dart';
import '../../../core/di/providers.dart';
import '../domain/spo2_log_model.dart';

class SpO2Repository {
  final SyncQueue _syncQueue;

  SpO2Repository(this._syncQueue);

  /// Log a new SpO2 reading
  Future<void> logSpO2(SpO2Log log) async {
    // 1. Save locally to Hive
    final box = Hive.box(HiveBoxes.spo2);
    await box.put(log.id, log.toMap());

    // 2. Queue for Appwrite sync
    final queueItem = SyncQueueItem.create(
      collectionId: AW.spo2Logs,
      operation: 'create',
      localId: log.id,
      payload: log.toMap(),
    );
    await _syncQueue.addItem(queueItem);
  }

  /// Get SpO2 history from local storage
  Future<List<SpO2Log>> getHistory() async {
    final box = Hive.box(HiveBoxes.spo2);
    final logs = box.values
        .map((data) => SpO2Log.fromMap(Map<String, dynamic>.from(data)))
        .toList();
    logs.sort((a, b) => b.loggedAt.compareTo(a.loggedAt));
    return logs;
  }

  /// Get latest reading
  Future<SpO2Log?> getLatest() async {
    final logs = await getHistory();
    return logs.isNotEmpty ? logs.first : null;
  }

  /// Get average SpO2 for last N days
  Future<double?> getAverage(int days) async {
    final now = DateTime.now();
    final start = now.subtract(Duration(days: days));
    final logs = await getHistory();
    final filtered = logs
        .where(
          (log) => log.loggedAt.isAfter(start) && log.loggedAt.isBefore(now),
        )
        .toList();
    if (filtered.isEmpty) return null;
    final sum = filtered.fold<double>(0, (sum, log) => sum + log.spo2Pct);
    return sum / filtered.length;
  }

  /// Check if SpO2 has been low recently
  Future<bool> isLowRecently() async {
    final now = DateTime.now();
    final weekAgo = now.subtract(const Duration(days: 7));
    final logs = await getHistory();
    final recent = logs
        .where(
          (log) => log.loggedAt.isAfter(weekAgo) && log.loggedAt.isBefore(now),
        )
        .toList();
    if (recent.isEmpty) return false;
    final lowCount = recent.where((log) => log.isLow).length;
    return lowCount > 0;
  }

  /// Mark as synced
  Future<void> markSynced(String logId) async {
    final box = Hive.box(HiveBoxes.spo2);
    final data = box.get(logId);
    if (data != null) {
      final log = SpO2Log.fromMap(Map<String, dynamic>.from(data));
      final updated = log.copyWith(syncStatus: 'synced');
      await box.put(logId, updated.toMap());
    }
  }

  /// Delete a log
  Future<void> deleteLog(String logId) async {
    final box = Hive.box(HiveBoxes.spo2);
    await box.delete(logId);

    final queueItem = SyncQueueItem.create(
      collectionId: AW.spo2Logs,
      operation: 'delete',
      localId: logId,
      payload: {},
    );
    await _syncQueue.addItem(queueItem);
  }
}

final spo2RepositoryProvider = Provider<SpO2Repository>((ref) {
  final syncQueue = ref.watch(syncQueueProvider);
  return SpO2Repository(syncQueue);
});
