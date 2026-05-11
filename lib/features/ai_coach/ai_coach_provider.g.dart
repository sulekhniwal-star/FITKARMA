// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ai_coach_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(AiCoach)
final aiCoachProvider = AiCoachProvider._();

final class AiCoachProvider
    extends $AsyncNotifierProvider<AiCoach, List<Map<String, String>>> {
  AiCoachProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'aiCoachProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$aiCoachHash();

  @$internal
  @override
  AiCoach create() => AiCoach();
}

String _$aiCoachHash() => r'3ce97d9c5350269f6b42d8ed73a2f775d03985ad';

abstract class _$AiCoach extends $AsyncNotifier<List<Map<String, String>>> {
  FutureOr<List<Map<String, String>>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref
            as $Ref<
              AsyncValue<List<Map<String, String>>>,
              List<Map<String, String>>
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<List<Map<String, String>>>,
                List<Map<String, String>>
              >,
              AsyncValue<List<Map<String, String>>>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
