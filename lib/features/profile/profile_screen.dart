import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../shared/widgets/scaffold_patterns.dart';
import '../../shared/widgets/bento_card.dart';
import '../onboarding/onboarding_providers.dart';
import '../karma/karma_providers.dart';
import 'profile_providers.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  void _editMetricDialog({
    required String title,
    required String currentValue,
    required void Function(String) onSave,
    bool isNumber = false,
  }) {
    final controller = TextEditingController(text: currentValue);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColorsDark.surface1,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text('Edit $title', style: AppTypography.h3(color: Colors.white)),
        content: TextField(
          controller: controller,
          keyboardType: isNumber ? const TextInputType.numberWithOptions(decimal: true) : TextInputType.text,
          style: AppTypography.bodyLg(color: Colors.white),
          decoration: InputDecoration(
            filled: true,
            fillColor: AppColorsDark.surface0,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => context.pop(),
            child: Text('Cancel', style: AppTypography.labelSm(color: AppColorsDark.textMuted)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColorsDark.teal,
              foregroundColor: Colors.black,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: () {
              final val = controller.text.trim();
              if (val.isNotEmpty) {
                onSave(val);
              }
              context.pop();
            },
            child: const Text('Update', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  void _triggerReferralBonus() {
    ref.read(karmaStateProvider.notifier).addKarmaEvent(
          'Wellness Companion Referral',
          'streak',
          500,
        );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('🎉 App link shared successfully! +500 Karma XP credited.'),
        backgroundColor: AppColorsDark.accent,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authAsync = ref.watch(authProvider);
    final user = authAsync.value;
    final emailStr = user?.email ?? 'sulekhniwal@fitkarma.in';

    final metrics = ref.watch(userProfileMetricsProvider);
    final karmaState = ref.watch(karmaStateProvider);

    // Derive avatar initials
    final nameStr = metrics.name;
    final initials = nameStr.isNotEmpty ? nameStr.split(' ').map((e) => e.isNotEmpty ? e[0] : '').take(2).join().toUpperCase() : 'ME';

    // Dosha percentages configuration
    // Fetch result from quiz if available, otherwise baseline fallback
    final doshaResult = ref.watch(doshaQuizProvider.notifier).calculateResult();
    final double vataPct = doshaResult?.vataPercentage ?? 40.0;
    final double pittaPct = doshaResult?.pittaPercentage ?? 35.0;
    final double kaphaPct = doshaResult?.kaphaPercentage ?? 25.0;

    return AppScaffold.patternB(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
          onPressed: () => context.pop(),
        ),
        title: Text('Wellness Profile', style: AppTypography.h2(color: Colors.white)),
        centerTitle: true,
      ),
      heroGradient: const LinearGradient(
        colors: [AppColorsDark.heroDeepEnd, AppColorsDark.heroDeepStart],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ),
      hero: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // CircleAvatar + name + email
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              CircleAvatar(
                radius: 48,
                backgroundColor: AppColorsDark.accent,
                foregroundColor: Colors.black,
                child: Text(
                  initials,
                  style: AppTypography.h1(color: Colors.black).copyWith(fontSize: 36, fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(color: AppColorsDark.teal, shape: BoxShape.circle),
                child: const Icon(Icons.verified_rounded, size: 16, color: Colors.black),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            nameStr,
            style: AppTypography.h1(color: Colors.white).copyWith(fontSize: 28),
          ),
          const SizedBox(height: 4),
          Text(
            emailStr,
            style: AppTypography.labelSm(color: AppColorsDark.textSecondary),
          ),
          const SizedBox(height: 12),

          // Security tier label
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
            decoration: BoxDecoration(
              color: AppColorsDark.surface1.withValues(alpha: 0.4),
              borderRadius: BorderRadius.circular(100),
              border: Border.all(color: AppColorsDark.surface2),
            ),
            child: Text(
              '🔒 Isolated SQL Key Protected',
              style: AppTypography.labelSm(color: AppColorsDark.textMuted).copyWith(fontSize: 11),
            ),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 20),

          // Karma level compact card
          GlassCard(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColorsDark.accent.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(Icons.bolt_rounded, size: 24, color: AppColorsDark.accent),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(karmaState.badgeTitle, style: AppTypography.labelLg(color: Colors.white)),
                      const SizedBox(height: 2),
                      Text('Next rank target: ${karmaState.nextLevelXp} XP', style: AppTypography.labelSm(color: AppColorsDark.textMuted)),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('${karmaState.totalXp}', style: AppTypography.h2(color: AppColorsDark.accent)),
                    Text('Total XP', style: AppTypography.labelSm(color: AppColorsDark.textMuted)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 28),

          // Dosha donut chart bento (vata/pitta/kapha percentages)
          Text('Prakriti Constitution (Dosha)', style: AppTypography.h3(color: Colors.white)),
          const SizedBox(height: 12),
          GlassCard(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                SizedBox(
                  height: 160,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      PieChart(
                        PieChartData(
                          sectionsSpace: 4,
                          centerSpaceRadius: 50,
                          startDegreeOffset: -90,
                          sections: [
                            PieChartSectionData(
                              color: AppColorsDark.purple,
                              value: vataPct,
                              title: '${vataPct.round()}%',
                              radius: 20,
                              titleStyle: AppTypography.labelSm(color: Colors.white).copyWith(fontWeight: FontWeight.bold),
                            ),
                            PieChartSectionData(
                              color: AppColorsDark.accent,
                              value: pittaPct,
                              title: '${pittaPct.round()}%',
                              radius: 24, // slightly larger emphasis
                              titleStyle: AppTypography.labelSm(color: Colors.black).copyWith(fontWeight: FontWeight.bold),
                            ),
                            PieChartSectionData(
                              color: AppColorsDark.teal,
                              value: kaphaPct,
                              title: '${kaphaPct.round()}%',
                              radius: 18,
                              titleStyle: AppTypography.labelSm(color: Colors.black).copyWith(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('Dominant', style: AppTypography.labelSm(color: AppColorsDark.textMuted).copyWith(fontSize: 10)),
                          Text(
                            doshaResult?.dominant.name.toUpperCase() ?? 'PITTA',
                            style: AppTypography.labelLg(color: Colors.white).copyWith(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Legends Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildDoshaLegendItem('Vata (Air)', AppColorsDark.purple),
                    _buildDoshaLegendItem('Pitta (Fire)', AppColorsDark.accent),
                    _buildDoshaLegendItem('Kapha (Earth)', AppColorsDark.teal),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 28),

          // Personal info rows (editable)
          Text('Personal Demographics', style: AppTypography.h3(color: Colors.white)),
          const SizedBox(height: 12),
          GlassCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                _buildEditableRow(
                  label: 'Full Name',
                  value: metrics.name,
                  onTap: () => _editMetricDialog(
                    title: 'Name',
                    currentValue: metrics.name,
                    onSave: (val) => ref.read(userProfileMetricsProvider.notifier).updateMetrics(name: val),
                  ),
                ),
                const Divider(color: AppColorsDark.divider, height: 1),
                _buildEditableRow(
                  label: 'Biological Age',
                  value: '${metrics.age} Years',
                  onTap: () => _editMetricDialog(
                    title: 'Age',
                    currentValue: metrics.age.toString(),
                    isNumber: true,
                    onSave: (val) {
                      final parsed = int.tryParse(val);
                      if (parsed != null) ref.read(userProfileMetricsProvider.notifier).updateMetrics(age: parsed);
                    },
                  ),
                ),
                const Divider(color: AppColorsDark.divider, height: 1),
                _buildEditableRow(
                  label: 'Height Metric',
                  value: '${metrics.heightCm} cm',
                  onTap: () => _editMetricDialog(
                    title: 'Height (cm)',
                    currentValue: metrics.heightCm.toString(),
                    isNumber: true,
                    onSave: (val) {
                      final parsed = double.tryParse(val);
                      if (parsed != null) ref.read(userProfileMetricsProvider.notifier).updateMetrics(heightCm: parsed);
                    },
                  ),
                ),
                const Divider(color: AppColorsDark.divider, height: 1),
                _buildEditableRow(
                  label: 'Body Weight',
                  value: '${metrics.weightKg} kg',
                  onTap: () => _editMetricDialog(
                    title: 'Weight (kg)',
                    currentValue: metrics.weightKg.toString(),
                    isNumber: true,
                    onSave: (val) {
                      final parsed = double.tryParse(val);
                      if (parsed != null) ref.read(userProfileMetricsProvider.notifier).updateMetrics(weightKg: parsed);
                    },
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 28),

          // Achievements section
          Text('Unlocked Honors', style: AppTypography.h3(color: Colors.white)),
          const SizedBox(height: 12),
          GlassCard(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: karmaState.achievements.where((a) => a.isUnlocked).map((ach) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(color: AppColorsDark.surface1, borderRadius: BorderRadius.circular(10)),
                        child: Text(ach.icon, style: const TextStyle(fontSize: 20)),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(ach.title, style: AppTypography.labelLg(color: Colors.white)),
                            const SizedBox(height: 2),
                            Text(ach.description, style: AppTypography.labelSm(color: AppColorsDark.textMuted)),
                          ],
                        ),
                      ),
                      const Icon(Icons.verified_rounded, color: AppColorsDark.teal, size: 18),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 28),

          // Referral card (share app + earn 500 XP)
          GlassCard(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(color: AppColorsDark.purple.withValues(alpha: 0.15), shape: BoxShape.circle),
                      child: const Icon(Icons.favorite_rounded, color: AppColorsDark.purple, size: 20),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Invite Family & Friends', style: AppTypography.h3(color: Colors.white)),
                          const SizedBox(height: 2),
                          Text('Share native store token link to earn lifetime rewards.', style: AppTypography.labelSm(color: AppColorsDark.textSecondary)),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColorsDark.purple,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  icon: const Icon(Icons.share_rounded, size: 18),
                  label: const Text('Share App Link  →  Claim +500 XP', style: TextStyle(fontWeight: FontWeight.bold)),
                  onPressed: _triggerReferralBonus,
                ),
              ],
            ),
          ),
          const SizedBox(height: 48),
        ],
      ),
    );
  }

  Widget _buildDoshaLegendItem(String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(width: 10, height: 10, decoration: BoxDecoration(shape: BoxShape.circle, color: color)),
        const SizedBox(width: 6),
        Text(label, style: AppTypography.labelSm(color: AppColorsDark.textSecondary)),
      ],
    );
  }

  Widget _buildEditableRow({
    required String label,
    required String value,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: AppTypography.labelSm(color: AppColorsDark.textSecondary)),
            Row(
              children: [
                Text(value, style: AppTypography.labelLg(color: Colors.white).copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(width: 8),
                const Icon(Icons.edit_rounded, size: 14, color: AppColorsDark.textMuted),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
