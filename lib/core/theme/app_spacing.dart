/// AppSpacing — Layout tokens for FitKarma.
///
/// Ensures consistent gutters, gaps, and FAB clearance across the app.
class AppSpacing {
  AppSpacing._();

  static const double screenH = 20.0;
  static const double cardH = 16.0;
  static const double fabClearance = 120.0;
  static const double bentoGap = 12.0;

  // Utility spacing
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 16.0;
  static const double lg = 24.0;
  static const double xl = 32.0;
  static const double xxl = 48.0;
}

/// AppRadius — Corner radius tokens for FitKarma.
///
/// Follows the "Surface & Depth" system with tiered radii.
class AppRadius {
  AppRadius._();

  static const double sm = 10.0;
  static const double md = 16.0;
  static const double lg = 20.0;
  static const double xl = 28.0;
  static const double full = 9999.0;

  // Bento-specific radii
  static const double bentoInner = 14.0;
  static const double bentoOuter = 20.0;
  static const double bentoHero = 28.0;
}
