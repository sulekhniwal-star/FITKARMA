import 'dart:convert';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'food_item.freezed.dart';
part 'food_item.g.dart';

@freezed
abstract class ServingSize with _$ServingSize {
  const ServingSize._();

  const factory ServingSize({
    required String label,
    required double weightG,
  }) = _ServingSize;

  factory ServingSize.fromJson(Map<String, dynamic> json) => _$ServingSizeFromJson(json);
}

@freezed
abstract class FoodItem with _$FoodItem {
  const FoodItem._();

  const factory FoodItem({
    required String id,
    required String name,
    String? nameHindi,
    String? category,
    required double caloriesPer100g,
    @Default(0.0) double proteinPer100g,
    @Default(0.0) double carbsPer100g,
    @Default(0.0) double fatPer100g,
    @Default(0.0) double fiberPer100g,
    @Default('🍛') String emoji,
    @Default('unknown') String source,
    String? barcode,
    @Default([]) List<ServingSize> servingSizes,
    // Legacy fields preserved for backward compatibility
    @Default(99) int priority,
    String? group,
    @Default(true) bool isBundled,
  }) = _FoodItem;

  factory FoodItem.fromJson(Map<String, dynamic> json) => _$FoodItemFromJson(json);

  /// Factory constructor to map Open Food Facts product JSON correctly
  factory FoodItem.fromOpenFoodFacts(Map<String, dynamic>? p) {
    if (p == null) {
      return const FoodItem(
        id: 'Unknown Food',
        name: 'Unknown Food',
        category: 'General',
        caloriesPer100g: 0.0,
        emoji: '🍛',
        source: 'off',
        isBundled: false,
      );
    }
    final nutriments = p['nutriments'] as Map<String, dynamic>? ?? {};
    final name = p['product_name']?.toString() ?? 'Unknown Food';
    final barcode = p['code']?.toString();
    final categories = p['categories']?.toString() ?? 'General';
    final category = categories.split(',').first.trim();

    double parseDouble(dynamic val) {
      if (val == null) return 0.0;
      if (val is num) return val.toDouble();
      if (val is String) return double.tryParse(val) ?? 0.0;
      return 0.0;
    }

    String getEmoji(String cat) {
      final c = cat.toLowerCase();
      if (c.contains('beverage') || c.contains('drink')) return '🥤';
      if (c.contains('fruit')) return '🍎';
      if (c.contains('vegetable')) return '🥦';
      if (c.contains('meat') || c.contains('chicken')) return '🍗';
      if (c.contains('dairy') || c.contains('milk')) return '🥛';
      if (c.contains('snack') || c.contains('chips')) return '🍿';
      if (c.contains('dessert') || c.contains('sweet')) return '🍰';
      return '🍛';
    }

    return FoodItem(
      id: barcode ?? name,
      name: name,
      nameHindi: p['product_name_hi']?.toString(),
      category: category,
      caloriesPer100g: parseDouble(nutriments['energy-kcal_100g']),
      proteinPer100g: parseDouble(nutriments['proteins_100g']),
      carbsPer100g: parseDouble(nutriments['carbohydrates_100g']),
      fatPer100g: parseDouble(nutriments['fat_100g']),
      fiberPer100g: parseDouble(nutriments['fiber_100g']),
      emoji: getEmoji(category),
      source: 'off',
      barcode: barcode,
      servingSizes: const [],
      isBundled: false,
    );
  }

  /// Factory constructor to map Appwrite documents correctly, decoding servingSizes JSON
  factory FoodItem.fromAppwriteDoc(Map<String, dynamic> doc) {
    double parseDouble(dynamic val) {
      if (val == null) return 0.0;
      if (val is num) return val.toDouble();
      if (val is String) return double.tryParse(val) ?? 0.0;
      return 0.0;
    }

    List<ServingSize> parseServings(dynamic val) {
      if (val == null) return const [];
      if (val is List) {
        return val.map((e) {
          if (e is Map<String, dynamic>) return ServingSize.fromJson(e);
          return null;
        }).whereType<ServingSize>().toList();
      }
      if (val is String) {
        try {
          final decoded = jsonDecode(val) as List;
          return decoded.map((e) => ServingSize.fromJson(e as Map<String, dynamic>)).toList();
        } catch (_) {}
      }
      return const [];
    }

    return FoodItem(
      id: doc['\$id']?.toString() ?? doc['id']?.toString() ?? 'unknown',
      name: doc['name']?.toString() ?? 'Unknown',
      nameHindi: doc['nameHindi']?.toString(),
      category: doc['category']?.toString() ?? 'General',
      caloriesPer100g: parseDouble(doc['caloriesPer100g']),
      proteinPer100g: parseDouble(doc['proteinPer100g']),
      carbsPer100g: parseDouble(doc['carbsPer100g']),
      fatPer100g: parseDouble(doc['fatPer100g']),
      fiberPer100g: parseDouble(doc['fiberPer100g']),
      emoji: doc['emoji']?.toString() ?? '🍛',
      source: doc['source']?.toString() ?? 'appwrite',
      barcode: doc['barcode']?.toString(),
      servingSizes: parseServings(doc['servingSizes']),
      priority: doc['priority'] as int? ?? 2,
      isBundled: false,
    );
  }

  /// Getter validation rule
  bool get isValid => name.isNotEmpty && caloriesPer100g > 0;
}