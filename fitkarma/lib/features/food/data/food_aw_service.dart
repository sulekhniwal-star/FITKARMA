// lib/features/food/data/food_aw_service.dart
import 'package:appwrite/appwrite.dart';
import '../../../core/network/appwrite_client.dart';
import '../../../core/constants/api_endpoints.dart';
import '../../../core/constants/app_config.dart';
import '../domain/food_log_model.dart';

/// Service for managing food data in Appwrite
class FoodAwService {
  Databases get _db => AppwriteClient.databases;

  /// Search food items from Appwrite
  Future<List<Map<String, dynamic>>> searchFoodItems(String query) async {
    try {
      final response = await _db.listDocuments(
        databaseId: AppConfig.appwriteDatabaseId,
        collectionId: AW.foodItems,
        queries: [Query.limit(50)],
      );

      // Filter by query in memory (Appwrite doesn't have full-text search)
      final documents = response.documents;
      final queryLower = query.toLowerCase();

      return documents
          .where((doc) {
            final name = (doc.data['name'] as String?)?.toLowerCase() ?? '';
            final nameHi =
                (doc.data['name_hi'] as String?)?.toLowerCase() ?? '';
            return name.contains(queryLower) || nameHi.contains(queryLower);
          })
          .map((doc) => doc.data)
          .toList();
    } catch (e) {
      // Return empty list on error
      return [];
    }
  }

  /// Get a food item by ID
  Future<Map<String, dynamic>?> getFoodItem(String id) async {
    try {
      final doc = await _db.getDocument(
        databaseId: AppConfig.appwriteDatabaseId,
        collectionId: AW.foodItems,
        documentId: id,
      );
      return doc.data;
    } catch (e) {
      return null;
    }
  }

  /// Log food to Appwrite
  Future<String?> logFood(FoodLog log) async {
    try {
      final response = await _db.createDocument(
        databaseId: AppConfig.appwriteDatabaseId,
        collectionId: AW.foodLogs,
        documentId: log.id,
        data: log.toAppwrite(),
      );
      return response.$id;
    } catch (e) {
      return null;
    }
  }

  /// Get all food logs for a user from Appwrite
  Future<List<FoodLog>> getFoodLogs(String userId) async {
    try {
      final response = await _db.listDocuments(
        databaseId: AppConfig.appwriteDatabaseId,
        collectionId: AW.foodLogs,
        queries: [Query.equal('user_id', userId), Query.orderDesc('logged_at')],
      );

      return response.documents.map((doc) {
        return FoodLog(
          id: doc.$id,
          userId: doc.data['user_id'] ?? '',
          foodName: doc.data['food_name'] ?? '',
          mealType: doc.data['meal_type'] ?? '',
          quantityG: (doc.data['quantity_g'] ?? 0).toDouble(),
          calories: (doc.data['calories'] ?? 0).toDouble(),
          proteinG: (doc.data['protein_g'] ?? 0).toDouble(),
          carbsG: (doc.data['carbs_g'] ?? 0).toDouble(),
          fatG: (doc.data['fat_g'] ?? 0).toDouble(),
          loggedAt:
              DateTime.tryParse(doc.data['logged_at'] ?? '') ?? DateTime.now(),
          syncStatus: 'synced',
          recipeId: doc.data['recipe_id'],
        );
      }).toList();
    } catch (e) {
      return [];
    }
  }

  /// Get food logs for a specific date from Appwrite
  Future<List<FoodLog>> getFoodLogsForDate(String userId, DateTime date) async {
    final allLogs = await getFoodLogs(userId);
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    return allLogs.where((log) {
      return log.loggedAt.isAfter(startOfDay) &&
          log.loggedAt.isBefore(endOfDay);
    }).toList();
  }

  /// Update a food log in Appwrite
  Future<bool> updateFoodLog(FoodLog log) async {
    try {
      await _db.updateDocument(
        databaseId: AppConfig.appwriteDatabaseId,
        collectionId: AW.foodLogs,
        documentId: log.id,
        data: log.toAppwrite(),
      );
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Delete a food log from Appwrite
  Future<bool> deleteFoodLog(String id) async {
    try {
      await _db.deleteDocument(
        databaseId: AppConfig.appwriteDatabaseId,
        collectionId: AW.foodLogs,
        documentId: id,
      );
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Get popular/trending food items
  Future<List<Map<String, dynamic>>> getPopularFoodItems({
    int limit = 20,
  }) async {
    try {
      final response = await _db.listDocuments(
        databaseId: AppConfig.appwriteDatabaseId,
        collectionId: AW.foodItems,
        queries: [Query.limit(limit)],
      );

      return response.documents.map((doc) => doc.data).toList();
    } catch (e) {
      return [];
    }
  }
}
