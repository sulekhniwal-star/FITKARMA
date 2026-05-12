import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:drift/drift.dart' show Value;
import '../../../core/providers/core_providers.dart';
import '../../../core/database/app_database.dart';

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
      final results = localResults.map((e) => {
        'id': e.id,
        'name': e.name,
        'source': e.source,
        'priority': e.priority,
        'caloriesPer100g': e.caloriesPer100g,
        'bundled': e.isBundled,
      }).toList();
      
      return {
        'ok': true,
        'source': 'local',
        'products': results,
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

      if (execution.status.toString().contains('completed')) {
        final data = jsonDecode(execution.responseBody);
        if (data['ok'] == true && data['source'] == 'appwrite') {
          final products = (data['products'] as List).cast<Map<String, dynamic>>();
          await _cacheToDrift(products);
        }
        return data;
      }
    } catch (e) {
      // ignore
    }
    return null;
  }

  Future<void> _cacheToDrift(List<Map<String, dynamic>> products) async {
    final db = ref.read(appDatabaseProvider);
    final companions = products.map((item) => FoodItemsCompanion.insert(
      id: item['id'] ?? 'unknown',
      name: item['name'] ?? 'Unknown',
      source: item['source'] ?? 'appwrite',
      priority: item['priority'] ?? 99,
      caloriesPer100g: (item['caloriesPer100g'] ?? 0).toDouble(),
      group: Value(item['group']),
      category: Value(item['category']),
      barcode: Value(item['barcode']),
      isBundled: Value(false),
    )).toList();
    
    await db.insertFoodItems(companions);
  }
}