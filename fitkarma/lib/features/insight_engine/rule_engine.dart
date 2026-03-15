// lib/features/insight_engine/rule_engine.dart

import 'package:hive/hive.dart';

/// Insight severity levels
enum InsightSeverity {
  info, // Blue - informational
  success, // Green - positive achievement
  warning, // Yellow - needs attention
  danger; // Red - critical

  String get emoji {
    switch (this) {
      case InsightSeverity.info:
        return 'ℹ️';
      case InsightSeverity.success:
        return '🎉';
      case InsightSeverity.warning:
        return '⚠️';
      case InsightSeverity.danger:
        return '🚨';
    }
  }

  String get label {
    switch (this) {
      case InsightSeverity.info:
        return 'Info';
      case InsightSeverity.success:
        return 'Great';
      case InsightSeverity.warning:
        return 'Notice';
      case InsightSeverity.danger:
        return 'Alert';
    }
  }
}

/// Single insight result from a rule evaluation
class InsightResult {
  final String id;
  final String ruleName;
  final String title;
  final String message;
  final InsightSeverity severity;
  final String category;
  final double? score; // 0-100 for ranking
  final Map<String, dynamic> data;
  final DateTime evaluatedAt;

  InsightResult({
    required this.id,
    required this.ruleName,
    required this.title,
    required this.message,
    required this.severity,
    required this.category,
    this.score,
    Map<String, dynamic>? data,
    DateTime? evaluatedAt,
  }) : data = data ?? {},
       evaluatedAt = evaluatedAt ?? DateTime.now();

  Map<String, dynamic> toJson() => {
    'id': id,
    'ruleName': ruleName,
    'title': title,
    'message': message,
    'severity': severity.name,
    'category': category,
    'score': score,
    'data': data,
    'evaluatedAt': evaluatedAt.toIso8601String(),
  };

  factory InsightResult.fromJson(Map<String, dynamic> json) => InsightResult(
    id: json['id'] as String,
    ruleName: json['ruleName'] as String,
    title: json['title'] as String,
    message: json['message'] as String,
    severity: InsightSeverity.values.firstWhere(
      (e) => e.name == json['severity'],
      orElse: () => InsightSeverity.info,
    ),
    category: json['category'] as String,
    score: (json['score'] as num?)?.toDouble(),
    data: json['data'] as Map<String, dynamic>? ?? {},
    evaluatedAt: json['evaluatedAt'] != null
        ? DateTime.parse(json['evaluatedAt'] as String)
        : DateTime.now(),
  );
}

/// Base class for all insight rules
abstract class InsightRule {
  String get name;
  String get category;

  /// Evaluate the rule and return insight results
  /// Returns empty list if rule doesn't apply or no insights
  Future<List<InsightResult>> evaluate(InsightContext context);
}

/// Context containing all health data for rule evaluation
class InsightContext {
  // User data
  final String? userId;
  final double? weightKg;
  final double? heightCm;
  final String? gender;
  final DateTime? dateOfBirth;
  final String? fitnessGoal;

  // Today's data
  final double? todaySteps;
  final double? todayCalories;
  final double? todayProtein;
  final double? todayWater;
  final int? todayWorkoutMinutes;
  final double? todaySleepHours;

  // Recent data (last 7 days)
  final List<double>? weeklySteps;
  final List<double>? weeklySleep;
  final List<int>? weeklyWorkoutMinutes;
  final List<double>? weeklyWater;

  // Health metrics
  final double? latestBMI;
  final int? latestSystolicBP;
  final int? latestDiastolicBP;
  final double? latestGlucose;

  // Cycle tracking (for female users)
  final int? daysSincePeriod;
  final int? cycleLength;
  final bool? isOnPeriod;

  // Streak data
  final int? currentStreak;
  final int? longestStreak;

  // Workout frequency
  final int? workoutsThisWeek;

  InsightContext({
    this.userId,
    this.weightKg,
    this.heightCm,
    this.gender,
    this.dateOfBirth,
    this.fitnessGoal,
    this.todaySteps,
    this.todayCalories,
    this.todayProtein,
    this.todayWater,
    this.todayWorkoutMinutes,
    this.todaySleepHours,
    this.weeklySteps,
    this.weeklySleep,
    this.weeklyWorkoutMinutes,
    this.weeklyWater,
    this.latestBMI,
    this.latestSystolicBP,
    this.latestDiastolicBP,
    this.latestGlucose,
    this.daysSincePeriod,
    this.cycleLength,
    this.isOnPeriod,
    this.currentStreak,
    this.longestStreak,
    this.workoutsThisWeek,
  });

  int? get age {
    if (dateOfBirth == null) return null;
    final now = DateTime.now();
    int age = now.year - dateOfBirth!.year;
    if (now.month < dateOfBirth!.month ||
        (now.month == dateOfBirth!.month && now.day < dateOfBirth!.day)) {
      age--;
    }
    return age;
  }

  double? get bmi => latestBMI ?? _calculateBMI();

  double? _calculateBMI() {
    if (weightKg == null || heightCm == null || heightCm! <= 0) return null;
    final heightM = heightCm! / 100;
    return weightKg! / (heightM * heightM);
  }
}

/// User feedback on an insight
enum InsightFeedback {
  thumbsUp, // Helpful
  thumbsDown; // Not helpful

  String get emoji => this == thumbsUp ? '👍' : '👎';
}

/// Store for user feedback on insights
class InsightFeedbackStore {
  static const String _boxName = 'insight_feedback_box';

  Future<Box> get _box async {
    if (!Hive.isBoxOpen(_boxName)) {
      return await Hive.openBox(_boxName);
    }
    return Hive.box(_boxName);
  }

  /// Record user feedback on an insight
  Future<void> recordFeedback(
    String insightId,
    InsightFeedback feedback,
  ) async {
    final box = await _box;
    await box.put(insightId, feedback.name);
  }

  /// Get feedback for an insight
  Future<InsightFeedback?> getFeedback(String insightId) async {
    final box = await _box;
    final value = box.get(insightId);
    if (value == null) return null;
    return InsightFeedback.values.firstWhere(
      (e) => e.name == value,
      orElse: () => InsightFeedback.thumbsUp,
    );
  }

  /// Check if an insight should be suppressed
  Future<bool> isSuppressed(String insightId) async {
    final feedback = await getFeedback(insightId);
    return feedback == InsightFeedback.thumbsDown;
  }

  /// Get all suppressed insight IDs
  Future<Set<String>> getSuppressedInsights() async {
    final box = await _box;
    final suppressed = <String>{};
    for (final key in box.keys) {
      if (box.get(key) == InsightFeedback.thumbsDown.name) {
        suppressed.add(key as String);
      }
    }
    return suppressed;
  }

  /// Clear feedback for an insight
  Future<void> clearFeedback(String insightId) async {
    final box = await _box;
    await box.delete(insightId);
  }
}

/// Main rule engine that evaluates all rules
class InsightRuleEngine {
  final List<InsightRule> _rules = [];
  final InsightFeedbackStore _feedbackStore = InsightFeedbackStore();

  InsightRuleEngine() {
    _registerAllRules();
  }

  void _registerAllRules() {
    // Register all rules from Section 11.13
    _rules.addAll([
      // Sleep rules
      SleepQualityRule(),
      SleepDebtRule(),
      SleepConsistencyRule(),

      // Steps rules
      StepsGoalRule(),
      SedentaryAlertRule(),
      ActiveMinutesRule(),

      // Water rules
      HydrationRule(),
      DehydrationAlertRule(),

      // Workout rules
      WorkoutFrequencyRule(),
      RestDayRule(),
      WorkoutStreakRule(),

      // Nutrition rules
      ProteinIntakeRule(),
      CalorieBalanceRule(),
      MacroBalanceRule(),

      // Cycle rules (for female users)
      PeriodPredictionRule(),
      FertileWindowRule(),
      CycleIrregularityRule(),

      // Streak rules
      StreakMilestoneRule(),
      StreakAtRiskRule(),

      // Health metrics
      BloodPressureRule(),
      GlucoseRule(),
      BurnoutRiskRule(),
      BMICategoryRule(),

      // Fasting rules
      FastingWindowRule(),
      FastingStreakRule(),
    ]);
  }

  /// Evaluate all rules and return top insights
  Future<List<InsightResult>> evaluate({
    required InsightContext context,
    int maxInsights = 2,
  }) async {
    final allResults = <InsightResult>[];
    final suppressedIds = await _feedbackStore.getSuppressedInsights();

    for (final rule in _rules) {
      try {
        final results = await rule.evaluate(context);
        for (final result in results) {
          // Skip suppressed insights
          if (!suppressedIds.contains(result.id)) {
            allResults.add(result);
          }
        }
      } catch (e) {
        // Skip failed rules
        continue;
      }
    }

    // Sort by severity priority and score
    allResults.sort((a, b) {
      // First by severity
      final severityOrder = {
        InsightSeverity.danger: 0,
        InsightSeverity.warning: 1,
        InsightSeverity.success: 2,
        InsightSeverity.info: 3,
      };
      final severityCompare = severityOrder[a.severity]!.compareTo(
        severityOrder[b.severity]!,
      );
      if (severityCompare != 0) return severityCompare;

      // Then by score (higher first)
      return (b.score ?? 50).compareTo(a.score ?? 50);
    });

    return allResults.take(maxInsights).toList();
  }

  /// Record user feedback on an insight
  Future<void> recordFeedback(
    String insightId,
    InsightFeedback feedback,
  ) async {
    await _feedbackStore.recordFeedback(insightId, feedback);
  }
}

// ============================================
// RULE IMPLEMENTATIONS - Section 11.13
// ============================================

// ============== SLEEP RULES ==============

class SleepQualityRule extends InsightRule {
  @override
  String get name => 'sleep_quality';
  @override
  String get category => 'sleep';

  @override
  Future<List<InsightResult>> evaluate(InsightContext context) async {
    final sleep = context.todaySleepHours;
    if (sleep == null) return [];

    if (sleep >= 7 && sleep <= 9) {
      return [
        InsightResult(
          id: 'sleep_quality_good',
          ruleName: name,
          title: 'Great Sleep!',
          message:
              'You got ${sleep.toStringAsFixed(1)} hours of sleep. Keep it up!',
          severity: InsightSeverity.success,
          category: category,
          score: 90,
        ),
      ];
    } else if (sleep < 6) {
      return [
        InsightResult(
          id: 'sleep_quality_poor',
          ruleName: name,
          title: 'Sleep Deficit',
          message:
              'Only ${sleep.toStringAsFixed(1)} hours. Aim for 7-9 hours for optimal recovery.',
          severity: InsightSeverity.warning,
          category: category,
          score: 70,
        ),
      ];
    }
    return [];
  }
}

class SleepDebtRule extends InsightRule {
  @override
  String get name => 'sleep_debt';
  @override
  String get category => 'sleep';

  @override
  Future<List<InsightResult>> evaluate(InsightContext context) async {
    final weeklySleep = context.weeklySleep;
    if (weeklySleep == null || weeklySleep.isEmpty) return [];

    final avgSleep = weeklySleep.reduce((a, b) => a + b) / weeklySleep.length;
    final totalDebt = (7 * 7) - (avgSleep * 7); // 7 hours * 7 days

    if (totalDebt > 7) {
      return [
        InsightResult(
          id: 'sleep_debt_high',
          ruleName: name,
          title: 'Sleep Debt Accumulating',
          message:
              'You\'ve accumulated ~${totalDebt.toStringAsFixed(0)} hours of sleep debt this week.',
          severity: InsightSeverity.danger,
          category: category,
          score: 85,
        ),
      ];
    } else if (totalDebt > 3) {
      return [
        InsightResult(
          id: 'sleep_debt_moderate',
          ruleName: name,
          title: 'Minor Sleep Debt',
          message:
              'You\'re slightly behind on sleep. Try to get more rest this weekend.',
          severity: InsightSeverity.warning,
          category: category,
          score: 60,
        ),
      ];
    }
    return [];
  }
}

class SleepConsistencyRule extends InsightRule {
  @override
  String get name => 'sleep_consistency';
  @override
  String get category => 'sleep';

  @override
  Future<List<InsightResult>> evaluate(InsightContext context) async {
    final weeklySleep = context.weeklySleep;
    if (weeklySleep == null || weeklySleep.length < 5) return [];

    // Calculate standard deviation
    final mean = weeklySleep.reduce((a, b) => a + b) / weeklySleep.length;
    final variance =
        weeklySleep
            .map((s) => (s - mean) * (s - mean))
            .reduce((a, b) => a + b) /
        weeklySleep.length;
    final stdDev = variance > 0 ? variance : 0.0;

    if (stdDev < 0.5) {
      return [
        InsightResult(
          id: 'sleep_consistent',
          ruleName: name,
          title: 'Consistent Sleep Schedule',
          message: 'Your sleep schedule is very consistent. Great job!',
          severity: InsightSeverity.success,
          category: category,
          score: 85,
        ),
      ];
    } else if (stdDev > 1.5) {
      return [
        InsightResult(
          id: 'sleep_inconsistent',
          ruleName: name,
          title: 'Irregular Sleep Pattern',
          message:
              'Your sleep times vary significantly. Try to maintain a consistent schedule.',
          severity: InsightSeverity.warning,
          category: category,
          score: 65,
        ),
      ];
    }
    return [];
  }
}

// ============== STEPS RULES ==============

class StepsGoalRule extends InsightRule {
  @override
  String get name => 'steps_goal';
  @override
  String get category => 'steps';

  @override
  Future<List<InsightResult>> evaluate(InsightContext context) async {
    final steps = context.todaySteps;
    if (steps == null) return [];

    if (steps >= 10000) {
      return [
        InsightResult(
          id: 'steps_goal_reached',
          ruleName: name,
          title: 'Daily Steps Goal Met! 🎯',
          message:
              'You\'ve reached 10,000 steps today! Keep the momentum going.',
          severity: InsightSeverity.success,
          category: category,
          score: 95,
        ),
      ];
    } else if (steps >= 7500) {
      final remaining = 10000 - steps;
      return [
        InsightResult(
          id: 'steps_almost_there',
          ruleName: name,
          title: 'Almost There!',
          message: 'Just $remaining more steps to reach your daily goal.',
          severity: InsightSeverity.info,
          category: category,
          score: 70,
        ),
      ];
    } else if (steps < 3000) {
      return [
        InsightResult(
          id: 'steps_low_activity',
          ruleName: name,
          title: 'Low Activity Today',
          message: 'You\'ve taken fewer than 3,000 steps. Try a short walk!',
          severity: InsightSeverity.warning,
          category: category,
          score: 75,
        ),
      ];
    }
    return [];
  }
}

class SedentaryAlertRule extends InsightRule {
  @override
  String get name => 'sedentary_alert';
  @override
  String get category => 'steps';

  @override
  Future<List<InsightResult>> evaluate(InsightContext context) async {
    final steps = context.todaySteps;
    final hour = DateTime.now().hour;

    // Check if it's past 8 PM and steps are low
    if (hour >= 20 && steps != null && steps < 2000) {
      return [
        InsightResult(
          id: 'sedentary_evening',
          ruleName: name,
          title: 'Sedentary Evening',
          message:
              'You\'ve been mostly inactive today. A short walk before bed can help!',
          severity: InsightSeverity.warning,
          category: category,
          score: 60,
        ),
      ];
    }
    return [];
  }
}

class ActiveMinutesRule extends InsightRule {
  @override
  String get name => 'active_minutes';
  @override
  String get category => 'steps';

  @override
  Future<List<InsightResult>> evaluate(InsightContext context) async {
    // Use weekly data to estimate active minutes
    final weeklySteps = context.weeklySteps;
    if (weeklySteps == null || weeklySteps.isEmpty) return [];

    // Estimate active minutes (roughly 100 steps per minute)
    final avgDailySteps =
        weeklySteps.reduce((a, b) => a + b) / weeklySteps.length;
    final estimatedActiveMinutes = (avgDailySteps / 100).round();

    if (estimatedActiveMinutes >= 30) {
      return [
        InsightResult(
          id: 'active_minutes_good',
          ruleName: name,
          title: 'Active Lifestyle',
          message:
              'You\'re averaging $estimatedActiveMinutes active minutes daily. Excellent!',
          severity: InsightSeverity.success,
          category: category,
          score: 85,
        ),
      ];
    } else if (estimatedActiveMinutes < 15) {
      return [
        InsightResult(
          id: 'active_minutes_low',
          ruleName: name,
          title: 'Increase Activity',
          message:
              'Try to get at least 30 minutes of activity daily for better health.',
          severity: InsightSeverity.warning,
          category: category,
          score: 70,
        ),
      ];
    }
    return [];
  }
}

// ============== WATER RULES ==============

class HydrationRule extends InsightRule {
  @override
  String get name => 'hydration';
  @override
  String get category => 'water';

  @override
  Future<List<InsightResult>> evaluate(InsightContext context) async {
    final water = context.todayWater;
    final weight = context.weightKg ?? 70;
    final target = weight * 0.033; // 33ml per kg

    if (water == null) return [];

    if (water >= target) {
      return [
        InsightResult(
          id: 'hydration_good',
          ruleName: name,
          title: 'Well Hydrated! 💧',
          message: 'You\'ve met your daily water target. Great job!',
          severity: InsightSeverity.success,
          category: category,
          score: 90,
        ),
      ];
    } else if (water < target * 0.5) {
      return [
        InsightResult(
          id: 'hydration_low',
          ruleName: name,
          title: 'Stay Hydrated',
          message:
              'You\'ve only had ${water.toStringAsFixed(1)}L. Aim for ${target.toStringAsFixed(1)}L today.',
          severity: InsightSeverity.warning,
          category: category,
          score: 75,
        ),
      ];
    }
    return [];
  }
}

class DehydrationAlertRule extends InsightRule {
  @override
  String get name => 'dehydration_alert';
  @override
  String get category => 'water';

  @override
  Future<List<InsightResult>> evaluate(InsightContext context) async {
    final water = context.todayWater;
    final hour = DateTime.now().hour;

    // Check afternoon hydration
    if (hour >= 14 && water != null && water < 1.0) {
      return [
        InsightResult(
          id: 'afternoon_dehydration',
          ruleName: name,
          title: 'Hydration Check',
          message:
              'It\'s past 2 PM and you\'ve only had ${water.toStringAsFixed(1)}L of water. Drink up!',
          severity: InsightSeverity.warning,
          category: category,
          score: 65,
        ),
      ];
    }
    return [];
  }
}

// ============== WORKOUT RULES ==============

class WorkoutFrequencyRule extends InsightRule {
  @override
  String get name => 'workout_frequency';
  @override
  String get category => 'workout';

  @override
  Future<List<InsightResult>> evaluate(InsightContext context) async {
    final workouts = context.workoutsThisWeek;
    if (workouts == null) return [];

    if (workouts >= 4) {
      return [
        InsightResult(
          id: 'workout_frequency_good',
          ruleName: name,
          title: 'Active Week! 💪',
          message: 'You\'ve worked out $workouts times this week. Keep it up!',
          severity: InsightSeverity.success,
          category: category,
          score: 90,
        ),
      ];
    } else if (workouts == 0) {
      return [
        InsightResult(
          id: 'workout_frequency_none',
          ruleName: name,
          title: 'No Workouts This Week',
          message: 'Consider adding some physical activity to your routine.',
          severity: InsightSeverity.warning,
          category: category,
          score: 70,
        ),
      ];
    }
    return [];
  }
}

class RestDayRule extends InsightRule {
  @override
  String get name => 'rest_day';
  @override
  String get category => 'workout';

  @override
  Future<List<InsightResult>> evaluate(InsightContext context) async {
    final todayMinutes = context.todayWorkoutMinutes;
    final weeklyMinutes = context.weeklyWorkoutMinutes;

    if (weeklyMinutes == null || weeklyMinutes.isEmpty) return [];

    final totalWeeklyMinutes = weeklyMinutes.reduce((a, b) => a + b);

    // If user has worked out heavily for 5+ days, suggest rest
    final intenseDays = weeklyMinutes.where((m) => m >= 45).length;

    if (intenseDays >= 5) {
      return [
        InsightResult(
          id: 'rest_day_needed',
          ruleName: name,
          title: 'Consider a Rest Day',
          message:
              'You\'ve had $intenseDays intense workouts this week. Your body needs recovery time!',
          severity: InsightSeverity.warning,
          category: category,
          score: 70,
        ),
      ];
    }
    return [];
  }
}

class WorkoutStreakRule extends InsightRule {
  @override
  String get name => 'workout_streak';
  @override
  String get category => 'workout';

  @override
  Future<List<InsightResult>> evaluate(InsightContext context) async {
    final streak = context.currentStreak;
    if (streak == null || streak < 3) return [];

    if (streak >= 7) {
      return [
        InsightResult(
          id: 'workout_streak_amazing',
          ruleName: name,
          title: 'Incredible Streak! 🔥',
          message: '$streak days of consistent workouts! You\'re on fire!',
          severity: InsightSeverity.success,
          category: category,
          score: 95,
        ),
      ];
    } else if (streak >= 3) {
      return [
        InsightResult(
          id: 'workout_streak_good',
          ruleName: name,
          title: 'Great Streak!',
          message: '$streak day workout streak. Keep it going!',
          severity: InsightSeverity.success,
          category: category,
          score: 80,
        ),
      ];
    }
    return [];
  }
}

// ============== NUTRITION RULES ==============

class ProteinIntakeRule extends InsightRule {
  @override
  String get name => 'protein_intake';
  @override
  String get category => 'nutrition';

  @override
  Future<List<InsightResult>> evaluate(InsightContext context) async {
    final protein = context.todayProtein;
    final weight = context.weightKg ?? 70;
    final target = weight * 1.6; // 1.6g per kg for active people

    if (protein == null) return [];

    if (protein >= target) {
      return [
        InsightResult(
          id: 'protein_good',
          ruleName: name,
          title: 'Protein Goal Met! 🥩',
          message:
              'You\'ve consumed ${protein.toStringAsFixed(0)}g protein. Great for muscle recovery!',
          severity: InsightSeverity.success,
          category: category,
          score: 90,
        ),
      ];
    } else if (protein < target * 0.5) {
      return [
        InsightResult(
          id: 'protein_low',
          ruleName: name,
          title: 'Low Protein Intake',
          message:
              'Only ${protein.toStringAsFixed(0)}g today. Aim for ${target.toStringAsFixed(0)}g for better results.',
          severity: InsightSeverity.warning,
          category: category,
          score: 70,
        ),
      ];
    }
    return [];
  }
}

class CalorieBalanceRule extends InsightRule {
  @override
  String get name => 'calorie_balance';
  @override
  String get category => 'nutrition';

  @override
  Future<List<InsightResult>> evaluate(InsightContext context) async {
    final calories = context.todayCalories;
    if (calories == null) return [];

    // Assuming ~2000 calorie target
    if (calories > 2500) {
      return [
        InsightResult(
          id: 'calories_high',
          ruleName: name,
          title: 'High Calorie Intake',
          message:
              'You\'ve consumed ${calories.toInt()} calories today. Consider a lighter dinner.',
          severity: InsightSeverity.warning,
          category: category,
          score: 65,
        ),
      ];
    } else if (calories < 800) {
      return [
        InsightResult(
          id: 'calories_low',
          ruleName: name,
          title: 'Very Low Calories',
          message:
              'You\'ve only had ${calories.toInt()} calories. Make sure you\'re eating enough!',
          severity: InsightSeverity.warning,
          category: category,
          score: 75,
        ),
      ];
    }
    return [];
  }
}

class MacroBalanceRule extends InsightRule {
  @override
  String get name => 'macro_balance';
  @override
  String get category => 'nutrition';

  @override
  Future<List<InsightResult>> evaluate(InsightContext context) async {
    final protein = context.todayProtein ?? 0;
    final calories = context.todayCalories ?? 0;

    if (calories <= 0) return [];

    // Calculate protein percentage of total calories
    final proteinCalories = protein * 4;
    final proteinPercent = (proteinCalories / calories) * 100;

    if (proteinPercent < 10) {
      return [
        InsightResult(
          id: 'macro_low_protein',
          ruleName: name,
          title: 'Increase Protein',
          message:
              'Protein is only ${proteinPercent.toStringAsFixed(0)}% of your calories. Aim for 20-30%.',
          severity: InsightSeverity.warning,
          category: category,
          score: 60,
        ),
      ];
    }
    return [];
  }
}

// ============== CYCLE RULES (Female) ==============

class PeriodPredictionRule extends InsightRule {
  @override
  String get name => 'period_prediction';
  @override
  String get category => 'cycle';

  @override
  Future<List<InsightResult>> evaluate(InsightContext context) async {
    // Only for female users
    if (context.gender?.toLowerCase() != 'female') return [];

    final daysSince = context.daysSincePeriod;
    final cycleLength = context.cycleLength ?? 28;

    if (daysSince == null) return [];

    final daysUntilPeriod = cycleLength - daysSince;

    if (daysUntilPeriod <= 3 && daysUntilPeriod > 0) {
      return [
        InsightResult(
          id: 'period_coming',
          ruleName: name,
          title: 'Period Expected Soon',
          message:
              'Your period is expected in $daysUntilPeriod days. Stay prepared!',
          severity: InsightSeverity.info,
          category: category,
          score: 60,
        ),
      ];
    } else if (daysUntilPeriod <= 0) {
      return [
        InsightResult(
          id: 'period_overdue',
          ruleName: name,
          title: 'Period Overdue',
          message:
              'Your period is ${(-daysUntilPeriod)} days late. Consider taking a test if sexually active.',
          severity: InsightSeverity.info,
          category: category,
          score: 70,
        ),
      ];
    }
    return [];
  }
}

class FertileWindowRule extends InsightRule {
  @override
  String get name => 'fertile_window';
  @override
  String get category => 'cycle';

  @override
  Future<List<InsightResult>> evaluate(InsightContext context) async {
    if (context.gender?.toLowerCase() != 'female') return [];

    final daysSince = context.daysSincePeriod;
    final cycleLength = context.cycleLength ?? 28;

    if (daysSince == null) return [];

    // Fertile window is typically days 10-16 of cycle
    if (daysSince >= 10 && daysSince <= 16) {
      return [
        InsightResult(
          id: 'fertile_window',
          ruleName: name,
          title: 'Fertile Window',
          message:
              'You\'re in your fertile window (days 10-16). If trying to conceive, this is optimal timing.',
          severity: InsightSeverity.info,
          category: category,
          score: 50,
        ),
      ];
    }
    return [];
  }
}

class CycleIrregularityRule extends InsightRule {
  @override
  String get name => 'cycle_irregularity';
  @override
  String get category => 'cycle';

  @override
  Future<List<InsightResult>> evaluate(InsightContext context) async {
    if (context.gender?.toLowerCase() != 'female') return [];

    final cycleLength = context.cycleLength;

    if (cycleLength == null) return [];

    if (cycleLength < 21 || cycleLength > 35) {
      return [
        InsightResult(
          id: 'cycle_irregular',
          ruleName: name,
          title: 'Irregular Cycle',
          message:
              'Your cycle length (${cycleLength} days) is outside the normal range (21-35 days).',
          severity: InsightSeverity.warning,
          category: category,
          score: 70,
        ),
      ];
    }
    return [];
  }
}

// ============== STREAK RULES ==============

class StreakMilestoneRule extends InsightRule {
  @override
  String get name => 'streak_milestone';
  @override
  String get category => 'streak';

  @override
  Future<List<InsightResult>> evaluate(InsightContext context) async {
    final streak = context.currentStreak;
    final longest = context.longestStreak;

    if (streak == null) return [];

    // Check for milestone streaks
    final milestones = [7, 14, 21, 30, 50, 100, 365];
    if (milestones.contains(streak)) {
      return [
        InsightResult(
          id: 'streak_milestone_$streak',
          ruleName: name,
          title: '🎯 $streak Day Milestone!',
          message: 'Amazing! You\'ve maintained your streak for $streak days!',
          severity: InsightSeverity.success,
          category: category,
          score: 100,
        ),
      ];
    }

    // Check if beating longest streak
    if (longest != null && streak > longest) {
      return [
        InsightResult(
          id: 'streak_new_record',
          ruleName: name,
          title: 'New Personal Record! 🏆',
          message: 'You\'ve broken your longest streak of $longest days!',
          severity: InsightSeverity.success,
          category: category,
          score: 95,
        ),
      ];
    }
    return [];
  }
}

class StreakAtRiskRule extends InsightRule {
  @override
  String get name => 'streak_at_risk';
  @override
  String get category => 'streak';

  @override
  Future<List<InsightResult>> evaluate(InsightContext context) async {
    final streak = context.currentStreak;
    if (streak == null || streak < 3) return [];

    // Check if no activity today
    final todaySteps = context.todaySteps;
    final todayWorkout = context.todayWorkoutMinutes;

    if ((todaySteps == null || todaySteps < 1000) &&
        (todayWorkout == null || todayWorkout == 0)) {
      return [
        InsightResult(
          id: 'streak_at_risk',
          ruleName: name,
          title: 'Streak at Risk! ⚠️',
          message:
              'Your $streak day streak is in danger. Do something today to maintain it!',
          severity: InsightSeverity.warning,
          category: category,
          score: 85,
        ),
      ];
    }
    return [];
  }
}

// ============== HEALTH METRICS RULES ==============

class BloodPressureRule extends InsightRule {
  @override
  String get name => 'blood_pressure';
  @override
  String get category => 'health';

  @override
  Future<List<InsightResult>> evaluate(InsightContext context) async {
    final systolic = context.latestSystolicBP;
    final diastolic = context.latestDiastolicBP;

    if (systolic == null || diastolic == null) return [];

    // Normal: <120/80
    // Elevated: 120-129/<80
    // High Stage 1: 130-139/80-89
    // High Stage 2: >=140/>=90

    if (systolic >= 140 || diastolic >= 90) {
      return [
        InsightResult(
          id: 'bp_high',
          ruleName: name,
          title: 'High Blood Pressure',
          message:
              'Your BP is ${systolic}/${diastolic}. Please consult a healthcare provider.',
          severity: InsightSeverity.danger,
          category: category,
          score: 90,
        ),
      ];
    } else if (systolic >= 130 || diastolic >= 80) {
      return [
        InsightResult(
          id: 'bp_elevated',
          ruleName: name,
          title: 'Elevated Blood Pressure',
          message:
              'Your BP is ${systolic}/${diastolic}. Consider lifestyle modifications.',
          severity: InsightSeverity.warning,
          category: category,
          score: 70,
        ),
      ];
    } else if (systolic < 90 || diastolic < 60) {
      return [
        InsightResult(
          id: 'bp_low',
          ruleName: name,
          title: 'Low Blood Pressure',
          message:
              'Your BP is ${systolic}/${diastolic}. If you feel dizzy, consult a doctor.',
          severity: InsightSeverity.warning,
          category: category,
          score: 65,
        ),
      ];
    }
    return [];
  }
}

class GlucoseRule extends InsightRule {
  @override
  String get name => 'glucose';
  @override
  String get category => 'health';

  @override
  Future<List<InsightResult>> evaluate(InsightContext context) async {
    final glucose = context.latestGlucose;
    if (glucose == null) return [];

    // Fasting glucose: Normal <100, Prediabetes 100-125, Diabetes >=126
    if (glucose >= 126) {
      return [
        InsightResult(
          id: 'glucose_high',
          ruleName: name,
          title: 'High Blood Sugar',
          message:
              'Your fasting glucose is ${glucose.toInt()} mg/dL. Please consult a doctor.',
          severity: InsightSeverity.danger,
          category: category,
          score: 90,
        ),
      ];
    } else if (glucose >= 100) {
      return [
        InsightResult(
          id: 'glucose_prediabetes',
          ruleName: name,
          title: 'Prediabetes Range',
          message:
              'Your fasting glucose is ${glucose.toInt()} mg/dL. Consider dietary changes.',
          severity: InsightSeverity.warning,
          category: category,
          score: 75,
        ),
      ];
    }
    return [];
  }
}

class BurnoutRiskRule extends InsightRule {
  @override
  String get name => 'burnout_risk';
  @override
  String get category => 'health';

  @override
  Future<List<InsightResult>> evaluate(InsightContext context) async {
    final weeklyWorkouts = context.weeklyWorkoutMinutes;
    final weeklySleep = context.weeklySleep;

    if (weeklyWorkouts == null || weeklySleep == null) return [];
    if (weeklyWorkouts.isEmpty || weeklySleep.isEmpty) return [];

    final totalWorkoutMinutes = weeklyWorkouts.reduce((a, b) => a + b);
    final avgSleep = weeklySleep.reduce((a, b) => a + b) / weeklySleep.length;

    // High workout + low sleep = burnout risk
    if (totalWorkoutMinutes > 300 && avgSleep < 6) {
      return [
        InsightResult(
          id: 'burnout_risk',
          ruleName: name,
          title: 'Burnout Risk ⚠️',
          message:
              'High activity (${totalWorkoutMinutes}min) + low sleep (${avgSleep.toStringAsFixed(1)}h) = burnout risk.',
          severity: InsightSeverity.danger,
          category: category,
          score: 85,
        ),
      ];
    }
    return [];
  }
}

class BMICategoryRule extends InsightRule {
  @override
  String get name => 'bmi_category';
  @override
  String get category => 'health';

  @override
  Future<List<InsightResult>> evaluate(InsightContext context) async {
    final bmi = context.bmi;
    if (bmi == null) return [];

    if (bmi >= 30) {
      return [
        InsightResult(
          id: 'bmi_obese',
          ruleName: name,
          title: 'Obesity Range',
          message:
              'Your BMI is ${bmi.toStringAsFixed(1)}. Consider consulting a healthcare provider.',
          severity: InsightSeverity.warning,
          category: category,
          score: 75,
        ),
      ];
    } else if (bmi >= 25) {
      return [
        InsightResult(
          id: 'bmi_overweight',
          ruleName: name,
          title: 'Overweight Range',
          message:
              'Your BMI is ${bmi.toStringAsFixed(1)}. Small lifestyle changes can help.',
          severity: InsightSeverity.info,
          category: category,
          score: 60,
        ),
      ];
    } else if (bmi < 18.5) {
      return [
        InsightResult(
          id: 'bmi_underweight',
          ruleName: name,
          title: 'Underweight',
          message:
              'Your BMI is ${bmi.toStringAsFixed(1)}. Consider nutritional counseling.',
          severity: InsightSeverity.warning,
          category: category,
          score: 70,
        ),
      ];
    }
    return [];
  }
}

// ============== FASTING RULES ==============

class FastingWindowRule extends InsightRule {
  @override
  String get name => 'fasting_window';
  @override
  String get category => 'fasting';

  @override
  Future<List<InsightResult>> evaluate(InsightContext context) async {
    // This would need actual fasting data - placeholder
    // Real implementation would check last fast duration
    return [];
  }
}

class FastingStreakRule extends InsightRule {
  @override
  String get name => 'fasting_streak';
  @override
  String get category => 'fasting';

  @override
  Future<List<InsightResult>> evaluate(InsightContext context) async {
    // This would need actual fasting streak data
    return [];
  }
}
