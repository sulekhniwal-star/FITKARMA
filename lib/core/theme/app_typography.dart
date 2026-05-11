import 'package:flutter/material.dart';
import 'app_colors.dart';

abstract class AppTypography {
  static const String primaryFont = 'PlusJakartaSans';
  static const String monoFont = 'JetBrainsMono';
  static const String hindiFont = 'NotoSansDevanagari';
  static const String dyslexicFont = 'OpenDyslexic';

  static TextStyle _base(double size, FontWeight weight, {bool isMono = false, bool isHindi = false, double? height}) {
    return TextStyle(
      fontFamily: isMono ? monoFont : (isHindi ? hindiFont : primaryFont),
      fontSize: size,
      fontWeight: weight,
      height: height,
      color: AppColors.darkTextPrimary,
    );
  }

  // ─── Displays & Metrics ───────────────────────────────────────────────────
  static final TextStyle heroDisplay = _base(72, FontWeight.w700, height: 1.1);
  static final TextStyle displayLg = _base(56, FontWeight.w700, height: 1.1);
  static final TextStyle metricXL = _base(48, FontWeight.w600, isMono: true);
  static final TextStyle metricLg = _base(36, FontWeight.w600, isMono: true);

  // ─── Headings ─────────────────────────────────────────────────────────────
  static final TextStyle h1 = _base(32, FontWeight.w700, height: 1.2);
  static final TextStyle h2 = _base(24, FontWeight.w700, height: 1.2);
  static final TextStyle h3 = _base(20, FontWeight.w600, height: 1.3);
  static final TextStyle h4 = _base(18, FontWeight.w600, height: 1.3);

  // ─── Body ─────────────────────────────────────────────────────────────────
  static final TextStyle bodyLg = _base(16, FontWeight.w500, height: 1.5);
  static final TextStyle bodyMd = _base(14, FontWeight.w500, height: 1.5);
  static final TextStyle bodySm = _base(12, FontWeight.w500, height: 1.4);

  // ─── Labels ───────────────────────────────────────────────────────────────
  static final TextStyle labelLg = _base(14, FontWeight.w600, height: 1.2);
  static final TextStyle labelMd = _base(12, FontWeight.w600, height: 1.2);
  static final TextStyle labelSm = _base(10, FontWeight.w700, height: 1.1);

  // ─── Mono ─────────────────────────────────────────────────────────────────
  static final TextStyle monoLg = _base(14, FontWeight.w500, isMono: true);
  static final TextStyle monoMd = _base(12, FontWeight.w500, isMono: true);

  // ─── Hindi Utility ────────────────────────────────────────────────────────
  static TextStyle hindi(double size, FontWeight weight) => _base(size, weight, isHindi: true);
}
