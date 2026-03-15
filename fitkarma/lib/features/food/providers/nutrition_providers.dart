// lib/features/food/providers/nutrition_providers.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/nutrition_goal_hive_service.dart';
import '../services/nutrition_calculation_service.dart';
import '../domain/nutrition_goal_model.dart';
import '../../auth/providers/auth_providers.dart';
import 'food_providers.dart';

/// Nutrition goal hive service provider
final nutritionGoalHiveServiceProvider = Provider<NutritionGoalHiveService>((
  ref,
) {
  return NutritionGoalHiveService();
});

/// Nutrition calculation service provider
final nutritionCalculationServiceProvider =
    Provider<NutritionCalculationService>((ref) {
      return NutritionCalculationService();
    });

/// Current user ID provider
final currentUserIdProvider = FutureProvider<String>((ref) async {
  final authState = ref.watch(authStateProvider);
  final isAuthenticated = authState.valueOrNull ?? false;

  if (!isAuthenticated) {
    return 'anonymous';
  }

  final user = await ref.watch(currentUserProvider.future);
  return user?.$id ?? 'anonymous';
});

/// Current user nutrition goals provider
final nutritionGoalProvider = FutureProvider<NutritionGoal?>((ref) async {
  final hiveService = ref.watch(nutritionGoalHiveServiceProvider);
  final userId = await ref.watch(currentUserIdProvider.future);

  await hiveService.init();
  return hiveService.getGoal(userId);
});

/// Create or get nutrition goal from user profile
class NutritionGoalNotifier extends StateNotifier<AsyncValue<NutritionGoal?>> {
  final NutritionGoalHiveService _hiveService;
  final String userId;

  NutritionGoalNotifier(this._hiveService, this.userId)
    : super(const AsyncValue.loading()) {
    _loadGoal();
  }

  Future<void> _loadGoal() async {
    try {
      await _hiveService.init();
      final goal = await _hiveService.getGoal(userId);
      state = AsyncValue.data(goal);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  /// Initialize goals from user profile data
  Future<void> initializeFromProfile({
    required double weightKg,
    required double heightCm,
    required int age,
    required String gender,
    required String activityLevel,
    required String fitnessGoal,
  }) async {
    state = const AsyncValue.loading();

    try {
      final goal = await _hiveService.createGoalFromProfile(
        userId: userId,
        weightKg: weightKg,
        heightCm: heightCm,
        age: age,
        gender: gender,
        activityLevel: activityLevel,
        fitnessGoal: fitnessGoal,
      );
      state = AsyncValue.data(goal);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  /// Update activity level
  Future<void> updateActivityLevel(String newActivityLevel) async {
    final current = state.valueOrNull;
    if (current == null) return;

    try {
      final updated = await _hiveService.updateActivityLevel(
        userId,
        newActivityLevel,
      );
      state = AsyncValue.data(updated);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  /// Update fitness goal
  Future<void> updateFitnessGoal(String newGoal) async {
    final current = state.valueOrNull;
    if (current == null) return;

    try {
      final updated = await _hiveService.updateFitnessGoal(userId, newGoal);
      state = AsyncValue.data(updated);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  /// Refresh goal
  Future<void> refresh() async {
    await _loadGoal();
  }
}

/// Nutrition goal state notifier provider
final nutritionGoalNotifierProvider =
    StateNotifierProvider<NutritionGoalNotifier, AsyncValue<NutritionGoal?>>((
      ref,
    ) {
      final hiveService = ref.watch(nutritionGoalHiveServiceProvider);

      return NutritionGoalNotifier(
        hiveService,
        'current_user',
      ); // Use user from auth
    });

/// Today's nutrition summary provider
final todayNutritionProvider = FutureProvider<DailyNutrition>((ref) async {
  final calcService = ref.watch(nutritionCalculationServiceProvider);

  final today = DateTime.now();

  // Get today's food logs
  final logs = ref.watch(foodLogsProvider);

  return calcService.calculateDailyNutrition(date: today, foodLogs: logs);
});

/// Remaining nutrients provider
final remainingNutrientsProvider = FutureProvider<Map<String, double>>((
  ref,
) async {
  final calcService = ref.watch(nutritionCalculationServiceProvider);
  final goalAsync = ref.watch(nutritionGoalProvider);
  final todayAsync = ref.watch(todayNutritionProvider);

  final goal = goalAsync.valueOrNull;
  final today = todayAsync.valueOrNull;

  if (goal == null || today == null) {
    return {
      'calories': 2000,
      'protein': 100,
      'carbs': 275,
      'fat': 56,
      'fiber': 25,
    };
  }

  return calcService.calculateRemaining(goals: goal, today: today);
});

/// Nutrition status providers (for traffic light)
final calorieStatusProvider = Provider<NutritionStatus>((ref) {
  final todayAsync = ref.watch(todayNutritionProvider);
  final goalAsync = ref.watch(nutritionGoalProvider);

  final today = todayAsync.valueOrNull;
  final goal = goalAsync.valueOrNull;

  if (today == null || goal == null) {
    return NutritionStatus.warning;
  }

  return NutritionStatus.fromProgress(
    today.consumedCalories,
    goal.targetCalories,
  );
});

final proteinStatusProvider = Provider<NutritionStatus>((ref) {
  final todayAsync = ref.watch(todayNutritionProvider);
  final goalAsync = ref.watch(nutritionGoalProvider);

  final today = todayAsync.valueOrNull;
  final goal = goalAsync.valueOrNull;

  if (today == null || goal == null) {
    return NutritionStatus.warning;
  }

  return NutritionStatus.fromProgress(today.consumedProtein, goal.proteinGrams);
});

final carbsStatusProvider = Provider<NutritionStatus>((ref) {
  final todayAsync = ref.watch(todayNutritionProvider);
  final goalAsync = ref.watch(nutritionGoalProvider);

  final today = todayAsync.valueOrNull;
  final goal = goalAsync.valueOrNull;

  if (today == null || goal == null) {
    return NutritionStatus.warning;
  }

  return NutritionStatus.fromProgress(today.consumedCarbs, goal.carbsGrams);
});

final fatStatusProvider = Provider<NutritionStatus>((ref) {
  final todayAsync = ref.watch(todayNutritionProvider);
  final goalAsync = ref.watch(nutritionGoalProvider);

  final today = todayAsync.valueOrNull;
  final goal = goalAsync.valueOrNull;

  if (today == null || goal == null) {
    return NutritionStatus.warning;
  }

  return NutritionStatus.fromProgress(today.consumedFat, goal.fatGrams);
});

/// Grocery list provider
final groceryListProvider = FutureProvider<List<GroceryItem>>((ref) async {
  final calcService = ref.watch(nutritionCalculationServiceProvider);
  final goalAsync = ref.watch(nutritionGoalProvider);
  final todayAsync = ref.watch(todayNutritionProvider);

  final goal = goalAsync.valueOrNull;
  final today = todayAsync.valueOrNull;

  if (goal == null) return [];

  return calcService.generateGroceryList(goals: goal, today: today);
});

/// Weekly report provider
final weeklyReportProvider = FutureProvider<WeeklyMicronutrientReport?>((
  ref,
) async {
  final calcService = ref.watch(nutritionCalculationServiceProvider);
  final goalAsync = ref.watch(nutritionGoalProvider);

  final goal = goalAsync.valueOrNull;
  if (goal == null) return null;

  // Get start of current week (Monday)
  final now = DateTime.now();
  final weekStart = now.subtract(Duration(days: now.weekday - 1));
  final startOfWeek = DateTime(weekStart.year, weekStart.month, weekStart.day);

  // Generate daily nutrition for each day of the week
  final dailyLogs = <DailyNutrition>[];
  for (int i = 0; i < 7; i++) {
    final date = startOfWeek.add(Duration(days: i));
    // In a real app, we'd fetch actual logs for each day
    // For now, we'll create sample data
    if (date.isBefore(now) || date.isAtSameMomentAs(now)) {
      dailyLogs.add(
        DailyNutrition(
          date: date,
          consumedCalories: 1800 + (i * 50),
          consumedProtein: 80 + (i * 5),
          consumedCarbs: 200 + (i * 10),
          consumedFat: 50 + (i * 3),
          consumedFiber: 20 + (i * 1),
          consumedWater: 2.0 + (i * 0.1),
          consumedIron: 10 + (i * 0.5),
          consumedVitaminB12: 2.0 + (i * 0.1),
          consumedVitaminD: 300 + (i * 20),
          consumedCalcium: 600 + (i * 30),
        ),
      );
    }
  }

  return calcService.generateWeeklyReport(
    weekStart: startOfWeek,
    dailyLogs: dailyLogs,
    goals: goal,
  );
});

/// Micronutrient status providers
final ironStatusProvider = Provider<NutritionStatus>((ref) {
  final todayAsync = ref.watch(todayNutritionProvider);
  final goalAsync = ref.watch(nutritionGoalProvider);

  final today = todayAsync.valueOrNull;
  final goal = goalAsync.valueOrNull;

  if (today == null || goal == null) {
    return NutritionStatus.warning;
  }

  return NutritionStatus.fromProgress(today.consumedIron, goal.ironMg);
});

final vitaminB12StatusProvider = Provider<NutritionStatus>((ref) {
  final todayAsync = ref.watch(todayNutritionProvider);
  final goalAsync = ref.watch(nutritionGoalProvider);

  final today = todayAsync.valueOrNull;
  final goal = goalAsync.valueOrNull;

  if (today == null || goal == null) {
    return NutritionStatus.warning;
  }

  return NutritionStatus.fromProgress(
    today.consumedVitaminB12,
    goal.vitaminB12Mcg,
  );
});

final vitaminDStatusProvider = Provider<NutritionStatus>((ref) {
  final todayAsync = ref.watch(todayNutritionProvider);
  final goalAsync = ref.watch(nutritionGoalProvider);

  final today = todayAsync.valueOrNull;
  final goal = goalAsync.valueOrNull;

  if (today == null || goal == null) {
    return NutritionStatus.warning;
  }

  return NutritionStatus.fromProgress(today.consumedVitaminD, goal.vitaminDIU);
});

final calciumStatusProvider = Provider<NutritionStatus>((ref) {
  final todayAsync = ref.watch(todayNutritionProvider);
  final goalAsync = ref.watch(nutritionGoalProvider);

  final today = todayAsync.valueOrNull;
  final goal = goalAsync.valueOrNull;

  if (today == null || goal == null) {
    return NutritionStatus.warning;
  }

  return NutritionStatus.fromProgress(today.consumedCalcium, goal.calciumMg);
});
