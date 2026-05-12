import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:health/health.dart';

class StepsData {
  final int totalSteps;
  final int dailyGoal;
  final double distanceKm;
  final int caloriesBurned;
  final List<int> hourlySteps12h;
  final bool isUsingSimulatedData;

  StepsData({
    required this.totalSteps,
    required this.dailyGoal,
    required this.distanceKm,
    required this.caloriesBurned,
    required this.hourlySteps12h,
    this.isUsingSimulatedData = false,
  });

  factory StepsData.fallback() {
    return StepsData(
      totalSteps: 7432,
      dailyGoal: 10000,
      distanceKm: 5.64,
      caloriesBurned: 297,
      hourlySteps12h: [120, 0, 450, 1100, 890, 320, 150, 600, 1400, 920, 810, 672],
      isUsingSimulatedData: true,
    );
  }
}

class StepsNotifier extends StateNotifier<AsyncValue<StepsData>> {
  StepsNotifier() : super(const AsyncValue.loading()) {
    loadData();
  }

  Future<void> loadData({bool forceSimulate = false}) async {
    state = const AsyncValue.loading();
    if (forceSimulate) {
      state = AsyncValue.data(StepsData.fallback());
      return;
    }

    try {
      final health = Health();
      final types = [HealthDataType.STEPS];
      
      final bool authorized = await health.requestAuthorization(types);
      if (!authorized) {
        state = AsyncValue.data(StepsData.fallback());
        return;
      }

      final now = DateTime.now();
      final startOfDay = DateTime(now.year, now.month, now.day);
      
      final steps = await health.getTotalStepsInInterval(startOfDay, now);
      final int total = steps ?? 0;

      if (total == 0) {
        state = AsyncValue.data(StepsData.fallback());
        return;
      }

      final List<int> hourly = [];
      for (int i = 11; i >= 0; i--) {
        final end = now.subtract(Duration(hours: i));
        final start = end.subtract(const Duration(hours: 1));
        try {
          final hSteps = await health.getTotalStepsInInterval(start, end);
          hourly.add(hSteps ?? 0);
        } catch (_) {
          hourly.add(0);
        }
      }

      final distance = total * 0.00076;
      final calories = (total * 0.04).toInt();

      state = AsyncValue.data(StepsData(
        totalSteps: total,
        dailyGoal: 10000,
        distanceKm: double.parse(distance.toStringAsFixed(2)),
        caloriesBurned: calories,
        hourlySteps12h: hourly,
        isUsingSimulatedData: false,
      ));
    } catch (e) {
      state = AsyncValue.data(StepsData.fallback());
    }
  }
}

final stepsDataProvider = StateNotifierProvider<StepsNotifier, AsyncValue<StepsData>>((ref) {
  return StepsNotifier();
});
