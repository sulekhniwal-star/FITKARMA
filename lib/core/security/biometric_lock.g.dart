// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'biometric_lock.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(BiometricAuthState)
final biometricAuthStateProvider = BiometricAuthStateProvider._();

final class BiometricAuthStateProvider
    extends $NotifierProvider<BiometricAuthState, Set<String>> {
  BiometricAuthStateProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'biometricAuthStateProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$biometricAuthStateHash();

  @$internal
  @override
  BiometricAuthState create() => BiometricAuthState();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Set<String> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Set<String>>(value),
    );
  }
}

String _$biometricAuthStateHash() =>
    r'ed58984ae73c538a48bc44341bf43bddecf7a99a';

abstract class _$BiometricAuthState extends $Notifier<Set<String>> {
  Set<String> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<Set<String>, Set<String>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<Set<String>, Set<String>>,
              Set<String>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
