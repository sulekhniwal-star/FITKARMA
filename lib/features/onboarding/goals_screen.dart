import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_gradients.dart';
import '../../core/theme/app_typography.dart';
import '../../shared/widgets/scaffold_patterns.dart';
import '../../shared/widgets/bento_card.dart';
import 'onboarding_providers.dart';
import 'models/health_goal.dart';

class GoalsScreen extends ConsumerStatefulWidget {
  const GoalsScreen({super.key});

  @override
  ConsumerState<GoalsScreen> createState() => _GoalsScreenState();
}

class _GoalsScreenState extends ConsumerState<GoalsScreen> {
  // Store GlobalKeys for triggering shake animations on individual Bento cards
  final Map<String, GlobalKey<_BentoGoalCardState>> _cardKeys = {};

  @override
  void initState() {
    super.initState();
    for (final goal in availableGoals) {
      _cardKeys[goal.id] = GlobalKey<_BentoGoalCardState>();
    }
  }

  @override
  Widget build(BuildContext context) {
    final goalsState = ref.watch(goalsProvider);
    final selectedGoals = goalsState.selectedGoals;
    const double weightKg = 70.0; // fallback default since weight entered in next step

    // Determine which sliders to show based on selected goals
    final showCalorieSlider = selectedGoals.contains('weight_loss');
    final showProteinSlider = selectedGoals.contains('muscle_gain');
    final showStepsSlider = selectedGoals.contains('heart_health') || selectedGoals.contains('manage_bp_glucose');
    final showSleepSlider = selectedGoals.contains('better_sleep') || selectedGoals.contains('reduce_stress') || selectedGoals.contains('energy_boost');

    return AppScaffold.patternC(
      gradient: AppGradients.heroDeep,
      body: Stack(
        children: [
          // Top Skip Button
          Positioned(
            top: 16,
            right: 16,
            child: TextButton(
              onPressed: () => context.go('/onboarding/demographics'),
              style: TextButton.styleFrom(
                foregroundColor: AppColorsDark.textSecondary,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              ),
              child: Text(
                'Skip',
                style: AppTypography.labelLg(color: AppColorsDark.textSecondary).copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 36),
                        
                        // Header
                        Center(
                          child: Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              color: AppColorsDark.primary.withValues(alpha: 0.1),
                              shape: BoxShape.circle,
                            ),
                            child: const Center(
                              child: Text(
                                '🎯',
                                style: TextStyle(fontSize: 48),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        Center(
                          child: Text(
                            "What's your goal?",
                            style: AppTypography.displayLg(color: Colors.white),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Center(
                          child: Text(
                            'Select up to 3 goals. We will customize your aggregate targets, algorithms, and Ayurveda plans.',
                            style: AppTypography.bodyMd(color: AppColorsDark.textSecondary),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(height: 32),

                        // Goal Selector 2x3 Grid
                        GridView.count(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          crossAxisCount: 2,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: 1.35,
                          children: availableGoals.map((goal) {
                            final isSelected = selectedGoals.contains(goal.id);
                            return BentoGoalCard(
                              key: _cardKeys[goal.id],
                              goal: goal,
                              isSelected: isSelected,
                              onTap: () {
                                final success = ref.read(goalsProvider.notifier).toggleGoal(goal.id);
                                if (!success) {
                                  // Trigger shake on this card since max-3 limit is breached
                                  _cardKeys[goal.id]?.currentState?._shake();
                                  
                                  // Show elegant snackbar
                                  ScaffoldMessenger.of(context).clearSnackBars();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Row(
                                        children: [
                                          const Icon(Icons.info_outline_rounded, color: Colors.black, size: 20),
                                          const SizedBox(width: 8),
                                          Text(
                                            'Max 3 goals — deselect one first',
                                            style: AppTypography.labelLg(color: Colors.black).copyWith(fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                      backgroundColor: AppColorsDark.warning,
                                      behavior: SnackBarBehavior.floating,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                                      duration: const Duration(seconds: 2),
                                    ),
                                  );
                                }
                              },
                            );
                          }).toList(),
                        ),
                        
                        const SizedBox(height: 24),

                        // Conditional Sliders Layout wrapped in AnimatedSize for springy reveal
                        AnimatedSize(
                          duration: const Duration(milliseconds: 350),
                          curve: Curves.easeOutBack,
                          alignment: Alignment.topCenter,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              // 1. Lose Weight Calorie Slider
                              if (showCalorieSlider) ...[
                                _buildSliderCard(
                                  title: '🏃 Lose Weight Target',
                                  subtitle: 'Calorie Target: ${goalsState.dailyCalorieTarget} kcal',
                                  color: AppColorsDark.error,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.stretch,
                                    children: [
                                      Slider(
                                        value: goalsState.dailyCalorieTarget.toDouble(),
                                        min: 1200,
                                        max: 2800,
                                        divisions: 32, // step 50
                                        activeColor: AppColorsDark.error,
                                        inactiveColor: AppColorsDark.surface2,
                                        onChanged: (val) {
                                          ref.read(goalsProvider.notifier).updateCalorieTarget(val.toInt());
                                        },
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          _buildPresetButton(
                                            label: 'Light -500',
                                            isSelected: goalsState.dailyCalorieTarget == 1500,
                                            onTap: () => ref.read(goalsProvider.notifier).updateCalorieTarget(1500),
                                          ),
                                          _buildPresetButton(
                                            label: 'Moderate -250',
                                            isSelected: goalsState.dailyCalorieTarget == 1750,
                                            onTap: () => ref.read(goalsProvider.notifier).updateCalorieTarget(1750),
                                          ),
                                          _buildPresetButton(
                                            label: 'Maintain',
                                            isSelected: goalsState.dailyCalorieTarget == 2000,
                                            onTap: () => ref.read(goalsProvider.notifier).updateCalorieTarget(2000),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 16),
                              ],

                              // 2. Build Muscle Protein Slider
                              if (showProteinSlider) ...[
                                _buildSliderCard(
                                  title: '💪 Build Muscle Target',
                                  subtitle: 'Protein Target: ${goalsState.dailyProteinG}g',
                                  color: AppColorsDark.secondary,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.stretch,
                                    children: [
                                      Slider(
                                        value: goalsState.dailyProteinG.toDouble(),
                                        min: 80,
                                        max: 220,
                                        divisions: 28, // step 5g
                                        activeColor: AppColorsDark.secondary,
                                        inactiveColor: AppColorsDark.surface2,
                                        onChanged: (val) {
                                          ref.read(goalsProvider.notifier).updateProteinTarget(val.toInt());
                                        },
                                      ),
                                      const SizedBox(height: 4),
                                      Center(
                                        child: Text(
                                          '~${(weightKg * 1.6).toStringAsFixed(0)}g recommended for your weight (${weightKg.toStringAsFixed(0)} kg)',
                                          style: AppTypography.bodySm(color: AppColorsDark.textSecondary).copyWith(
                                            fontStyle: FontStyle.italic,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 16),
                              ],

                              // 3. Heart Health & Glucose Steps Slider
                              if (showStepsSlider) ...[
                                _buildSliderCard(
                                  title: '🩸 / ❤️ Cardio Activity Goal',
                                  subtitle: 'Daily Steps Goal: ${goalsState.dailyStepsGoal} steps',
                                  color: AppColorsDark.primary,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.stretch,
                                    children: [
                                      Slider(
                                        value: goalsState.dailyStepsGoal.toDouble(),
                                        min: 4000,
                                        max: 15000,
                                        divisions: 22, // step 500
                                        activeColor: AppColorsDark.primary,
                                        inactiveColor: AppColorsDark.surface2,
                                        onChanged: (val) {
                                          ref.read(goalsProvider.notifier).updateStepsGoal(val.toInt());
                                        },
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          _buildPresetButton(
                                            label: 'Easy 5k',
                                            isSelected: goalsState.dailyStepsGoal == 5000,
                                            onTap: () => ref.read(goalsProvider.notifier).updateStepsGoal(5000),
                                          ),
                                          _buildPresetButton(
                                            label: 'Active 8k',
                                            isSelected: goalsState.dailyStepsGoal == 8000,
                                            onTap: () => ref.read(goalsProvider.notifier).updateStepsGoal(8000),
                                          ),
                                          _buildPresetButton(
                                            label: 'Athletic 12k',
                                            isSelected: goalsState.dailyStepsGoal == 12000,
                                            onTap: () => ref.read(goalsProvider.notifier).updateStepsGoal(12000),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 16),
                              ],

                              // 4. Sleep, Stress & Energy Sleep Target Slider
                              if (showSleepSlider) ...[
                                _buildSliderCard(
                                  title: '🧘 Sleep & Recovery Target',
                                  subtitle: 'Sleep Target: ${goalsState.sleepTargetHours.toStringAsFixed(1)} hours',
                                  color: AppColorsDark.teal,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.stretch,
                                    children: [
                                      Slider(
                                        value: goalsState.sleepTargetHours,
                                        min: 6.0,
                                        max: 9.0,
                                        divisions: 6, // step 30min
                                        activeColor: AppColorsDark.teal,
                                        inactiveColor: AppColorsDark.surface2,
                                        onChanged: (val) {
                                          ref.read(goalsProvider.notifier).updateSleepTarget(val);
                                        },
                                      ),
                                      const SizedBox(height: 4),
                                      Center(
                                        child: Text(
                                          'Adults need 7–8h of restorative sleep',
                                          style: AppTypography.bodySm(color: AppColorsDark.textSecondary).copyWith(
                                            fontStyle: FontStyle.italic,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 16),
                              ],
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Bottom Continue CTA
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
                  child: Container(
                    width: double.infinity,
                    height: 56,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: selectedGoals.isNotEmpty
                          ? [
                              BoxShadow(
                                color: AppColorsDark.primary.withValues(alpha: 0.3),
                                blurRadius: 20,
                                offset: const Offset(0, 8),
                              ),
                            ]
                          : null,
                    ),
                    child: ElevatedButton(
                      onPressed: selectedGoals.isNotEmpty
                          ? () async {
                              await ref.read(authProvider.notifier).saveGoals(
                                    goals: selectedGoals,
                                    dailyCalorieTarget: goalsState.dailyCalorieTarget,
                                    dailyProteinG: goalsState.dailyProteinG,
                                    dailyStepsGoal: goalsState.dailyStepsGoal,
                                    sleepTargetHours: goalsState.sleepTargetHours,
                                  );
                              if (context.mounted) {
                                context.go('/onboarding/demographics');
                              }
                            }
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColorsDark.primary,
                        disabledBackgroundColor: AppColorsDark.surface0.withValues(alpha: 0.4),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        'Continue',
                        style: AppTypography.h3(
                          color: selectedGoals.isNotEmpty ? Colors.white : AppColorsDark.textMuted,
                        ).copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Helper builder for custom targets card
  Widget _buildSliderCard({
    required String title,
    required String subtitle,
    required Color color,
    required Widget child,
  }) {
    return GlassCard(
      customRadius: 20,
      glowColor: color.withValues(alpha: 0.15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: AppTypography.h3(color: Colors.white).copyWith(fontSize: 15),
              ),
              Text(
                subtitle,
                style: AppTypography.labelLg(color: color).copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }

  // Helper builder for preset buttons
  Widget _buildPresetButton({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected
                ? AppColorsDark.primary.withValues(alpha: 0.15)
                : AppColorsDark.surface0.withValues(alpha: 0.4),
            border: Border.all(
              color: isSelected ? AppColorsDark.primary : AppColorsDark.glassBorder,
              width: 1.5,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Text(
              label,
              style: AppTypography.labelMd(
                color: isSelected ? Colors.white : AppColorsDark.textSecondary,
              ).copyWith(
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Stateful Goal Bento Card supporting scale spring bounce and shake translations
class BentoGoalCard extends StatefulWidget {
  final HealthGoal goal;
  final bool isSelected;
  final VoidCallback onTap;

  const BentoGoalCard({
    super.key,
    required this.goal,
    required this.isSelected,
    required this.onTap,
  });

  @override
  State<BentoGoalCard> createState() => _BentoGoalCardState();
}

class _BentoGoalCardState extends State<BentoGoalCard> with TickerProviderStateMixin {
  late AnimationController _scaleController;
  late AnimationController _shakeController;

  @override
  void initState() {
    super.initState();
    // spring scale feedback: 0.96 -> 1.0
    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
      lowerBound: 0.96,
      upperBound: 1.0,
      value: 1.0,
    );

    // micro-shake animation controller: 300ms
    _shakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _shakeController.dispose();
    super.dispose();
  }

  void _shake() {
    _shakeController.forward(from: 0.0);
  }

  @override
  Widget build(BuildContext context) {
    // Left-right translation sequence representing the limits breach shake
    final Animation<double> shakeOffset = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: -8.0), weight: 1),
      TweenSequenceItem(tween: Tween(begin: -8.0, end: 8.0), weight: 2),
      TweenSequenceItem(tween: Tween(begin: 8.0, end: -6.0), weight: 2),
      TweenSequenceItem(tween: Tween(begin: -6.0, end: 6.0), weight: 2),
      TweenSequenceItem(tween: Tween(begin: 6.0, end: -4.0), weight: 2),
      TweenSequenceItem(tween: Tween(begin: -4.0, end: 0.0), weight: 1),
    ]).animate(CurvedAnimation(
      parent: _shakeController,
      curve: Curves.linear,
    ));

    return AnimatedBuilder(
      animation: Listenable.merge([_scaleController, _shakeController]),
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(shakeOffset.value, 0),
          child: Transform.scale(
            scale: _scaleController.value,
            child: child,
          ),
        );
      },
      child: GlassCard(
        glowColor: widget.isSelected ? widget.goal.color.withValues(alpha: 0.2) : null,
        padding: EdgeInsets.zero,
        customRadius: 20,
        child: InkWell(
          onTapDown: (_) => _scaleController.reverse(),
          onTapUp: (_) => _scaleController.forward(),
          onTapCancel: () => _scaleController.forward(),
          onTap: widget.onTap,
          borderRadius: BorderRadius.circular(20),
          child: Container(
            decoration: BoxDecoration(
              color: widget.isSelected
                  ? AppColorsDark.primaryMuted.withValues(alpha: 0.15)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: widget.isSelected
                    ? AppColorsDark.primaryGlow
                    : AppColorsDark.glassBorder,
                width: 2,
              ),
            ),
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        widget.goal.icon,
                        style: const TextStyle(fontSize: 32),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        widget.goal.title,
                        style: AppTypography.h3(color: Colors.white).copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                ),
                if (widget.isSelected)
                  Positioned(
                    top: 12,
                    right: 12,
                    child: Icon(
                      Icons.check_circle_rounded,
                      color: AppColorsDark.primary,
                      size: 20,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
