// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bp_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(bpMetadataService)
final bpMetadataServiceProvider = BpMetadataServiceProvider._();

final class BpMetadataServiceProvider
    extends
        $FunctionalProvider<
          BpMetadataService,
          BpMetadataService,
          BpMetadataService
        >
    with $Provider<BpMetadataService> {
  BpMetadataServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'bpMetadataServiceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$bpMetadataServiceHash();

  @$internal
  @override
  $ProviderElement<BpMetadataService> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  BpMetadataService create(Ref ref) {
    return bpMetadataService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(BpMetadataService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<BpMetadataService>(value),
    );
  }
}

String _$bpMetadataServiceHash() => r'544c2271d65bacd5698957c93d415bd64086545b';

@ProviderFor(BpMetadataCache)
final bpMetadataCacheProvider = BpMetadataCacheProvider._();

final class BpMetadataCacheProvider
    extends
        $NotifierProvider<BpMetadataCache, Map<String, Map<String, String?>>> {
  BpMetadataCacheProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'bpMetadataCacheProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$bpMetadataCacheHash();

  @$internal
  @override
  BpMetadataCache create() => BpMetadataCache();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Map<String, Map<String, String?>> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Map<String, Map<String, String?>>>(
        value,
      ),
    );
  }
}

String _$bpMetadataCacheHash() => r'd21dea9f4b135fb4662611fb13613c3f00b6139f';

abstract class _$BpMetadataCache
    extends $Notifier<Map<String, Map<String, String?>>> {
  Map<String, Map<String, String?>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref
            as $Ref<
              Map<String, Map<String, String?>>,
              Map<String, Map<String, String?>>
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                Map<String, Map<String, String?>>,
                Map<String, Map<String, String?>>
              >,
              Map<String, Map<String, String?>>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
