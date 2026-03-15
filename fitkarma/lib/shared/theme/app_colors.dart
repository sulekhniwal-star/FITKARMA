import 'package:flutter/material.dart';

/// App colour constants based on Section 2.2 Visual Design System
///
/// Primary colour: Deep orange #FF5722
/// Secondary colour: Indigo / deep purple #3F3D8F
/// Accent: Amber #FFC107 (insight cards, karma coins)
/// Background: Warm off-white #FDF6EC
/// Surface: Pure white #FFFFFF cards with 8px border radius
class AppColors {
  AppColors._();

  // Primary colours
  static const Color primary = Color(0xFFFF5722); // Deep orange
  static const Color primaryLight = Color(0xFFFF8A65); // Lighter orange
  static const Color primaryDark = Color(0xFFE64A19); // Darker orange

  // Secondary colours
  static const Color secondary = Color(0xFF3F3D8F); // Indigo / deep purple
  static const Color secondaryLight = Color(0xFF6B68B3); // Lighter indigo
  static const Color secondaryDark = Color(0xFF1E1978); // Darker indigo

  // Accent colour
  static const Color accent = Color(0xFFFFC107); // Amber
  static const Color accentLight = Color(0xFFFFD54F); // Lighter amber
  static const Color accentDark = Color(0xFFFFA000); // Darker amber

  // Background colours
  static const Color background = Color(0xFFFDF6EC); // Warm off-white
  static const Color surface = Color(0xFFFFFFFF); // Pure white

  // Text colours
  static const Color textPrimary = Color(0xFF212121); // Primary text
  static const Color textSecondary = Color(0xFF757575); // Secondary text
  static const Color textOnPrimary = Color(
    0xFFFFFFFF,
  ); // Text on primary colour
  static const Color textOnSecondary = Color(
    0xFFFFFFFF,
  ); // Text on secondary colour

  // Activity ring colours
  static const Color ringCalories = Color(
    0xFFFF5722,
  ); // Orange - same as primary
  static const Color ringSteps = Color(0xFF4CAF50); // Green
  static const Color ringWater = Color(0xFF009688); // Teal
  static const Color ringActiveMinutes = Color(0xFF9C27B0); // Purple

  // Status colours
  static const Color success = Color(0xFF4CAF50); // Green
  static const Color warning = Color(0xFFFFC107); // Amber
  static const Color error = Color(0xFFF44336); // Red
  static const Color info = Color(0xFF2196F3); // Blue

  // Card and elevation
  static const Color cardShadow = Color(0x1A000000); // 10% black for shadow
  static const Color divider = Color(0xFFE0E0E0); // Light grey

  // Dosha colours (for Ayurveda screen)
  static const Color vata = Color(0xFF8BC34A); // Light green
  static const Color pitta = Color(0xFFFF5722); // Orange
  static const Color kapha = Color(0xFF3F51B5); // Indigo
}
