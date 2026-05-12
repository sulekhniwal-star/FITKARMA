import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../shared/widgets/scaffold_patterns.dart';
import '../../shared/widgets/bento_card.dart';
import '../../shared/widgets/bilingual_label.dart';
import 'festival_providers.dart';

class FestivalScreen extends ConsumerWidget {
  const FestivalScreen({super.key});

  String _formatDateShort(DateTime d) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${d.day} ${months[d.month - 1]} ${d.year}';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final listAsync = ref.watch(festivalsListProvider);

    return AppScaffold.patternA(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
          onPressed: () => context.pop(),
        ),
        title: const BilingualLabel(
          english: 'Cultural Health Calendar',
          hindi: 'सांस्कृतिक स्वास्थ्य पंचांग',
          crossAxisAlignment: CrossAxisAlignment.center,
        ),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Guidance context header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColorsDark.accent.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColorsDark.accent.withValues(alpha: 0.3)),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(color: AppColorsDark.accent.withValues(alpha: 0.2), shape: BoxShape.circle),
                  child: const Icon(Icons.celebration_rounded, color: AppColorsDark.accent, size: 24),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Holistic Celebration Guide', style: AppTypography.labelLg(color: Colors.white).copyWith(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 2),
                      Text('Seeded from FitKarma Indian metadata endpoints mapping seasonal custom culinary alternatives.', style: AppTypography.labelSm(color: AppColorsDark.textSecondary)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Core feed container
          listAsync.when(
            loading: () => const Center(child: Padding(padding: EdgeInsets.all(32), child: CircularProgressIndicator(color: AppColorsDark.accent))),
            error: (err, _) => Center(child: Text('Error rendering localized cultural calendar arrays.', style: AppTypography.bodySm(color: AppColorsDark.rose))),
            data: (items) {
              return Column(
                children: items.map((item) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 20.0),
                    child: GlassCard(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Bilingual label header mapping dates
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: BilingualLabel(
                                  english: item.englishName,
                                  hindi: item.hindiName,
                                  color: Colors.white,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(color: AppColorsDark.surface2, borderRadius: BorderRadius.circular(6)),
                                child: Text(_formatDateShort(item.date), style: AppTypography.monoMd(color: AppColorsDark.accent).copyWith(fontSize: 11, fontWeight: FontWeight.bold)),
                              ),
                            ],
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 14),
                            child: Divider(color: AppColorsDark.divider, height: 1),
                          ),

                          // Nutrition advice
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(Icons.restaurant_menu_rounded, color: AppColorsDark.teal, size: 16),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Mindful Nutrition Strategy', style: AppTypography.labelSm(color: AppColorsDark.teal).copyWith(fontSize: 10)),
                                    const SizedBox(height: 2),
                                    Text(item.nutritionTips, style: AppTypography.bodySm(color: Colors.white)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),

                          // Special foods recommendations
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(Icons.local_dining_rounded, color: AppColorsDark.accent, size: 16),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Curated Superfood Substitutes', style: AppTypography.labelSm(color: AppColorsDark.accent).copyWith(fontSize: 10)),
                                    const SizedBox(height: 2),
                                    Text(item.specialFoods, style: AppTypography.bodySm(color: AppColorsDark.textSecondary).copyWith(fontStyle: FontStyle.italic)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),

                          // Activity recommendations
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(Icons.directions_run_rounded, color: AppColorsDark.secondary, size: 16),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Targeted Energy Routines', style: AppTypography.labelSm(color: AppColorsDark.secondary).copyWith(fontSize: 10)),
                                    const SizedBox(height: 2),
                                    Text(item.activityRecommendations, style: AppTypography.bodySm(color: Colors.white)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              );
            },
          ),
          const SizedBox(height: 48),
        ],
      ),
    );
  }
}
