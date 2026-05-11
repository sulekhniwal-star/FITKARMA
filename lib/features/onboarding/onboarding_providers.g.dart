// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'onboarding_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// AuthNotifier — Manages user authentication state via Appwrite.

@ProviderFor(Auth)
final authProvider = AuthProvider._();

/// AuthNotifier — Manages user authentication state via Appwrite.
final class AuthProvider extends $AsyncNotifierProvider<Auth, models.User?> {
  /// AuthNotifier — Manages user authentication state via Appwrite.
  AuthProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'authProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$authHash();

  @$internal
  @override
  Auth create() => Auth();
}

String _$authHash() => r'8f7870db878e861b2e5fef44ad33dcabb5a0ce77';

/// AuthNotifier — Manages user authentication state via Appwrite.

abstract class _$Auth extends $AsyncNotifier<models.User?> {
  FutureOr<models.User?> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<models.User?>, models.User?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<models.User?>, models.User?>,
              AsyncValue<models.User?>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
