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
import 'bp_providers.dart';
import 'widgets/log_bp_sheet.dart';

class BloodPressureScreen extends ConsumerWidget {
  const BloodPressureScreen({super.key});

  void _openLogSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const Padding(
        padding: EdgeInsets.only(top: 40.0),
        child: LogBpSheet(),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final readingsAsync = ref.watch(bpReadingsStreamProvider);
    final metadataMap = ref.watch(bpMetadataCacheProvider);

    // Auto-load metadata into cache when new readings stream in
    ref.listen(bpReadingsStreamProvider, (prev, next) {
      next.whenData((readings) {
        ref.read(bpMetadataCacheProvider.notifier).loadForReadings(readings);
      });
    });

    final readings = readingsAsync.valueOrNull ?? [];
    final latest = readings.isNotEmpty ? readings.first : null;
    final classification = latest != null
        ? BpClassification.classify(latest.systolic, latest.diastolic)
        : BpClassification.normal;

    return AppScaffold.patternB(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
          onPressed: () => context.pop(),
        ),
        title: Text('Blood Pressure', style: AppTypography.h2(color: Colors.white)),
        centerTitle: true,
      ),
      heroGradient: const LinearGradient(
        colors: [AppColorsDark.heroDeepStart, AppColorsDark.heroDeepEnd],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ),
      hero: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 12),
          // Glowing Metric
          GlowingMetric(
            value: latest != null ? '${latest.systolic}/${latest.diastolic}' : '--/--',
            unit: latest != null ? 'mmHg' : null,
            textStyle: AppTypography.metricXL().copyWith(fontSize: 56),
            glowColor: latest != null ? classification.glowColor : AppColorsDark.primaryGlow,
          ),
          const SizedBox(height: 12),
          
          // Pulse MonoLg
          if (latest != null)
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.favorite_rounded, color: AppColorsDark.rose, size: 16),
                const SizedBox(width: 6),
                Text(
                  '${latest.pulse} BPM',
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
                color: classification.color.withOpacity(0.15),
                borderRadius: BorderRadius.circular(100),
                border: Border.all(color: classification.color.withOpacity(0.3)),
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
                          color: classification.color.withOpacity(0.5),
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
              backgroundColor: AppColorsDark.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              elevation: 4,
            ),
            icon: const Icon(Icons.add_rounded, size: 22),
            label: Text('Log Reading', style: AppTypography.labelLg(color: Colors.white)),
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
                        const Icon(Icons.history_rounded, size: 48, color: AppColorsDark.surface2),
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
                  final itemClass = BpClassification.classify(item.systolic, item.diastolic);
                  final arm = meta['arm'] ?? 'Left';
                  final notes = meta['notes'];

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
                                  '${item.systolic}/${item.diastolic}',
                                  style: AppTypography.metricLg(color: Colors.white).copyWith(fontSize: 28),
                                ),
                                const SizedBox(width: 4),
                                Text('mmHg', style: AppTypography.labelSm(color: AppColorsDark.textMuted)),
                              ],
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: itemClass.color.withOpacity(0.15),
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
                            Icon(Icons.favorite_rounded, size: 14, color: AppColorsDark.rose.withOpacity(0.8)),
                            const SizedBox(width: 4),
                            Text('${item.pulse} bpm', style: AppTypography.labelSm(color: AppColorsDark.textSecondary)),
                            const SizedBox(width: 16),
                            Icon(Icons.accessibility_new_rounded, size: 14, color: AppColorsDark.teal.withOpacity(0.8)),
                            const SizedBox(width: 4),
                            Text('$arm Arm', style: AppTypography.labelSm(color: AppColorsDark.textSecondary)),
                            const Spacer(),
                            Text(
                              DateFormat('MMM d, h:mm a').format(item.measuredAt),
                              style: AppTypography.labelSm(color: AppColorsDark.textMuted),
                            ),
                          ],
                        ),
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
    );
  }

  Widget _buildChart(List<BpReading> readings) {
    final now = DateTime.now();
    final sevenDaysAgo = now.subtract(const Duration(days: 7));
    final recentReadings = readings.where((r) => r.measuredAt.isAfter(sevenDaysAgo)).toList();

    if (recentReadings.isEmpty) {
      return const GlassCard(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Text(
            'No logged readings in the past 7 days to generate trends.',
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColorsDark.textMuted),
          ),
        ),
      );
    }

    final sorted = List<BpReading>.from(recentReadings)..sort((a, b) => a.measuredAt.compareTo(b.measuredAt));
    final systolicSpots = <FlSpot>[];
    final diastolicSpots = <FlSpot>[];

    for (int i = 0; i < sorted.length; i++) {
      final r = sorted[i];
      systolicSpots.add(FlSpot(i.toDouble(), r.systolic.toDouble()));
      diastolicSpots.add(FlSpot(i.toDouble(), r.diastolic.toDouble()));
    }

    double minY = 50;
    double maxY = 160;
    for (final r in sorted) {
      if (r.diastolic - 10 < minY) minY = (r.diastolic - 10).toDouble();
      if (r.systolic + 20 > maxY) maxY = (r.systolic + 20).toDouble();
    }

    return GlassCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('7-Day Trends', style: AppTypography.h3(color: Colors.white)),
              Row(
                children: [
                  _buildLegendItem('Systolic', AppColorsDark.primary),
                  const SizedBox(width: 12),
                  _buildLegendItem('Diastolic', AppColorsDark.teal),
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
                  horizontalInterval: 20,
                  getDrawingHorizontalLine: (value) => FlLine(
                    color: AppColorsDark.divider,
                    strokeWidth: 1,
                    dashArray: [4, 4],
                  ),
                ),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 32,
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
                    spots: systolicSpots,
                    isCurved: true,
                    color: AppColorsDark.primary,
                    barWidth: 3,
                    isStrokeCapRound: true,
                    dotData: FlDotData(
                      show: true,
                      getDotPainter: (spot, percent, barData, index) => FlDotCirclePainter(
                        radius: 4,
                        color: AppColorsDark.primary,
                        strokeWidth: 2,
                        strokeColor: AppColorsDark.surface0,
                      ),
                    ),
                    belowBarData: BarAreaData(
                      show: true,
                      color: AppColorsDark.primary.withOpacity(0.1),
                    ),
                  ),
                  LineChartBarData(
                    spots: diastolicSpots,
                    isCurved: true,
                    color: AppColorsDark.teal,
                    barWidth: 3,
                    isStrokeCapRound: true,
                    dotData: FlDotData(
                      show: true,
                      getDotPainter: (spot, percent, barData, index) => FlDotCirclePainter(
                        radius: 4,
                        color: AppColorsDark.teal,
                        strokeWidth: 2,
                        strokeColor: AppColorsDark.surface0,
                      ),
                    ),
                  ),
                ],
                lineTouchData: LineTouchData(
                  touchTooltipData: LineTouchTooltipData(
                    getTooltipColor: (spot) => AppColorsDark.surface1,
                    getTooltipItems: (touchedSpots) {
                      return touchedSpots.map((spot) {
                        return LineTooltipItem(
                          '${spot.y.toInt()} mmHg',
                          AppTypography.monoMd(
                            color: spot.barIndex == 0 ? AppColorsDark.primary : AppColorsDark.teal,
                          ).copyWith(fontWeight: FontWeight.bold),
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

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      children: [
        Container(width: 8, height: 8, decoration: BoxDecoration(shape: BoxShape.circle, color: color)),
        const SizedBox(width: 4),
        Text(label, style: AppTypography.labelSm(color: AppColorsDark.textSecondary)),
      ],
    );
  }
}
