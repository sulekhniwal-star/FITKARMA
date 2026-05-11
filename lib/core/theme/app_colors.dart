import 'package:flutter/material.dart';

/// AppColorsDark — Primary theme tokens for FitKarma.
///
/// Follows the "Rich Aesthetics" pillars: Spatial Depth, Fluid Motion,
/// Bold Information, and Cultural Pulse (Orange-Indigo-Saffron).
class AppColorsDark {
  AppColorsDark._();

  // Backgrounds
  static const bg0 = Color(0xFF080810);
  static const bg1 = Color(0xFF0F0F1A);
  static const bg2 = Color(0xFF161625);

  // Surfaces
  static const surface0 = Color(0xFF1C1C2E);
  static const surface1 = Color(0xFF22223A);
  static const surface2 = Color(0xFF2A2A45);

  // Glassmorphism
  static const glass = Color(0x0FFFFFFF);
  static const glassBorder = Color(0x1AFFFFFF);

  // Brand Colors
  static const primary = Color(0xFFFF6B35);
  static const primaryGlow = Color(0x40FF6B35);
  static const primaryMuted = Color(0x30FF6B35);

  static const accent = Color(0xFFFFB547);
  static const accentGlow = Color(0x33FFB547);

  static const secondary = Color(0xFF7B6FF0);
  static const secondaryGlow = Color(0x407B6FF0);

  // Semantic Colors
  static const teal = Color(0xFF00D4B4);
  static const tealGlow = Color(0x3300D4B4);
  static const success = Color(0xFF4ADE80);
  static const successGlow = Color(0x334ADE80);
  static const warning = Color(0xFFFBBF24);
  static const error = Color(0xFFF87171);
  static const rose = Color(0xFFFB7185);
  static const purple = Color(0xFFC084FC);

  // Text & UI
  static const textPrimary = Color(0xFFF1F0FF);
  static const textSecondary = Color(0xFF9B99CC);
  static const textMuted = Color(0xFF6B68A0);
  static const divider = Color(0x14FFFFFF);

  // Gradient Tokens
  static const heroDeepStart = Color(0xFF0A0818);
  static const heroDeepEnd = Color(0xFF1E1850);
  static const heroSleepStart = Color(0xFF04020F);
  static const heroSleepMid = Color(0xFF0D0B2E);
  static const heroSleepEnd = Color(0xFF1C1A48);
  static const heroFestivalStart = Color(0xFF1A0A00);
  static const heroFestivalEnd = Color(0xFF3D1500);
  static const heroWeddingStart = Color(0xFF1A0008);
  static const heroWeddingEnd = Color(0xFF3D0015);
}

/// AppColorsLight — Warm inversion of the dark theme.
class AppColorsLight {
  AppColorsLight._();

  static const bg0 = Color(0xFFF7F0E8);
  static const bg1 = Color(0xFFFDF6EC);
  static const bg2 = Color(0xFFFFF9F2);

  static const surface0 = Color(0xFFFFFFFF);
  static const surface1 = Color(0xFFFFFAF5);
  static const surface2 = Color(0xFFFFF3EF);

  static const glass = Color(0xB3FFFAF5);
  static const glassBorder = Color(0x26FF6B35);

  static const primary = Color(0xFFF4511E);
  static const primaryMuted = Color(0xFFFEE8E2);
  static const accent = Color(0xFFF59E0B);
  static const secondary = Color(0xFF5B50D4);
  static const teal = Color(0xFF0D9488);
  static const success = Color(0xFF22C55E);

  static const textPrimary = Color(0xFF1A1830);
  static const textSecondary = Color(0xFF6B6A96);
  static const textMuted = Color(0xFFB0AEC8);
  static const divider = Color(0x121A1830);
}
