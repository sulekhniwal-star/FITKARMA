import 'dart:convert';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'core_providers.dart';

part 'feature_flags_provider.freezed.dart';
part 'feature_flags_provider.g.dart';

@freezed
class FeatureFlags with _$FeatureFlags {
  const factory FeatureFlags({
    @Default(true) bool aiInsights,
    @Default(false) bool wearableSync,
    @Default(true) bool periodTracker,
    @Default(false) bool socialFeed,
    @Default(false) bool weddingPlanner,
    @Default(true) bool doshaQuiz,
    @Default(false) bool festivalCalendar,
    @Default(false) bool proSubscription,
    @Default(false) bool fhirExport,
    @Default(false) bool voiceLogging,
    @Default(false) bool cgmIntegration,
    @Default(false) bool pharmacySearch,
  }) = _FeatureFlags;

  factory FeatureFlags.fromJson(Map<String, dynamic> json) => _$FeatureFlagsFromJson(json);

  static const defaults = FeatureFlags();
}

@riverpod
Future<FeatureFlags> featureFlags(FeatureFlagsRef ref) async {
  final functions = ref.watch(appwriteFunctionsProvider);

  try {
    final response = await functions.createExecution(
      functionId: 'fitkarma-core',
      body: jsonEncode({'action': 'get_feature_flags'}),
    );
    
    if (response.status == 'completed') {
      final data = jsonDecode(response.responseBody);
      return FeatureFlags.fromJson(data);
    }
    return FeatureFlags.defaults;
  } catch (_) {
    return FeatureFlags.defaults;
  }
}
