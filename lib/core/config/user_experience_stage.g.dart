// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_experience_stage.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(UxStage)
final uxStageProvider = UxStageProvider._();

final class UxStageProvider extends $AsyncNotifierProvider<UxStage, UXStage> {
  UxStageProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'uxStageProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$uxStageHash();

  @$internal
  @override
  UxStage create() => UxStage();
}

String _$uxStageHash() => r'7783713a5e75adc1557a3ac9e8ddf6f6bcf1a79c';

abstract class _$UxStage extends $AsyncNotifier<UXStage> {
  FutureOr<UXStage> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<UXStage>, UXStage>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<UXStage>, UXStage>,
              AsyncValue<UXStage>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
