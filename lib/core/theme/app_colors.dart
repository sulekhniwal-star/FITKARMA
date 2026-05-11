import 'package:flutter/material.dart';

abstract class AppColors {
  // ─── Dark Mode Palette (Primary) ──────────────────────────────────────────
  static const Color darkBg0 = Color(0xFF000000);
  static const Color darkBg1 = Color(0xFF0A0A0A);
  static const Color darkBg2 = Color(0xFF141414);
  
  static const Color darkSurface0 = Color(0xFF1C1C1E);
  static const Color darkSurface1 = Color(0xFF2C2C2E);
  static const Color darkSurface2 = Color(0xFF3A3A3C);
  
  static const Color darkGlass = Color(0x0DFFFFFF);
  static const Color darkGlassBorder = Color(0x1AFFFFFF);
  
  static const Color primary = Color(0xFFFF3B30); // Vibrant FitKarma Red
  static const Color accent = Color(0xFF5856D6); // Indigo
  static const Color secondary = Color(0xFFFF9500); // Orange
  static const Color teal = Color(0xFF30B0C7); // Teal (Security)
  
  static const Color success = Color(0xFF34C759);
  static const Color warning = Color(0xFFFFCC00);
  static const Color error = Color(0xFFFF453A);
  static const Color rose = Color(0xFFFF2D55);
  static const Color purple = Color(0xFFAF52DE);
  
  static const Color darkTextPrimary = Color(0xFFFFFFFF);
  static const Color darkTextSecondary = Color(0x99EBEBF5);
  static const Color darkTextTertiary = Color(0x4DEBEBF5);
  
  static const Color darkDivider = Color(0xFF38383A);

  // ─── Light Mode Palette (Warm Inversion) ──────────────────────────────────
  static const Color lightBg0 = Color(0xFFFFF9F5); // Warm white
  static const Color lightBg1 = Color(0xFFF2ECE9);
  static const Color lightBg2 = Color(0xFFE5DFDC);
  
  static const Color lightSurface0 = Color(0xFFFFFFFF);
  static const Color lightSurface1 = Color(0xFFF9F4F2);
  static const Color lightSurface2 = Color(0xFFF0EBE9);
  
  static const Color lightGlass = Color(0x0D000000);
  static const Color lightGlassBorder = Color(0x1A000000);
  
  static const Color lightTextPrimary = Color(0xFF1C1C1E);
  static const Color lightTextSecondary = Color(0x993C3C43);
  static const Color lightTextTertiary = Color(0x4D3C3C43);
  
  static const Color lightDivider = Color(0xFFC6C6C8);
}
