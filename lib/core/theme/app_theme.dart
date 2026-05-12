import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_typography.dart';
import 'app_spacing.dart';

/// AppTheme — ThemeData builder for FitKarma.
///
/// Provides dark (primary) and light (warm inversion) themes.
/// Supports OpenDyslexic accessibility font override.
class AppTheme {
  AppTheme._();

  static ThemeData dark({String? overrideFont}) {
    final textTheme = _buildTextTheme(
      AppColorsDark.textPrimary,
      AppColorsDark.textSecondary,
      AppColorsDark.textMuted,
      overrideFont: overrideFont,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColorsDark.bg1,
      colorScheme: const ColorScheme.dark(
        primary: AppColorsDark.primary,
        secondary: AppColorsDark.secondary,
        surface: AppColorsDark.surface0,
        error: AppColorsDark.error,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: AppColorsDark.textPrimary,
        onError: Colors.white,
      ),
      textTheme: textTheme,
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: AppColorsDark.textSecondary),
        titleTextStyle: AppTypography.h1(color: AppColorsDark.textPrimary).copyWith(
          fontFamily: overrideFont,
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: AppColorsDark.divider,
        thickness: 1,
        space: 1,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColorsDark.primary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16),
          textStyle: AppTypography.h4(color: Colors.white).copyWith(
            fontFamily: overrideFont,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: AppColorsDark.surface1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.lg)),
        ),
        elevation: 8,
      ),
    );
  }

  static ThemeData light({String? overrideFont}) {
    final textTheme = _buildTextTheme(
      AppColorsLight.textPrimary,
      AppColorsLight.textSecondary,
      AppColorsLight.textMuted,
      overrideFont: overrideFont,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: AppColorsLight.bg1,
      colorScheme: const ColorScheme.light(
        primary: AppColorsLight.primary,
        secondary: AppColorsLight.secondary,
        surface: AppColorsLight.surface0,
        error: AppColorsDark.error,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: AppColorsLight.textPrimary,
        onError: Colors.white,
      ),
      textTheme: textTheme,
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: AppColorsLight.textSecondary),
        titleTextStyle: AppTypography.h1(color: AppColorsLight.textPrimary).copyWith(
          fontFamily: overrideFont,
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: AppColorsLight.divider,
        thickness: 1,
        space: 1,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColorsLight.primary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16),
          textStyle: AppTypography.h4(color: Colors.white).copyWith(
            fontFamily: overrideFont,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: AppColorsLight.surface1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.lg)),
        ),
        elevation: 8,
      ),
    );
  }

  static TextTheme _buildTextTheme(
    Color primary,
    Color secondary,
    Color muted, {
    String? overrideFont,
  }) {
    return TextTheme(
      displayLarge: AppTypography.heroDisplay(color: primary).copyWith(fontFamily: overrideFont),
      displayMedium: AppTypography.displayLg(color: primary).copyWith(fontFamily: overrideFont),
      headlineLarge: AppTypography.h1(color: primary).copyWith(fontFamily: overrideFont),
      headlineMedium: AppTypography.h2(color: primary).copyWith(fontFamily: overrideFont),
      headlineSmall: AppTypography.h3(color: primary).copyWith(fontFamily: overrideFont),
      titleLarge: AppTypography.h4(color: primary).copyWith(fontFamily: overrideFont),
      bodyLarge: AppTypography.bodyLg(color: primary).copyWith(fontFamily: overrideFont),
      bodyMedium: AppTypography.bodyMd(color: secondary).copyWith(fontFamily: overrideFont),
      bodySmall: AppTypography.bodySm(color: muted).copyWith(fontFamily: overrideFont),
      labelLarge: AppTypography.labelLg(color: secondary).copyWith(fontFamily: overrideFont),
      labelMedium: AppTypography.labelMd(color: secondary).copyWith(fontFamily: overrideFont),
      labelSmall: AppTypography.labelSm(color: muted).copyWith(fontFamily: overrideFont),
    );
  }
}
