import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class OpenFoodFactsClient {
  final Dio _dio;

  OpenFoodFactsClient(this._dio);

  /// searchByName — Searches Open Food Facts via standard CGI API.
  Future<List<Map<String, dynamic>>> searchByName(String query, {int limit = 20}) async {
    try {
      final response = await _dio.get(
        'https://world.openfoodfacts.org/cgi/search.pl',
        queryParameters: {
          'search_terms': query,
          'search_simple': 1,
          'action': 'process',
          'json': 1,
          'page_size': limit,
        },
      );

      if (response.statusCode == 200 && response.data is Map) {
        final data = response.data as Map;
        final products = data['products'] as List<dynamic>?;
        if (products != null) {
          return products.whereType<Map>().map((e) => Map<String, dynamic>.from(e)).toList();
        }
      }
    } catch (e) {
      // Return empty list on timeout or network errors
    }
    return [];
  }

  /// searchByBarcode — Looks up a specific product by its EAN/UPC code.
  Future<Map<String, dynamic>?> searchByBarcode(String barcode) async {
    try {
      final response = await _dio.get(
        'https://world.openfoodfacts.org/api/v0/product/$barcode.json',
      );

      if (response.statusCode == 200 && response.data is Map) {
        final data = response.data as Map;
        if (data['status'] == 1 && data['product'] is Map) {
          return Map<String, dynamic>.from(data['product'] as Map);
        }
      }
    } catch (e) {
      // Return null on failure
    }
    return null;
  }
}

final openFoodFactsClientProvider = Provider<OpenFoodFactsClient>((ref) {
  final dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 5),
      headers: {
        'User-Agent': 'FitKarma/1.0 (offline-first Indian nutrition tracker)',
      },
    ),
  );
  return OpenFoodFactsClient(dio);
});
