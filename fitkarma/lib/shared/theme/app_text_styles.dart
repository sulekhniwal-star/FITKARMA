import 'package:flutter/material.dart';
import 'app_colors.dart';

/// App text styles based on Section 2.2 Visual Design System
///
/// Typography: System default (Roboto on Android, SF Pro on iOS)
/// Hindi text rendered with Devanagari support
class AppTextStyles {
  AppTextStyles._();

  // ==================== Headings ====================

  /// Display Large - for hero sections or large headers
  static const TextStyle displayLarge = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
    letterSpacing: -0.5,
    height: 1.2,
  );

  /// Display Medium
  static const TextStyle displayMedium = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
    letterSpacing: -0.25,
    height: 1.25,
  );

  /// Display Small
  static const TextStyle displaySmall = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    height: 1.3,
  );

  /// Headline Large - main screen titles
  static const TextStyle headlineLarge = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    height: 1.35,
  );

  /// Headline Medium - section headers
  static const TextStyle headlineMedium = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    height: 1.4,
  );

  /// Headline Small - subsection headers
  static const TextStyle headlineSmall = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    height: 1.4,
  );

  // ==================== Body Text ====================

  /// Title Large - card titles, list item titles
  static const TextStyle titleLarge = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
    height: 1.4,
  );

  /// Title Medium - subtitles
  static const TextStyle titleMedium = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
    letterSpacing: 0.15,
    height: 1.45,
  );

  /// Title Small - smaller titles
  static const TextStyle titleSmall = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
    letterSpacing: 0.1,
    height: 1.45,
  );

  /// Body Large - main content text
  static const TextStyle bodyLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: AppColors.textPrimary,
    letterSpacing: 0.5,
    height: 1.5,
  );

  /// Body Medium - regular content
  static const TextStyle bodyMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: AppColors.textPrimary,
    letterSpacing: 0.25,
    height: 1.5,
  );

  /// Body Small - secondary content
  static const TextStyle bodySmall = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    color: AppColors.textSecondary,
    letterSpacing: 0.4,
    height: 1.5,
  );

  // ==================== Labels ====================

  /// Label Large - buttons, tabs
  static const TextStyle labelLarge = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
    letterSpacing: 0.1,
    height: 1.4,
  );

  /// Label Medium - small buttons, chips
  static const TextStyle labelMedium = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
    letterSpacing: 0.5,
    height: 1.4,
  );

  /// Label Small - smallest labels
  static const TextStyle labelSmall = TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondary,
    letterSpacing: 0.5,
    height: 1.4,
  );

  // ==================== Caption ====================

  /// Caption - helper text, timestamps
  static const TextStyle caption = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    color: AppColors.textSecondary,
    letterSpacing: 0.4,
    height: 1.4,
  );

  /// Caption Small - very small helper text
  static const TextStyle captionSmall = TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.normal,
    color: AppColors.textSecondary,
    letterSpacing: 0.4,
    height: 1.4,
  );

  // ==================== Special Styles ====================

  /// Button text - uppercase, medium weight
  static const TextStyle button = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.textOnPrimary,
    letterSpacing: 1.25,
    height: 1.4,
  );

  /// Primary button text
  static const TextStyle buttonPrimary = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.textOnPrimary,
    letterSpacing: 1.0,
    height: 1.4,
  );

  /// Secondary button text
  static const TextStyle buttonSecondary = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.primary,
    letterSpacing: 1.0,
    height: 1.4,
  );

  /// Hindi sub-label for bilingual UI (10sp per Section 2.3)
  static const TextStyle hindiLabel = TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.normal,
    color: AppColors.textSecondary,
    letterSpacing: 0.2,
    height: 1.3,
  );

  /// Karma level title (large, bold)
  static const TextStyle karmaLevel = TextStyle(
    fontSize: 36,
    fontWeight: FontWeight.bold,
    color: AppColors.textOnPrimary,
    letterSpacing: -0.5,
    height: 1.2,
  );

  /// Insight card text
  static const TextStyle insight = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
    letterSpacing: 0.25,
    height: 1.5,
  );
}
