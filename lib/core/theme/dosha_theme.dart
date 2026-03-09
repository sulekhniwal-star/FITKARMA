import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fitkarma_ui/fitkarma_ui.dart';

class DoshaTheme {
  static ThemeData getTheme(DoshaType type) {
    final Color primary = switch (type) {
      DoshaType.pitta => const Color(0xFF81D4FA),
      DoshaType.vata => const Color(0xFFD84315),
      DoshaType.kapha => const Color(0xFFFFD600),
    };
    return ThemeData(useMaterial3: true, colorScheme: ColorScheme.fromSeed(seedColor: primary), textTheme: GoogleFonts.outfitTextTheme());
  }
}
