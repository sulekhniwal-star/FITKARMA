import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/database/app_database.dart';
import '../../shared/widgets/scaffold_patterns.dart';
import '../../shared/widgets/glowing_metric.dart';
import '../../shared/widgets/encryption_badge.dart';
import '../../shared/widgets/bento_card.dart';
import '../../core/security/security_service.dart';
import 'glucose_providers.dart';
import 'widgets/log_glucose_sheet.dart';

class GlucoseScreen extends ConsumerWidget {
  const GlucoseScreen({super.key});

  void _openLogSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const Padding(
        padding: EdgeInsets.only(top: 40.0),
        child: LogGlucoseSheet(),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final readingsAsync = ref.watch(glucoseReadingsStreamProvider);
    final metadataMap = ref.watch(glucoseMetadataCacheProvider);

    // Auto-load metadata into cache when new readings stream in
    ref.listen(glucoseReadingsStreamProvider, (prev, next) {
      next.whenData((readings) {
        ref.read(glucoseMetadataCacheProvider.notifier).loadForReadings(readings);
      });
    });

    final readings = readingsAsync.value ?? [];
    final latest = readings.isNotEmpty ? readings.first : null;
    final classification = latest != null
        ? GlucoseClassification.classify(latest.value, latest.timing)
        : GlucoseClassification.normal;

    return SensitiveScreenGuard(
      screenName: 'Blood Glucose Records',
      child: AppScaffold.patternB(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
            onPressed: () => context.pop(),
          ),
          title: Text('Blood Glucose', style: AppTypography.h2(color: Colors.white)),
          centerTitle: true,
        ),
        heroGradient: const LinearGradient(
          colors: [Color(0xFF130F25), Color(0xFF2E1E50)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        hero: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 12),
            // Glowing Metric
            GlowingMetric(
              value: latest != null ? latest.value.toInt().toString() : '--',
              unit: latest != null ? 'mg/dL' : null,
              textStyle: AppTypography.metricXL().copyWith(fontSize: 64),
              glowColor: latest != null ? classification.glowColor : AppColorsDark.accentGlow,
            ),
            const SizedBox(height: 16),
            
            // Context Timing Text
            if (latest != null)
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    _getTimingIcon(latest.timing),
                    color: AppColorsDark.textSecondary,
                    size: 16,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    latest.timing.toUpperCase(),
                    style: AppTypography.monoLg(color: AppColorsDark.textSecondary),
                  ),
                ],
              ),
            const SizedBox(height: 16),

            // Classification Chip
            if (latest != null)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                decoration: BoxDecoration(
                  color: classification.color.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(100),
                  border: Border.all(color: classification.color.withValues(alpha: 0.3)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: classification.color,
                        boxShadow: [
                          BoxShadow(
                            color: classification.color.withValues(alpha: 0.5),
                            blurRadius: 6,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      classification.label,
                      style: AppTypography.labelLg(color: classification.color).copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              )
            else
              Text(
                'No recorded readings',
                style: AppTypography.labelMd(color: AppColorsDark.textMuted),
              ),
          ],
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 24),
            
            // Log Reading Button CTA
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColorsDark.accent,
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                elevation: 4,
              ),
              icon: const Icon(Icons.add_rounded, size: 22, color: Colors.black),
              label: Text(
                'Log Reading',
                style: AppTypography.labelLg(color: Colors.black).copyWith(fontWeight: FontWeight.bold),
              ),
              onPressed: () => _openLogSheet(context),
            ),
            const SizedBox(height: 24),

            // 7-Day LineChart
            readingsAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => Center(
                child: Text('Error loading chart', style: AppTypography.bodySm(color: AppColorsDark.rose)),
              ),
              data: (data) => _buildChart(data),
            ),
            const SizedBox(height: 28),

            // Reading History List
            Text('Reading History', style: AppTypography.h2(color: Colors.white)),
            const SizedBox(height: 12),

            readingsAsync.when(
              loading: () => const Center(child: Padding(
                padding: EdgeInsets.all(20.0),
                child: CircularProgressIndicator(),
              )),
              error: (err, stack) => const SizedBox(),
              data: (data) {
                if (data.isEmpty) {
                  return GlassCard(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 24.0),
                      child: Column(
                        children: [
                          const Icon(Icons.water_drop_outlined, size: 48, color: AppColorsDark.surface2),
                          const SizedBox(height: 12),
                          Text(
                            'Your offline log is empty',
                            style: AppTypography.bodyMd(color: AppColorsDark.textSecondary),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                return ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.zero,
                  itemCount: data.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final item = data[index];
                    final meta = metadataMap[item.id] ?? {};
                    final itemClass = GlucoseClassification.classify(item.value, item.timing);
                    final notes = meta['notes'];
                    final linkedFood = meta['linkedFood'];

                    return GlassCard(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.baseline,
                                textBaseline: TextBaseline.alphabetic,
                                children: [
                                  Text(
                                    item.value.toInt().toString(),
                                    style: AppTypography.metricLg(color: Colors.white).copyWith(fontSize: 28),
                                  ),
                                  const SizedBox(width: 4),
                                  Text('mg/dL', style: AppTypography.labelSm(color: AppColorsDark.textMuted)),
                                ],
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: itemClass.color.withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  itemClass.label,
                                  style: AppTypography.labelSm(color: itemClass.color).copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Icon(_getTimingIcon(item.timing), size: 14, color: AppColorsDark.accent.withValues(alpha: 0.8)),
                              const SizedBox(width: 4),
                              Text(
                                item.timing.toUpperCase(),
                                style: AppTypography.labelSm(color: AppColorsDark.textSecondary),
                              ),
                              const Spacer(),
                              Text(
                                DateFormat('MMM d, h:mm a').format(item.measuredAt),
                                style: AppTypography.labelSm(color: AppColorsDark.textMuted),
                              ),
                            ],
                          ),

                          // Linked food chip
                          if (linkedFood != null && linkedFood.isNotEmpty) ...[
                            const SizedBox(height: 10),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppColorsDark.teal.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(color: AppColorsDark.teal.withValues(alpha: 0.2)),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.link_rounded, size: 12, color: AppColorsDark.teal),
                                  const SizedBox(width: 4),
                                  Flexible(
                                    child: Text(
                                      linkedFood,
                                      style: AppTypography.labelSm(color: AppColorsDark.teal),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],

                          // Notes
                          if (notes != null && notes.isNotEmpty) ...[
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 8.0),
                              child: Divider(color: AppColorsDark.divider, height: 1),
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Icon(Icons.notes_rounded, size: 14, color: AppColorsDark.textMuted),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: Text(
                                    notes,
                                    style: AppTypography.bodySm(color: AppColorsDark.textSecondary),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ],
                      ),
                    );
                  },
                );
              },
            ),
            const SizedBox(height: 36),

            // Encryption Badge
            const Center(child: EncryptionBadge()),
            const SizedBox(height: 48),
          ],
        ),
      ),
    );
  }

  IconData _getTimingIcon(String timing) {
    switch (timing.toLowerCase()) {
      case 'fasting': return Icons.wb_twilight_rounded;
      case 'post-meal': return Icons.restaurant_rounded;
      case 'bedtime': return Icons.bedtime_rounded;
      default: return Icons.shuffle_rounded;
    }
  }

  Widget _buildChart(List<GlucoseReading> readings) {
    final now = DateTime.now();
    final sevenDaysAgo = now.subtract(const Duration(days: 7));
    final recentReadings = readings.where((r) => r.measuredAt.isAfter(sevenDaysAgo)).toList();

    if (recentReadings.isEmpty) {
      return const GlassCard(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Text(
            'No logged glucose readings in the past 7 days to display trends.',
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColorsDark.textMuted),
          ),
        ),
      );
    }

    final sorted = List<GlucoseReading>.from(recentReadings)..sort((a, b) => a.measuredAt.compareTo(b.measuredAt));
    final spots = <FlSpot>[];

    for (int i = 0; i < sorted.length; i++) {
      spots.add(FlSpot(i.toDouble(), sorted[i].value));
    }

    double minY = 40;
    double maxY = 220;
    for (final r in sorted) {
      if (r.value - 20 < minY) minY = r.value - 20;
      if (r.value + 30 > maxY) maxY = r.value + 30;
    }

    return GlassCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('7-Day Concentration Trends', style: AppTypography.h3(color: Colors.white)),
              Row(
                children: [
                  Container(width: 8, height: 8, decoration: const BoxDecoration(shape: BoxShape.circle, color: AppColorsDark.accent)),
                  const SizedBox(width: 4),
                  Text('Glucose', style: AppTypography.labelSm(color: AppColorsDark.textSecondary)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 180,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: 40,
                  getDrawingHorizontalLine: (value) => FlLine(
                    color: AppColorsDark.divider,
                    strokeWidth: 1,
                    dashArray: [4, 4],
                  ),
                ),
                // Add clinical reference ranges
                extraLinesData: ExtraLinesData(
                  horizontalLines: [
                    HorizontalLine(
                      y: 70,
                      color: AppColorsDark.purple.withValues(alpha: 0.5),
                      strokeWidth: 1.5,
                      dashArray: [6, 4],
                      label: HorizontalLineLabel(
                        show: true,
                        alignment: Alignment.topRight,
                        padding: const EdgeInsets.only(right: 4, bottom: 2),
                        style: AppTypography.labelSm(color: AppColorsDark.purple),
                        labelResolver: (_) => 'Low Target (70)',
                      ),
                    ),
                    HorizontalLine(
                      y: 140,
                      color: AppColorsDark.teal.withValues(alpha: 0.5),
                      strokeWidth: 1.5,
                      dashArray: [6, 4],
                      label: HorizontalLineLabel(
                        show: true,
                        alignment: Alignment.topRight,
                        padding: const EdgeInsets.only(right: 4, bottom: 2),
                        style: AppTypography.labelSm(color: AppColorsDark.teal),
                        labelResolver: (_) => 'High Target (140)',
                      ),
                    ),
                  ],
                ),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 36,
                      interval: 40,
                      getTitlesWidget: (value, meta) => Text(
                        value.toInt().toString(),
                        style: AppTypography.labelSm(color: AppColorsDark.textMuted),
                      ),
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 1,
                      getTitlesWidget: (value, meta) {
                        final index = value.toInt();
                        if (index < 0 || index >= sorted.length) return const SizedBox();
                        return Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            DateFormat('E').format(sorted[index].measuredAt),
                            style: AppTypography.labelSm(color: AppColorsDark.textMuted),
                          ),
                        );
                      },
                    ),
                  ),
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                borderData: FlBorderData(show: false),
                minY: minY,
                maxY: maxY,
                lineBarsData: [
                  LineChartBarData(
                    spots: spots,
                    isCurved: true,
                    color: AppColorsDark.accent,
                    barWidth: 3,
                    isStrokeCapRound: true,
                    dotData: FlDotData(
                      show: true,
                      getDotPainter: (spot, percent, barData, index) {
                        // Highlight out of bound spots with their classification color
                        final item = sorted[index];
                        final classification = GlucoseClassification.classify(item.value, item.timing);
                        return FlDotCirclePainter(
                          radius: 4,
                          color: classification.color,
                          strokeWidth: 2,
                          strokeColor: AppColorsDark.surface0,
                        );
                      },
                    ),
                    belowBarData: BarAreaData(
                      show: true,
                      color: AppColorsDark.accent.withValues(alpha: 0.1),
                    ),
                  ),
                ],
                lineTouchData: LineTouchData(
                  touchTooltipData: LineTouchTooltipData(
                    getTooltipColor: (spot) => AppColorsDark.surface1,
                    getTooltipItems: (touchedSpots) {
                      return touchedSpots.map((spot) {
                        return LineTooltipItem(
                          '${spot.y.toInt()} mg/dL',
                          AppTypography.monoMd(color: AppColorsDark.accent).copyWith(fontWeight: FontWeight.bold),
                        );
                      }).toList();
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
