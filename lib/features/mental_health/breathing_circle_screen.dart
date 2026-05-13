import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../shared/widgets/scaffold_patterns.dart';
import 'mental_health_providers.dart';

class BreathingCircleScreen extends ConsumerStatefulWidget {
  const BreathingCircleScreen({super.key});

  @override
  ConsumerState<BreathingCircleScreen> createState() => _BreathingCircleScreenState();
}

class _BreathingCircleScreenState extends ConsumerState<BreathingCircleScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  
  Timer? _phaseTimer;
  String _currentPhase = 'Prepare';
  String _currentHindiPhase = 'तैयार हों';
  int _secondsLeft = 3;
  bool _isRunning = false;

  BreathingExercise? _exercise;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 4));
    _scaleAnimation = Tween<double>(begin: 0.6, end: 1.4).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _exercise ??= ref.read(selectedBreathingExerciseProvider);
  }

  @override
  void dispose() {
    _phaseTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _startSession() {
    if (_exercise == null) return;
    setState(() {
      _isRunning = true;
    });
    _triggerPhase('inhale');
  }

  void _stopSession() {
    _phaseTimer?.cancel();
    _controller.stop();
    setState(() {
      _isRunning = false;
      _currentPhase = 'Session Paused';
      _currentHindiPhase = 'विश्राम';
    });
  }

  void _triggerPhase(String phase) {
    if (!mounted || !_isRunning || _exercise == null) return;

    int durationSecs = 4;
    String nextPhase = 'hold1';

    switch (phase) {
      case 'inhale':
        durationSecs = _exercise!.inhaleSeconds;
        nextPhase = _exercise!.hold1Seconds > 0 ? 'hold1' : 'exhale';
        setState(() {
          _currentPhase = 'Inhale deeply...';
          _currentHindiPhase = 'गहरी श्वास लें...';
          _secondsLeft = durationSecs;
        });
        _controller.animateTo(1.0, duration: Duration(seconds: durationSecs), curve: Curves.easeOutCubic);
        break;

      case 'hold1':
        durationSecs = _exercise!.hold1Seconds;
        nextPhase = 'exhale';
        setState(() {
          _currentPhase = 'Hold breath...';
          _currentHindiPhase = 'श्वास रोकें...';
          _secondsLeft = durationSecs;
        });
        // Stay expanded
        break;

      case 'exhale':
        durationSecs = _exercise!.exhaleSeconds;
        nextPhase = _exercise!.hold2Seconds > 0 ? 'hold2' : 'inhale';
        setState(() {
          _currentPhase = 'Exhale fully...';
          _currentHindiPhase = 'पूरी श्वास छोड़ें...';
          _secondsLeft = durationSecs;
        });
        _controller.animateTo(0.0, duration: Duration(seconds: durationSecs), curve: Curves.easeInCubic);
        break;

      case 'hold2':
        durationSecs = _exercise!.hold2Seconds;
        nextPhase = 'inhale';
        setState(() {
          _currentPhase = 'Hold empty...';
          _currentHindiPhase = 'बाह्य कुम्भक (खाली रोकें)...';
          _secondsLeft = durationSecs;
        });
        // Stay small
        break;
    }

    _phaseTimer?.cancel();
    
    // Countdown loop handling
    _phaseTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      setState(() {
        if (_secondsLeft > 1) {
          _secondsLeft--;
        } else {
          timer.cancel();
          _triggerPhase(nextPhase);
        }
      });
    });
  }

  Color _getExerciseColor() {
    if (_exercise == null) return AppColorsDark.teal;
    switch (_exercise!.colorToken) {
      case 'purple': return AppColorsDark.purple;
      case 'accent': return AppColorsDark.accent;
      default: return AppColorsDark.teal;
    }
  }

  @override
  Widget build(BuildContext context) {
    final Color focalColor = _getExerciseColor();

    return AppScaffold.patternC(
      gradient: LinearGradient(
        colors: [
          focalColor.withValues(alpha: 0.2),
          AppColorsDark.bg1,
          AppColorsDark.surface1,
        ],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.close_rounded, color: Colors.white),
                  onPressed: () => context.pop(),
                ),
                Column(
                  children: [
                    Text(_exercise?.title ?? 'Pranayama Loop', style: AppTypography.labelLg(color: Colors.white)),
                    if (_exercise != null)
                      Text(_exercise!.hindiTitle, style: AppTypography.hindi(color: AppColorsDark.textSecondary)),
                  ],
                ),
                const SizedBox(width: 48), // Balancing clearance
              ],
            ),
          ),

          // Grounding Center Canvas Area
          Expanded(
            child: Center(
              child: AnimatedBuilder(
                animation: _scaleAnimation,
                builder: (context, child) {
                  return Stack(
                    alignment: Alignment.center,
                    children: [
                      // Ambient backdrop wave glow ring
                      Container(
                        width: 280 * _scaleAnimation.value,
                        height: 280 * _scaleAnimation.value,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: focalColor.withValues(alpha: 0.12),
                          boxShadow: [
                            BoxShadow(
                              color: focalColor.withValues(alpha: 0.2),
                              blurRadius: 40,
                              spreadRadius: 10 * _scaleAnimation.value,
                            ),
                          ],
                        ),
                      ),

                      // Inner boundary circle
                      Container(
                        width: 200 * _scaleAnimation.value,
                        height: 200 * _scaleAnimation.value,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: focalColor.withValues(alpha: 0.6), width: 2),
                          gradient: RadialGradient(
                            colors: [
                              focalColor.withValues(alpha: 0.3),
                              focalColor.withValues(alpha: 0.05),
                            ],
                          ),
                        ),
                      ),

                      // Core focal indicator display showing remaining runtime countdowns
                      if (_isRunning)
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '$_secondsLeft',
                              style: AppTypography.heroDisplay(color: Colors.white).copyWith(fontSize: 64),
                            ),
                            Text('sec', style: AppTypography.labelSm(color: AppColorsDark.textSecondary)),
                          ],
                        )
                      else
                        Icon(Icons.self_improvement_rounded, size: 64, color: focalColor.withValues(alpha: 0.8)),
                    ],
                  );
                },
              ),
            ),
          ),

          // Realtime Grounding Prompts Bar
          Container(
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 32),
            decoration: BoxDecoration(
              color: AppColorsDark.surface0.withValues(alpha: 0.4),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
              border: Border.all(color: AppColorsDark.divider),
            ),
            child: Column(
              children: [
                Text(
                  _currentPhase,
                  style: AppTypography.h1(color: Colors.white).copyWith(fontSize: 28),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 4),
                Text(
                  _currentHindiPhase,
                  style: AppTypography.hindi(color: focalColor).copyWith(fontSize: 18),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 28),

                // Controls CTA Button row
                if (!_isRunning)
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: focalColor,
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
                      elevation: 8,
                    ),
                    icon: const Icon(Icons.play_arrow_rounded, size: 24),
                    label: Text('Begin Cycle', style: AppTypography.labelLg(color: Colors.black).copyWith(fontWeight: FontWeight.bold)),
                    onPressed: _startSession,
                  )
                else
                  OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white,
                      side: const BorderSide(color: Colors.white54),
                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
                    ),
                    icon: const Icon(Icons.pause_rounded, size: 20),
                    label: const Text('Pause Cycle'),
                    onPressed: _stopSession,
                  ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
