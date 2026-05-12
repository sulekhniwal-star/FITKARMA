import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../shared/widgets/scaffold_patterns.dart';
import '../../shared/widgets/bento_card.dart';
import 'water_providers.dart';

class WaterScreen extends ConsumerWidget {
  const WaterScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(waterTrackingProvider);
    final notifier = ref.read(waterTrackingProvider.notifier);

    final todayAsync = ref.watch(todayWaterStreamProvider);
    final currentTotalMl = todayAsync.valueOrNull ?? 0;

    final double progressRatio = (currentTotalMl / state.dailyGoalMl).clamp(0.0, 1.0);

    return AppScaffold.patternA(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
          onPressed: () => context.pop(),
        ),
        title: Text('Hydration Hub', style: AppTypography.h2(color: Colors.white)),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 16),

          // Daily total + goal progress ring widget banner
          GlassCard(
            padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 20),
            child: Column(
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 220,
                      height: 220,
                      child: CircularProgressIndicator(
                        value: progressRatio,
                        strokeWidth: 16,
                        backgroundColor: AppColorsDark.surface2,
                        valueColor: const AlwaysStoppedAnimation<Color>(AppColorsDark.teal),
                        strokeCap: StrokeCap.round,
                      ),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.water_drop_rounded, size: 36, color: AppColorsDark.teal),
                        const SizedBox(height: 4),
                        Text(
                          '$currentTotalMl',
                          style: AppTypography.heroDisplay(color: Colors.white).copyWith(fontSize: 48),
                        ),
                        Text(
                          'of ${state.dailyGoalMl} ml',
                          style: AppTypography.labelSm(color: AppColorsDark.textMuted),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 28),

                // Streak tracking indicator bar
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                    color: AppColorsDark.accent.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(100),
                    border: Border.all(color: AppColorsDark.accent.withOpacity(0.3)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('🔥', style: TextStyle(fontSize: 18)),
                      const SizedBox(width: 8),
                      Text(
                        '${state.currentStreakDays} Day Hydration Streak',
                        style: AppTypography.labelLg(color: AppColorsDark.accent).copyWith(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),

          // Log amount (ml) with preset buttons (200ml, 350ml, 500ml)
          Text('Log Immediate Intake', style: AppTypography.h3(color: Colors.white)),
          const SizedBox(height: 4),
          Text('Select standardized dynamic volume units below.', style: AppTypography.labelSm(color: AppColorsDark.textSecondary)),
          const SizedBox(height: 16),

          Row(
            children: [
              Expanded(
                child: _buildPresetButton(
                  context,
                  amountMl: 200,
                  iconSize: 20,
                  label: 'Small Glass',
                  onTap: () => notifier.addWater(200),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildPresetButton(
                  context,
                  amountMl: 350,
                  iconSize: 24,
                  label: 'Medium Mug',
                  onTap: () => notifier.addWater(350),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildPresetButton(
                  context,
                  amountMl: 500,
                  iconSize: 28,
                  label: 'Large Bottle',
                  onTap: () => notifier.addWater(500),
                ),
              ),
            ],
          ),
          const SizedBox(height: 28),

          // Custom entry modifier option
          GlassCard(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Custom Capacity Input', style: AppTypography.labelLg(color: Colors.white)),
                    const SizedBox(height: 2),
                    Text('Adjust bespoke target volumes.', style: AppTypography.labelSm(color: AppColorsDark.textMuted)),
                  ],
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColorsDark.surface2,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed: () => _showCustomInputDialog(context, notifier),
                  child: const Text('+ Custom ml'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 48),
        ],
      ),
    );
  }

  Widget _buildPresetButton(
    BuildContext context, {
    required int amountMl,
    required double iconSize,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: () {
        onTap();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('💧 Logged +$amountMl ml successfully!'),
            backgroundColor: AppColorsDark.teal,
            duration: const Duration(milliseconds: 1200),
          ),
        );
      },
      borderRadius: BorderRadius.circular(20),
      child: GlassCard(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 8),
        child: Column(
          children: [
            Icon(Icons.water_drop_rounded, size: iconSize, color: AppColorsDark.teal),
            const SizedBox(height: 8),
            Text('+$amountMl', style: AppTypography.h2(color: Colors.white).copyWith(fontSize: 20)),
            Text('ml', style: AppTypography.labelSm(color: AppColorsDark.teal)),
            const SizedBox(height: 4),
            Text(label, style: AppTypography.labelSm(color: AppColorsDark.textMuted).copyWith(fontSize: 10), textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }

  void _showCustomInputDialog(BuildContext context, WaterNotifier notifier) {
    final ctrl = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColorsDark.surface1,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text('Custom Intake (ml)', style: AppTypography.h3(color: Colors.white)),
        content: TextField(
          controller: ctrl,
          keyboardType: TextInputType.number,
          style: AppTypography.bodyLg(color: Colors.white),
          decoration: InputDecoration(
            hintText: 'e.g. 750',
            hintStyle: AppTypography.bodyLg(color: AppColorsDark.textMuted),
            filled: true,
            fillColor: AppColorsDark.surface0,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
          ),
        ),
        actions: [
          TextButton(onPressed: () => context.pop(), child: Text('Cancel', style: AppTypography.labelSm(color: AppColorsDark.textMuted))),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColorsDark.teal, foregroundColor: Colors.black),
            onPressed: () {
              final parsed = int.tryParse(ctrl.text.trim());
              if (parsed != null && parsed > 0) {
                notifier.addWater(parsed);
                context.pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('💧 Logged +$parsed ml successfully!'), backgroundColor: AppColorsDark.teal),
                );
              }
            },
            child: const Text('Add Capacity', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}
