import 'package:appwrite/appwrite.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/di/providers.dart';

class CloudFunctionService {
  final Functions _functions;

  CloudFunctionService(this._functions);

  Future<void> sendFamilyNudge(String userId, String message) async {
    await _functions.createExecution(
      functionId: 'family-nudge',
      body: '{"userId": "$userId", "message": "$message"}',
    );
  }

  Future<void> syncWearableToken(String provider, String code) async {
    await _functions.createExecution(
      functionId: 'wearable-sync',
      body: '{"provider": "$provider", "code": "$code"}',
    );
  }
}

final cloudFunctionServiceProvider = Provider<CloudFunctionService>((ref) {
  final functions = ref.watch(appwriteFunctionsProvider);
  return CloudFunctionService(functions);
});
