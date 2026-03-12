import 'package:fitkarma/features/gamification/data/repositories/progress_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';
import '../../domain/models/food_item.dart';
import '../../domain/models/meal_log.dart';

part 'food_repository.g.dart';

@Riverpod(keepAlive: true)
class FoodRepository extends _$FoodRepository {
  late Box<FoodItem> _foodBox;
  late Box<MealLog> _mealLogBox;

  @override
  FutureOr<void> build() async {
    _foodBox = await Hive.openBox<FoodItem>('food_items');
    _mealLogBox = await Hive.openBox<MealLog>('meal_logs');
  }

  Future<List<FoodItem>> searchFood(String query) async {
    if (query.isEmpty) return _foodBox.values.take(10).toList();
    
    final lowerQuery = query.toLowerCase();
    return _foodBox.values.where((item) {
      return item.nameEn.toLowerCase().contains(lowerQuery) ||
             item.nameHi.contains(query);
    }).toList();
  }

  Future<void> logMeal({
    required String foodId,
    required String mealType,
    required double amount,
    required String unit,
    required double totalCalories,
  }) async {
    final log = MealLog(
      id: const Uuid().v4(),
      foodId: foodId,
      timestamp: DateTime.now(),
      mealType: mealType,
      amount: amount,
      unit: unit,
      totalCalories: totalCalories,
    );
    await _mealLogBox.put(log.id, log);

    // Trigger XP: 20 XP per meal logged
    await ref.read(progressRepositoryProvider.notifier).addXp(20);
  }

  Future<double> getTodayTotalCalories() async {
    final today = DateTime.now();
    return _mealLogBox.values.where((log) {
      return log.timestamp.year == today.year &&
             log.timestamp.month == today.month &&
             log.timestamp.day == today.day;
    }).fold<double>(0.0, (sum, log) => sum + log.totalCalories);
  }
}
