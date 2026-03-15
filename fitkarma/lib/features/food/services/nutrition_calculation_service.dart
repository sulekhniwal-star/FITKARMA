// lib/features/food/services/nutrition_calculation_service.dart

import '../domain/nutrition_goal_model.dart';
import '../domain/food_log_model.dart';

/// Service for nutrition calculations and analysis
class NutritionCalculationService {
  /// Calculate daily nutrition from food logs
  DailyNutrition calculateDailyNutrition({
    required DateTime date,
    required List<FoodLog> foodLogs,
  }) {
    // Filter logs for the specific date
    final dayStart = DateTime(date.year, date.month, date.day);
    final dayEnd = dayStart.add(const Duration(days: 1));

    final dailyLogs = foodLogs
        .where(
          (log) =>
              log.loggedAt.isAfter(dayStart) && log.loggedAt.isBefore(dayEnd),
        )
        .toList();

    // Sum up all nutrients
    double calories = 0;
    double protein = 0;
    double carbs = 0;
    double fat = 0;
    double fiber = 0;
    double iron = 0;
    double vitaminB12 = 0;
    double vitaminD = 0;
    double calcium = 0;

    for (final log in dailyLogs) {
      calories += log.calories;
      protein += log.proteinG;
      carbs += log.carbsG;
      fat += log.fatG;
      // Fiber and micronutrients would come from food database
      // For now, using estimated values based on calories
      fiber += _estimateFiber(log.calories);
      iron += _estimateIron(log.calories);
      vitaminB12 += _estimateVitaminB12(log.calories);
      vitaminD += _estimateVitaminD(log.calories);
      calcium += _estimateCalcium(log.calories);
    }

    return DailyNutrition(
      date: date,
      consumedCalories: calories,
      consumedProtein: protein,
      consumedCarbs: carbs,
      consumedFat: fat,
      consumedFiber: fiber,
      consumedWater: 0, // Water tracked separately
      consumedIron: iron,
      consumedVitaminB12: vitaminB12,
      consumedVitaminD: vitaminD,
      consumedCalcium: calcium,
    );
  }

  /// Estimate fiber (rough approximation: 10 cal = 1g fiber)
  double _estimateFiber(double calories) => calories / 10;

  /// Estimate iron (rough approximation: 100 cal = 1mg iron)
  double _estimateIron(double calories) => calories / 100;

  /// Estimate Vitamin B12 (rough approximation: 100 cal = 0.5mcg B12)
  double _estimateVitaminB12(double calories) => calories / 200;

  /// Estimate Vitamin D (rough approximation: 100 cal = 5 IU vitamin D)
  double _estimateVitaminD(double calories) => calories / 20;

  /// Estimate calcium (rough approximation: 100 cal = 20mg calcium)
  double _estimateCalcium(double calories) => calories / 5;

  /// Calculate progress percentage
  double calculateProgress(double consumed, double target) {
    if (target <= 0) return 0;
    return (consumed / target * 100).clamp(0, 200);
  }

  /// Get traffic light status for a nutrient
  NutritionStatus getStatus(double consumed, double target) {
    return NutritionStatus.fromProgress(consumed, target);
  }

  /// Generate grocery list based on nutrition goals and current intake
  List<GroceryItem> generateGroceryList({
    required NutritionGoal goals,
    required DailyNutrition? today,
  }) {
    final List<GroceryItem> list = [];

    // Calculate gaps
    final calorieGap = goals.targetCalories - (today?.consumedCalories ?? 0);
    final proteinGap = goals.proteinGrams - (today?.consumedProtein ?? 0);
    final carbsGap = goals.carbsGrams - (today?.consumedCarbs ?? 0);
    final fatGap = goals.fatGrams - (today?.consumedFat ?? 0);

    // Iron gap
    final ironGap = goals.ironMg - (today?.consumedIron ?? 0);
    // B12 gap
    final b12Gap = goals.vitaminB12Mcg - (today?.consumedVitaminB12 ?? 0);
    // Vitamin D gap
    final vitDGap = goals.vitaminDIU - (today?.consumedVitaminD ?? 0);
    // Calcium gap
    final calciumGap = goals.calciumMg - (today?.consumedCalcium ?? 0);

    // Add items based on gaps
    if (proteinGap > 20) {
      list.addAll(_getProteinRichItems(proteinGap));
    }

    if (ironGap > 2) {
      list.addAll(_getIronRichItems(ironGap));
    }

    if (calciumGap > 200) {
      list.addAll(_getCalciumRichItems(calciumGap));
    }

    if (vitDGap > 100) {
      list.addAll(_getVitaminDRichItems(vitDGap));
    }

    if (b12Gap > 0.5) {
      list.addAll(_getB12RichItems(b12Gap));
    }

    // Always add some basics
    list.addAll(_getBasicItems());

    return list;
  }

  List<GroceryItem> _getProteinRichItems(double gap) {
    final factor = (gap / 30).clamp(1.0, 3.0);
    return [
      GroceryItem(
        name: 'Chicken Breast',
        category: 'Protein',
        quantity: 200 * factor,
        unit: 'g',
        providesNutrients: [MicronutrientType.vitaminB12],
      ),
      GroceryItem(
        name: 'Eggs',
        category: 'Protein',
        quantity: (6 * factor).roundToDouble(),
        unit: 'pcs',
        providesNutrients: [
          MicronutrientType.vitaminB12,
          MicronutrientType.vitaminD,
        ],
      ),
      GroceryItem(
        name: 'Greek Yogurt',
        category: 'Dairy',
        quantity: 150 * factor,
        unit: 'g',
        providesNutrients: [
          MicronutrientType.calcium,
          MicronutrientType.vitaminB12,
        ],
      ),
      GroceryItem(
        name: 'Paneer/Tofu',
        category: 'Protein',
        quantity: 100 * factor,
        unit: 'g',
        providesNutrients: [MicronutrientType.calcium],
      ),
    ];
  }

  List<GroceryItem> _getIronRichItems(double gap) {
    final factor = (gap / 5).clamp(1.0, 3.0);
    return [
      GroceryItem(
        name: 'Spinach',
        category: 'Vegetables',
        quantity: 100 * factor,
        unit: 'g',
        providesNutrients: [MicronutrientType.iron, MicronutrientType.calcium],
      ),
      GroceryItem(
        name: 'Lentils/Dal',
        category: 'Legumes',
        quantity: 100 * factor,
        unit: 'g',
        providesNutrients: [MicronutrientType.iron],
      ),
      GroceryItem(
        name: 'Fortified Cereals',
        category: 'Grains',
        quantity: 50 * factor,
        unit: 'g',
        providesNutrients: [
          MicronutrientType.iron,
          MicronutrientType.vitaminB12,
        ],
      ),
    ];
  }

  List<GroceryItem> _getCalciumRichItems(double gap) {
    final factor = (gap / 300).clamp(1.0, 3.0);
    return [
      GroceryItem(
        name: 'Milk',
        category: 'Dairy',
        quantity: 250 * factor,
        unit: 'ml',
        providesNutrients: [
          MicronutrientType.calcium,
          MicronutrientType.vitaminD,
        ],
      ),
      GroceryItem(
        name: 'Cheese',
        category: 'Dairy',
        quantity: 30 * factor,
        unit: 'g',
        providesNutrients: [
          MicronutrientType.calcium,
          MicronutrientType.vitaminB12,
        ],
      ),
      GroceryItem(
        name: 'Yogurt',
        category: 'Dairy',
        quantity: 150 * factor,
        unit: 'g',
        providesNutrients: [MicronutrientType.calcium],
      ),
    ];
  }

  List<GroceryItem> _getVitaminDRichItems(double gap) {
    final factor = (gap / 200).clamp(1.0, 3.0);
    return [
      GroceryItem(
        name: 'Fortified Milk',
        category: 'Dairy',
        quantity: 250 * factor,
        unit: 'ml',
        providesNutrients: [MicronutrientType.vitaminD],
      ),
      GroceryItem(
        name: 'Egg Yolks',
        category: 'Protein',
        quantity: (2 * factor).roundToDouble(),
        unit: 'pcs',
        providesNutrients: [MicronutrientType.vitaminD],
      ),
      GroceryItem(
        name: 'Mushrooms (Sun-exposed)',
        category: 'Vegetables',
        quantity: 50 * factor,
        unit: 'g',
        providesNutrients: [MicronutrientType.vitaminD],
      ),
    ];
  }

  List<GroceryItem> _getB12RichItems(double gap) {
    final factor = (gap / 1).clamp(1.0, 3.0);
    return [
      GroceryItem(
        name: 'Fish (Salmon/Tuna)',
        category: 'Seafood',
        quantity: 100 * factor,
        unit: 'g',
        providesNutrients: [
          MicronutrientType.vitaminB12,
          MicronutrientType.vitaminD,
        ],
      ),
      GroceryItem(
        name: 'Fortified Nutritional Yeast',
        category: 'Supplements',
        quantity: 10 * factor,
        unit: 'g',
        providesNutrients: [MicronutrientType.vitaminB12],
      ),
    ];
  }

  List<GroceryItem> _getBasicItems() {
    return [
      GroceryItem(
        name: 'Brown Rice',
        category: 'Grains',
        quantity: 500,
        unit: 'g',
        providesNutrients: [],
      ),
      GroceryItem(
        name: 'Mixed Vegetables',
        category: 'Vegetables',
        quantity: 500,
        unit: 'g',
        providesNutrients: [MicronutrientType.iron],
      ),
      GroceryItem(
        name: 'Fruits (Seasonal)',
        category: 'Fruits',
        quantity: 300,
        unit: 'g',
        providesNutrients: [],
      ),
      GroceryItem(
        name: 'Nuts (Almonds/Walnuts)',
        category: 'Nuts',
        quantity: 100,
        unit: 'g',
        providesNutrients: [],
      ),
    ];
  }

  /// Generate weekly micronutrient gap analysis report
  WeeklyMicronutrientReport generateWeeklyReport({
    required DateTime weekStart,
    required List<DailyNutrition> dailyLogs,
    required NutritionGoal goals,
  }) {
    // Calculate average intake for each micronutrient
    final avgIron = _calculateAverage(
      dailyLogs.map((d) => d.consumedIron).toList(),
    );
    final avgB12 = _calculateAverage(
      dailyLogs.map((d) => d.consumedVitaminB12).toList(),
    );
    final avgVitD = _calculateAverage(
      dailyLogs.map((d) => d.consumedVitaminD).toList(),
    );
    final avgCalcium = _calculateAverage(
      dailyLogs.map((d) => d.consumedCalcium).toList(),
    );

    final averageIntake = {
      MicronutrientType.iron: avgIron,
      MicronutrientType.vitaminB12: avgB12,
      MicronutrientType.vitaminD: avgVitD,
      MicronutrientType.calcium: avgCalcium,
    };

    final targets = {
      MicronutrientType.iron: goals.ironMg,
      MicronutrientType.vitaminB12: goals.vitaminB12Mcg,
      MicronutrientType.vitaminD: goals.vitaminDIU,
      MicronutrientType.calcium: goals.calciumMg,
    };

    // Calculate gaps as percentage
    final gaps = <MicronutrientType, double>{};
    for (final nutrient in MicronutrientType.values) {
      final intake = averageIntake[nutrient] ?? 0;
      final target = targets[nutrient] ?? nutrient.rda;
      gaps[nutrient] = target > 0 ? (intake / target * 100) : 0;
    }

    // Generate recommendations
    final recommendations = _generateRecommendations(gaps, averageIntake);

    return WeeklyMicronutrientReport(
      weekStart: weekStart,
      weekEnd: weekStart.add(const Duration(days: 6)),
      averageIntake: averageIntake,
      targets: targets,
      gaps: gaps,
      recommendations: recommendations,
    );
  }

  double _calculateAverage(List<double> values) {
    if (values.isEmpty) return 0;
    return values.reduce((a, b) => a + b) / values.length;
  }

  List<String> _generateRecommendations(
    Map<MicronutrientType, double> gaps,
    Map<MicronutrientType, double> intake,
  ) {
    final recommendations = <String>[];

    if ((gaps[MicronutrientType.iron] ?? 0) < 80) {
      if ((intake[MicronutrientType.iron] ?? 0) < 5) {
        recommendations.add(
          '⚠️ Iron intake is low. Include iron-rich foods like spinach, lentils, '
          'lean meat, or fortified cereals. Pair with Vitamin C to enhance absorption.',
        );
      }
    }

    if ((gaps[MicronutrientType.vitaminB12] ?? 0) < 80) {
      recommendations.add(
        '⚠️ Vitamin B12 intake is below target. Consider adding eggs, dairy, '
        'fish, or fortified foods. B12 is essential for nerve function and energy.',
      );
    }

    if ((gaps[MicronutrientType.vitaminD] ?? 0) < 80) {
      recommendations.add(
        '⚠️ Vitamin D intake is low. Get more sunlight exposure, or include '
        'fortified dairy, egg yolks, or fatty fish in your diet.',
      );
    }

    if ((gaps[MicronutrientType.calcium] ?? 0) < 80) {
      recommendations.add(
        '⚠️ Calcium intake needs improvement. Add more dairy products, '
        'leafy greens, or fortified plant milks for bone health.',
      );
    }

    if (recommendations.isEmpty) {
      recommendations.add(
        '✅ Great job! Your micronutrient intake is well-balanced this week.',
      );
    }

    return recommendations;
  }

  /// Calculate remaining nutrients for the day
  Map<String, double> calculateRemaining({
    required NutritionGoal goals,
    required DailyNutrition today,
  }) {
    return {
      'calories': (goals.targetCalories - today.consumedCalories).clamp(
        0,
        double.infinity,
      ),
      'protein': (goals.proteinGrams - today.consumedProtein).clamp(
        0,
        double.infinity,
      ),
      'carbs': (goals.carbsGrams - today.consumedCarbs).clamp(
        0,
        double.infinity,
      ),
      'fat': (goals.fatGrams - today.consumedFat).clamp(0, double.infinity),
      'fiber': (goals.fiberGrams - today.consumedFiber).clamp(
        0,
        double.infinity,
      ),
    };
  }
}
