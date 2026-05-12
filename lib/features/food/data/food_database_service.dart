import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../core/providers/core_providers.dart';
import '../../../core/database/app_database.dart';
import '../models/food_item.dart';

part 'food_database_service.g.dart';

@riverpod
class FoodDatabaseService extends _$FoodDatabaseService {
  @override
  void build() {}

  Future<void> loadBundledSeed() async {
    final db = ref.read(appDatabaseProvider);
    final String jsonString = await rootBundle.loadString('assets/data/indian_foods_seed.json');
    
    final List<dynamic> jsonList = json.decode(jsonString);
    final companions = <FoodItemsCompanion>[];
    
    for (final jsonItem in jsonList.take(500)) {
      final item = jsonItem as Map<String, dynamic>;
      companions.add(FoodItemsCompanion.insert(
        id: item['code'] ?? item['name'] ?? 'unknown',
        name: item['name'] ?? 'Unknown',
        source: item['source'] ?? 'unknown',
        priority: item['priority'] ?? 99,
        caloriesPer100g: (item['caloriesPer100g'] ?? item['energy_kcal'] ?? 0).toDouble(),
        group: Value(item['group']),
        category: Value(item['category']),
        barcode: Value(item['barcode']),
        isBundled: Value(true),
      ));
    }
    
    await db.insertFoodItems(companions);
  }

  Stream<List<FoodItem>> searchLocally(String query) {
    return ref.read(appDatabaseProvider).searchFoodItems(query);
  }

  Future<Map<String, dynamic>?> searchRemote({String? query, String? barcode}) async {
    final db = ref.read(appDatabaseProvider);
    final functions = ref.read(appwriteFunctionsProvider);

    final localResults = await db.searchFoodItems(query ?? '').first;
    
    if (localResults.length >= 5) {
      return {
        'ok': true,
        'source': 'local',
        'products': localResults.map((e) => e.toJson()).toList(),
      };
    }

    try {
      final execution = await functions.createExecution(
        functionId: 'fitkarma-cores',
        body: jsonEncode({
          'action': 'search_food',
          'query': query,
          'barcode': barcode,
        }),
      );

      if (execution.status == 'completed') {
        final data = jsonDecode(execution.responseBody);
        if (data['ok'] && data['source'] == 'appwrite') {
          final products = (data['products'] as List)
              .map((p) => FoodItem.fromJson(p))
              .toList();
          await _cacheToDrift(products);
        }
        return data;
      }
    } catch (e) {
      print('Error searching food: $e');
    }
    return null;
  }

  Future<void> _cacheToDrift(List<FoodItem> items) async {
    final db = ref.read(appDatabaseProvider);
    final companions = items.map((item) => FoodItemsCompanion.insert(
      id: item.id,
      name: item.name,
      source: item.source,
      priority: item.priority,
      caloriesPer100g: item.caloriesPer100g,
      group: Value(item.group),
      category: Value(item.category),
      barcode: Value(item.barcode),
      isBundled: Value(false),
    )).toList();
    
    await db.insertFoodItems(companions);
  }
}