import 'package:appwrite/models.dart' as models;

class FoodLog {
  final String id;
  final String userId;
  final String? foodItemId;
  final String? recipeId;
  final String foodName;
  final String mealType; // breakfast, lunch, dinner, snack
  final double quantityG;
  final double calories;
  final double proteinG;
  final double carbsG;
  final double fatG;
  final double? fiberG;
  final DateTime loggedAt;
  final String logMethod; // search, barcode, ocr, voice, etc.
  final String syncStatus; // synced, pending, conflict

  FoodLog({
    required this.id,
    required this.userId,
    this.foodItemId,
    this.recipeId,
    required this.foodName,
    required this.mealType,
    required this.quantityG,
    required this.calories,
    required this.proteinG,
    required this.carbsG,
    required this.fatG,
    this.fiberG,
    required this.loggedAt,
    required this.logMethod,
    this.syncStatus = 'synced',
  });

  factory FoodLog.fromAppwrite(models.Document doc) {
    return FoodLog(
      id: doc.$id,
      userId: doc.data['user_id'] ?? '',
      foodItemId: doc.data['food_item_id'],
      recipeId: doc.data['recipe_id'],
      foodName: doc.data['food_name'] ?? '',
      mealType: doc.data['meal_type'] ?? '',
      quantityG: (doc.data['quantity_g'] as num?)?.toDouble() ?? 0.0,
      calories: (doc.data['calories'] as num?)?.toDouble() ?? 0.0,
      proteinG: (doc.data['protein_g'] as num?)?.toDouble() ?? 0.0,
      carbsG: (doc.data['carbs_g'] as num?)?.toDouble() ?? 0.0,
      fatG: (doc.data['fat_g'] as num?)?.toDouble() ?? 0.0,
      fiberG: (doc.data['fiber_g'] as num?)?.toDouble(),
      loggedAt: DateTime.parse(doc.data['logged_at'] ?? doc.$createdAt),
      logMethod: doc.data['log_method'] ?? 'manual',
      syncStatus: 'synced',
    );
  }

  Map<String, dynamic> toAppwrite() {
    return {
      'user_id': userId,
      'food_item_id': foodItemId,
      'recipe_id': recipeId,
      'food_name': foodName,
      'meal_type': mealType,
      'quantity_g': quantityG,
      'calories': calories,
      'protein_g': proteinG,
      'carbs_g': carbsG,
      'fat_g': fatG,
      'fiber_g': fiberG,
      'logged_at': loggedAt.toIso8601String(),
      'log_method': logMethod,
      'sync_status': syncStatus,
    };
  }
}
