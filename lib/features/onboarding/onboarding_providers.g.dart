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

String _$authHash() => r'fd76af12a2943890e3e5e3e37aec1d3c22c34158';

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

/// DoshaQuizNotifier — Manages the state of the 10-question quiz.

@ProviderFor(DoshaQuiz)
final doshaQuizProvider = DoshaQuizProvider._();

/// DoshaQuizNotifier — Manages the state of the 10-question quiz.
final class DoshaQuizProvider
    extends $NotifierProvider<DoshaQuiz, Map<int, DoshaType>> {
  /// DoshaQuizNotifier — Manages the state of the 10-question quiz.
  DoshaQuizProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'doshaQuizProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$doshaQuizHash();

  @$internal
  @override
  DoshaQuiz create() => DoshaQuiz();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Map<int, DoshaType> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Map<int, DoshaType>>(value),
    );
  }
}

String _$doshaQuizHash() => r'cf6073be730e102d5eb0db914b33472ed7ba9ddd';

/// DoshaQuizNotifier — Manages the state of the 10-question quiz.

abstract class _$DoshaQuiz extends $Notifier<Map<int, DoshaType>> {
  Map<int, DoshaType> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<Map<int, DoshaType>, Map<int, DoshaType>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<Map<int, DoshaType>, Map<int, DoshaType>>,
              Map<int, DoshaType>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

/// Goals — Multi-selection provider for health goals and target metrics.
/// Generates a `goalsProvider` that reads/writes `GoalsState`.

@ProviderFor(Goals)
final goalsProvider = GoalsProvider._();

/// Goals — Multi-selection provider for health goals and target metrics.
/// Generates a `goalsProvider` that reads/writes `GoalsState`.
final class GoalsProvider extends $NotifierProvider<Goals, GoalsState> {
  /// Goals — Multi-selection provider for health goals and target metrics.
  /// Generates a `goalsProvider` that reads/writes `GoalsState`.
  GoalsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'goalsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$goalsHash();

  @$internal
  @override
  Goals create() => Goals();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GoalsState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GoalsState>(value),
    );
  }
}

String _$goalsHash() => r'ad34080dd010fb112b3da68a0c4691a4c867239d';

/// Goals — Multi-selection provider for health goals and target metrics.
/// Generates a `goalsProvider` that reads/writes `GoalsState`.

abstract class _$Goals extends $Notifier<GoalsState> {
  GoalsState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<GoalsState, GoalsState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<GoalsState, GoalsState>,
              GoalsState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
