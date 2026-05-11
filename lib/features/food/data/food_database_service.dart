import 'dart:convert';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../core/providers/core_providers.dart';

part 'food_database_service.g.dart';

@riverpod
class FoodDatabaseService extends _$FoodDatabaseService {
  @override
  void build() {}

  Future<Map<String, dynamic>?> searchRemote({String? query, String? barcode}) async {
    final functions = ref.read(appwriteFunctionsProvider);

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
        if (data['ok']) {
          return data;
        }
      }
    } catch (e) {
      print('Error searching food: $e');
    }
    return null;
  }
}
