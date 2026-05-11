import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_gradients.dart';
import '../../core/theme/app_typography.dart';
import '../../shared/widgets/scaffold_patterns.dart';
import '../../shared/widgets/bento_card.dart';
import 'onboarding_providers.dart';
import 'models/health_goal.dart';

class GoalsScreen extends ConsumerWidget {
  const GoalsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedGoals = ref.watch(goalsProvider);

    return AppScaffold.patternC(
      gradient: AppGradients.heroDeep,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 40),
            Text(
              'What are your goals?',
              style: AppTypography.h1(color: Colors.white).copyWith(fontSize: 32),
            ).animate().fadeIn().slideX(begin: -0.1, end: 0),
            const SizedBox(height: 8),
            Text(
              'Select all that apply. We will tailor your\nexperience based on these.',
              style: AppTypography.bodyLg(color: AppColorsDark.textSecondary),
            ).animate().fadeIn(delay: 200.ms).slideX(begin: -0.1, end: 0),
            const SizedBox(height: 40),

            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1.1,
                ),
                itemCount: availableGoals.length,
                itemBuilder: (context, index) {
                  final goal = availableGoals[index];
                  final isSelected = selectedGoals.contains(goal.id);

                  return _GoalCard(
                    goal: goal,
                    isSelected: isSelected,
                    onTap: () => ref.read(goalsProvider.notifier).toggleGoal(goal.id),
                  ).animate().fadeIn(delay: (index * 50).ms).scale(begin: const Offset(0.8, 0.8), end: const Offset(1, 1));
                },
              ),
            ),

            const SizedBox(height: 24),
            
            _ContinueButton(
              isEnabled: selectedGoals.isNotEmpty,
              onPressed: () async {
                await ref.read(authProvider.notifier).saveGoals(selectedGoals);
                if (context.mounted) {
                  context.go('/onboarding/permissions');
                }
              },
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

class _GoalCard extends StatelessWidget {
  final HealthGoal goal;
  final bool isSelected;
  final VoidCallback onTap;

  const _GoalCard({
    required this.goal,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      onTap: onTap,
      glowColor: isSelected ? goal.color : null,
      padding: EdgeInsets.zero,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isSelected ? goal.color : Colors.transparent,
            width: 2,
          ),
        ),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    goal.icon,
                    style: const TextStyle(fontSize: 32),
                  ),
                  Text(
                    goal.title,
                    style: AppTypography.h3(color: Colors.white).copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              Positioned(
                top: 12,
                right: 12,
                child: Icon(
                  Icons.check_circle,
                  color: goal.color,
                  size: 24,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _ContinueButton extends StatelessWidget {
  final bool isEnabled;
  final VoidCallback onPressed;

  const _ContinueButton({
    required this.isEnabled,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: isEnabled
            ? [
                BoxShadow(
                  color: AppColorsDark.primary.withOpacity(0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ]
            : null,
      ),
      child: ElevatedButton(
        onPressed: isEnabled ? onPressed : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColorsDark.primary,
          disabledBackgroundColor: AppColorsDark.surface0,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 0,
        ),
        child: Text(
          'Continue',
          style: AppTypography.h3(color: isEnabled ? Colors.white : AppColorsDark.textMuted).copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
