import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:appwrite/appwrite.dart';
import '../../../core/constants/hive_boxes.dart';
import '../../../core/constants/api_endpoints.dart';
import '../../../core/network/sync_queue.dart';
import '../../../core/network/sync_queue_item.dart';
import '../../../core/di/providers.dart';
import '../domain/workout_log_model.dart';

class WorkoutRepository {
  final Box _box = Hive.box(HiveBoxes.workoutLogs);
  final SyncQueue _syncQueue;
  final Databases _databases;

  WorkoutRepository(this._syncQueue, this._databases);

  Future<void> logWorkout(WorkoutLog log) async {
    // 1. Write to Hive locally
    await _box.put(log.id, log.toAppwrite());

    // 2. Add to sync queue for Appwrite
    final queueItem = SyncQueueItem.create(
      collectionId: AW.workoutLogs,
      operation: 'create',
      localId: log.id,
      payload: log.toAppwrite(),
    );
    await _syncQueue.addItem(queueItem);
  }

  Future<List<WorkoutLog>> getWorkoutLogs() async {
    await _refreshFromServer();
    
    return _box.values.map((data) {
      return WorkoutLog.fromAppwrite(
        _createMockDocument(data as Map<String, dynamic>),
      );
    }).toList();
  }

  dynamic _createMockDocument(Map<String, dynamic> data) {
    return _MockDocument(data['\$id'] ?? '', data);
  }

  Future<void> _refreshFromServer() async {
    try {
      await _databases.listDocuments(
        databaseId: AW.dbId,
        collectionId: AW.workoutLogs,
        queries: [Query.limit(1)],
      );
    } catch (_) {}
  }
}

class _MockDocument {
  final String $id;
  final Map<String, dynamic> data;
  final String $createdAt;
  final String $updatedAt;

  _MockDocument(this.$id, this.data) 
    : $createdAt = data['completed_at'] ?? DateTime.now().toIso8601String(),
      $updatedAt = data['completed_at'] ?? DateTime.now().toIso8601String();
}

final workoutRepositoryProvider = Provider<WorkoutRepository>((ref) {
  final syncQueue = ref.watch(syncQueueProvider);
  final databases = ref.watch(appwriteDatabaseProvider);
  return WorkoutRepository(syncQueue, databases);
});
