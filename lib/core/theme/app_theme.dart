import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_typography.dart';
import 'app_spacing.dart';

class AppTheme {
  static ThemeData dark({String? overrideFont}) {
    final String fontFamily = overrideFont ?? AppTypography.primaryFont;

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.darkBg0,
      fontFamily: fontFamily,
      
      colorScheme: const ColorScheme.dark(
        primary: AppColors.primary,
        secondary: AppColors.secondary,
        surface: AppColors.darkSurface0,
        error: AppColors.error,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: AppColors.darkTextPrimary,
      ),

      textTheme: _buildTextTheme(AppColors.darkTextPrimary, fontFamily),

      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          color: AppColors.darkTextPrimary,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
        iconTheme: IconThemeData(color: AppColors.darkTextPrimary),
      ),

      dividerTheme: const DividerThemeData(
        color: AppColors.darkDivider,
        thickness: 1,
        space: 1,
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          minimumSize: const Size.fromHeight(56),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: AppColors.darkSurface0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppRadius.xl),
          ),
        ),
      ),
    );
  }

  static ThemeData light({String? overrideFont}) {
    final String fontFamily = overrideFont ?? AppTypography.primaryFont;

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: AppColors.lightBg0,
      fontFamily: fontFamily,

      colorScheme: const ColorScheme.light(
        primary: AppColors.primary,
        secondary: AppColors.secondary,
        surface: AppColors.lightSurface0,
        error: AppColors.error,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: AppColors.lightTextPrimary,
      ),

      textTheme: _buildTextTheme(AppColors.lightTextPrimary, fontFamily),

      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          color: AppColors.lightTextPrimary,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
        iconTheme: IconThemeData(color: AppColors.lightTextPrimary),
      ),

      dividerTheme: const DividerThemeData(
        color: AppColors.lightDivider,
        thickness: 1,
        space: 1,
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          minimumSize: const Size.fromHeight(56),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: AppColors.lightSurface0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppRadius.xl),
          ),
        ),
      ),
    );
  }

  static TextTheme _buildTextTheme(Color textColor, String fontFamily) {
    return TextTheme(
      displayLarge: AppTypography.displayLg.copyWith(color: textColor, fontFamily: fontFamily),
      headlineLarge: AppTypography.h1.copyWith(color: textColor, fontFamily: fontFamily),
      headlineMedium: AppTypography.h2.copyWith(color: textColor, fontFamily: fontFamily),
      headlineSmall: AppTypography.h3.copyWith(color: textColor, fontFamily: fontFamily),
      bodyLarge: AppTypography.bodyLg.copyWith(color: textColor, fontFamily: fontFamily),
      bodyMedium: AppTypography.bodyMd.copyWith(color: textColor, fontFamily: fontFamily),
      bodySmall: AppTypography.bodySm.copyWith(color: textColor, fontFamily: fontFamily),
      labelLarge: AppTypography.labelLg.copyWith(color: textColor, fontFamily: fontFamily),
      labelMedium: AppTypography.labelMd.copyWith(color: textColor, fontFamily: fontFamily),
      labelSmall: AppTypography.labelSm.copyWith(color: textColor, fontFamily: fontFamily),
    );
  }
}
