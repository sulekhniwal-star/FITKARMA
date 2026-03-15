// lib/features/food/data/food_repository.dart
import '../domain/food_log_model.dart';
import 'food_hive_service.dart';
import 'food_aw_service.dart';

/// Repository for food data - Hive first, Appwrite fallback, queue sync
class FoodRepository {
  final FoodHiveService _hiveService;
  final FoodAwService _awService;

  FoodRepository({FoodHiveService? hiveService, FoodAwService? awService})
    : _hiveService = hiveService ?? FoodHiveService(),
      _awService = awService ?? FoodAwService();

  /// Add a food log entry
  /// Saves to Hive first, queues for Appwrite sync
  Future<void> addFoodLog(FoodLog log) async {
    // Save to Hive first (fast)
    await _hiveService.saveFoodLog(log);

    // Try to sync to Appwrite in background
    try {
      final result = await _awService.logFood(log);
      if (result != null) {
        await _hiveService.updateSyncStatus(log.id, 'synced');
      } else {
        // Keep as pending - will sync later
      }
    } catch (e) {
      // Keep as pending - will sync later
    }
  }

  /// Get food logs for a date - reads from Hive first
  Future<List<FoodLog>> getFoodLogsForDate(String userId, DateTime date) async {
    // Read from Hive first (fast)
    final hiveLogs = await _hiveService.getFoodLogsForDate(userId, date);

    if (hiveLogs.isNotEmpty) {
      return hiveLogs;
    }

    // Fallback to Appwrite if Hive is empty
    try {
      final awLogs = await _awService.getFoodLogsForDate(userId, date);
      // Cache in Hive for next time
      for (final log in awLogs) {
        await _hiveService.saveFoodLog(log);
      }
      return awLogs;
    } catch (e) {
      return [];
    }
  }

  /// Get all food logs for a user
  Future<List<FoodLog>> getAllFoodLogs(String userId) async {
    return _hiveService.getAllFoodLogs(userId);
  }

  /// Search food items
  Future<List<Map<String, dynamic>>> searchFoodItems(String query) async {
    return _awService.searchFoodItems(query);
  }

  /// Get popular food items
  Future<List<Map<String, dynamic>>> getPopularFoodItems({
    int limit = 20,
  }) async {
    return _awService.getPopularFoodItems(limit: limit);
  }

  /// Get a food item by ID
  Future<Map<String, dynamic>?> getFoodItem(String id) async {
    return _awService.getFoodItem(id);
  }

  /// Delete a food log
  Future<void> deleteFoodLog(String id) async {
    await _hiveService.deleteFoodLog(id);
    await _awService.deleteFoodLog(id);
  }

  /// Sync pending logs to Appwrite
  Future<void> syncPendingLogs() async {
    final pendingLogs = await _hiveService.getPendingSyncLogs();

    for (final log in pendingLogs) {
      try {
        final result = await _awService.logFood(log);
        if (result != null) {
          await _hiveService.updateSyncStatus(log.id, 'synced');
        }
      } catch (e) {
        // Keep as pending
      }
    }
  }

  /// Get total calories for a date
  Future<double> getTotalCalories(String userId, DateTime date) async {
    return _hiveService.getTotalCalories(userId, date);
  }

  /// Get macros summary for a date
  Future<Map<String, double>> getMacrosSummary(
    String userId,
    DateTime date,
  ) async {
    return _hiveService.getMacrosSummary(userId, date);
  }

  /// Close resources
  Future<void> close() async {
    await _hiveService.close();
  }
}
