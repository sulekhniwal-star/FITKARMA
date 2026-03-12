import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../tracking/data/repositories/activity_repository.dart';
import '../../tracking/data/repositories/water_repository.dart';
import '../../food/data/repositories/food_repository.dart';

part 'dashboard_controller.g.dart';

class DashboardState {
  final double calories;
  final double caloriesGoal;
  final int steps;
  final int stepsGoal;
  final int water;
  final int waterGoal;
  final int minutes;
  final int minutesGoal;

  DashboardState({
    required this.calories,
    required this.caloriesGoal,
    required this.steps,
    required this.stepsGoal,
    required this.water,
    required this.waterGoal,
    required this.minutes,
    required this.minutesGoal,
  });

  double get caloriesProgress => (calories / caloriesGoal).clamp(0.0, 1.0);
  double get stepsProgress => (steps / stepsGoal).clamp(0.0, 1.0);
  double get waterProgress => (water / waterGoal).clamp(0.0, 1.0);
  double get minutesProgress => (minutes / minutesGoal).clamp(0.0, 1.0);

  DashboardState copyWith({
    double? calories,
    double? caloriesGoal,
    int? steps,
    int? stepsGoal,
    int? water,
    int? waterGoal,
    int? minutes,
    int? minutesGoal,
  }) {
    return DashboardState(
      calories: calories ?? this.calories,
      caloriesGoal: caloriesGoal ?? this.caloriesGoal,
      steps: steps ?? this.steps,
      stepsGoal: stepsGoal ?? this.stepsGoal,
      water: water ?? this.water,
      waterGoal: waterGoal ?? this.waterGoal,
      minutes: minutes ?? this.minutes,
      minutesGoal: minutesGoal ?? this.minutesGoal,
    );
  }
}

@riverpod
class DashboardController extends _$DashboardController {
  @override
  FutureOr<DashboardState> build() async {
    final activityRepo = await ref.watch(activityRepositoryProvider.future);
    final waterRepo = await ref.watch(waterRepositoryProvider.future);
    final foodRepo = await ref.watch(foodRepositoryProvider.future);
    
    final dailyActivity = await activityRepo.getDailyActivity(DateTime.now());
    final dailyWater = await waterRepo.getDailyWater(DateTime.now());
    final dailyCalories = await foodRepo.getTodayTotalCalories();

    return DashboardState(
      calories: dailyCalories,
      caloriesGoal: 2000,
      steps: dailyActivity.steps,
      stepsGoal: 10000,
      water: dailyWater.amountGlasses,
      waterGoal: 8,
      minutes: dailyActivity.activeMinutes,
      minutesGoal: 60,
    );
  }

  Future<void> updateSteps(int steps) async {
    final activityRepo = ref.read(activityRepositoryProvider).value;
    if (activityRepo != null) {
      await activityRepo.saveSteps(steps);
      ref.invalidateSelf();
    }
  }

  Future<void> addWater() async {
    final waterRepo = ref.read(waterRepositoryProvider).value;
    if (waterRepo != null) {
      await waterRepo.addGlass();
      ref.invalidateSelf();
    }
  }

  Future<void> addMinutes(int mins) async {
    final activityRepo = ref.read(activityRepositoryProvider).value;
    if (activityRepo != null) {
      await activityRepo.saveActiveMinutes(mins);
      ref.invalidateSelf();
    }
  }
}
