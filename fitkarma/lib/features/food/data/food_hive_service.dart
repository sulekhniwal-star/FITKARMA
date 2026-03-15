// lib/features/food/data/food_hive_service.dart
import 'package:hive/hive.dart';
import '../../../core/constants/hive_boxes.dart';
import '../domain/food_log_model.dart';

/// Service for managing FoodLog entries in Hive local storage
class FoodHiveService {
  Box<FoodLog>? _box;

  /// Get the food logs box, opening if necessary
  Future<Box<FoodLog>> get box async {
    _box ??= await Hive.openBox<FoodLog>(HiveBoxes.foodLogs);
    return _box!;
  }

  /// Save a food log entry to Hive
  Future<void> saveFoodLog(FoodLog log) async {
    final b = await box;
    await b.put(log.id, log);
  }

  /// Get a food log by ID
  Future<FoodLog?> getFoodLog(String id) async {
    final b = await box;
    return b.get(id);
  }

  /// Get all food logs for a user
  Future<List<FoodLog>> getAllFoodLogs(String userId) async {
    final b = await box;
    return b.values.where((log) => log.userId == userId).toList();
  }

  /// Get food logs for a specific date
  Future<List<FoodLog>> getFoodLogsForDate(String userId, DateTime date) async {
    final b = await box;
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    return b.values.where((log) {
      return log.userId == userId &&
          log.loggedAt.isAfter(startOfDay) &&
          log.loggedAt.isBefore(endOfDay);
    }).toList();
  }

  /// Get food logs for a specific meal type on a date
  Future<List<FoodLog>> getFoodLogsForMeal(
    String userId,
    DateTime date,
    String mealType,
  ) async {
    final logs = await getFoodLogsForDate(userId, date);
    return logs.where((log) => log.mealType == mealType).toList();
  }

  /// Get all pending sync logs
  Future<List<FoodLog>> getPendingSyncLogs() async {
    final b = await box;
    return b.values.where((log) => log.syncStatus == 'pending').toList();
  }

  /// Update sync status for a log
  Future<void> updateSyncStatus(String id, String status) async {
    final b = await box;
    final log = b.get(id);
    if (log != null) {
      log.syncStatus = status;
      await log.save();
    }
  }

  /// Delete a food log
  Future<void> deleteFoodLog(String id) async {
    final b = await box;
    await b.delete(id);
  }

  /// Clear all food logs for a user
  Future<void> clearAllLogs(String userId) async {
    final b = await box;
    final keysToDelete = b.values
        .where((log) => log.userId == userId)
        .map((log) => log.id)
        .toList();
    await b.deleteAll(keysToDelete);
  }

  /// Get total calories for a date
  Future<double> getTotalCalories(String userId, DateTime date) async {
    final logs = await getFoodLogsForDate(userId, date);
    return logs.fold<double>(0.0, (sum, log) => sum + log.calories);
  }

  /// Get macros summary for a date
  Future<Map<String, double>> getMacrosSummary(
    String userId,
    DateTime date,
  ) async {
    final logs = await getFoodLogsForDate(userId, date);

    double protein = 0;
    double carbs = 0;
    double fat = 0;

    for (final log in logs) {
      protein += log.proteinG;
      carbs += log.carbsG;
      fat += log.fatG;
    }

    return {'protein': protein, 'carbs': carbs, 'fat': fat};
  }

  /// Close the box
  Future<void> close() async {
    await _box?.close();
    _box = null;
  }
}
