// lib/features/food/domain/food_log_model.dart
import 'package:hive/hive.dart';

part 'food_log_model.g.dart';

/// Food log entry - stored in Hive, synced to Appwrite
@HiveType(typeId: 1)
class FoodLog extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String userId;

  @HiveField(2)
  String foodName;

  @HiveField(3)
  String mealType; // breakfast, lunch, dinner, snack

  @HiveField(4)
  double quantityG;

  @HiveField(5)
  double calories;

  @HiveField(6)
  double proteinG;

  @HiveField(7)
  double carbsG;

  @HiveField(8)
  double fatG;

  @HiveField(9)
  DateTime loggedAt;

  @HiveField(10)
  String syncStatus; // 'pending' | 'synced' | 'conflict'

  @HiveField(11)
  String? recipeId; // nullable — set when logged from recipe

  FoodLog({
    required this.id,
    required this.userId,
    required this.foodName,
    required this.mealType,
    required this.quantityG,
    required this.calories,
    required this.proteinG,
    required this.carbsG,
    required this.fatG,
    required this.loggedAt,
    this.syncStatus = 'pending',
    this.recipeId,
  });

  /// Create a new FoodLog with a generated ID
  factory FoodLog.create({
    required String userId,
    required String foodName,
    required String mealType,
    required double quantityG,
    required double calories,
    required double proteinG,
    required double carbsG,
    required double fatG,
    String? recipeId,
  }) {
    return FoodLog(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      userId: userId,
      foodName: foodName,
      mealType: mealType,
      quantityG: quantityG,
      calories: calories,
      proteinG: proteinG,
      carbsG: carbsG,
      fatG: fatG,
      loggedAt: DateTime.now(),
      syncStatus: 'pending',
      recipeId: recipeId,
    );
  }

  /// Construct from an Appwrite Document after sync/fetch
  // FoodLog.fromAppwrite(Document doc) {
  //   id         = doc.$id;
  //   userId     = doc.data['user_id'];
  //   foodName   = doc.data['food_name'];
  //   mealType   = doc.data['meal_type'];
  //   quantityG  = doc.data['quantity_g'];
  //   calories   = doc.data['calories'];
  //   proteinG   = doc.data['protein_g'];
  //   carbsG     = doc.data['carbs_g'];
  //   fatG       = doc.data['fat_g'];
  //   loggedAt   = DateTime.parse(doc.data['logged_at']);
  //   syncStatus = 'synced';
  //   recipeId   = doc.data['recipe_id'];
  // }

  /// Serialise for Appwrite document creation
  Map<String, dynamic> toAppwrite() => {
    'user_id': userId,
    'food_name': foodName,
    'meal_type': mealType,
    'quantity_g': quantityG,
    'calories': calories,
    'protein_g': proteinG,
    'carbs_g': carbsG,
    'fat_g': fatG,
    'logged_at': loggedAt.toIso8601String(),
    'recipe_id': recipeId,
  };

  /// Copy with modifications
  FoodLog copyWith({
    String? id,
    String? userId,
    String? foodName,
    String? mealType,
    double? quantityG,
    double? calories,
    double? proteinG,
    double? carbsG,
    double? fatG,
    DateTime? loggedAt,
    String? syncStatus,
    String? recipeId,
  }) {
    return FoodLog(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      foodName: foodName ?? this.foodName,
      mealType: mealType ?? this.mealType,
      quantityG: quantityG ?? this.quantityG,
      calories: calories ?? this.calories,
      proteinG: proteinG ?? this.proteinG,
      carbsG: carbsG ?? this.carbsG,
      fatG: fatG ?? this.fatG,
      loggedAt: loggedAt ?? this.loggedAt,
      syncStatus: syncStatus ?? this.syncStatus,
      recipeId: recipeId ?? this.recipeId,
    );
  }

  @override
  String toString() {
    return 'FoodLog(id: $id, foodName: $foodName, mealType: $mealType, calories: $calories)';
  }
}

/// Meal type enum for type safety
enum MealType {
  breakfast,
  lunch,
  dinner,
  snack;

  String get displayName {
    switch (this) {
      case MealType.breakfast:
        return 'Breakfast';
      case MealType.lunch:
        return 'Lunch';
      case MealType.dinner:
        return 'Dinner';
      case MealType.snack:
        return 'Snack';
    }
  }

  static MealType fromString(String value) {
    return MealType.values.firstWhere(
      (e) => e.name.toLowerCase() == value.toLowerCase(),
      orElse: () => MealType.snack,
    );
  }
}
