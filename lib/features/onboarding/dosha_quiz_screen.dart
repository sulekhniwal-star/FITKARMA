import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../shared/widgets/scaffold_patterns.dart';
import 'onboarding_providers.dart';
import 'models/dosha_quiz.dart';

class DoshaQuizScreen extends ConsumerStatefulWidget {
  const DoshaQuizScreen({super.key});

  @override
  ConsumerState<DoshaQuizScreen> createState() => _DoshaQuizScreenState();
}

class _DoshaQuizScreenState extends ConsumerState<DoshaQuizScreen> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  void _onAnswer(DoshaType type) {
    ref.read(doshaQuizProvider.notifier).answerQuestion(_currentIndex, type);
    
    if (_currentIndex < doshaQuestions.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOutCubic,
      );
    } else {
      _showResult();
    }
  }

  Future<void> _showResult() async {
    final result = ref.read(doshaQuizProvider.notifier).calculateResult();
    if (result == null) return;

    // Show a loading overlay while saving
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    await ref.read(authProvider.notifier).saveDoshaResult(result);

    if (mounted) {
      Navigator.of(context).pop(); // Close loading dialog
      context.go('/onboarding/goals');
    }
  }

  @override
  Widget build(BuildContext context) {
    final quizState = ref.watch(doshaQuizProvider);

    return AppScaffold.patternA(
      showFab: false,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          
          // Progress Indicator
          Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    value: (_currentIndex + 1) / doshaQuestions.length,
                    minHeight: 8,
                    backgroundColor: AppColorsDark.surface0,
                    valueColor: const AlwaysStoppedAnimation(AppColorsDark.primary),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Text(
                '${_currentIndex + 1} / ${doshaQuestions.length}',
                style: AppTypography.labelMd(color: AppColorsDark.textSecondary),
              ),
            ],
          ),
          
          const SizedBox(height: 40),

          SizedBox(
            height: MediaQuery.of(context).size.height * 0.6,
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: (index) => setState(() => _currentIndex = index),
              physics: const NeverScrollableScrollPhysics(),
              itemCount: doshaQuestions.length,
              itemBuilder: (context, index) {
                final q = doshaQuestions[index];
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      q.question,
                      style: AppTypography.h1(color: Colors.white).copyWith(
                        fontSize: 28,
                        height: 1.3,
                      ),
                    ).animate().fadeIn().slideX(begin: 0.1, end: 0),
                    const SizedBox(height: 40),
                    
                    _OptionCard(
                      text: q.vataOption,
                      isSelected: quizState[index] == DoshaType.vata,
                      onTap: () => _onAnswer(DoshaType.vata),
                    ).animate().fadeIn(delay: 100.ms).slideY(begin: 0.1, end: 0),
                    
                    const SizedBox(height: 16),
                    
                    _OptionCard(
                      text: q.pittaOption,
                      isSelected: quizState[index] == DoshaType.pitta,
                      onTap: () => _onAnswer(DoshaType.pitta),
                    ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.1, end: 0),
                    
                    const SizedBox(height: 16),
                    
                    _OptionCard(
                      text: q.kaphaOption,
                      isSelected: quizState[index] == DoshaType.kapha,
                      onTap: () => _onAnswer(DoshaType.kapha),
                    ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.1, end: 0),
                  ],
                );
              },
            ),
          ),
          
          if (_currentIndex > 0)
            TextButton.icon(
              onPressed: () {
                _pageController.previousPage(
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.easeInOutCubic,
                );
              },
              icon: const Icon(Icons.arrow_back, size: 18),
              label: const Text('Previous Question'),
              style: TextButton.styleFrom(foregroundColor: AppColorsDark.textMuted),
            ),
        ],
      ),
    );
  }
}

class _OptionCard extends StatelessWidget {
  final String text;
  final bool isSelected;
  final VoidCallback onTap;

  const _OptionCard({
    required this.text,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(20),
        width: double.infinity,
        decoration: BoxDecoration(
          color: isSelected ? AppColorsDark.primary.withValues(alpha: 0.1) : AppColorsDark.surface0,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppColorsDark.primary : Colors.transparent,
            width: 2,
          ),
        ),
        child: Text(
          text,
          style: AppTypography.bodyLg(
            color: isSelected ? Colors.white : AppColorsDark.textPrimary,
          ).copyWith(
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
