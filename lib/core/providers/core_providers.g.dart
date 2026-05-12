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

String _$appDatabaseHash() => r'8c69eb46d45206533c176c88a926608e79ca927d';

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

String _$appwriteClientHash() => r'777cd590463dae4f9b03fbea9d73f1e0dfb18011';

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

String _$appwriteDatabasesHash() => r'd3841ab93533f56a0b57d7631fbd444af5aa467a';

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

String _$appwriteStorageHash() => r'b1c835e05314f23fe37b1729a74bbb54963188e6';

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

String _$appwriteFunctionsHash() => r'092cfb103b6c96f52da562909c80c2ee8569375a';

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

String _$appwriteAccountHash() => r'7c5c3bf21a5f8cc29d2fbcff5337c6cfc39ff979';

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

String _$isProHash() => r'daa32388b468b581d2be19ff8d5fdb1a8eb8f148';
