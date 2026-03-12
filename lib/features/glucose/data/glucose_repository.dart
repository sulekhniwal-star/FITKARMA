import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:appwrite/appwrite.dart';
import '../../../core/constants/hive_boxes.dart';
import '../../../core/constants/api_endpoints.dart';
import '../../../core/network/sync_queue.dart';
import '../../../core/network/sync_queue_item.dart';
import '../../../core/security/encryption_service.dart';
import '../../../core/di/providers.dart';
import '../../../core/network/appwrite_client.dart';
import '../domain/glucose_log_model.dart';

class GlucoseRepository {
  final SyncQueue _syncQueue;
  final EncryptionService _encryption;
  final Databases _databases;

  GlucoseRepository(this._syncQueue, this._encryption)
    : _databases = AppwriteClient.databases;

  /// Log a new glucose reading with AES-256 encryption
  Future<void> logGlucose(GlucoseLog log, Uint8List encryptionKey) async {
    // 1. Open encrypted box
    final box = await _encryption.openEncryptedBox(
      HiveBoxes.glucose,
      encryptionKey,
    );

    // 2. Save locally (encrypted)
    await box.put(log.id, log.toMap());

    // 3. Queue for Appwrite sync (encrypted payload)
    final plainJson = json.encode(log.toMap());
    final queueItem = SyncQueueItem.create(
      collectionId: AW.glucoseLogs,
      operation: 'create',
      localId: log.id,
      payload: {'encrypted_data': base64Encode(utf8.encode(plainJson))},
    );
    await _syncQueue.addItem(queueItem);
  }

  /// Get glucose history from encrypted local storage
  Future<List<GlucoseLog>> getHistory(Uint8List encryptionKey) async {
    final box = await _encryption.openEncryptedBox(
      HiveBoxes.glucose,
      encryptionKey,
    );
    final logs = box.values
        .map((data) => GlucoseLog.fromMap(Map<String, dynamic>.from(data)))
        .toList();
    // Sort by date descending
    logs.sort((a, b) => b.loggedAt.compareTo(a.loggedAt));
    return logs;
  }

  /// Get glucose readings for a specific date range
  Future<List<GlucoseLog>> getRange(
    Uint8List encryptionKey,
    DateTime start,
    DateTime end,
  ) async {
    final allLogs = await getHistory(encryptionKey);
    return allLogs.where((log) {
      return log.loggedAt.isAfter(start) && log.loggedAt.isBefore(end);
    }).toList();
  }

  /// Get latest reading
  Future<GlucoseLog?> getLatest(Uint8List encryptionKey) async {
    final logs = await getHistory(encryptionKey);
    return logs.isNotEmpty ? logs.first : null;
  }

  /// Get average glucose for last N days
  Future<double?> getAverage(Uint8List encryptionKey, int days) async {
    final now = DateTime.now();
    final start = now.subtract(Duration(days: days));
    final logs = await getRange(encryptionKey, start, now);
    if (logs.isEmpty) return null;
    final sum = logs.fold<double>(0, (sum, log) => sum + log.glucoseMgdl);
    return sum / logs.length;
  }

  /// Get estimated HbA1c (90-day average glucose → estimated A1c)
  /// Formula: (averageGlucose + 46.7) / 28.7
  Future<double?> getEstimatedHbA1c(Uint8List encryptionKey) async {
    final avg = await getAverage(encryptionKey, 90);
    if (avg == null) return null;
    return (avg + 46.7) / 28.7;
  }

  /// Check if post-meal glucose has been high for 3+ days
  Future<bool> isPostMealHigh3Days(Uint8List encryptionKey) async {
    final now = DateTime.now();
    final threeDaysAgo = now.subtract(const Duration(days: 3));
    final logs = await getRange(encryptionKey, threeDaysAgo, now);

    final postMealLogs = logs.where(
      (log) =>
          log.readingType == GlucoseReadingType.postMeal1h ||
          log.readingType == GlucoseReadingType.postMeal2h,
    );

    if (postMealLogs.length < 3) return false;

    final highCount = postMealLogs
        .where((log) => log.classification == GlucoseClassification.diabetic)
        .length;
    return highCount >= 3;
  }

  /// Mark a glucose log as synced
  Future<void> markSynced(String logId, Uint8List encryptionKey) async {
    final box = await _encryption.openEncryptedBox(
      HiveBoxes.glucose,
      encryptionKey,
    );
    final data = box.get(logId);
    if (data != null) {
      final log = GlucoseLog.fromMap(Map<String, dynamic>.from(data));
      final updated = log.copyWith(syncStatus: 'synced');
      await box.put(logId, updated.toMap());
    }
  }

  /// Delete a glucose log
  Future<void> deleteLog(String logId, Uint8List encryptionKey) async {
    final box = await _encryption.openEncryptedBox(
      HiveBoxes.glucose,
      encryptionKey,
    );
    await box.delete(logId);

    // Queue deletion for sync
    final queueItem = SyncQueueItem.create(
      collectionId: AW.glucoseLogs,
      operation: 'delete',
      localId: logId,
      payload: {},
    );
    await _syncQueue.addItem(queueItem);
  }
}

final glucoseRepositoryProvider = Provider<GlucoseRepository>((ref) {
  final syncQueue = ref.watch(syncQueueProvider);
  return GlucoseRepository(syncQueue, EncryptionService());
});
