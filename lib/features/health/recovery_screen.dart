import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import '../../core/database/app_database.dart';
import '../../shared/widgets/readiness_ring.dart';
import 'readiness_provider.dart';
import 'readiness_engine.dart';
import 'morning_checkin_sheet.dart';

class RecoveryScreen extends ConsumerWidget {
  const RecoveryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final readinessAsync = ref.watch(readinessStateProvider);
    final historyAsync = ref.watch(readinessHistoryProvider);

    return Scaffold(
      backgroundColor: AppColorsDark.bg0,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColorsDark.textPrimary),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Recovery & Readiness',
          style: AppTypography.h2(color: AppColorsDark.textPrimary),
        ),
      ),
      body: readinessAsync.when(
        loading: () => const Center(child: CircularProgressIndicator(color: AppColorsDark.primary)),
        error: (e, _) => Center(child: Text('Error: $e', style: AppTypography.bodyMd(color: AppColorsDark.error))),
        data: (log) {
          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenH),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 16),
                if (log != null) ...[
                  // If checked in, show readiness ring and recovery factors
                  Center(
                    child: ReadinessRing(
                      score: log.score,
                      color: ReadinessEngine.calculate(
                        sleepMinutes: log.sleepMinutes ?? 480,
                        sleepQuality: log.sleepQuality ?? 7,
                        sorenessLevel: log.sorenessLevel ?? 3,
                        stressLevel: log.stressLevel ?? 3,
                        energyLevel: log.energyLevel ?? 7,
                      ).color,
                      size: 160,
                    ),
                  ),
                  const SizedBox(height: 24),
                  _buildRecoveryDetails(context, log),
                ] else ...[
                  // If not checked in, show morning check-in request card
                  const SizedBox(height: 40),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: AppColorsDark.surface1,
                      borderRadius: BorderRadius.circular(AppRadius.lg),
                      border: Border.all(color: AppColorsDark.glassBorder),
                    ),
                    child: Column(
                      children: [
                        const Icon(Icons.favorite_border, color: AppColorsDark.rose, size: 48),
                        const SizedBox(height: 16),
                        Text(
                          'No Readiness Data Today',
                          style: AppTypography.h2(color: AppColorsDark.textPrimary),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Tell us how you are feeling to calculate today\'s recovery levels and get tailored training guidelines.',
                          textAlign: TextAlign.center,
                          style: AppTypography.bodyMd(color: AppColorsDark.textSecondary),
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton(
                          onPressed: () => _openCheckInSheet(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColorsDark.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(AppRadius.md),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                          ),
                          child: const Text('Start Morning Check-In', style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                  ),
                ],
                const SizedBox(height: 32),
                _buildReadinessHistory(context, historyAsync),
                const SizedBox(height: 40),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildRecoveryDetails(BuildContext context, ReadinessLog log) {
    // Determine values to show
    final double sleepHrs = (log.sleepMinutes ?? 0) / 60.0;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Recovery Recommendation',
          style: AppTypography.h3(color: AppColorsDark.textPrimary),
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColorsDark.surface1,
            borderRadius: BorderRadius.circular(AppRadius.md),
            border: Border.all(color: AppColorsDark.glassBorder),
          ),
          child: Text(
            log.recommendation ?? 'No recommendations logged.',
            style: AppTypography.bodyMd(color: AppColorsDark.textSecondary),
          ),
        ),
        const SizedBox(height: 24),
        Text(
          'Subjective Factors',
          style: AppTypography.h3(color: AppColorsDark.textPrimary),
        ),
        const SizedBox(height: 12),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 1.6,
          children: [
            _buildFactorCard('Sleep Duration', '${sleepHrs.toStringAsFixed(1)} hrs', Icons.bedtime, AppColorsDark.teal),
            _buildFactorCard('Sleep Quality', '${log.sleepQuality ?? 0}/10', Icons.star, AppColorsDark.success),
            _buildFactorCard('Soreness', '${log.sorenessLevel ?? 0}/10', Icons.healing, AppColorsDark.rose),
            _buildFactorCard('Energy Level', '${log.energyLevel ?? 0}/10', Icons.bolt, AppColorsDark.accent),
            _buildFactorCard('Mental Stress', '${log.stressLevel ?? 0}/10', Icons.psychology, Colors.purpleAccent),
            _buildFactorCard('Resting HR', log.restingHr != null ? '${log.restingHr} bpm' : '--', Icons.favorite, Colors.redAccent),
          ],
        ),
      ],
    );
  }

  Widget _buildFactorCard(String title, String value, IconData icon, Color color) {
    return Container(
      decoration: BoxDecoration(
        color: AppColorsDark.surface1,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: AppColorsDark.glassBorder),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: AppTypography.labelSm(color: AppColorsDark.textSecondary),
              ),
              Icon(icon, color: color, size: 18),
            ],
          ),
          Text(
            value,
            style: AppTypography.h2(color: AppColorsDark.textPrimary),
          ),
        ],
      ),
    );
  }

  Widget _buildReadinessHistory(BuildContext context, AsyncValue<List<ReadinessLog>> historyAsync) {
    return historyAsync.when(
      loading: () => const SizedBox(),
      error: (_, _) => const SizedBox(),
      data: (history) {
        if (history.isEmpty) return const SizedBox();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Readiness History',
              style: AppTypography.h3(color: AppColorsDark.textPrimary),
            ),
            const SizedBox(height: 12),
            Container(
              decoration: BoxDecoration(
                color: AppColorsDark.surface1,
                borderRadius: BorderRadius.circular(AppRadius.md),
                border: Border.all(color: AppColorsDark.glassBorder),
              ),
              child: ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: history.length,
                separatorBuilder: (c, i) => const Divider(color: AppColorsDark.divider, height: 1),
                itemBuilder: (c, i) {
                  final item = history[i];
                  final dateStr = '${item.loggedAt.day}/${item.loggedAt.month}';
                  
                  Color color = AppColorsDark.teal;
                  if (item.score >= 85) color = Colors.green;
                  if (item.score < 50) color = Colors.orange;
                  if (item.score < 30) color = Colors.red;

                  return Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          dateStr,
                          style: AppTypography.bodyMd(color: AppColorsDark.textSecondary),
                        ),
                        Text(
                          item.zone.toUpperCase(),
                          style: AppTypography.labelSm(color: color).copyWith(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '${item.score}',
                          style: AppTypography.h3(color: color),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  void _openCheckInSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const MorningCheckInSheet(),
    );
  }
}
