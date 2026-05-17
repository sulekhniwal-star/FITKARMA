// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sync_worker.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(syncWorker)
final syncWorkerProvider = SyncWorkerProvider._();

final class SyncWorkerProvider
    extends $FunctionalProvider<SyncWorker, SyncWorker, SyncWorker>
    with $Provider<SyncWorker> {
  SyncWorkerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'syncWorkerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$syncWorkerHash();

  @$internal
  @override
  $ProviderElement<SyncWorker> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  SyncWorker create(Ref ref) {
    return syncWorker(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SyncWorker value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SyncWorker>(value),
    );
  }
}

String _$syncWorkerHash() => r'515690c610c51dfd355af2d984bd1ed2a610b2f4';

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
    r'45071cab8780631dcd017a6c42c81fb9a512cd86';

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

String _$syncIntervalHash() => r'9c6e4a1a984427ee898d215b9ca2a781aa4851d6';

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

String _$hasDlqRecordsHash() => r'1958636a3c4c9f95c791ac953b4fd88e29ffe753';
