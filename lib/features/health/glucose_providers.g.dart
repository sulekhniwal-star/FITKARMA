// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'glucose_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(glucoseMetadataService)
final glucoseMetadataServiceProvider = GlucoseMetadataServiceProvider._();

final class GlucoseMetadataServiceProvider
    extends
        $FunctionalProvider<
          GlucoseMetadataService,
          GlucoseMetadataService,
          GlucoseMetadataService
        >
    with $Provider<GlucoseMetadataService> {
  GlucoseMetadataServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'glucoseMetadataServiceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$glucoseMetadataServiceHash();

  @$internal
  @override
  $ProviderElement<GlucoseMetadataService> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  GlucoseMetadataService create(Ref ref) {
    return glucoseMetadataService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GlucoseMetadataService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GlucoseMetadataService>(value),
    );
  }
}

String _$glucoseMetadataServiceHash() =>
    r'678ff9552b0385a38bfea661dc866b9853342a63';

@ProviderFor(GlucoseMetadataCache)
final glucoseMetadataCacheProvider = GlucoseMetadataCacheProvider._();

final class GlucoseMetadataCacheProvider
    extends
        $NotifierProvider<
          GlucoseMetadataCache,
          Map<String, Map<String, String?>>
        > {
  GlucoseMetadataCacheProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'glucoseMetadataCacheProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$glucoseMetadataCacheHash();

  @$internal
  @override
  GlucoseMetadataCache create() => GlucoseMetadataCache();

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

String _$glucoseMetadataCacheHash() =>
    r'6e952f1dba17357333e7ab168097169c02e20211';

abstract class _$GlucoseMetadataCache
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
