import 'dart:convert';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../core/providers/core_providers.dart';
import '../onboarding/onboarding_providers.dart';

part 'ai_coach_provider.g.dart';

@riverpod
class AiCoach extends _$AiCoach {
  @override
  FutureOr<List<Map<String, String>>> build() {
    return [];
  }

  Future<void> sendMessage(String message) async {
    final functions = ref.read(appwriteFunctionsProvider);
    final user = ref.read(authProvider).value;

    if (user == null) return;

    final currentMessages = state.value ?? [];
    state = AsyncValue.data([...currentMessages, {'role': 'user', 'content': message}]);

    try {
      final execution = await functions.createExecution(
        functionId: 'fitkarma-cores',
        body: jsonEncode({
          'action': 'ai_coach',
          'userId': user.$id,
          'message': message,
        }),
      );

      if (execution.status.toString().contains('completed')) {
        final data = jsonDecode(execution.responseBody);
        final reply = data['reply'] as String;
        state = AsyncValue.data([...state.value!, {'role': 'coach', 'content': reply}]);
      } else {
        state = AsyncValue.error('Coach is busy, try again later', StackTrace.current);
      }
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }
}
