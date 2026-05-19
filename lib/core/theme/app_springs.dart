import 'package:flutter/physics.dart';

/// AppSprings — Spring physics presets for FitKarma.
///
/// Ensures fluid, physics-based motion throughout the app.
class AppSprings {
  AppSprings._();

  /// Standard spring for most UI transitions.
  /// damping: 28, stiffness: 300
  static const standard = SpringDescription(
    mass: 1.0,
    stiffness: 300,
    damping: 28,
  );

  /// Dramatic spring for hero elements and accent animations.
  /// damping: 20, stiffness: 200
  static const dramatic = SpringDescription(
    mass: 1.0,
    stiffness: 200,
    damping: 20,
  );

  /// Gentle spring for subtle feedback and secondary motions.
  /// damping: 22, stiffness: 150
  static const gentle = SpringDescription(
    mass: 1.0,
    stiffness: 150,
    damping: 22,
  );

  /// Bouncy spring for playful, elastic elements.
  /// damping: 18, stiffness: 400
  static const bouncy = SpringDescription(
    mass: 1.0,
    stiffness: 400,
    damping: 18,
  );
}
