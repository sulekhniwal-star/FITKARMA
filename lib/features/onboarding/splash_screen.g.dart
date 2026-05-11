// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'splash_screen.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// SplashScreen — Logo reveal animation → auto-redirect based on auth.
/// Shows LogoReveal for 1.5s with spring animation, then navigates.

@ProviderFor(SplashScreen)
final splashScreenProvider = SplashScreenProvider._();

/// SplashScreen — Logo reveal animation → auto-redirect based on auth.
/// Shows LogoReveal for 1.5s with spring animation, then navigates.
final class SplashScreenProvider
    extends $NotifierProvider<SplashScreen, Widget> {
  /// SplashScreen — Logo reveal animation → auto-redirect based on auth.
  /// Shows LogoReveal for 1.5s with spring animation, then navigates.
  SplashScreenProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'splashScreenProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$splashScreenHash();

  @$internal
  @override
  SplashScreen create() => SplashScreen();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Widget value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Widget>(value),
    );
  }
}

String _$splashScreenHash() => r'95dbd618595f09075a90c53a6d3cd4bcbe681738';

/// SplashScreen — Logo reveal animation → auto-redirect based on auth.
/// Shows LogoReveal for 1.5s with spring animation, then navigates.

abstract class _$SplashScreen extends $Notifier<Widget> {
  Widget build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<Widget, Widget>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<Widget, Widget>,
              Widget,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
