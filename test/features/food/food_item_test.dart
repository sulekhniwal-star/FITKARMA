import 'package:flutter_test/flutter_test.dart';
import 'package:fitkarma/features/food/data/models/food_item.dart';

void main() {
  group('FoodItem.fromOpenFoodFacts - malformed input handling', () {
    test('handles null input gracefully', () {
      expect(() => FoodItem.fromOpenFoodFacts(null), returnsNormally);
      final result = FoodItem.fromOpenFoodFacts(null);
      expect(result.id, 'Unknown Food');
      expect(result.name, 'Unknown Food');
    });

    test('handles missing nutriments gracefully', () {
      final result = FoodItem.fromOpenFoodFacts({
        'product_name': 'Test Food',
      });
      expect(result.name, 'Test Food');
      expect(result.caloriesPer100g, 0.0);
    });

    test('handles missing product_name', () {
      final result = FoodItem.fromOpenFoodFacts({
        'code': '123456789',
      });
      expect(result.id, '123456789');
      expect(result.name, 'Unknown Food');
    });

    test('handles nutriments as null', () {
      final result = FoodItem.fromOpenFoodFacts({
        'product_name': 'Test Food',
        'nutriments': null,
      });
      expect(result.caloriesPer100g, 0.0);
      expect(result.proteinPer100g, 0.0);
    });

    test('handles nutriment values as strings', () {
      final result = FoodItem.fromOpenFoodFacts({
        'product_name': 'Test Food',
        'nutriments': {
          'energy-kcal_100g': '100',
          'proteins_100g': '10',
          'carbohydrates_100g': '20',
          'fat_100g': '5',
          'fiber_100g': '3',
        },
      });
      expect(result.caloriesPer100g, 100.0);
      expect(result.proteinPer100g, 10.0);
      expect(result.carbsPer100g, 20.0);
      expect(result.fatPer100g, 5.0);
      expect(result.fiberPer100g, 3.0);
    });

    test('handles invalid string values for nutriments', () {
      final result = FoodItem.fromOpenFoodFacts({
        'product_name': 'Test Food',
        'nutriments': {
          'energy-kcal_100g': 'invalid',
          'proteins_100g': null,
        },
      });
      expect(result.caloriesPer100g, 0.0);
      expect(result.proteinPer100g, 0.0);
    });

    test('handles categories as null', () {
      final result = FoodItem.fromOpenFoodFacts({
        'product_name': 'Test Food',
        'categories': null,
      });
      expect(result.category, 'General');
    });

    test('extracts first category from comma-separated list', () {
      final result = FoodItem.fromOpenFoodFacts({
        'product_name': 'Test Food',
        'categories': 'Dairy, Milk, Cheese',
      });
      expect(result.category, 'Dairy');
    });

    test('handles empty categories', () {
      final result = FoodItem.fromOpenFoodFacts({
        'product_name': 'Test Food',
        'categories': '',
      });
      expect(result.category, '');
    });

    test('sets correct emoji based on category', () {
      expect(FoodItem.fromOpenFoodFacts({'product_name': 'Test', 'categories': 'Beverages'}).emoji, '🥤');
      expect(FoodItem.fromOpenFoodFacts({'product_name': 'Test', 'categories': 'Fruits'}).emoji, '🍎');
      expect(FoodItem.fromOpenFoodFacts({'product_name': 'Test', 'categories': 'Vegetables'}).emoji, '🥦');
      expect(FoodItem.fromOpenFoodFacts({'product_name': 'Test', 'categories': 'Meat'}).emoji, '🍗');
      expect(FoodItem.fromOpenFoodFacts({'product_name': 'Test', 'categories': 'Dairy'}).emoji, '🥛');
      expect(FoodItem.fromOpenFoodFacts({'product_name': 'Test', 'categories': 'Snacks'}).emoji, '🍿');
      expect(FoodItem.fromOpenFoodFacts({'product_name': 'Test', 'categories': 'Desserts'}).emoji, '🍰');
      expect(FoodItem.fromOpenFoodFacts({'product_name': 'Test', 'categories': 'Unknown'}).emoji, '🍛');
    });

    test('handles product_name_hi correctly', () {
      final result = FoodItem.fromOpenFoodFacts({
        'product_name': 'Test Food',
        'product_name_hi': 'टेस्ट फूड',
      });
      expect(result.nameHindi, 'टेस्ट फूड');
    });

    test('sets source to off', () {
      final result = FoodItem.fromOpenFoodFacts({
        'product_name': 'Test Food',
      });
      expect(result.source, 'off');
    });

    test('sets isBundled to false for OFF items', () {
      final result = FoodItem.fromOpenFoodFacts({
        'product_name': 'Test Food',
      });
      expect(result.isBundled, isFalse);
    });

    test('handles missing code (uses name as id)', () {
      final result = FoodItem.fromOpenFoodFacts({
        'product_name': 'Test Food',
      });
      expect(result.id, 'Test Food');
      expect(result.barcode, isNull);
    });

    test('parses valid barcode', () {
      final result = FoodItem.fromOpenFoodFacts({
        'product_name': 'Test Food',
        'code': '9876543210123',
      });
      expect(result.barcode, '9876543210123');
    });

    test('handles complete valid input', () {
      final result = FoodItem.fromOpenFoodFacts({
        'product_name': 'Organic Apple',
        'product_name_hi': 'ऑर्गेनिक सेब',
        'code': '1234567890123',
        'categories': 'Fruits, Organic',
        'nutriments': {
          'energy-kcal_100g': 52,
          'proteins_100g': 0.3,
          'carbohydrates_100g': 14,
          'fat_100g': 0.2,
          'fiber_100g': 2.4,
        },
      });

      expect(result.id, '1234567890123');
      expect(result.name, 'Organic Apple');
      expect(result.nameHindi, 'ऑर्गेनिक सेब');
      expect(result.category, 'Fruits');
      expect(result.barcode, '1234567890123');
      expect(result.caloriesPer100g, 52.0);
      expect(result.emoji, '🍎');
      expect(result.source, 'off');
      expect(result.isBundled, isFalse);
    });
  });
}