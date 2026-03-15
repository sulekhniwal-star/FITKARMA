// lib/features/steps/services/background_sync_service.dart
import 'package:flutter/foundation.dart';
import 'package:workmanager/workmanager.dart';
import '../data/step_hive_service.dart';

/// Background sync service for steps using WorkManager
class BackgroundSyncService {
  static final BackgroundSyncService _instance =
      BackgroundSyncService._internal();
  factory BackgroundSyncService() => _instance;
  BackgroundSyncService._internal();

  static const String stepSyncTaskName = 'stepSyncTask';
  static const String midnightSyncTaskName = 'midnightSyncTask';

  /// Initialize background sync
  Future<void> init() async {
    try {
      await Workmanager().initialize(
        callbackDispatcher,
        isInDebugMode: kDebugMode,
      );
      debugPrint('Workmanager initialized');
    } catch (e) {
      debugPrint('Error initializing Workmanager: $e');
    }
  }

  /// Register periodic step sync (hourly)
  Future<void> registerHourlySync() async {
    try {
      await Workmanager().registerPeriodicTask(
        stepSyncTaskName,
        stepSyncTaskName,
        frequency: const Duration(hours: 1),
        constraints: Constraints(networkType: NetworkType.notRequired),
      );
      debugPrint('Hourly step sync registered');
    } catch (e) {
      debugPrint('Error registering hourly sync: $e');
    }
  }

  /// Register midnight sync for batch processing
  Future<void> registerMidnightSync() async {
    try {
      await Workmanager().registerPeriodicTask(
        midnightSyncTaskName,
        midnightSyncTaskName,
        frequency: const Duration(days: 1),
        initialDelay: _calculateMidnightDelay(),
        constraints: Constraints(networkType: NetworkType.notRequired),
      );
      debugPrint('Midnight step sync registered');
    } catch (e) {
      debugPrint('Error registering midnight sync: $e');
    }
  }

  /// Calculate delay until midnight
  Duration _calculateMidnightDelay() {
    final now = DateTime.now();
    final midnight = DateTime(now.year, now.month, now.day + 1);
    return midnight.difference(now);
  }

  /// Cancel all background tasks
  Future<void> cancelAll() async {
    try {
      await Workmanager().cancelAll();
      debugPrint('All background tasks cancelled');
    } catch (e) {
      debugPrint('Error cancelling tasks: $e');
    }
  }
}

/// Background task callback dispatcher
@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    try {
      switch (task) {
        case BackgroundSyncService.stepSyncTaskName:
          await _syncSteps();
          break;
        case BackgroundSyncService.midnightSyncTaskName:
          await _midnightSync();
          break;
      }
    } catch (e) {
      debugPrint('Background task error: $e');
    }
    return true;
  });
}

/// Sync steps data
Future<void> _syncSteps() async {
  debugPrint('Running step sync...');
  // Get pending sync items and process them
  // This would integrate with Appwrite for cloud sync
  final pendingLogs = StepHiveService.getPendingSyncLogs();
  debugPrint('Found ${pendingLogs.length} pending step logs to sync');
}

/// Midnight sync - process and batch sync
Future<void> _midnightSync() async {
  debugPrint('Running midnight step sync...');
  // Perform midnight batch sync
  // This would:
  // 1. Calculate the previous day's total
  // 2. Calculate XP earned
  // 3. Update adaptive goal
  // 4. Sync to cloud
  await _syncSteps();
}
