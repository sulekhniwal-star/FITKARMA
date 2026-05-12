import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../shared/widgets/scaffold_patterns.dart';
import '../../shared/widgets/bento_card.dart';
import '../../shared/widgets/pro_gate.dart';
import 'wedding_providers.dart';

class WeddingScreen extends StatelessWidget {
  const WeddingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Fulfills the explicit [ProGate wrapper] requirement
    return const ProGate(
      featureName: 'Bridal & Groom Timeline Architect',
      child: _WeddingContentScreen(),
    );
  }
}

class _WeddingContentScreen extends ConsumerWidget {
  const _WeddingContentScreen();

  Future<void> _pickNewDate(BuildContext context, WidgetRef ref, DateTime current) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: current,
      firstDate: DateTime.now().subtract(const Duration(days: 10)),
      lastDate: DateTime.now().add(const Duration(days: 730)),
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: const ColorScheme.dark(
              primary: AppColorsDark.accent,
              onPrimary: Colors.black,
              surface: AppColorsDark.surface1,
              onSurface: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      ref.read(weddingPlannerProvider.notifier).updateWeddingDate(picked);
    }
  }

  String _formatDate(DateTime d) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${d.day} ${months[d.month - 1]}, ${d.year}';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(weddingPlannerProvider);
    final notifier = ref.read(weddingPlannerProvider.notifier);

    return AppScaffold.patternB(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
          onPressed: () => context.pop(),
        ),
        title: Text('Wedding Preparation', style: AppTypography.h2(color: Colors.white)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_calendar_rounded, color: AppColorsDark.accent),
            tooltip: 'Adjust Wedding Date',
            onPressed: () => _pickNewDate(context, ref, state.weddingDate),
          ),
        ],
      ),
      heroGradient: const LinearGradient(
        colors: [AppColorsDark.accent, AppColorsDark.secondary],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      hero: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 12),
          Text(
            '${state.daysRemaining}',
            style: AppTypography.heroDisplay(color: Colors.black).copyWith(fontSize: 72, height: 1.0),
          ),
          Text(
            'Days Remaining',
            style: AppTypography.h3(color: Colors.black.withOpacity(0.7)),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(color: Colors.black.withOpacity(0.15), borderRadius: BorderRadius.circular(100)),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.favorite_rounded, color: Colors.black, size: 16),
                const SizedBox(width: 6),
                Text(
                  'Target: ${_formatDate(state.weddingDate)}',
                  style: AppTypography.labelSm(color: Colors.black).copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 16),

          // Customised fitness milestones for wedding timeline
          Row(
            children: [
              const Icon(Icons.timeline_rounded, color: AppColorsDark.accent, size: 20),
              const SizedBox(width: 8),
              Text('Milestone Targets', style: AppTypography.h3(color: Colors.white)),
            ],
          ),
          const SizedBox(height: 4),
          Text('Tailored physical checkpoints advancing naturally toward final countdown dates.', style: AppTypography.labelSm(color: AppColorsDark.textSecondary)),
          const SizedBox(height: 12),

          Column(
            children: state.milestones.map((m) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: GlassCard(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      InkWell(
                        onTap: () => notifier.toggleMilestone(m.title),
                        borderRadius: BorderRadius.circular(8),
                        child: Container(
                          width: 24,
                          height: 24,
                          margin: const EdgeInsets.only(top: 2),
                          decoration: BoxDecoration(
                            color: m.isCompleted ? AppColorsDark.accent : AppColorsDark.surface2,
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(color: m.isCompleted ? AppColorsDark.accent : AppColorsDark.textMuted),
                          ),
                          child: m.isCompleted ? const Icon(Icons.check_rounded, color: Colors.black, size: 16) : null,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    m.title,
                                    style: AppTypography.labelLg(color: Colors.white).copyWith(
                                      fontWeight: FontWeight.bold,
                                      decoration: m.isCompleted ? TextDecoration.lineThrough : null,
                                      color: m.isCompleted ? AppColorsDark.textMuted : Colors.white,
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                  decoration: BoxDecoration(color: AppColorsDark.surface2, borderRadius: BorderRadius.circular(4)),
                                  child: Text(
                                    '${m.targetDaysOut}d Out',
                                    style: AppTypography.labelSm(color: AppColorsDark.accent).copyWith(fontSize: 10),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(m.description, style: AppTypography.bodySm(color: m.isCompleted ? AppColorsDark.textMuted : AppColorsDark.textSecondary)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 28),

          // Special meal plan suggestions
          Row(
            children: [
              const Icon(Icons.restaurant_rounded, color: AppColorsDark.secondary, size: 20),
              const SizedBox(width: 8),
              Text('Bridal Nutrition Blueprint', style: AppTypography.h3(color: Colors.white)),
            ],
          ),
          const SizedBox(height: 4),
          Text('Curated traditional dietary arrays generating luminous skin texture and optimal anti-puffing properties.', style: AppTypography.labelSm(color: AppColorsDark.textSecondary)),
          const SizedBox(height: 12),

          Column(
            children: state.mealPlans.map((plan) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: GlassCard(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(plan.phaseName, style: AppTypography.labelLg(color: AppColorsDark.secondary).copyWith(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Text('Focal Core: ', style: AppTypography.labelSm(color: AppColorsDark.textMuted).copyWith(fontSize: 10)),
                          Expanded(child: Text(plan.focalNutrients, style: AppTypography.monoMd(color: Colors.white).copyWith(fontSize: 11))),
                        ],
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 8),
                        child: Divider(color: AppColorsDark.divider, height: 1),
                      ),
                      Text(plan.suggestions, style: AppTypography.bodySm(color: AppColorsDark.textSecondary)),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 48),
        ],
      ),
    );
  }
}
