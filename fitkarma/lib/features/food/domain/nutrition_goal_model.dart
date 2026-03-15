// lib/features/food/domain/nutrition_goal_model.dart
import 'package:hive/hive.dart';

part 'nutrition_goal_model.g.dart';

/// Activity level multipliers for TDEE calculation
class ActivityMultiplier {
  static const double sedentary = 1.2;
  static const double lightlyActive = 1.375;
  static const double moderatelyActive = 1.55;
  static const double veryActive = 1.725;
  static const double extremelyActive = 1.9;

  static double fromActivityLevel(String? activityLevel) {
    switch (activityLevel) {
      case 'sedentary':
        return sedentary;
      case 'lightly_active':
        return lightlyActive;
      case 'moderately_active':
        return moderatelyActive;
      case 'very_active':
        return veryActive;
      case 'extremely_active':
        return extremelyActive;
      default:
        return sedentary;
    }
  }
}

/// Fitness goal adjustments for TDEE
class GoalAdjustment {
  static const double loseWeight = 0.8; // 20% deficit
  static const double maintain = 1.0;
  static const double gainMuscle = 1.1; // 10% surplus
  static const double endurance = 1.15; // 15% surplus for endurance

  static double fromGoal(String? goal) {
    switch (goal) {
      case 'lose_weight':
        return loseWeight;
      case 'gain_muscle':
        return gainMuscle;
      case 'endurance':
        return endurance;
      case 'maintain':
      default:
        return maintain;
    }
  }
}

/// Nutrition goals model - stored in Hive, synced to Appwrite
@HiveType(typeId: 11)
class NutritionGoal extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String userId;

  @HiveField(2)
  double tdee; // Total Daily Energy Expenditure

  @HiveField(3)
  double targetCalories;

  @HiveField(4)
  double proteinGrams;

  @HiveField(5)
  double carbsGrams;

  @HiveField(6)
  double fatGrams;

  @HiveField(7)
  double fiberGrams; // Recommended fiber intake

  @HiveField(8)
  double waterLiters; // Daily water intake target

  @HiveField(9)
  // Micronutrient targets (mg for minerals, mcg/IU for vitamins)
  double ironMg;
  @HiveField(10)
  double vitaminB12Mcg;
  @HiveField(11)
  double vitaminDIU;
  @HiveField(12)
  double calciumMg;

  @HiveField(13)
  String activityLevel;

  @HiveField(14)
  String fitnessGoal;

  @HiveField(15)
  DateTime calculatedAt;

  @HiveField(16)
  DateTime validUntil;

  @HiveField(17)
  String syncStatus;

  NutritionGoal({
    required this.id,
    required this.userId,
    required this.tdee,
    required this.targetCalories,
    required this.proteinGrams,
    required this.carbsGrams,
    required this.fatGrams,
    required this.fiberGrams,
    required this.waterLiters,
    required this.ironMg,
    required this.vitaminB12Mcg,
    required this.vitaminDIU,
    required this.calciumMg,
    required this.activityLevel,
    required this.fitnessGoal,
    required this.calculatedAt,
    required this.validUntil,
    this.syncStatus = 'pending',
  });

  /// Calculate TDEE using Mifflin-St Jeor Equation (Section 11.7)
  ///
  /// For men: BMR = 10 × weight(kg) + 6.25 × height(cm) - 5 × age(y) + 5
  /// For women: BMR = 10 × weight(kg) + 6.25 × height(cm) - 5 × age(y) - 161
  ///
  /// TDEE = BMR × Activity Multiplier
  static double calculateTDEE({
    required double weightKg,
    required double heightCm,
    required int age,
    required String gender,
    required String activityLevel,
  }) {
    double bmr;

    // Calculate BMR using Mifflin-St Jeor formula
    final weightBase = 10 * weightKg;
    final heightBase = 6.25 * heightCm;
    final ageBase = 5 * age;

    if (gender.toLowerCase() == 'male' || gender.toLowerCase() == 'm') {
      bmr = weightBase + heightBase - ageBase + 5;
    } else {
      bmr = weightBase + heightBase - ageBase - 161;
    }

    // Apply activity multiplier
    final multiplier = ActivityMultiplier.fromActivityLevel(activityLevel);
    return bmr * multiplier;
  }

  /// Create NutritionGoal from user profile data
  /// Uses Mifflin-St Jeor formula with macro split: 55% carbs / 20% protein / 25% fat
  factory NutritionGoal.fromUserProfile({
    required String userId,
    required double weightKg,
    required double heightCm,
    required int age,
    required String gender,
    required String activityLevel,
    required String fitnessGoal,
  }) {
    // Calculate TDEE
    final tdee = calculateTDEE(
      weightKg: weightKg,
      heightCm: heightCm,
      age: age,
      gender: gender,
      activityLevel: activityLevel,
    );

    // Apply goal adjustment
    final goalMultiplier = GoalAdjustment.fromGoal(fitnessGoal);
    final targetCalories = tdee * goalMultiplier;

    // Calculate macros based on percentages
    // 55% carbs, 20% protein, 25% fat
    final carbsCalories = targetCalories * 0.55;
    final proteinCalories = targetCalories * 0.20;
    final fatCalories = targetCalories * 0.25;

    // Convert to grams (carbs/protein = 4 cal/g, fat = 9 cal/g)
    final carbsGrams = carbsCalories / 4;
    final proteinGrams = proteinCalories / 4;
    final fatGrams = fatCalories / 9;

    // Fiber: 25-30g recommended daily
    final fiberGrams = 25.0;

    // Water: 30-35ml per kg of body weight
    final waterLiters = (weightKg * 0.033).clamp(2.0, 4.0);

    // Micronutrient targets (RDA values)
    // Iron: 8mg men, 18mg women
    final ironMg =
        gender.toLowerCase() == 'female' || gender.toLowerCase() == 'f'
        ? 18.0
        : 8.0;
    // Vitamin B12: 2.4 mcg
    final vitaminB12Mcg = 2.4;
    // Vitamin D: 600 IU (some recommend 1000-2000)
    final vitaminDIU = 600.0;
    // Calcium: 1000mg
    final calciumMg = 1000.0;

    final now = DateTime.now();

    return NutritionGoal(
      id: now.millisecondsSinceEpoch.toString(),
      userId: userId,
      tdee: tdee,
      targetCalories: targetCalories,
      proteinGrams: proteinGrams,
      carbsGrams: carbsGrams,
      fatGrams: fatGrams,
      fiberGrams: fiberGrams,
      waterLiters: waterLiters,
      ironMg: ironMg,
      vitaminB12Mcg: vitaminB12Mcg,
      vitaminDIU: vitaminDIU,
      calciumMg: calciumMg,
      activityLevel: activityLevel,
      fitnessGoal: fitnessGoal,
      calculatedAt: now,
      validUntil: now.add(const Duration(days: 30)), // Valid for 30 days
      syncStatus: 'pending',
    );
  }

  /// Create default goals for a user
  factory NutritionGoal.createDefault(String userId) {
    final now = DateTime.now();
    return NutritionGoal(
      id: now.millisecondsSinceEpoch.toString(),
      userId: userId,
      tdee: 2000,
      targetCalories: 2000,
      proteinGrams: 100,
      carbsGrams: 275,
      fatGrams: 56,
      fiberGrams: 25,
      waterLiters: 2.5,
      ironMg: 8.0,
      vitaminB12Mcg: 2.4,
      vitaminDIU: 600,
      calciumMg: 1000,
      activityLevel: 'sedentary',
      fitnessGoal: 'maintain',
      calculatedAt: now,
      validUntil: now.add(const Duration(days: 30)),
      syncStatus: 'pending',
    );
  }

  /// Convert to JSON for Appwrite
  Map<String, dynamic> toAppwrite() => {
    'user_id': userId,
    'tdee': tdee,
    'target_calories': targetCalories,
    'protein_grams': proteinGrams,
    'carbs_grams': carbsGrams,
    'fat_grams': fatGrams,
    'fiber_grams': fiberGrams,
    'water_liters': waterLiters,
    'iron_mg': ironMg,
    'vitamin_b12_mcg': vitaminB12Mcg,
    'vitamin_d_iu': vitaminDIU,
    'calcium_mg': calciumMg,
    'activity_level': activityLevel,
    'fitness_goal': fitnessGoal,
    'calculated_at': calculatedAt.toIso8601String(),
    'valid_until': validUntil.toIso8601String(),
  };

  /// Copy with modifications
  NutritionGoal copyWith({
    String? id,
    String? userId,
    double? tdee,
    double? targetCalories,
    double? proteinGrams,
    double? carbsGrams,
    double? fatGrams,
    double? fiberGrams,
    double? waterLiters,
    double? ironMg,
    double? vitaminB12Mcg,
    double? vitaminDIU,
    double? calciumMg,
    String? activityLevel,
    String? fitnessGoal,
    DateTime? calculatedAt,
    DateTime? validUntil,
    String? syncStatus,
  }) {
    return NutritionGoal(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      tdee: tdee ?? this.tdee,
      targetCalories: targetCalories ?? this.targetCalories,
      proteinGrams: proteinGrams ?? this.proteinGrams,
      carbsGrams: carbsGrams ?? this.carbsGrams,
      fatGrams: fatGrams ?? this.fatGrams,
      fiberGrams: fiberGrams ?? this.fiberGrams,
      waterLiters: waterLiters ?? this.waterLiters,
      ironMg: ironMg ?? this.ironMg,
      vitaminB12Mcg: vitaminB12Mcg ?? this.vitaminB12Mcg,
      vitaminDIU: vitaminDIU ?? this.vitaminDIU,
      calciumMg: calciumMg ?? this.calciumMg,
      activityLevel: activityLevel ?? this.activityLevel,
      fitnessGoal: fitnessGoal ?? this.fitnessGoal,
      calculatedAt: calculatedAt ?? this.calculatedAt,
      validUntil: validUntil ?? this.validUntil,
      syncStatus: syncStatus ?? this.syncStatus,
    );
  }

  @override
  String toString() {
    return 'NutritionGoal(id: $id, tdee: $tdee, target: $targetCalories cal, '
        'P: $proteinGrams g, C: $carbsGrams g, F: $fatGrams g)';
  }
}

/// Traffic light status for nutrition tracking
enum NutritionStatus {
  good, // Green - on track (90-110% of target)
  warning, // Yellow - slightly off (75-89% or 111-125%)
  bad; // Red - significantly off (<75% or >125%)

  static NutritionStatus fromProgress(double consumed, double target) {
    if (target <= 0) return NutritionStatus.warning;

    final progress = consumed / target;

    if (progress >= 0.9 && progress <= 1.1) {
      return NutritionStatus.good;
    } else if ((progress >= 0.75 && progress < 0.9) ||
        (progress > 1.1 && progress <= 1.25)) {
      return NutritionStatus.warning;
    } else {
      return NutritionStatus.bad;
    }
  }

  String get emoji {
    switch (this) {
      case NutritionStatus.good:
        return '🟢';
      case NutritionStatus.warning:
        return '🟡';
      case NutritionStatus.bad:
        return '🔴';
    }
  }

  String get label {
    switch (this) {
      case NutritionStatus.good:
        return 'On Track';
      case NutritionStatus.warning:
        return 'Slightly Off';
      case NutritionStatus.bad:
        return 'Off Track';
    }
  }
}

/// Daily nutrition summary
class DailyNutrition {
  final DateTime date;
  final double consumedCalories;
  final double consumedProtein;
  final double consumedCarbs;
  final double consumedFat;
  final double consumedFiber;
  final double consumedWater;
  // Micronutrients
  final double consumedIron;
  final double consumedVitaminB12;
  final double consumedVitaminD;
  final double consumedCalcium;

  DailyNutrition({
    required this.date,
    required this.consumedCalories,
    required this.consumedProtein,
    required this.consumedCarbs,
    required this.consumedFat,
    required this.consumedFiber,
    required this.consumedWater,
    required this.consumedIron,
    required this.consumedVitaminB12,
    required this.consumedVitaminD,
    required this.consumedCalcium,
  });

  double get calorieProgress => 0; // Will be calculated with goals
  double get proteinProgress => 0;
  double get carbsProgress => 0;
  double get fatProgress => 0;

  NutritionStatus get calorieStatus =>
      NutritionStatus.fromProgress(consumedCalories, 2000);
  NutritionStatus get proteinStatus =>
      NutritionStatus.fromProgress(consumedProtein, 100);
  NutritionStatus get carbsStatus =>
      NutritionStatus.fromProgress(consumedCarbs, 275);
  NutritionStatus get fatStatus =>
      NutritionStatus.fromProgress(consumedFat, 56);
}

/// Micronutrient types for tracking
enum MicronutrientType {
  iron,
  vitaminB12,
  vitaminD,
  calcium;

  String get displayName {
    switch (this) {
      case MicronutrientType.iron:
        return 'Iron';
      case MicronutrientType.vitaminB12:
        return 'Vitamin B12';
      case MicronutrientType.vitaminD:
        return 'Vitamin D';
      case MicronutrientType.calcium:
        return 'Calcium';
    }
  }

  String get unit {
    switch (this) {
      case MicronutrientType.iron:
        return 'mg';
      case MicronutrientType.vitaminB12:
        return 'mcg';
      case MicronutrientType.vitaminD:
        return 'IU';
      case MicronutrientType.calcium:
        return 'mg';
    }
  }

  double get rda {
    switch (this) {
      case MicronutrientType.iron:
        return 8.0; // mg
      case MicronutrientType.vitaminB12:
        return 2.4; // mcg
      case MicronutrientType.vitaminD:
        return 600.0; // IU
      case MicronutrientType.calcium:
        return 1000.0; // mg
    }
  }
}

/// Grocery item for shopping list
class GroceryItem {
  final String name;
  final String category;
  final double quantity;
  final String unit;
  final List<MicronutrientType> providesNutrients;

  GroceryItem({
    required this.name,
    required this.category,
    required this.quantity,
    required this.unit,
    required this.providesNutrients,
  });

  Map<String, dynamic> toJson() => {
    'name': name,
    'category': category,
    'quantity': quantity,
    'unit': unit,
    'providesNutrients': providesNutrients.map((e) => e.name).toList(),
  };
}

/// Weekly micronutrient gap analysis
class WeeklyMicronutrientReport {
  final DateTime weekStart;
  final DateTime weekEnd;
  final Map<MicronutrientType, double> averageIntake;
  final Map<MicronutrientType, double> targets;
  final Map<MicronutrientType, double> gaps; // Percentage gap
  final List<String> recommendations;

  WeeklyMicronutrientReport({
    required this.weekStart,
    required this.weekEnd,
    required this.averageIntake,
    required this.targets,
    required this.gaps,
    required this.recommendations,
  });

  bool get hasGaps => gaps.values.any((gap) => gap < 100);
}
