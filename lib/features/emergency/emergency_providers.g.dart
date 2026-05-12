// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'emergency_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(EmergencyContacts)
final emergencyContactsProvider = EmergencyContactsProvider._();

final class EmergencyContactsProvider
    extends $NotifierProvider<EmergencyContacts, List<EmergencyContact>> {
  EmergencyContactsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'emergencyContactsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$emergencyContactsHash();

  @$internal
  @override
  EmergencyContacts create() => EmergencyContacts();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<EmergencyContact> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<EmergencyContact>>(value),
    );
  }
}

String _$emergencyContactsHash() => r'8bd1dda92d947c19f51d9bb919c58417c5d3f6aa';

abstract class _$EmergencyContacts extends $Notifier<List<EmergencyContact>> {
  List<EmergencyContact> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref as $Ref<List<EmergencyContact>, List<EmergencyContact>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<List<EmergencyContact>, List<EmergencyContact>>,
              List<EmergencyContact>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
