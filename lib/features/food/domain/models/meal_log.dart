import 'package:hive/hive.dart';

part 'meal_log.g.dart';

@HiveType(typeId: 4)
class MealLog extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String foodId;

  @HiveField(2)
  final String mealType; // Breakfast, Lunch, Dinner, Snacks

  @HiveField(3)
  final double amount;

  @HiveField(4)
  final String unit; // katori, piece, gram, ladle

  @HiveField(5)
  final DateTime timestamp;

  @HiveField(6)
  final double totalCalories;

  @HiveField(7)
  final bool isSynced;

  MealLog({
    required this.id,
    required this.foodId,
    required this.mealType,
    required this.amount,
    required this.unit,
    required this.timestamp,
    required this.totalCalories,
    this.isSynced = false,
  });
}
