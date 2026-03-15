// lib/features/food/data/nutrition_goal_hive_service.dart

import 'package:hive/hive.dart';
import '../domain/nutrition_goal_model.dart';
import '../../../core/constants/hive_boxes.dart';

/// Service for managing nutrition goals in Hive
class NutritionGoalHiveService {
  late Box<NutritionGoal> _box;
  bool _isInitialized = false;

  /// Initialize the Hive box
  Future<void> init() async {
    if (_isInitialized) return;

    _box = await Hive.openBox<NutritionGoal>(HiveBoxes.nutritionGoals);
    _isInitialized = true;
  }

  /// Ensure box is initialized
  Future<void> _ensureInitialized() async {
    if (!_isInitialized) {
      await init();
    }
  }

  /// Get current nutrition goal for a user
  Future<NutritionGoal?> getGoal(String userId) async {
    await _ensureInitialized();

    try {
      return _box.values.firstWhere((goal) => goal.userId == userId);
    } catch (e) {
      return null;
    }
  }

  /// Save or update nutrition goal
  Future<void> saveGoal(NutritionGoal goal) async {
    await _ensureInitialized();

    await _box.put(goal.userId, goal);
  }

  /// Create and save new nutrition goal from user profile
  Future<NutritionGoal> createGoalFromProfile({
    required String userId,
    required double weightKg,
    required double heightCm,
    required int age,
    required String gender,
    required String activityLevel,
    required String fitnessGoal,
  }) async {
    final goal = NutritionGoal.fromUserProfile(
      userId: userId,
      weightKg: weightKg,
      heightCm: heightCm,
      age: age,
      gender: gender,
      activityLevel: activityLevel,
      fitnessGoal: fitnessGoal,
    );

    await saveGoal(goal);
    return goal;
  }

  /// Get or create default goal
  Future<NutritionGoal> getOrCreateDefault(String userId) async {
    final existing = await getGoal(userId);
    if (existing != null) {
      return existing;
    }

    final defaultGoal = NutritionGoal.createDefault(userId);
    await saveGoal(defaultGoal);
    return defaultGoal;
  }

  /// Update activity level and recalculate
  Future<NutritionGoal> updateActivityLevel(
    String userId,
    String newActivityLevel,
  ) async {
    final current = await getGoal(userId);
    if (current == null) {
      return getOrCreateDefault(userId);
    }

    // Recalculate TDEE with new activity level
    // This would need the original profile data
    final updated = current.copyWith(
      activityLevel: newActivityLevel,
      syncStatus: 'pending',
    );

    await saveGoal(updated);
    return updated;
  }

  /// Update fitness goal and recalculate
  Future<NutritionGoal> updateFitnessGoal(String userId, String newGoal) async {
    final current = await getGoal(userId);
    if (current == null) {
      return getOrCreateDefault(userId);
    }

    final updated = current.copyWith(
      fitnessGoal: newGoal,
      syncStatus: 'pending',
    );

    await saveGoal(updated);
    return updated;
  }

  /// Check if goal needs recalculation (e.g., after weight change)
  bool needsRecalculation(NutritionGoal goal) {
    final now = DateTime.now();
    // Recalculate if older than 30 days
    return now.difference(goal.calculatedAt).inDays > 30;
  }

  /// Delete nutrition goal
  Future<void> deleteGoal(String userId) async {
    await _ensureInitialized();
    await _box.delete(userId);
  }

  /// Get all goals (for admin/debug)
  Future<List<NutritionGoal>> getAllGoals() async {
    await _ensureInitialized();
    return _box.values.toList();
  }

  /// Clear all goals (for testing)
  Future<void> clearAll() async {
    await _ensureInitialized();
    await _box.clear();
  }
}
