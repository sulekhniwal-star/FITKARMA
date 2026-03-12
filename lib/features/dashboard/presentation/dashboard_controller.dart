import 'package:riverpod_annotation/riverpod_annotation.dart';

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
  DashboardState build() {
    // Initial mock data for Phase 2 UI development
    return DashboardState(
      calories: 1200,
      caloriesGoal: 2000,
      steps: 8500,
      stepsGoal: 10000,
      water: 4,
      waterGoal: 8,
      minutes: 35,
      minutesGoal: 60,
    );
  }

  void updateSteps(int steps) {
    state = state.copyWith(steps: steps);
  }

  void addWater() {
    state = state.copyWith(water: state.water + 1);
  }
}
