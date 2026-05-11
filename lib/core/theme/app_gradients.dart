import 'package:flutter/material.dart';
import 'app_colors.dart';

/// AppGradients — Centralized gradient definitions for FitKarma.
///
/// Follows the "Design Tokens" rule: No hardcoded hex values.
class AppGradients {
  AppGradients._();

  static const heroDeep = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      AppColorsDark.heroDeepStart,
      AppColorsDark.heroDeepEnd,
    ],
  );

  static const heroSleep = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      AppColorsDark.heroSleepStart,
      AppColorsDark.heroSleepMid,
      AppColorsDark.heroSleepEnd,
    ],
  );

  static const heroWorkout = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      AppColorsDark.heroWorkoutStart,
      AppColorsDark.heroWorkoutEnd,
    ],
  );

  static const heroFestival = LinearGradient(
    begin: Alignment(-.5, -1),
    end: Alignment(.5, 1),
    colors: [
      AppColorsDark.heroFestivalStart,
      AppColorsDark.heroFestivalEnd,
    ],
  );

  static const heroWedding = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      AppColorsDark.heroWeddingStart,
      AppColorsDark.heroWeddingEnd,
    ],
  );

  static const cardSubtle = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      AppColorsDark.glass,
      AppColorsDark.glassBorder, // Using border as a subtle end
    ],
  );

  static const overlayBottom = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Colors.transparent,
      AppColorsDark.bg0, // Using bg0 for deep overlay
    ],
  );
}
