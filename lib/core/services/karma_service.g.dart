// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'karma_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(KarmaService)
final karmaServiceProvider = KarmaServiceProvider._();

final class KarmaServiceProvider extends $NotifierProvider<KarmaService, void> {
  KarmaServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'karmaServiceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$karmaServiceHash();

  @$internal
  @override
  KarmaService create() => KarmaService();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<void>(value),
    );
  }
}

String _$karmaServiceHash() => r'fb3a6bb6927828095cffb012cbb87d4e2b4b6add';

abstract class _$KarmaService extends $Notifier<void> {
  void build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<void, void>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<void, void>,
              void,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
