import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../shared/widgets/logo_reveal.dart';
import '../../core/providers/core_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'splash_screen.g.dart';

/// SplashScreen — Logo reveal animation → auto-redirect based on auth.
/// Shows LogoReveal for 1.5s with spring animation, then navigates.
@riverpod
class SplashScreen extends _$SplashScreen {
  @override
  Widget build() {
    // Splash screen logic handled by the widget below.
    // This provider exists to watch auth state if needed.
    return const _SplashScreenContent();
  }
}

class _SplashScreenContent extends ConsumerStatefulWidget {
  const _SplashScreenContent();

  @override
  ConsumerState<_SplashScreenContent> createState() => _SplashScreenContentState();
}

class _SplashScreenContentState extends ConsumerState<_SplashScreenContent> {
  @override
  void initState() {
    super.initState();
    _handleNavigation();
  }

  Future<void> _handleNavigation() async {
    // Wait for logo animation to complete (1.5s total)
    await Future.delayed(const Duration(milliseconds: 1500));

    if (!mounted) return;

    // Check auth state
    final authState = ref.read(authProvider);

    // If auth state is still loading, wait briefly
    if (authState.isLoading) {
      await Future.delayed(const Duration(milliseconds: 500));
    }

    if (!mounted) return;

    final user = authState.valueOrNull;
    if (user != null) {
      // User is logged in → go to dashboard
      context.go('/home/dashboard');
    } else {
      // Not logged in → go to welcome
      context.go('/onboarding/welcome');
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: LogoReveal(),
      ),
    );
  }
}
