// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'correlation_engine.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_HealthInsight _$HealthInsightFromJson(Map<String, dynamic> json) =>
    _HealthInsight(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      category: json['category'] as String,
      confidence: (json['confidence'] as num).toDouble(),
      isActionable: json['isActionable'] as bool,
    );

Map<String, dynamic> _$HealthInsightToJson(_HealthInsight instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'category': instance.category,
      'confidence': instance.confidence,
      'isActionable': instance.isActionable,
    };

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(CorrelationEngine)
final correlationEngineProvider = CorrelationEngineProvider._();

final class CorrelationEngineProvider
    extends $AsyncNotifierProvider<CorrelationEngine, List<HealthInsight>> {
  CorrelationEngineProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'correlationEngineProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$correlationEngineHash();

  @$internal
  @override
  CorrelationEngine create() => CorrelationEngine();
}

String _$correlationEngineHash() => r'01adc0e4d6a6903cb04ab198a583cd7211b0bc58';

abstract class _$CorrelationEngine extends $AsyncNotifier<List<HealthInsight>> {
  FutureOr<List<HealthInsight>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<List<HealthInsight>>, List<HealthInsight>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<HealthInsight>>, List<HealthInsight>>,
              AsyncValue<List<HealthInsight>>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
