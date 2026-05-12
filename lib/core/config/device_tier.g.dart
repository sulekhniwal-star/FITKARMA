// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'device_tier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(deviceTier)
final deviceTierProvider = DeviceTierProvider._();

final class DeviceTierProvider
    extends
        $FunctionalProvider<
          AsyncValue<DeviceTier>,
          DeviceTier,
          FutureOr<DeviceTier>
        >
    with $FutureModifier<DeviceTier>, $FutureProvider<DeviceTier> {
  DeviceTierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'deviceTierProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$deviceTierHash();

  @$internal
  @override
  $FutureProviderElement<DeviceTier> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<DeviceTier> create(Ref ref) {
    return deviceTier(ref);
  }
}

String _$deviceTierHash() => r'83c1baa8999e8392dde844d3397b5aec524e0c45';
