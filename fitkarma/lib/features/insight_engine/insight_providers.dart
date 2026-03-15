// lib/features/insight_engine/insight_providers.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'rule_engine.dart';

/// Insight rule engine singleton provider
final insightEngineProvider = Provider<InsightRuleEngine>((ref) {
  return InsightRuleEngine();
});

/// Today's insights provider - evaluates up to 2 insights
final todayInsightsProvider = FutureProvider<List<InsightResult>>((ref) async {
  final engine = ref.watch(insightEngineProvider);

  // Build context from available data
  final context = await _buildInsightContext();

  // Evaluate with max 2 insights
  return engine.evaluate(context: context, maxInsights: 2);
});

/// All insights provider (for detailed view)
final allInsightsProvider = FutureProvider<List<InsightResult>>((ref) async {
  final engine = ref.watch(insightEngineProvider);
  final context = await _buildInsightContext();

  return engine.evaluate(context: context, maxInsights: 10);
});

/// Build insight context from various data sources
/// In production, this would gather data from all health providers
Future<InsightContext> _buildInsightContext() async {
  // In a real implementation, you would gather data from:
  // - Steps providers
  // - Sleep providers
  // - Food/nutrition providers
  // - Workout providers
  // - Health metrics (BP, glucose, etc.)
  // - User profile (weight, height, gender, age)
  // - Streak data

  // For now, return a basic context - the actual data would come from providers
  return InsightContext(
    userId: 'current_user',
    weightKg: 70,
    heightCm: 170,
    gender: 'male',
    dateOfBirth: DateTime(1990, 1, 1),
    fitnessGoal: 'maintain',
    todaySteps: 5000,
    todayCalories: 1800,
    todayProtein: 60,
    todayWater: 2.0,
    todayWorkoutMinutes: 30,
    todaySleepHours: 7.0,
    weeklySteps: [8000, 9000, 7000, 10000, 8500, 6000, 7500],
    weeklySleep: [7.0, 7.5, 6.5, 8.0, 7.0, 6.0, 7.5],
    weeklyWorkoutMinutes: [45, 30, 60, 45, 0, 90, 30],
    weeklyWater: [2.5, 2.0, 2.2, 3.0, 2.5, 1.8, 2.0],
    latestBMI: 24.2,
    latestSystolicBP: 118,
    latestDiastolicBP: 78,
    latestGlucose: 95,
    currentStreak: 5,
    longestStreak: 12,
    workoutsThisWeek: 4,
  );
}

/// Provider for recording user feedback
final insightFeedbackProvider = Provider<InsightFeedbackStore>((ref) {
  return InsightFeedbackStore();
});
