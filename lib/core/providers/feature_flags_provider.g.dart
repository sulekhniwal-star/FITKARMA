// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'feature_flags_provider.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_FeatureFlags _$FeatureFlagsFromJson(Map<String, dynamic> json) =>
    _FeatureFlags(
      aiInsights: json['aiInsights'] as bool? ?? true,
      wearableSync: json['wearableSync'] as bool? ?? false,
      periodTracker: json['periodTracker'] as bool? ?? true,
      socialFeed: json['socialFeed'] as bool? ?? false,
      weddingPlanner: json['weddingPlanner'] as bool? ?? false,
      doshaQuiz: json['doshaQuiz'] as bool? ?? true,
      festivalCalendar: json['festivalCalendar'] as bool? ?? false,
      proSubscription: json['proSubscription'] as bool? ?? false,
      fhirExport: json['fhirExport'] as bool? ?? false,
      voiceLogging: json['voiceLogging'] as bool? ?? false,
      cgmIntegration: json['cgmIntegration'] as bool? ?? false,
      pharmacySearch: json['pharmacySearch'] as bool? ?? false,
    );

Map<String, dynamic> _$FeatureFlagsToJson(_FeatureFlags instance) =>
    <String, dynamic>{
      'aiInsights': instance.aiInsights,
      'wearableSync': instance.wearableSync,
      'periodTracker': instance.periodTracker,
      'socialFeed': instance.socialFeed,
      'weddingPlanner': instance.weddingPlanner,
      'doshaQuiz': instance.doshaQuiz,
      'festivalCalendar': instance.festivalCalendar,
      'proSubscription': instance.proSubscription,
      'fhirExport': instance.fhirExport,
      'voiceLogging': instance.voiceLogging,
      'cgmIntegration': instance.cgmIntegration,
      'pharmacySearch': instance.pharmacySearch,
    };

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(featureFlags)
final featureFlagsProvider = FeatureFlagsProvider._();

final class FeatureFlagsProvider
    extends
        $FunctionalProvider<
          AsyncValue<FeatureFlags>,
          FeatureFlags,
          FutureOr<FeatureFlags>
        >
    with $FutureModifier<FeatureFlags>, $FutureProvider<FeatureFlags> {
  FeatureFlagsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'featureFlagsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$featureFlagsHash();

  @$internal
  @override
  $FutureProviderElement<FeatureFlags> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<FeatureFlags> create(Ref ref) {
    return featureFlags(ref);
  }
}

String _$featureFlagsHash() => r'c93f72794769242a4d50bd01a0039f2a264bc634';
