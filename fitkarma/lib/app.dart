import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'shared/theme/app_theme.dart';
import 'core/router/app_router.dart';

/// FitKarma Application Root Widget
///
/// This is the main application widget that sets up:
/// - Theme configuration with custom colors and typography
/// - GoRouter with all routes from Section 19
/// - System UI overlay style
/// - 5-tab BottomNavigationBar with bilingual labels
class FitKarmaApp extends StatelessWidget {
  const FitKarmaApp({super.key});

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
