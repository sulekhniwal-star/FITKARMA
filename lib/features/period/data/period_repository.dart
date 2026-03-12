import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../../core/constants/hive_boxes.dart';
import '../../../core/constants/api_endpoints.dart';
import '../../../core/network/sync_queue.dart';
import '../../../core/network/sync_queue_item.dart';
import '../../../core/security/encryption_service.dart';
import '../../../core/di/providers.dart';
import '../domain/period_log_model.dart';

class PeriodRepository {
  final SyncQueue _syncQueue;
  final EncryptionService _encryption;

  PeriodRepository(this._syncQueue, this._encryption);

  /// Log a new period start with AES-256 encryption
  Future<void> logPeriodStart(PeriodLog log, Uint8List encryptionKey) async {
    // 1. Open encrypted box
    final box = await _encryption.openEncryptedBox(
      HiveBoxes.periodLogs,
      encryptionKey,
    );

    // 2. Save locally (encrypted)
    await box.put(log.id, log.toMap());

    // 3. Only sync if user opted in
    if (log.syncEnabled) {
      final plainJson = json.encode(log.toMap());
      final queueItem = SyncQueueItem.create(
        collectionId: AW.periodLogs,
        operation: 'create',
        localId: log.id,
        payload: {'encrypted_data': base64Encode(utf8.encode(plainJson))},
      );
      await _syncQueue.addItem(queueItem);
    }
  }

  /// Update period end
  Future<void> logPeriodEnd(
    String logId,
    DateTime endDate,
    Uint8List encryptionKey,
  ) async {
    final box = await _encryption.openEncryptedBox(
      HiveBoxes.periodLogs,
      encryptionKey,
    );
    final data = box.get(logId);
    if (data != null) {
      final log = PeriodLog.fromMap(Map<String, dynamic>.from(data));
      final updated = log.copyWith(cycleEnd: endDate);
      await box.put(logId, updated.toMap());

      // Sync if enabled
      if (updated.syncEnabled) {
        final plainJson = json.encode(updated.toMap());
        final queueItem = SyncQueueItem.create(
          collectionId: AW.periodLogs,
          operation: 'update',
          localId: logId,
          payload: {'encrypted_data': base64Encode(utf8.encode(plainJson))},
        );
        await _syncQueue.addItem(queueItem);
      }
    }
  }

  /// Get period history from encrypted local storage
  Future<List<PeriodLog>> getHistory(Uint8List encryptionKey) async {
    final box = await _encryption.openEncryptedBox(
      HiveBoxes.periodLogs,
      encryptionKey,
    );
    final logs = box.values
        .map((data) => PeriodLog.fromMap(Map<String, dynamic>.from(data)))
        .toList();
    logs.sort((a, b) => b.cycleStart.compareTo(a.cycleStart));
    return logs;
  }

  /// Get current/last period
  Future<PeriodLog?> getCurrent(Uint8List encryptionKey) async {
    final logs = await getHistory(encryptionKey);
    return logs.isNotEmpty ? logs.first : null;
  }

  /// Calculate average cycle length from last 3 cycles
  Future<int?> getAverageCycleLength(Uint8List encryptionKey) async {
    final logs = await getHistory(encryptionKey);
    final completedCycles = logs.where((log) => log.cycleEnd != null).toList();

    if (completedCycles.length < 2) return null;

    // Get last 3 completed cycles
    final recent = completedCycles.take(3).toList();
    int totalDays = 0;

    for (int i = 0; i < recent.length - 1; i++) {
      final days = recent[i].cycleStart
          .difference(recent[i + 1].cycleStart)
          .inDays
          .abs();
      totalDays += days;
    }

    return totalDays ~/ (recent.length - 1);
  }

  /// Predict next period start date
  Future<DateTime?> predictNextPeriod(Uint8List encryptionKey) async {
    final avgCycle = await getAverageCycleLength(encryptionKey);
    if (avgCycle == null) return null;

    final current = await getCurrent(encryptionKey);
    if (current == null) return null;

    return current.cycleStart.add(Duration(days: avgCycle));
  }

  /// Get ovulation window (typically day 14 of cycle)
  Future<({DateTime start, DateTime end})?> getOvulationWindow(
    Uint8List encryptionKey,
  ) async {
    final current = await getCurrent(encryptionKey);
    if (current == null) return null;

    final ovulationDay = 14;
    final dayDiff = ovulationDay - current.currentDay;

    if (dayDiff < 0) return null; // Already passed ovulation

    final start = current.cycleStart.add(Duration(days: dayDiff));
    final end = start.add(const Duration(days: 2)); // 2-day window

    return (start: start, end: end);
  }

  /// Update sync preference
  Future<void> setSyncEnabled(
    String logId,
    bool enabled,
    Uint8List encryptionKey,
  ) async {
    final box = await _encryption.openEncryptedBox(
      HiveBoxes.periodLogs,
      encryptionKey,
    );
    final data = box.get(logId);
    if (data != null) {
      final log = PeriodLog.fromMap(Map<String, dynamic>.from(data));
      final updated = log.copyWith(syncEnabled: enabled);
      await box.put(logId, updated.toMap());
    }
  }

  /// Delete a period log
  Future<void> deleteLog(String logId, Uint8List encryptionKey) async {
    final box = await _encryption.openEncryptedBox(
      HiveBoxes.periodLogs,
      encryptionKey,
    );
    await box.delete(logId);
  }

  /// Check if cycle is irregular (PCOS/PCOD support)
  Future<bool> isIrregularCycle(Uint8List encryptionKey) async {
    final logs = await getHistory(encryptionKey);
    final completedCycles = logs
        .where((log) => log.cycleEnd != null)
        .take(6)
        .toList();

    if (completedCycles.length < 3) return false;

    // Check if cycle lengths vary significantly (> 7 days)
    final lengths = <int>[];
    for (int i = 0; i < completedCycles.length - 1; i++) {
      final days = completedCycles[i].cycleStart
          .difference(completedCycles[i + 1].cycleStart)
          .inDays
          .abs();
      lengths.add(days);
    }

    if (lengths.isEmpty) return false;

    final avg = lengths.reduce((a, b) => a + b) / lengths.length;
    final variance =
        lengths.map((l) => (l - avg).abs()).reduce((a, b) => a + b) /
        lengths.length;

    return variance > 7; // More than 7 days variation indicates irregular
  }
}

final periodRepositoryProvider = Provider<PeriodRepository>((ref) {
  final syncQueue = ref.watch(syncQueueProvider);
  return PeriodRepository(syncQueue, EncryptionService());
});
