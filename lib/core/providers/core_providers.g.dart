// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'core_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(appDatabase)
final appDatabaseProvider = AppDatabaseProvider._();

final class AppDatabaseProvider
    extends $FunctionalProvider<AppDatabase, AppDatabase, AppDatabase>
    with $Provider<AppDatabase> {
  AppDatabaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appDatabaseProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appDatabaseHash();

  @$internal
  @override
  $ProviderElement<AppDatabase> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AppDatabase create(Ref ref) {
    return appDatabase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AppDatabase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AppDatabase>(value),
    );
  }
}

String _$appDatabaseHash() => r'3d3a397d2ea952fc020fce0506793a5564e93530';

/// appwriteClientProvider — Configures the core Appwrite client.
///
/// Reads configuration from --dart-define environment variables.

@ProviderFor(appwriteClient)
final appwriteClientProvider = AppwriteClientProvider._();

/// appwriteClientProvider — Configures the core Appwrite client.
///
/// Reads configuration from --dart-define environment variables.

final class AppwriteClientProvider
    extends $FunctionalProvider<Client, Client, Client>
    with $Provider<Client> {
  /// appwriteClientProvider — Configures the core Appwrite client.
  ///
  /// Reads configuration from --dart-define environment variables.
  AppwriteClientProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appwriteClientProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appwriteClientHash();

  @$internal
  @override
  $ProviderElement<Client> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  Client create(Ref ref) {
    return appwriteClient(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Client value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Client>(value),
    );
  }
}

String _$appwriteClientHash() => r'588ba90736c7150a28c2c3f2b2b717ddf36b58cc';

@ProviderFor(appwriteDatabases)
final appwriteDatabasesProvider = AppwriteDatabasesProvider._();

final class AppwriteDatabasesProvider
    extends $FunctionalProvider<Databases, Databases, Databases>
    with $Provider<Databases> {
  AppwriteDatabasesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appwriteDatabasesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appwriteDatabasesHash();

  @$internal
  @override
  $ProviderElement<Databases> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  Databases create(Ref ref) {
    return appwriteDatabases(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Databases value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Databases>(value),
    );
  }
}

String _$appwriteDatabasesHash() => r'0dd371f80b0913101a7f25dc28df59ce2e75d777';

@ProviderFor(appwriteStorage)
final appwriteStorageProvider = AppwriteStorageProvider._();

final class AppwriteStorageProvider
    extends $FunctionalProvider<Storage, Storage, Storage>
    with $Provider<Storage> {
  AppwriteStorageProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appwriteStorageProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appwriteStorageHash();

  @$internal
  @override
  $ProviderElement<Storage> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  Storage create(Ref ref) {
    return appwriteStorage(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Storage value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Storage>(value),
    );
  }
}

String _$appwriteStorageHash() => r'df63e1e9bd5679a4627e84fa426c0bd4d1d76891';

@ProviderFor(appwriteFunctions)
final appwriteFunctionsProvider = AppwriteFunctionsProvider._();

final class AppwriteFunctionsProvider
    extends $FunctionalProvider<Functions, Functions, Functions>
    with $Provider<Functions> {
  AppwriteFunctionsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appwriteFunctionsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appwriteFunctionsHash();

  @$internal
  @override
  $ProviderElement<Functions> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  Functions create(Ref ref) {
    return appwriteFunctions(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Functions value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Functions>(value),
    );
  }
}

String _$appwriteFunctionsHash() => r'dde98ec414867fd35d39bbc4e3157725834638be';

@ProviderFor(appwriteAccount)
final appwriteAccountProvider = AppwriteAccountProvider._();

final class AppwriteAccountProvider
    extends $FunctionalProvider<Account, Account, Account>
    with $Provider<Account> {
  AppwriteAccountProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appwriteAccountProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appwriteAccountHash();

  @$internal
  @override
  $ProviderElement<Account> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  Account create(Ref ref) {
    return appwriteAccount(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Account value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Account>(value),
    );
  }
}

String _$appwriteAccountHash() => r'e40c83404bb3689a262bde501d894c3c8ac1787b';

@ProviderFor(isPro)
final isProProvider = IsProProvider._();

final class IsProProvider
    extends $FunctionalProvider<AsyncValue<bool>, bool, FutureOr<bool>>
    with $FutureModifier<bool>, $FutureProvider<bool> {
  IsProProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'isProProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$isProHash();

  @$internal
  @override
  $FutureProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<bool> create(Ref ref) {
    return isPro(ref);
  }
}

String _$isProHash() => r'8297031fc0a08356b4b8c37f2c268607f4b320a9';
