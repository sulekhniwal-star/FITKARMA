import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';

/// BreathingCircle — A guided meditation/breathing widget.
///
/// Follows a 4-7-8 or Box breathing pattern visually.
class BreathingCircle extends StatefulWidget {
  const BreathingCircle({super.key});

  @override
  State<BreathingCircle> createState() => _BreathingCircleState();
}

class _BreathingCircleState extends State<BreathingCircle> {
  String _phase = 'Inhale';

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              // Outer Glow
              Container(
                width: 280,
                height: 280,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColorsDark.teal.withValues(alpha: 0.1),
                ),
              )
                  .animate(onPlay: (c) => c.repeat(reverse: true))
                  .scale(duration: 4.seconds, begin: const Offset(0.8, 0.8), end: const Offset(1.2, 1.2)),

              // Main Circle
              Container(
                width: 200,
                height: 200,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [AppColorsDark.teal, AppColorsDark.tealGlow],
                  ),
                ),
                child: Center(
                  child: Text(
                    _phase,
                    style: AppTypography.h2(color: Colors.white),
                  ),
                ),
              )
                  .animate(onPlay: (c) => c.repeat())
                  .scale(duration: 4.seconds, begin: const Offset(0.5, 0.5), end: const Offset(1.0, 1.0))
                  .callback(delay: 0.ms, callback: (_) => setState(() => _phase = 'Inhale'))
                  .then(delay: 4.seconds)
                  .callback(delay: 0.ms, callback: (_) => setState(() => _phase = 'Hold'))
                  .then(delay: 7.seconds)
                  .scale(duration: 8.seconds, begin: const Offset(1.0, 1.0), end: const Offset(0.5, 0.5))
                  .callback(delay: 0.ms, callback: (_) => setState(() => _phase = 'Exhale')),
            ],
          ),
          const SizedBox(height: 64),
          Text(
            'Focus on your breath',
            style: AppTypography.bodyLg(color: AppColorsDark.textSecondary),
          ),
        ],
      ),
    );
  }
}
