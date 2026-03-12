// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'connectivity_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$connectivityStatusHash() =>
    r'980882b6b98a02e431d5f3de24ba9eaffab9e800';

/// See also [connectivityStatus].
@ProviderFor(connectivityStatus)
final connectivityStatusProvider =
    AutoDisposeStreamProvider<List<ConnectivityResult>>.internal(
  connectivityStatus,
  name: r'connectivityStatusProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$connectivityStatusHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef ConnectivityStatusRef
    = AutoDisposeStreamProviderRef<List<ConnectivityResult>>;
String _$networkNotifierHash() => r'1b2e47940f829d5deda772486d1095412d9445c0';

/// See also [NetworkNotifier].
@ProviderFor(NetworkNotifier)
final networkNotifierProvider =
    AutoDisposeNotifierProvider<NetworkNotifier, bool>.internal(
  NetworkNotifier.new,
  name: r'networkNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$networkNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$NetworkNotifier = AutoDisposeNotifier<bool>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
