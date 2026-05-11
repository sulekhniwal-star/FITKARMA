import 'dart:convert';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../providers/core_providers.dart';
import '../../features/onboarding/onboarding_providers.dart';

part 'karma_service.g.dart';

@riverpod
class KarmaService extends _$KarmaService {
  @override
  void build() {}

  Future<void> awardXP(String eventType) async {
    final functions = ref.read(appwriteFunctionsProvider);
    final user = ref.read(authProvider).value;

    if (user == null) return;

    try {
      await functions.createExecution(
        functionId: 'fitkarma-cores',
        body: jsonEncode({
          'action': 'award_xp',
          'userId': user.$id,
          'eventType': eventType,
        }),
      );
    } catch (e) {
      // Log error but don't break the UI
      print('Error awarding XP: $e');
    }
  }
}
