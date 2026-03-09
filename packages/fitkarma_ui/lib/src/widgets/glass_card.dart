import 'dart:ui';
import 'package:flutter/material.dart';

class FKGlassCard extends StatelessWidget {
  final Widget child;
  final double blur;
  final double opacity;
  const FKGlassCard({
    super.key,
    required this.child,
    this.blur = 10,
    this.opacity = 0.1,
  });

  @override
  Widget build(BuildContext context) => ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: opacity),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
            ),
            child: child,
          ),
        ),
      );
}
