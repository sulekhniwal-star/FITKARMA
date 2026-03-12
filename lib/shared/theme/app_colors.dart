import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFFFF5722);
  static const Color primaryLight = Color(0xFFFF8A65);
  static const Color primarySurface = Color(0xFFFFF3EF);

  static const Color secondary = Color(0xFF3F3D8F);
  static const Color secondaryDark = Color(0xFF2C2A6B);
  static const Color secondarySurface = Color(0xFFE8E7F6);

  static const Color accent = Color(0xFFFFC107);
  static const Color accentLight = Color(0xFFFFECB3);
  static const Color accentDark = Color(0xFFFF8F00);

  // Background and Surface Colors
  static const Color background = Color(0xFFFDF6EC);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceVariant = Color(0xFFF5F5F5);

  // Border/Divider Colors
  static const Color divider = Color(0xFFEEE8E4);

  // Semantic Colors
  static const Color success = Color(0xFF4CAF50);
  static const Color teal = Color(0xFF009688);
  static const Color purple = Color(0xFF9C27B0);
  static const Color warning = Color(0xFFFF9800);
  static const Color error = Color(0xFFF44336);
  static const Color errorLight = Color(0xFFFFEBEE); // Derived for usage in error background
  static const Color rose = Color(0xFFE91E63);

  // Text Colors
  static const Color textPrimary = Color(0xFF1A1A2E);
  static const Color textSecondary = Color(0xFF6B6B8A);
  static const Color textMuted = Color(0xFFB0AECB);
  static const Color white = Color(0xFFFFFFFF);
  static const Color white70 = Colors.white70;
  static const Color white54 = Colors.white54;
}

class AppGradients {
  static const LinearGradient heroGradient = LinearGradient(
    colors: [AppColors.secondary, AppColors.secondaryDark],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient orangeGradient = LinearGradient(
    colors: [AppColors.primary, AppColors.primaryLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient amberGradient = LinearGradient(
    colors: [AppColors.accent, Color(0xFFFFD54F)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient sleepGradient = LinearGradient(
    colors: [Color(0xFF1A1A3E), AppColors.secondaryDark, AppColors.background],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    stops: [0.0, 0.5, 1.0],
  );
}
