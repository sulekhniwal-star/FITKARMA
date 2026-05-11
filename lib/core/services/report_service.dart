import 'dart:convert';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../providers/core_providers.dart';
import '../../features/onboarding/onboarding_providers.dart';

part 'report_service.g.dart';

@riverpod
class ReportService extends _$ReportService {
  @override
  void build() {}

  Future<String?> generateShareLink(String reportId) async {
    final functions = ref.read(appwriteFunctionsProvider);
    final user = ref.read(authProvider).value;

    if (user == null) return null;

    try {
      final execution = await functions.createExecution(
        functionId: 'fitkarma-cores',
        body: jsonEncode({
          'action': 'generate_share_link',
          'userId': user.$id,
          'reportId': reportId,
        }),
      );

      if (execution.status == 'completed') {
        final data = jsonDecode(execution.responseBody);
        return data['shareUrl'];
      }
    } catch (e) {
      print('Error generating share link: $e');
    }
    return null;
  }
}
