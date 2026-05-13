// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'food_database_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(FoodDatabaseService)
final foodDatabaseServiceProvider = FoodDatabaseServiceProvider._();

final class FoodDatabaseServiceProvider
    extends $NotifierProvider<FoodDatabaseService, void> {
  FoodDatabaseServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'foodDatabaseServiceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$foodDatabaseServiceHash();

  @$internal
  @override
  FoodDatabaseService create() => FoodDatabaseService();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<void>(value),
    );
  }
}

String _$foodDatabaseServiceHash() =>
    r'da898b49453d7033648d867b0e4b523d8a7bc58e';

abstract class _$FoodDatabaseService extends $Notifier<void> {
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
