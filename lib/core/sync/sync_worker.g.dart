// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sync_worker.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(connectivityService)
final connectivityServiceProvider = ConnectivityServiceProvider._();

final class ConnectivityServiceProvider
    extends
        $FunctionalProvider<
          AsyncValue<ConnectivityResult>,
          ConnectivityResult,
          Stream<ConnectivityResult>
        >
    with
        $FutureModifier<ConnectivityResult>,
        $StreamProvider<ConnectivityResult> {
  ConnectivityServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'connectivityServiceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$connectivityServiceHash();

  @$internal
  @override
  $StreamProviderElement<ConnectivityResult> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<ConnectivityResult> create(Ref ref) {
    return connectivityService(ref);
  }
}

String _$connectivityServiceHash() =>
    r'ffdf91f8ed9e0260e3881f4a7f1fa291dd24033b';

@ProviderFor(syncInterval)
final syncIntervalProvider = SyncIntervalProvider._();

final class SyncIntervalProvider
    extends $FunctionalProvider<Duration, Duration, Duration>
    with $Provider<Duration> {
  SyncIntervalProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'syncIntervalProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$syncIntervalHash();

  @$internal
  @override
  $ProviderElement<Duration> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  Duration create(Ref ref) {
    return syncInterval(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Duration value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Duration>(value),
    );
  }
}

String _$syncIntervalHash() => r'adf983fbaff012aca5ac9a309617477a27ca49d9';

@ProviderFor(hasDlqRecords)
final hasDlqRecordsProvider = HasDlqRecordsProvider._();

final class HasDlqRecordsProvider
    extends $FunctionalProvider<AsyncValue<bool>, bool, Stream<bool>>
    with $FutureModifier<bool>, $StreamProvider<bool> {
  HasDlqRecordsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'hasDlqRecordsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$hasDlqRecordsHash();

  @$internal
  @override
  $StreamProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<bool> create(Ref ref) {
    return hasDlqRecords(ref);
  }
}

String _$hasDlqRecordsHash() => r'cd5658ab3de38cf19867f9b492693314dc32cad8';
