import 'package:hive/hive.dart';

part 'food_item.g.dart';

@HiveType(typeId: 3)
class FoodItem extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String nameEn;

  @HiveField(2)
  final String nameHi;

  @HiveField(3)
  final double caloriesPer100g;

  @HiveField(4)
  final double protein;

  @HiveField(5)
  final double carbs;

  @HiveField(6)
  final double fat;

  @HiveField(7)
  final String imageUrl;

  @HiveField(8)
  final Map<String, double> portionMultipliers; // e.g., {'katori': 1.5, 'piece': 0.8}

  FoodItem({
    required this.id,
    required this.nameEn,
    required this.nameHi,
    required this.caloriesPer100g,
    required this.protein,
    required this.carbs,
    required this.fat,
    required this.imageUrl,
    required this.portionMultipliers,
  });
}
