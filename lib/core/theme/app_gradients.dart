import 'package:flutter/material.dart';

abstract class AppGradients {
  static const LinearGradient heroDeep = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFFF3B30), Color(0xFF5856D6)], // Red to Indigo
  );

  static const LinearGradient heroSleep = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF141E30), Color(0xFF243B55)], // Midnight Blue
  );

  static const LinearGradient heroWorkout = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFF09819), Color(0xFFEDDE5D)], // Sunny Orange
  );

  static const LinearGradient cardSubtle = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0x0FFFFFFF), Color(0x05FFFFFF)],
  );

  static const LinearGradient overlayBottom = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Colors.transparent, Color(0xCC000000)],
  );
}
