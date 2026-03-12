import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../../core/constants/hive_boxes.dart';
import '../../../core/constants/api_endpoints.dart';
import '../../../core/network/sync_queue.dart';
import '../../../core/network/sync_queue_item.dart';
import '../../../core/di/providers.dart';
import '../domain/step_log_model.dart';

class StepRepository {
  final Box _box = Hive.box(HiveBoxes.stepLogs);
  final SyncQueue _syncQueue;

  StepRepository(this._syncQueue);

  Future<void> updateSteps(StepLog log) async {
    // 1. Write to Hive locally
    await _box.put(log.id, log.toAppwrite());

    // 2. Add to sync queue for Appwrite (update or create)
    final queueItem = SyncQueueItem.create(
      collectionId: AW.stepLogs,
      operation: 'update',
      localId: log.id,
      appwriteDocId: log.id,
      payload: log.toAppwrite(),
    );
    await _syncQueue.addItem(queueItem);
  }

  Future<StepLog?> getStepsForDate(DateTime date) async {
    final dateStr = DateTime(date.year, date.month, date.day).toIso8601String();
    final data = _box.get(dateStr);
    
    if (data != null) {
      return StepLog.fromAppwrite(_createMockDocument(Map<String, dynamic>.from(data)));
    }
    return null;
  }

  dynamic _createMockDocument(Map<String, dynamic> data) {
    return _MockDocument(data['\$id'] ?? '', data);
  }
}

class _MockDocument {
  final String $id;
  final Map<String, dynamic> data;
  final String $createdAt;
  final String $updatedAt;

  _MockDocument(this.$id, this.data) 
    : $createdAt = data['date'] ?? DateTime.now().toIso8601String(),
      $updatedAt = data['date'] ?? DateTime.now().toIso8601String();
}

final stepRepositoryProvider = Provider<StepRepository>((ref) {
  final syncQueue = ref.watch(syncQueueProvider);
  return StepRepository(syncQueue);
});
