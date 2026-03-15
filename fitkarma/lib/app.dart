// lib/app.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'shared/theme/app_theme.dart';
import 'core/router/app_router.dart';
import 'core/security/biometric_service.dart';

/// FitKarma Application Root Widget
///
/// This is the main application widget that sets up:
/// - Theme configuration with custom colors and typography
/// - GoRouter with all routes from Section 19
/// - System UI overlay style
/// - 5-tab BottomNavigationBar with bilingual labels
/// - Biometric lock on app resume
class FitKarmaApp extends StatefulWidget {
  const FitKarmaApp({super.key});

  @override
  State<FitKarmaApp> createState() => _FitKarmaAppState();
}

class _FitKarmaAppState extends State<FitKarmaApp> with WidgetsBindingObserver {
  final BiometricService _biometricService = BiometricService();
  bool _isAuthenticated = true; // Start as authenticated
  
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    
    // Check for biometric on app resume (not on first launch)
    if (state == AppLifecycleState.resumed) {
      _checkBiometricOnResume();
    }
  }

  Future<void> _checkBiometricOnResume() async {
    // Skip biometric check on first launch
    final isFirstLaunch = await _biometricService.isFirstLaunch();
    if (isFirstLaunch) {
      return;
    }

    // Check if biometric lock is enabled
    final isBiometricEnabled = await _biometricService.isBiometricEnabled();
    if (!isBiometricEnabled) {
      return;
    }

    // If app was in background and biometric is enabled, require authentication
    if (!_isAuthenticated) {
      return;
    }

    // Mark as not authenticated until we verify
    _isAuthenticated = false;

    // Authenticate
    final authenticated = await _biometricService.authenticate(
      reason: 'Authenticate to unlock FitKarma',
    );

    if (authenticated) {
      _isAuthenticated = true;
    } else {
      // Could show a locked screen or pop back to login
      // For now, we just stay unauthenticated
      debugPrint('Biometric authentication failed');
    }
  }

  @override
  Widget build(BuildContext context) {
    // Set system UI overlay style
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
    );

    return MaterialApp.router(
      title: 'FitKarma',
      debugShowCheckedModeBanner: false,

      // Apply the custom theme
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.light,

      // GoRouter configuration
      routerConfig: AppRouter.router,
    );
  }
}
