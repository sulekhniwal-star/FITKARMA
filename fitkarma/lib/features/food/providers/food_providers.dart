// lib/features/food/providers/food_providers.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/food_repository.dart';
import '../domain/food_log_model.dart';

/// Food repository provider
final foodRepositoryProvider = Provider<FoodRepository>((ref) {
  return FoodRepository();
});

/// Food logs notifier for managing food log state
class FoodLogsNotifier extends StateNotifier<List<FoodLog>> {
  final FoodRepository _repository;
  final String userId;

  FoodLogsNotifier(this._repository, this.userId) : super([]) {
    loadTodayLogs();
  }

  /// Load today's food logs
  Future<void> loadTodayLogs() async {
    final today = DateTime.now();
    final logs = await _repository.getFoodLogsForDate(userId, today);
    state = logs;
  }

  /// Load food logs for a specific date
  Future<void> loadLogsForDate(DateTime date) async {
    final logs = await _repository.getFoodLogsForDate(userId, date);
    state = logs;
  }

  /// Add a new food log
  Future<void> addFoodLog(FoodLog log) async {
    await _repository.addFoodLog(log);
    await loadTodayLogs();
  }

  /// Delete a food log
  Future<void> deleteFoodLog(String id) async {
    await _repository.deleteFoodLog(id);
    await loadTodayLogs();
  }

  /// Sync pending logs
  Future<void> syncPendingLogs() async {
    await _repository.syncPendingLogs();
  }
}

/// Main food logs provider
final foodLogsProvider = StateNotifierProvider<FoodLogsNotifier, List<FoodLog>>((ref) {
  final repository = ref.watch(foodRepositoryProvider);
  return FoodLogsNotifier(repository, 'current_user'); // TODO: Get from auth
});

/// Provider for recent food logs for a specific meal type
final recentFoodLogsProvider = FutureProvider.family<List<FoodLog>, String>((ref, mealType) async {
  final repository = ref.watch(foodRepositoryProvider);
  final today = DateTime.now();
  final logs = await repository.getFoodLogsForDate('current_user', today);
  return logs.where((log) => log.mealType == mealType).toList();
});

/// Search results provider
final foodSearchQueryProvider = StateProvider<String>((ref) => '');

final foodSearchResultsProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final query = ref.watch(foodSearchQueryProvider);
  if (query.isEmpty) return [];
  
  final repository = ref.watch(foodRepositoryProvider);
  return repository.searchFoodItems(query);
});

/// Total calories for today provider
final todayCaloriesProvider = FutureProvider<double>((ref) async {
  final repository = ref.watch(foodRepositoryProvider);
  return repository.getTotalCalories('current_user', DateTime.now());
});

/// Today's macros provider
final todayMacrosProvider = FutureProvider<Map<String, double>>((ref) async {
  final repository = ref.watch(foodRepositoryProvider);
  return repository.getMacrosSummary('current_user', DateTime.now());
});

/// Food log stats for a date
class FoodLogStats {
  final double totalCalories;
  final double protein;
  final double carbs;
  final double fat;
  final int mealCount;

  FoodLogStats({
    required this.totalCalories,
    required this.protein,
    required this.carbs,
    required this.fat,
    required this.mealCount,
  });
}

/// Food log stats provider
final foodLogStatsProvider = FutureProvider.family<FoodLogStats, DateTime>((ref, date) async {
  final repository = ref.watch(foodRepositoryProvider);
  final logs = await repository.getFoodLogsForDate('current_user', date);
  
  double calories = 0;
  double protein = 0;
  double carbs = 0;
  double fat = 0;
  
  for (final log in logs) {
    calories += log.calories;
    protein += log.proteinG;
    carbs += log.carbsG;
    fat += log.fatG;
  }

  return FoodLogStats(
    totalCalories: calories,
    protein: protein,
    carbs: carbs,
    fat: fat,
    mealCount: logs.length,
  );
});
