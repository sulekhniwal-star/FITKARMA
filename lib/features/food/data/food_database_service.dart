import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:drift/drift.dart' show Value;
import 'package:appwrite/appwrite.dart' show Query, ID;
import '../../../core/providers/core_providers.dart';
import '../../../core/database/app_database.dart';
import '../../../core/providers/low_data_mode_provider.dart';
import 'open_food_facts_client.dart';

part 'food_database_service.g.dart';

@riverpod
class FoodDatabaseService extends _$FoodDatabaseService {
  @override
  void build() {}

  double _parseDouble(dynamic val) {
    if (val == null) return 0.0;
    if (val is num) return val.toDouble();
    if (val is String) return double.tryParse(val) ?? 0.0;
    return 0.0;
  }

  String _getEmojiForCategory(String category) {
    final c = category.toLowerCase();
    if (c.contains('beverage') || c.contains('drink')) return '🥤';
    if (c.contains('fruit')) return '🍎';
    if (c.contains('vegetable')) return '🥦';
    if (c.contains('meat') || c.contains('chicken')) return '🍗';
    if (c.contains('dairy') || c.contains('milk')) return '🥛';
    if (c.contains('snack') || c.contains('chips')) return '🍿';
    if (c.contains('dessert') || c.contains('sweet')) return '🍰';
    return '🍛';
  }

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
        isBundled: const Value(true),
      ));
    }
    
    await db.insertFoodItems(companions);
  }

  Stream<List<FoodItem>> searchLocally(String query) {
    return ref.read(appDatabaseProvider).searchFoodItems(query);
  }

  /// searchByName — priority: Appwrite Indian DB (fulltext) → Open Food Facts API (if <5 results and not lowData)
  Future<List<Map<String, dynamic>>> searchByName(String query) async {
    if (query.trim().isEmpty) return [];

    final results = <Map<String, dynamic>>[];
    final existingNames = <String>{};

    // 1. Query Appwrite Indian DB (fulltext)
    try {
      final databases = ref.read(appwriteDatabasesProvider);
      final response = await databases.listDocuments(
        databaseId: 'fitkarma-db',
        collectionId: 'food_database',
        queries: [
          Query.search('name', query),
          Query.limit(20),
        ],
      );

      for (final doc in response.documents) {
        final data = doc.data;
        final name = data['name']?.toString() ?? 'Unknown';
        final mapped = {
          'id': doc.$id,
          'name': name,
          'nameHindi': data['nameHindi'],
          'category': data['category'] ?? 'General',
          'caloriesPer100g': _parseDouble(data['caloriesPer100g']),
          'proteinPer100g': _parseDouble(data['proteinPer100g']),
          'carbsPer100g': _parseDouble(data['carbsPer100g']),
          'fatPer100g': _parseDouble(data['fatPer100g']),
          'fiberPer100g': _parseDouble(data['fiberPer100g']),
          'barcode': data['barcode'],
          'emoji': data['emoji'] ?? '🍛',
          'source': data['source'] ?? 'appwrite',
          'priority': data['priority'] ?? 2,
        };
        results.add(mapped);
        existingNames.add(name.toLowerCase());
      }

      if (results.isNotEmpty) {
        await _cacheToDrift(results);
      }
    } catch (_) {
      // Appwrite query failed or offline
    }

    // 2. Open Food Facts API (if <5 results and not lowData)
    if (results.length < 5) {
      final isLowData = ref.read(lowDataModeProvider).value ?? false;
      if (!isLowData) {
        try {
          final offClient = ref.read(openFoodFactsClientProvider);
          final offResultsRaw = await offClient.searchByName(query, limit: 15);

          final offMapped = <Map<String, dynamic>>[];
          for (final p in offResultsRaw) {
            final nutriments = p['nutriments'] as Map<String, dynamic>? ?? {};
            final name = p['product_name']?.toString() ?? 'Unknown Food';
            if (name.trim().isEmpty || name == 'Unknown Food') continue;

            if (existingNames.contains(name.toLowerCase())) continue;

            final barcode = p['code']?.toString();
            final categories = p['categories']?.toString() ?? 'General';
            final category = categories.split(',').first.trim();

            final mapped = {
              'id': barcode ?? name,
              'name': name,
              'category': category,
              'caloriesPer100g': _parseDouble(nutriments['energy-kcal_100g']),
              'proteinPer100g': _parseDouble(nutriments['proteins_100g']),
              'carbsPer100g': _parseDouble(nutriments['carbohydrates_100g']),
              'fatPer100g': _parseDouble(nutriments['fat_100g']),
              'fiberPer100g': _parseDouble(nutriments['fiber_100g']),
              'barcode': barcode,
              'emoji': _getEmojiForCategory(category),
              'source': 'off',
              'priority': 5,
            };

            offMapped.add(mapped);
            results.add(mapped);
            existingNames.add(name.toLowerCase());
          }

          if (offMapped.isNotEmpty) {
            await _cacheToDrift(offMapped);
            // Silent best-effort cache of OFF results
            _cacheToAppwrite(offMapped);
          }
        } catch (_) {
          // OFF lookup failed
        }
      }
    }

    results.sort((a, b) => (a['priority'] as int).compareTo(b['priority'] as int));
    return results;
  }

  /// searchByBarcode — priority: Appwrite (exact match) → Open Food Facts → return null
  Future<Map<String, dynamic>?> searchByBarcode(String barcode) async {
    if (barcode.trim().isEmpty) return null;

    // 1. Appwrite (exact match)
    try {
      final databases = ref.read(appwriteDatabasesProvider);
      final response = await databases.listDocuments(
        databaseId: 'fitkarma-db',
        collectionId: 'food_database',
        queries: [
          Query.equal('barcode', barcode),
          Query.limit(1),
        ],
      );

      if (response.documents.isNotEmpty) {
        final doc = response.documents.first;
        final data = doc.data;
        final mapped = {
          'id': doc.$id,
          'name': data['name'] ?? 'Unknown',
          'nameHindi': data['nameHindi'],
          'category': data['category'] ?? 'General',
          'caloriesPer100g': _parseDouble(data['caloriesPer100g']),
          'proteinPer100g': _parseDouble(data['proteinPer100g']),
          'carbsPer100g': _parseDouble(data['carbsPer100g']),
          'fatPer100g': _parseDouble(data['fatPer100g']),
          'fiberPer100g': _parseDouble(data['fiberPer100g']),
          'barcode': data['barcode'],
          'emoji': data['emoji'] ?? '🍛',
          'source': data['source'] ?? 'appwrite',
          'priority': data['priority'] ?? 2,
        };
        await _cacheToDrift([mapped]);
        return mapped;
      }
    } catch (_) {
      // Fallback to OFF
    }

    // 2. Open Food Facts
    try {
      final offClient = ref.read(openFoodFactsClientProvider);
      final p = await offClient.searchByBarcode(barcode);

      if (p != null) {
        final nutriments = p['nutriments'] as Map<String, dynamic>? ?? {};
        final name = p['product_name']?.toString() ?? 'Unknown Food';
        final categories = p['categories']?.toString() ?? 'General';
        final category = categories.split(',').first.trim();

        final mapped = {
          'id': barcode,
          'name': name,
          'category': category,
          'caloriesPer100g': _parseDouble(nutriments['energy-kcal_100g']),
          'proteinPer100g': _parseDouble(nutriments['proteins_100g']),
          'carbsPer100g': _parseDouble(nutriments['carbohydrates_100g']),
          'fatPer100g': _parseDouble(nutriments['fat_100g']),
          'fiberPer100g': _parseDouble(nutriments['fiber_100g']),
          'barcode': barcode,
          'emoji': _getEmojiForCategory(category),
          'source': 'off',
          'priority': 5,
        };

        await _cacheToDrift([mapped]);
        // Silent best-effort cache of OFF results
        _cacheToAppwrite([mapped]);
        return mapped;
      }
    } catch (_) {
      // Ignore
    }

    return null;
  }

  /// Silent best-effort cache of OFF results to Appwrite
  Future<void> _cacheToAppwrite(List<Map<String, dynamic>> offResults) async {
    try {
      final databases = ref.read(appwriteDatabasesProvider);
      for (final item in offResults) {
        try {
          await databases.createDocument(
            databaseId: 'fitkarma-db',
            collectionId: 'food_database',
            documentId: ID.unique(),
            data: {
              'name': item['name'],
              'category': item['category'] ?? 'General',
              'caloriesPer100g': item['caloriesPer100g'],
              'proteinPer100g': item['proteinPer100g'],
              'carbsPer100g': item['carbsPer100g'],
              'fatPer100g': item['fatPer100g'],
              'fiberPer100g': item['fiberPer100g'],
              'barcode': item['barcode'],
              'emoji': item['emoji'] ?? '🍛',
              'source': 'off_cached',
            },
          );
        } catch (_) {
          // If direct write fails due to client read-only permission,
          // trigger backend execution proxy if barcode is available
          if (item['barcode'] != null) {
            try {
              final functions = ref.read(appwriteFunctionsProvider);
              await functions.createExecution(
                functionId: 'fitkarma-cores',
                body: jsonEncode({
                  'action': 'search_food',
                  'barcode': item['barcode'],
                }),
              );
            } catch (_) {}
          }
        }
      }
    } catch (_) {
      // Catch all silent failure
    }
  }

  Future<Map<String, dynamic>?> searchRemote({String? query, String? barcode}) async {
    if (barcode != null && barcode.isNotEmpty) {
      final res = await searchByBarcode(barcode);
      if (res != null) {
        return {
          'ok': true,
          'source': res['source'],
          'products': [res],
        };
      }
      return null;
    }
    if (query != null && query.isNotEmpty) {
      final res = await searchByName(query);
      return {
        'ok': true,
        'source': 'remote',
        'products': res,
      };
    }
    return null;
  }

  Future<void> _cacheToDrift(List<Map<String, dynamic>> products) async {
    final db = ref.read(appDatabaseProvider);
    final companions = products.map((item) => FoodItemsCompanion.insert(
      id: item['id']?.toString() ?? 'unknown',
      name: item['name']?.toString() ?? 'Unknown',
      source: item['source']?.toString() ?? 'appwrite',
      priority: item['priority'] as int? ?? 99,
      caloriesPer100g: _parseDouble(item['caloriesPer100g']),
      group: Value(item['group']?.toString()),
      category: Value(item['category']?.toString()),
      barcode: Value(item['barcode']?.toString()),
      isBundled: const Value(false),
    )).toList();
    
    await db.insertFoodItems(companions);
  }
}