import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'shared/theme/app_theme.dart';

/// FitKarma Application Root Widget
///
/// This is the main application widget that sets up:
/// - Theme configuration with custom colors and typography
/// - System UI overlay style
/// - MaterialApp with routing configuration placeholder
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

    return MaterialApp(
      title: 'FitKarma',
      debugShowCheckedModeBanner: false,

      // Apply the custom theme
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.light,

      // Placeholder for home screen - will be replaced with actual dashboard
      home: const Scaffold(body: Center(child: Text('FitKarma - Loading...'))),
    );
  }
}
