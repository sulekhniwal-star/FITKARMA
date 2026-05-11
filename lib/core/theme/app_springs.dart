import 'package:flutter/physics.dart';

abstract class AppSprings {
  // Standard: damping 20, stiffness 300
  static const SpringDescription standard = SpringDescription(
    mass: 1.0,
    stiffness: 300.0,
    damping: 20.0,
  );

  // Dramatic: damping 15, stiffness 400
  static const SpringDescription dramatic = SpringDescription(
    mass: 1.0,
    stiffness: 400.0,
    damping: 15.0,
  );

  // Gentle: damping 25, stiffness 200
  static const SpringDescription gentle = SpringDescription(
    mass: 1.0,
    stiffness: 200.0,
    damping: 25.0,
  );
}
