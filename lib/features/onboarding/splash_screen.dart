import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../shared/widgets/logo_reveal.dart';
import 'onboarding_providers.dart';

/// SplashScreen — Logo reveal animation → auto-redirect based on auth.
/// Shows LogoReveal for 1.5s with spring animation, then navigates.
class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _handleNavigation();
  }

  Future<void> _handleNavigation() async {
    // 1. Wait for the core logo animation to complete (1.5s)
    final stopwatch = Stopwatch()..start();
    
    // 2. Concurrently ensure auth state is resolved
    // We use ref.read(authProvider.future) to wait if it's still loading
    try {
      await ref.read(authProvider.future);
    } catch (e) {
      // Ignore errors here, we'll check the value below
    }

    // 3. Ensure at least 1.5s has passed for the animation
    final elapsed = stopwatch.elapsedMilliseconds;
    if (elapsed < 1500) {
      await Future.delayed(Duration(milliseconds: 1500 - elapsed));
    }

    if (!mounted) return;

    // 4. Final check of auth state
    final user = ref.read(authProvider).value;
    
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
      backgroundColor: AppColorsDark.bg0,
      body: Center(
        child: LogoReveal(),
      ),
    );
  }
}
