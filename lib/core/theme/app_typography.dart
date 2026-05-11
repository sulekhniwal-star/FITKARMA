import 'package:flutter/material.dart';
import 'app_colors.dart';

/// AppTypography — Typography system for FitKarma.
///
/// Uses PlusJakartaSans for body/headings and JetBrainsMono for metrics.
/// Supports NotoSansDevanagari for Hindi labels.
class AppTypography {
  AppTypography._();

  static const _bodyFont = 'PlusJakartaSans';
  static const _monoFont = 'JetBrainsMono';
  static const _hindiFont = 'NotoSansDevanagari';

  // ─── Hero & Metrics ────────────────────────────────────────────────────────

  static TextStyle heroDisplay({Color color = AppColorsDark.textPrimary}) =>
      TextStyle(
        fontFamily: _bodyFont,
        fontSize: 72,
        fontWeight: FontWeight.w800,
        letterSpacing: -2.0,
        height: 1.0,
        color: color,
      );

  static TextStyle displayLg({Color color = AppColorsDark.textPrimary}) =>
      TextStyle(
        fontFamily: _bodyFont,
        fontSize: 56,
        fontWeight: FontWeight.w700,
        letterSpacing: -1.5,
        height: 1.1,
        color: color,
      );

  static TextStyle metricXL({Color color = AppColorsDark.textPrimary}) =>
      TextStyle(
        fontFamily: _monoFont,
        fontSize: 48,
        fontWeight: FontWeight.w700,
        letterSpacing: -1.0,
        color: color,
      );

  static TextStyle metricLg({Color color = AppColorsDark.textPrimary}) =>
      TextStyle(
        fontFamily: _monoFont,
        fontSize: 36,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.5,
        color: color,
      );

  // ─── Headings ─────────────────────────────────────────────────────────────

  static TextStyle h1({Color color = AppColorsDark.textPrimary}) => TextStyle(
        fontFamily: _bodyFont,
        fontSize: 24,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.3,
        color: color,
      );

  static TextStyle h2({Color color = AppColorsDark.textPrimary}) => TextStyle(
        fontFamily: _bodyFont,
        fontSize: 20,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.2,
        color: color,
      );

  static TextStyle h3({Color color = AppColorsDark.textPrimary}) => TextStyle(
        fontFamily: _bodyFont,
        fontSize: 17,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.1,
        color: color,
      );

  static TextStyle h4({Color color = AppColorsDark.textPrimary}) => TextStyle(
        fontFamily: _bodyFont,
        fontSize: 15,
        fontWeight: FontWeight.w600,
        color: color,
      );

  // ─── Body ─────────────────────────────────────────────────────────────────

  static TextStyle bodyLg({Color color = AppColorsDark.textPrimary}) =>
      TextStyle(
        fontFamily: _bodyFont,
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: color,
      );

  static TextStyle bodyMd({Color color = AppColorsDark.textSecondary}) =>
      TextStyle(
        fontFamily: _bodyFont,
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: color,
      );

  static TextStyle bodySm({Color color = AppColorsDark.textMuted}) => TextStyle(
        fontFamily: _bodyFont,
        fontSize: 12,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.1,
        color: color,
      );

  // ─── Labels ───────────────────────────────────────────────────────────────

  static TextStyle labelLg({Color color = AppColorsDark.textSecondary}) =>
      TextStyle(
        fontFamily: _bodyFont,
        fontSize: 13,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.1,
        color: color,
      );

  static TextStyle labelMd({Color color = AppColorsDark.textSecondary}) =>
      TextStyle(
        fontFamily: _bodyFont,
        fontSize: 11,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.2,
        color: color,
      );

  static TextStyle labelSm({Color color = AppColorsDark.textMuted}) => TextStyle(
        fontFamily: _bodyFont,
        fontSize: 10,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.3,
        color: color,
      );

  // ─── Mono ─────────────────────────────────────────────────────────────────

  static TextStyle monoLg({Color color = AppColorsDark.textPrimary}) =>
      TextStyle(
        fontFamily: _monoFont,
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: color,
      );

  static TextStyle monoMd({Color color = AppColorsDark.textSecondary}) =>
      TextStyle(
        fontFamily: _monoFont,
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: color,
      );

  // ─── Hindi Utility ────────────────────────────────────────────────────────

  static TextStyle hindi({Color color = AppColorsDark.textSecondary}) =>
      TextStyle(
        fontFamily: _hindiFont,
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: color,
      );
}
