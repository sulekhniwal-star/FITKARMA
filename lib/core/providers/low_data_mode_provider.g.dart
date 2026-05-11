// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'low_data_mode_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(LowDataMode)
final lowDataModeProvider = LowDataModeProvider._();

final class LowDataModeProvider
    extends $AsyncNotifierProvider<LowDataMode, bool> {
  LowDataModeProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'lowDataModeProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$lowDataModeHash();

  @$internal
  @override
  LowDataMode create() => LowDataMode();
}

String _$lowDataModeHash() => r'7b9e305a823e5a874a47fd2cdc95c70593d99151';

abstract class _$LowDataMode extends $AsyncNotifier<bool> {
  FutureOr<bool> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<bool>, bool>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<bool>, bool>,
              AsyncValue<bool>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
