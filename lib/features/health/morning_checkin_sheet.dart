import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import 'readiness_provider.dart';

class MorningCheckInSheet extends ConsumerStatefulWidget {
  const MorningCheckInSheet({super.key});

  @override
  ConsumerState<MorningCheckInSheet> createState() => _MorningCheckInSheetState();
}

class _MorningCheckInSheetState extends ConsumerState<MorningCheckInSheet> {
  double _sleepHours = 7.0;
  double _sleepQuality = 7.0;
  double _soreness = 3.0;
  double _stress = 3.0;
  double _energy = 7.0;
  final TextEditingController _hrController = TextEditingController();

  @override
  void dispose() {
    _hrController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColorsDark.bg1,
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.lg)),
      ),
      padding: EdgeInsets.only(
        left: AppSpacing.screenH,
        right: AppSpacing.screenH,
        top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColorsDark.surface2,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Morning Check-In',
              style: AppTypography.h1(color: AppColorsDark.textPrimary),
            ),
            const SizedBox(height: 4),
            Text(
              'Align your goals with your physical recovery state today.',
              style: AppTypography.bodyMd(color: AppColorsDark.textSecondary),
            ),
            const SizedBox(height: 20),

            // Sleep Hours Slider
            _buildSliderRow(
              title: 'Sleep Duration',
              value: '${_sleepHours.toStringAsFixed(1)} hrs',
              subtitle: 'How long did you sleep last night?',
            ),
            Slider(
              value: _sleepHours,
              min: 3.0,
              max: 12.0,
              divisions: 18,
              activeColor: AppColorsDark.teal,
              inactiveColor: AppColorsDark.surface2,
              onChanged: (v) => setState(() => _sleepHours = v),
            ),

            // Sleep Quality Slider
            _buildSliderRow(
              title: 'Sleep Quality',
              value: '${_sleepQuality.toInt()}/10',
              subtitle: 'Restfulness, interruptions, depth',
            ),
            Slider(
              value: _sleepQuality,
              min: 1.0,
              max: 10.0,
              divisions: 9,
              activeColor: AppColorsDark.teal,
              inactiveColor: AppColorsDark.surface2,
              onChanged: (v) => setState(() => _sleepQuality = v),
            ),

            // Soreness Slider
            _buildSliderRow(
              title: 'Muscle Soreness',
              value: '${_soreness.toInt()}/10',
              subtitle: '10 means extremely sore or in pain',
            ),
            Slider(
              value: _soreness,
              min: 1.0,
              max: 10.0,
              divisions: 9,
              activeColor: AppColorsDark.rose,
              inactiveColor: AppColorsDark.surface2,
              onChanged: (v) => setState(() => _soreness = v),
            ),

            // Stress Slider
            _buildSliderRow(
              title: 'Mental Stress',
              value: '${_stress.toInt()}/10',
              subtitle: 'Current mental load or anxiety',
            ),
            Slider(
              value: _stress,
              min: 1.0,
              max: 10.0,
              divisions: 9,
              activeColor: AppColorsDark.accent,
              inactiveColor: AppColorsDark.surface2,
              onChanged: (v) => setState(() => _stress = v),
            ),

            // Energy Slider
            _buildSliderRow(
              title: 'Energy Level',
              value: '${_energy.toInt()}/10',
              subtitle: 'Overall vitality and wakefulness',
            ),
            Slider(
              value: _energy,
              min: 1.0,
              max: 10.0,
              divisions: 9,
              activeColor: AppColorsDark.success,
              inactiveColor: AppColorsDark.surface2,
              onChanged: (v) => setState(() => _energy = v),
            ),

            const SizedBox(height: 12),
            // Resting HR Input
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Resting Heart Rate (optional)',
                      style: AppTypography.bodyMd(color: AppColorsDark.textPrimary).copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      'Helps detect autonomic strain',
                      style: AppTypography.labelSm(color: AppColorsDark.textSecondary),
                    ),
                  ],
                ),
                SizedBox(
                  width: 80,
                  child: TextField(
                    controller: _hrController,
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    style: AppTypography.bodyMd(color: AppColorsDark.textPrimary),
                    decoration: InputDecoration(
                      hintText: '--',
                      hintStyle: AppTypography.bodyMd(color: AppColorsDark.textMuted),
                      contentPadding: const EdgeInsets.symmetric(vertical: 8),
                      filled: true,
                      fillColor: AppColorsDark.surface0,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppRadius.sm),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Submit Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColorsDark.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppRadius.md),
                  ),
                ),
                child: const Text(
                  'Submit Check-In',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildSliderRow({required String title, required String value, required String subtitle}) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTypography.bodyMd(color: AppColorsDark.textPrimary).copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  subtitle,
                  style: AppTypography.labelSm(color: AppColorsDark.textSecondary),
                ),
              ],
            ),
          ),
          Text(
            value,
            style: AppTypography.h3(color: AppColorsDark.textPrimary),
          ),
        ],
      ),
    );
  }

  void _submit() async {
    final sleepMins = (_sleepHours * 60).round();
    final restingHr = int.tryParse(_hrController.text);

    await ref.read(readinessStateProvider.notifier).logMorningCheckIn(
      sleepMinutes: sleepMins,
      sleepQuality: _sleepQuality.toInt(),
      sorenessLevel: _soreness.toInt(),
      stressLevel: _stress.toInt(),
      energyLevel: _energy.toInt(),
      restingHr: restingHr,
    );

    if (mounted) {
      context.pop();
    }
  }
}
