import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';
import '../../../core/constants/hive_boxes.dart';
import '../../../core/constants/api_endpoints.dart';
import '../../../core/network/sync_queue.dart';
import '../../../core/network/sync_queue_item.dart';
import '../../../core/di/providers.dart';
import '../domain/fasting_model.dart';

class FastingRepository {
  final SyncQueue _syncQueue;

  FastingRepository(this._syncQueue);

  /// Get current active fasting session
  Future<FastingSession?> getActiveSession(String userId) async {
    final box = Hive.box(HiveBoxes.fasting);
    final sessions = box.values
        .map((data) => FastingSession.fromMap(Map<String, dynamic>.from(data)))
        .where((s) => s.userId == userId && !s.completed)
        .toList();

    if (sessions.isEmpty) return null;

    // Return the most recent incomplete session
    sessions.sort((a, b) => b.fastStart.compareTo(a.fastStart));
    return sessions.first;
  }

  /// Start a new fasting session
  Future<FastingSession> startFast({
    required String userId,
    required FastingProtocol protocol,
    required String eatingWindowStart,
    required String eatingWindowEnd,
  }) async {
    final box = Hive.box(HiveBoxes.fasting);

    // End any active sessions first
    final activeSession = await getActiveSession(userId);
    if (activeSession != null) {
      await endFast(userId, activeSession.id);
    }

    final session = FastingSession(
      id: const Uuid().v4(),
      userId: userId,
      protocol: protocol,
      fastStart: DateTime.now(),
      eatingWindowStart: eatingWindowStart,
      eatingWindowEnd: eatingWindowEnd,
      createdAt: DateTime.now(),
    );

    await box.put(session.id, session.toMap());

    // Add to sync queue
    final queueItem = SyncQueueItem.create(
      collectionId: AW.fastingLogs,
      operation: 'create',
      localId: session.id,
      payload: session.toMap(),
    );
    await _syncQueue.addItem(queueItem);

    return session;
  }

  /// End a fasting session
  Future<FastingSession?> endFast(String userId, String sessionId) async {
    final box = Hive.box(HiveBoxes.fasting);
    final data = box.get(sessionId);

    if (data == null) return null;

    final session = FastingSession.fromMap(Map<String, dynamic>.from(data));
    final completedSession = session.copyWith(
      fastEnd: DateTime.now(),
      completed: true,
      syncStatus: 'pending',
    );

    await box.put(sessionId, completedSession.toMap());

    // Add to sync queue
    final queueItem = SyncQueueItem.create(
      collectionId: AW.fastingLogs,
      operation: 'update',
      localId: sessionId,
      payload: completedSession.toMap(),
    );
    await _syncQueue.addItem(queueItem);

    return completedSession;
  }

  /// Get fasting history
  Future<List<FastingSession>> getHistory(
    String userId, {
    int limit = 30,
  }) async {
    final box = Hive.box(HiveBoxes.fasting);
    final sessions = box.values
        .map((data) => FastingSession.fromMap(Map<String, dynamic>.from(data)))
        .where((s) => s.userId == userId && s.completed)
        .toList();

    sessions.sort((a, b) => b.fastStart.compareTo(a.fastStart));
    return sessions.take(limit).toList();
  }

  /// Calculate streak of consecutive completed fasts
  Future<int> calculateStreak(String userId) async {
    final history = await getHistory(userId, limit: 90);
    if (history.isEmpty) return 0;

    int streak = 0;
    DateTime checkDate = DateTime.now();

    for (var session in history) {
      final sessionDate = DateTime(
        session.fastStart.year,
        session.fastStart.month,
        session.fastStart.day,
      );
      final checkDateOnly = DateTime(
        checkDate.year,
        checkDate.month,
        checkDate.day,
      );

      // Check if this session is on the expected date
      final expectedDate = checkDateOnly.subtract(Duration(days: streak));

      if (sessionDate.year == expectedDate.year &&
          sessionDate.month == expectedDate.month &&
          sessionDate.day == expectedDate.day) {
        streak++;
        checkDate = checkDate.subtract(const Duration(days: 1));
      } else if (sessionDate.isBefore(expectedDate)) {
        // Missed a day, streak broken
        break;
      }
    }

    return streak;
  }

  /// Get total completed fasts
  Future<int> getTotalFasts(String userId) async {
    final history = await getHistory(userId);
    return history.length;
  }

  /// Get average fasting duration
  Future<double> getAverageDuration(String userId) async {
    final history = await getHistory(userId);
    if (history.isEmpty) return 0;

    final totalMinutes = history.fold<int>(
      0,
      (sum, session) => sum + session.fastingDuration.inMinutes,
    );

    return totalMinutes / history.length / 60; // Return hours
  }

  /// Update eating window times
  Future<void> updateEatingWindow(
    String sessionId,
    String eatingWindowStart,
    String eatingWindowEnd,
  ) async {
    final box = Hive.box(HiveBoxes.fasting);
    final data = box.get(sessionId);

    if (data == null) return;

    final session = FastingSession.fromMap(Map<String, dynamic>.from(data));
    final updatedSession = session.copyWith(
      eatingWindowStart: eatingWindowStart,
      eatingWindowEnd: eatingWindowEnd,
    );

    await box.put(sessionId, updatedSession.toMap());

    // Add to sync queue
    final queueItem = SyncQueueItem.create(
      collectionId: AW.fastingLogs,
      operation: 'update',
      localId: sessionId,
      payload: updatedSession.toMap(),
    );
    await _syncQueue.addItem(queueItem);
  }
}

// Provider
final fastingRepositoryProvider = Provider<FastingRepository>((ref) {
  final syncQueue = ref.watch(syncQueueProvider);
  return FastingRepository(syncQueue);
});
