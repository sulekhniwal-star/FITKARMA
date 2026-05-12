import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../shared/widgets/scaffold_patterns.dart';
import '../../shared/widgets/bilingual_label.dart';
import '../../shared/widgets/bento_card.dart';
import 'mental_health_providers.dart';

class MentalHealthScreen extends ConsumerStatefulWidget {
  const MentalHealthScreen({super.key});

  @override
  ConsumerState<MentalHealthScreen> createState() => _MentalHealthScreenState();
}

class _MentalHealthScreenState extends ConsumerState<MentalHealthScreen> {
  // Track CBT expansion index state locally
  int? _expandedCbtIndex;

  void _routeToBreathing(BreathingExercise exercise) {
    ref.read(selectedBreathingExerciseProvider.notifier).select(exercise);
    context.push('/mental-health/breathing');
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(mentalHealthStateProvider);

    return AppScaffold.patternA(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
          onPressed: () => context.pop(),
        ),
        title: const BilingualLabel(
          english: 'Mental Health Hub',
          hindi: 'मानसिक स्वास्थ्य केंद्र',
          crossAxisAlignment: CrossAxisAlignment.center,
        ),
        centerTitle: true,
      ),
      showFab: false, // Clean layout prioritizing psychological clarity
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 16),

          // Burnout Gauge (Self-Assessment)
          _buildBurnoutGaugeCard(state),
          const SizedBox(height: 28),

          // Breathing Exercise Selector Bento Grid
          Text('Pranayama Breathing Cycles', style: AppTypography.h2(color: Colors.white)),
          const SizedBox(height: 4),
          Text(
            'Targeted parasympathetic resets routing to guided spatial circle loops.',
            style: AppTypography.labelSm(color: AppColorsDark.textSecondary),
          ),
          const SizedBox(height: 16),
          _buildBreathingSelector(state.exercises),
          const SizedBox(height: 32),

          // CBT Insight Cards
          Text('CBT Cognitive Distortions', style: AppTypography.h2(color: Colors.white)),
          const SizedBox(height: 4),
          Text(
            'Tap cards to flip standard unhelpful cognitive traps into balanced reframing statements.',
            style: AppTypography.labelSm(color: AppColorsDark.textSecondary),
          ),
          const SizedBox(height: 16),
          _buildCbtInsightsList(state.cbtInsights),
          const SizedBox(height: 36),

          // Indian Crisis Helplines always visible (BilingualLabel)
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColorsDark.rose.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: AppColorsDark.rose.withValues(alpha: 0.3)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    const Icon(Icons.support_agent_rounded, color: AppColorsDark.rose, size: 28),
                    const SizedBox(width: 12),
                    Expanded(
                      child: const BilingualLabel(
                        english: '24/7 Crisis Helplines',
                        hindi: 'आपातकालीन सहायता रेखाएँ',
                        color: AppColorsDark.rose,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Free, confidential psychological support accessible across India instantly:',
                  style: AppTypography.labelSm(color: AppColorsDark.textSecondary),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12.0),
                  child: Divider(color: AppColorsDark.divider, height: 1),
                ),

                // Helpline 1: iCall
                _buildHelplineRow(
                  englishName: 'iCall Psychosocial Service',
                  hindiName: 'आईकॉल मनोसामाजिक सेवा',
                  phoneStr: '9152987821',
                ),
                const SizedBox(height: 12),

                // Helpline 2: Vandrevala
                _buildHelplineRow(
                  englishName: 'Vandrevala Foundation',
                  hindiName: 'वांद्रेवाला फाउंडेशन',
                  phoneStr: '1860-2662-345',
                ),
                const SizedBox(height: 12),

                // Helpline 3: NIMHANS
                _buildHelplineRow(
                  englishName: 'NIMHANS National Helpline',
                  hindiName: 'निमहांस राष्ट्रीय हेल्पलाइन',
                  phoneStr: '080-46110007',
                ),
              ],
            ),
          ),
          const SizedBox(height: 48),
        ],
      ),
    );
  }

  Widget _buildBurnoutGaugeCard(MentalHealthState state) {
    Color gaugeColor = AppColorsDark.teal;
    if (state.burnoutScore >= 6.5) gaugeColor = AppColorsDark.accent;
    if (state.burnoutScore >= 8.5) gaugeColor = AppColorsDark.rose;

    return GlassCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: const BilingualLabel(
                  english: 'Burnout Fatigue Gauge',
                  hindi: 'मानसिक थकावट सूचकांक',
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: gaugeColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(100),
                  border: Border.all(color: gaugeColor.withValues(alpha: 0.3)),
                ),
                child: Text(
                  state.burnoutScore.toStringAsFixed(1),
                  style: AppTypography.monoLg(color: gaugeColor).copyWith(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Custom Gauge Bar representation
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: SizedBox(
              height: 12,
              child: LinearProgressIndicator(
                value: state.burnoutScore / 10.0,
                backgroundColor: AppColorsDark.surface2,
                valueColor: AlwaysStoppedAnimation<Color>(gaugeColor),
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Dynamic Status tags
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(state.burnoutLevelLabel, style: AppTypography.labelLg(color: gaugeColor)),
              Text(state.burnoutHindiLabel, style: AppTypography.hindi(color: AppColorsDark.textSecondary)),
            ],
          ),
          const SizedBox(height: 16),

          // Interactive slider allowing user adjustment
          Text('Adjust real-time self-assessment index:', style: AppTypography.labelSm(color: AppColorsDark.textMuted)),
          Slider(
            value: state.burnoutScore,
            min: 1.0,
            max: 10.0,
            divisions: 18,
            activeColor: gaugeColor,
            inactiveColor: AppColorsDark.surface2,
            onChanged: (val) {
              ref.read(mentalHealthStateProvider.notifier).setBurnoutScore(val);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildBreathingSelector(List<BreathingExercise> exercises) {
    return Column(
      children: exercises.map((ex) {
        Color ringColor = AppColorsDark.teal;
        if (ex.colorToken == 'purple') ringColor = AppColorsDark.purple;
        if (ex.colorToken == 'accent') ringColor = AppColorsDark.accent;

        return Padding(
          padding: const EdgeInsets.only(bottom: 12.0),
          child: InkWell(
            onTap: () => _routeToBreathing(ex),
            borderRadius: BorderRadius.circular(20),
            child: GlassCard(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: ringColor.withValues(alpha: 0.12),
                      shape: BoxShape.circle,
                      border: Border.all(color: ringColor.withValues(alpha: 0.4)),
                    ),
                    child: Icon(Icons.air_rounded, color: ringColor, size: 22),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(ex.title, style: AppTypography.labelLg(color: Colors.white)),
                            const SizedBox(width: 8),
                            Text(ex.hindiTitle, style: AppTypography.hindi(color: AppColorsDark.textSecondary)),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(ex.description, style: AppTypography.labelSm(color: AppColorsDark.textMuted)),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(Icons.chevron_right_rounded, color: AppColorsDark.textSecondary),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildCbtInsightsList(List<CbtInsight> insights) {
    return Column(
      children: insights.asMap().entries.map((entry) {
        final int index = entry.key;
        final CbtInsight item = entry.value;
        final bool isExpanded = _expandedCbtIndex == index;

        return Padding(
          padding: const EdgeInsets.only(bottom: 12.0),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeInOut,
            decoration: BoxDecoration(
              color: isExpanded ? AppColorsDark.surface1 : AppColorsDark.surface0,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isExpanded ? AppColorsDark.teal : AppColorsDark.surface2,
              ),
            ),
            child: InkWell(
              onTap: () {
                setState(() {
                  _expandedCbtIndex = isExpanded ? null : index;
                });
              },
              borderRadius: BorderRadius.circular(20),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: BilingualLabel(
                            english: item.distortion,
                            hindi: item.hindiDistortion,
                            color: isExpanded ? AppColorsDark.teal : Colors.white,
                          ),
                        ),
                        Icon(
                          isExpanded ? Icons.expand_less_rounded : Icons.psychology_alt_rounded,
                          color: isExpanded ? AppColorsDark.teal : AppColorsDark.textMuted,
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(item.definition, style: AppTypography.bodySm(color: AppColorsDark.textSecondary)),
                    
                    if (isExpanded) ...[
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 12.0),
                        child: Divider(color: AppColorsDark.divider, height: 1),
                      ),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColorsDark.teal.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColorsDark.teal.withValues(alpha: 0.2)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Cognitive Reframing Prompt:', style: AppTypography.labelSm(color: AppColorsDark.teal)),
                            const SizedBox(height: 4),
                            Text(item.reframing, style: AppTypography.bodySm(color: Colors.white).copyWith(fontStyle: FontStyle.italic)),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildHelplineRow({
    required String englishName,
    required String hindiName,
    required String phoneStr,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColorsDark.surface1,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColorsDark.surface2),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: BilingualLabel(
              english: englishName,
              hindi: hindiName,
              color: Colors.white,
            ),
          ),
          Row(
            children: [
              SelectableText(
                phoneStr,
                style: AppTypography.monoLg(color: AppColorsDark.rose).copyWith(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: AppColorsDark.rose.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(10)),
                child: const Icon(Icons.phone_in_talk_rounded, size: 16, color: AppColorsDark.rose),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
