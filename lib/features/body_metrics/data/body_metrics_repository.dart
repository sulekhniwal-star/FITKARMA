import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../../core/constants/hive_boxes.dart';
import '../../../core/constants/api_endpoints.dart';
import '../../../core/network/sync_queue.dart';
import '../../../core/network/sync_queue_item.dart';
import '../../../core/di/providers.dart';
import '../domain/body_measurement_model.dart';

class BodyMetricsRepository {
  final SyncQueue _syncQueue;

  BodyMetricsRepository(this._syncQueue);

  /// Add a new body measurement
  Future<void> addMeasurement(BodyMeasurement measurement) async {
    final box = Hive.box(HiveBoxes.bodyMetrics);
    await box.put(measurement.id, measurement.toMap());

    final queueItem = SyncQueueItem.create(
      collectionId: AW.bodyMeasurements,
      operation: 'create',
      localId: measurement.id,
      payload: measurement.toMap(),
    );
    await _syncQueue.addItem(queueItem);
  }

  /// Get all measurements
  Future<List<BodyMeasurement>> getAll() async {
    final box = Hive.box(HiveBoxes.bodyMetrics);
    final measurements = box.values
        .map((data) => BodyMeasurement.fromMap(Map<String, dynamic>.from(data)))
        .toList();
    measurements.sort((a, b) => b.date.compareTo(a.date));
    return measurements;
  }

  /// Get latest measurement
  Future<BodyMeasurement?> getLatest() async {
    final all = await getAll();
    return all.isNotEmpty ? all.first : null;
  }

  /// Get measurement by ID
  Future<BodyMeasurement?> getById(String id) async {
    final box = Hive.box(HiveBoxes.bodyMetrics);
    final data = box.get(id);
    if (data == null) return null;
    return BodyMeasurement.fromMap(Map<String, dynamic>.from(data));
  }

  /// Update a measurement
  Future<void> updateMeasurement(BodyMeasurement measurement) async {
    final box = Hive.box(HiveBoxes.bodyMetrics);
    await box.put(measurement.id, measurement.toMap());

    final queueItem = SyncQueueItem.create(
      collectionId: AW.bodyMeasurements,
      operation: 'update',
      localId: measurement.id,
      payload: measurement.toMap(),
    );
    await _syncQueue.addItem(queueItem);
  }

  /// Delete a measurement
  Future<void> deleteMeasurement(String id) async {
    final box = Hive.box(HiveBoxes.bodyMetrics);
    await box.delete(id);

    final queueItem = SyncQueueItem.create(
      collectionId: AW.bodyMeasurements,
      operation: 'delete',
      localId: id,
      payload: {},
    );
    await _syncQueue.addItem(queueItem);
  }

  /// Get measurements for a date range
  Future<List<BodyMeasurement>> getByDateRange(
    DateTime start,
    DateTime end,
  ) async {
    final all = await getAll();
    return all
        .where(
          (m) =>
              m.date.isAfter(start.subtract(const Duration(days: 1))) &&
              m.date.isBefore(end.add(const Duration(days: 1))),
        )
        .toList();
  }

  /// Get measurements for the last N days
  Future<List<BodyMeasurement>> getLastNDays(int days) async {
    final end = DateTime.now();
    final start = end.subtract(Duration(days: days));
    return getByDateRange(start, end);
  }

  /// Get weight trend data for charts
  Future<List<Map<String, dynamic>>> getWeightTrend(int days) async {
    final measurements = await getLastNDays(days);
    return measurements
        .where((m) => m.weightKg != null)
        .map((m) => {'date': m.date, 'value': m.weightKg, 'bmi': m.bmi})
        .toList();
  }

  /// Get measurement changes (difference from previous)
  Future<Map<String, double>?> getChangesFromPrevious(
    BodyMeasurement current,
  ) async {
    final all = await getAll();
    final previousMeasurements = all
        .where((m) => m.date.isBefore(current.date))
        .toList();

    if (previousMeasurements.isEmpty) return null;

    final previous = previousMeasurements.first;

    return {
      'weightKg': (current.weightKg ?? 0) - (previous.weightKg ?? 0),
      'waistCm': (current.waistCm ?? 0) - (previous.waistCm ?? 0),
      'hipsCm': (current.hipsCm ?? 0) - (previous.hipsCm ?? 0),
      'armsCm': (current.armsCm ?? 0) - (previous.armsCm ?? 0),
      'thighsCm': (current.thighsCm ?? 0) - (previous.thighsCm ?? 0),
      'chestCm': (current.chestCm ?? 0) - (previous.chestCm ?? 0),
    };
  }

  /// Mark as synced
  Future<void> markSynced(String id) async {
    final box = Hive.box(HiveBoxes.bodyMetrics);
    final data = box.get(id);
    if (data != null) {
      final measurement = BodyMeasurement.fromMap(
        Map<String, dynamic>.from(data),
      );
      final updated = measurement.copyWith(syncStatus: 'synced');
      await box.put(id, updated.toMap());
    }
  }
}

final bodyMetricsRepositoryProvider = Provider<BodyMetricsRepository>((ref) {
  final syncQueue = ref.watch(syncQueueProvider);
  return BodyMetricsRepository(syncQueue);
});
