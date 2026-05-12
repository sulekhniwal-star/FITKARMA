import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../shared/widgets/scaffold_patterns.dart';
import 'workout_providers.dart';

class ActiveWorkoutScreen extends ConsumerStatefulWidget {
  final String workoutId;

  const ActiveWorkoutScreen({
    super.key,
    required this.workoutId,
  });

  @override
  ConsumerState<ActiveWorkoutScreen> createState() => _ActiveWorkoutScreenState();
}

class _ActiveWorkoutScreenState extends ConsumerState<ActiveWorkoutScreen> {
  final _weightController = TextEditingController();
  final _repsController = TextEditingController();

  bool _isFinalizing = false;

  @override
  void dispose() {
    _weightController.dispose();
    _repsController.dispose();
    super.dispose();
  }

  String _formatTimer(int totalSeconds) {
    final mins = totalSeconds ~/ 60;
    final secs = totalSeconds % 60;
    return '${mins.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  void _logCurrentSet(ActiveWorkoutNotifier notifier) {
    final weight = double.tryParse(_weightController.text.trim()) ?? 0.0;
    final reps = int.tryParse(_repsController.text.trim()) ?? 0;

    if (reps > 0) {
      notifier.logSet(weight, reps);
      // Clear inputs for continuous next set entries
      _repsController.clear();
      FocusScope.of(context).unfocus();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a valid repetition quantity.'),
          backgroundColor: AppColorsDark.rose,
        ),
      );
    }
  }

  Future<void> _triggerCompleteWorkout(ActiveWorkoutNotifier notifier, int totalCals) async {
    setState(() => _isFinalizing = true);

    try {
      await notifier.finalizeWorkout(ref);

      if (mounted) {
        // Show high fidelity celebration sequence
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => AlertDialog(
            backgroundColor: AppColorsDark.surface1,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
            contentPadding: const EdgeInsets.all(28),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(color: AppColorsDark.accent.withOpacity(0.2), shape: BoxShape.circle),
                  child: const Icon(Icons.fitness_center_rounded, size: 48, color: AppColorsDark.accent),
                ),
                const SizedBox(height: 20),
                Text('Workout Mastered!', style: AppTypography.h1(color: Colors.white).copyWith(fontSize: 24)),
                const SizedBox(height: 8),
                Text(
                  'Saved securely offline to local Drift engine. Enqueued for Appwrite background sync pipeline.',
                  style: AppTypography.bodySm(color: AppColorsDark.textSecondary),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(color: AppColorsDark.surface2, borderRadius: BorderRadius.circular(12)),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.local_fire_department_rounded, color: AppColorsDark.accent, size: 18),
                      const SizedBox(width: 8),
                      Text('$totalCals kcal burned', style: AppTypography.labelLg(color: Colors.white)),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColorsDark.accent,
                    foregroundColor: Colors.black,
                    minimumSize: const Size.fromHeight(48),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () {
                    context.pop(); // close dialog
                    context.go('/home/dashboard'); // redirect master state
                  },
                  child: const Text('Return to Home', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
        );
      }
    } catch (_) {
      if (mounted) {
        setState(() => _isFinalizing = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to complete logging cycle.'), backgroundColor: AppColorsDark.rose),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final providerToken = activeWorkoutProvider(widget.workoutId);
    final state = ref.watch(providerToken);
    final notifier = ref.read(providerToken.notifier);

    final activeEx = state.currentExercise;

    return AppScaffold.patternC(
      gradient: const LinearGradient(
        colors: [
          AppColorsDark.heroWorkoutStart,
          AppColorsDark.heroDeepStart,
          AppColorsDark.heroDeepEnd,
        ],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Top Status Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.close_rounded, color: Colors.white),
                    onPressed: () => _showCancelDialog(context),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.black45,
                      borderRadius: BorderRadius.circular(100),
                      border: Border.all(color: Colors.white24),
                    ),
                    child: Text(
                      state.workoutType,
                      style: AppTypography.labelSm(color: AppColorsDark.accent).copyWith(fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(width: 48), // balance layout space
                ],
              ),
            ),

            // Immersive Full-screen Timer Focal Display
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Column(
                children: [
                  Text(
                    _formatTimer(state.elapsedSeconds),
                    style: AppTypography.heroDisplay(color: Colors.white).copyWith(
                      fontSize: 84,
                      letterSpacing: 2,
                      shadows: [
                        const BoxShadow(color: Colors.black54, blurRadius: 20, offset: Offset(0, 4)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 4),
                  
                  // Estimated Calories Burned indicator
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.local_fire_department_rounded, color: AppColorsDark.accent, size: 20),
                      const SizedBox(width: 6),
                      Text(
                        '${state.estimatedCaloriesBurned} kcal active expenditure',
                        style: AppTypography.labelLg(color: AppColorsDark.textPrimary),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Current exercise name + set/rep tracker header block
            Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: AppColorsDark.surface0.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(28),
                  border: Border.all(color: AppColorsDark.divider),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Exercise details bar
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.arrow_back_ios_rounded, size: 18),
                            color: state.currentExerciseIndex > 0 ? Colors.white : AppColorsDark.textMuted,
                            onPressed: state.currentExerciseIndex > 0 ? () => notifier.previousExercise() : null,
                          ),
                          Expanded(
                            child: Column(
                              children: [
                                Text(
                                  activeEx?.name ?? 'Complete Lifts',
                                  style: AppTypography.h2(color: Colors.white).copyWith(fontSize: 22),
                                  textAlign: TextAlign.center,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                                  decoration: BoxDecoration(color: AppColorsDark.surface2, borderRadius: BorderRadius.circular(6)),
                                  child: Text(
                                    activeEx?.category ?? 'Strength',
                                    style: AppTypography.labelSm(color: AppColorsDark.textSecondary).copyWith(fontSize: 11),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.arrow_forward_ios_rounded, size: 18),
                            color: state.currentExerciseIndex < state.exercises.length - 1 ? Colors.white : AppColorsDark.textMuted,
                            onPressed: state.currentExerciseIndex < state.exercises.length - 1 ? () => notifier.nextExercise() : null,
                          ),
                        ],
                      ),
                    ),
                    const Divider(color: AppColorsDark.divider, height: 1),

                    // Logged sets history rows feed inside dynamic scrolling space
                    Expanded(
                      child: activeEx == null || activeEx.sets.isEmpty
                          ? Center(
                              child: Text(
                                'No sets recorded yet.\nEnter weight & target reps below.',
                                style: AppTypography.bodySm(color: AppColorsDark.textMuted),
                                textAlign: TextAlign.center,
                              ),
                            )
                          : ListView.separated(
                              padding: const EdgeInsets.all(20),
                              itemCount: activeEx.sets.length,
                              separatorBuilder: (_, _) => const SizedBox(height: 10),
                              itemBuilder: (context, idx) {
                                final s = activeEx.sets[idx];
                                return Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                  decoration: BoxDecoration(
                                    color: AppColorsDark.surface1.withOpacity(0.5),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('Set ${s.setNumber}', style: AppTypography.labelSm(color: AppColorsDark.textSecondary)),
                                      Text(
                                        '${s.weightKg > 0 ? '${s.weightKg.toStringAsFixed(1)} kg  ×  ' : ''}${s.reps} reps',
                                        style: AppTypography.labelLg(color: Colors.white).copyWith(fontWeight: FontWeight.bold),
                                      ),
                                      const Icon(Icons.check_circle_rounded, color: AppColorsDark.teal, size: 18),
                                    ],
                                  ),
                                );
                              },
                            ),
                    ),
                    const Divider(color: AppColorsDark.divider, height: 1),

                    // Log Set manual parameters array
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: _weightController,
                                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                  style: AppTypography.bodyLg(color: Colors.white),
                                  decoration: InputDecoration(
                                    labelText: 'Weight (kg)',
                                    labelStyle: AppTypography.labelSm(color: AppColorsDark.textMuted),
                                    filled: true,
                                    fillColor: AppColorsDark.surface1,
                                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: TextField(
                                  controller: _repsController,
                                  keyboardType: TextInputType.number,
                                  style: AppTypography.bodyLg(color: Colors.white),
                                  decoration: InputDecoration(
                                    labelText: 'Reps',
                                    labelStyle: AppTypography.labelSm(color: AppColorsDark.textMuted),
                                    filled: true,
                                    fillColor: AppColorsDark.surface1,
                                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),

                          // Trigger Add Set execution
                          ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColorsDark.surface2,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            icon: const Icon(Icons.add_rounded, size: 18),
                            label: const Text('Log Finished Set', style: TextStyle(fontWeight: FontWeight.bold)),
                            onPressed: () => _logCurrentSet(notifier),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Stop/complete workout button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColorsDark.accent,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
                  elevation: 6,
                ),
                icon: _isFinalizing
                    ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.black, strokeWidth: 2))
                    : const Icon(Icons.flag_rounded, size: 22, color: Colors.black),
                label: Text(
                  _isFinalizing ? 'Encrypting Log Data...' : 'Complete Workout & Sync',
                  style: AppTypography.labelLg(color: Colors.black).copyWith(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                onPressed: _isFinalizing ? null : () => _triggerCompleteWorkout(notifier, state.estimatedCaloriesBurned),
              ),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  void _showCancelDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColorsDark.surface1,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text('Discard Workout?', style: AppTypography.h3(color: Colors.white)),
        content: Text('Unlogged progress and elapsed tracking times will be permanently erased.', style: AppTypography.bodySm(color: AppColorsDark.textSecondary)),
        actions: [
          TextButton(
            onPressed: () => context.pop(),
            child: Text('Resume', style: AppTypography.labelSm(color: AppColorsDark.teal)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColorsDark.rose, foregroundColor: Colors.white),
            onPressed: () {
              context.pop();
              context.pop(); // route back out
            },
            child: const Text('Discard'),
          ),
        ],
      ),
    );
  }
}
