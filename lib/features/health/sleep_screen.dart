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
import 'sleep_providers.dart';
import 'widgets/log_sleep_sheet.dart';

class SleepScreen extends ConsumerWidget {
  const SleepScreen({super.key});

  void _openLogSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const Padding(
        padding: EdgeInsets.only(top: 40.0),
        child: LogSleepSheet(),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final logsAsync = ref.watch(sleepLogsStreamProvider);
    final metadataMap = ref.watch(sleepMetadataCacheProvider);

    // Auto-load auxiliary sleep stages and biomarkers when logs stream in
    ref.listen(sleepLogsStreamProvider, (prev, next) {
      next.whenData((logs) {
        ref.read(sleepMetadataCacheProvider.notifier).loadForLogs(logs);
      });
    });

    final logs = logsAsync.value ?? [];
    final latest = logs.isNotEmpty ? logs.first : null;
    final latestMeta = latest != null ? metadataMap[latest.id] ?? {} : {};

    // Calculate core display bounds
    String heroDurationStr = '7h 24m'; // Fallback demo metric as requested
    int qualityScore = 85;

    if (latest != null) {
      final diff = latest.endTime.difference(latest.startTime);
      final hrs = diff.inHours;
      final mins = diff.inMinutes % 60;
      heroDurationStr = '${hrs}h ${mins}m';
      qualityScore = latest.quality * 10; // map 1-10 slider to 10-100 score
    }

    // Stages breakdown
    final Map<String, int> stages = (latestMeta['stagesMinutes'] as Map<String, int>?) ?? {
      'rem': 95,
      'deep': 85,
      'light': 240,
      'awake': 24,
    };

    final int spO2 = (latestMeta['spO2'] as int?) ?? 97;
    final int hr = (latestMeta['heartRate'] as int?) ?? 58;

    return AppScaffold.patternB(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
          onPressed: () => context.pop(),
        ),
        title: Text('Sleep Recovery', style: AppTypography.h2(color: Colors.white)),
        centerTitle: true,
      ),
      heroGradient: const LinearGradient(
        colors: [AppColorsDark.heroSleepStart, AppColorsDark.heroSleepMid, AppColorsDark.heroSleepEnd],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ),
      hero: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 12),
          // Glowing Metric Focal Duration Display
          GlowingMetric(
            value: heroDurationStr,
            textStyle: AppTypography.metricXL().copyWith(fontSize: 56),
            glowColor: AppColorsDark.purple.withValues(alpha: 0.4),
          ),
          const SizedBox(height: 8),

          // Sleep Score MonoLg
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.auto_awesome_rounded, color: AppColorsDark.purple, size: 18),
              const SizedBox(width: 8),
              Text(
                'Sleep Score: $qualityScore',
                style: AppTypography.monoLg(color: AppColorsDark.textSecondary),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Context label tag
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
            decoration: BoxDecoration(
              color: AppColorsDark.surface1.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(100),
              border: Border.all(color: AppColorsDark.surface2),
            ),
            child: Text(
              latest != null ? 'Synchronized Offline Entry' : 'Demonstration Baseline',
              style: AppTypography.labelSm(color: AppColorsDark.textMuted),
            ),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 24),

          // Log Recovery CTA Button
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColorsDark.purple,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              elevation: 4,
            ),
            icon: const Icon(Icons.add_rounded, size: 22),
            label: Text('Log Recovery Session', style: AppTypography.labelLg(color: Colors.white)),
            onPressed: () => _openLogSheet(context),
          ),
          const SizedBox(height: 24),

          // Bedtime + Wake Time Cards Row
          Row(
            children: [
              Expanded(
                child: GlassCard(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.bedtime_rounded, size: 16, color: AppColorsDark.purple),
                          const SizedBox(width: 6),
                          Text('Bedtime', style: AppTypography.labelSm(color: AppColorsDark.textSecondary)),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        latest != null ? DateFormat('h:mm a').format(latest.startTime) : '10:30 PM',
                        style: AppTypography.metricLg(color: Colors.white).copyWith(fontSize: 24),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: GlassCard(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.wb_sunny_rounded, size: 16, color: AppColorsDark.accent),
                          const SizedBox(width: 6),
                          Text('Wake Time', style: AppTypography.labelSm(color: AppColorsDark.textSecondary)),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        latest != null ? DateFormat('h:mm a').format(latest.endTime) : '6:30 AM',
                        style: AppTypography.metricLg(color: Colors.white).copyWith(fontSize: 24),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Biomarkers Row: Avg SpO2 + Avg Heart Rate
          Row(
            children: [
              Expanded(
                child: GlassCard(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Avg SpO2', style: AppTypography.labelSm(color: AppColorsDark.textMuted)),
                      const SizedBox(height: 4),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Text('$spO2', style: AppTypography.h2(color: AppColorsDark.teal)),
                          const SizedBox(width: 2),
                          Text('%', style: AppTypography.labelSm(color: AppColorsDark.textMuted)),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: GlassCard(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Resting HR', style: AppTypography.labelSm(color: AppColorsDark.textMuted)),
                      const SizedBox(height: 4),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Text('$hr', style: AppTypography.h2(color: AppColorsDark.rose)),
                          const SizedBox(width: 2),
                          Text('bpm', style: AppTypography.labelSm(color: AppColorsDark.textMuted)),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Sleep Stages Chart Bento (REM/deep/light/awake)
          Text('Hypnogram Stages Breakdown', style: AppTypography.h3(color: Colors.white)),
          const SizedBox(height: 12),
          _buildStagesCard(stages),
          
          const SizedBox(height: 28),

          // 7-Day Trend Chart
          Text('7-Day Rest Duration Trend', style: AppTypography.h3(color: Colors.white)),
          const SizedBox(height: 12),
          logsAsync.when(
            loading: () => const Center(child: Padding(padding: EdgeInsets.all(20), child: CircularProgressIndicator())),
            error: (err, stack) => const SizedBox(),
            data: (data) => _build7DayChart(data),
          ),
          
          const SizedBox(height: 28),

          // Reading History List
          if (logs.isNotEmpty) ...[
            Text('Recorded Logs Feed', style: AppTypography.h3(color: Colors.white)),
            const SizedBox(height: 12),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsets.zero,
              itemCount: logs.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final item = logs[index];
                final meta = metadataMap[item.id] ?? {};
                final duration = item.endTime.difference(item.startTime);
                final notes = meta['notes'];

                return GlassCard(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${duration.inHours}h ${duration.inMinutes % 60}m',
                            style: AppTypography.metricLg(color: Colors.white).copyWith(fontSize: 22),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: AppColorsDark.purple.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              'Score: ${item.quality * 10}',
                              style: AppTypography.labelSm(color: AppColorsDark.purple),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.bedtime_rounded, size: 12, color: AppColorsDark.textMuted),
                          const SizedBox(width: 4),
                          Text(
                            DateFormat('MMM d, h:mm a').format(item.startTime),
                            style: AppTypography.labelSm(color: AppColorsDark.textSecondary),
                          ),
                          const Text('  →  ', style: TextStyle(color: AppColorsDark.textMuted)),
                          Text(
                            DateFormat('h:mm a').format(item.endTime),
                            style: AppTypography.labelSm(color: AppColorsDark.textSecondary),
                          ),
                        ],
                      ),
                      if (notes != null && notes.isNotEmpty) ...[
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 8.0),
                          child: Divider(color: AppColorsDark.divider, height: 1),
                        ),
                        Text(notes, style: AppTypography.bodySm(color: AppColorsDark.textSecondary)),
                      ],
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: 36),
          ],

          // Encryption Badge
          const Center(child: EncryptionBadge()),
          const SizedBox(height: 48),
        ],
      ),
    );
  }

  Widget _buildStagesCard(Map<String, int> stages) {
    final int rem = stages['rem'] ?? 0;
    final int deep = stages['deep'] ?? 0;
    final int light = stages['light'] ?? 0;
    final int awake = stages['awake'] ?? 0;

    final int total = rem + deep + light + awake;
    final totalSafe = total > 0 ? total : 1;

    return GlassCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Stacked Progress Bar representation
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: SizedBox(
              height: 16,
              child: Row(
                children: [
                  _buildStageFlexSegment(deep, totalSafe, AppColorsDark.secondary),
                  _buildStageFlexSegment(rem, totalSafe, AppColorsDark.purple),
                  _buildStageFlexSegment(light, totalSafe, AppColorsDark.teal),
                  _buildStageFlexSegment(awake, totalSafe, AppColorsDark.accent),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Categories Breakdowns Legend
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildStageLegendItem('Deep', deep, totalSafe, AppColorsDark.secondary),
              _buildStageLegendItem('REM', rem, totalSafe, AppColorsDark.purple),
              _buildStageLegendItem('Light', light, totalSafe, AppColorsDark.teal),
              _buildStageLegendItem('Awake', awake, totalSafe, AppColorsDark.accent),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStageFlexSegment(int value, int total, Color color) {
    if (value <= 0) return const SizedBox();
    return Expanded(
      flex: value,
      child: Container(color: color),
    );
  }

  Widget _buildStageLegendItem(String title, int minutes, int total, Color color) {
    final pct = ((minutes / total) * 100).round();
    final hrs = minutes ~/ 60;
    final mins = minutes % 60;
    final timeStr = hrs > 0 ? '${hrs}h ${mins}m' : '${mins}m';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(width: 8, height: 8, decoration: BoxDecoration(shape: BoxShape.circle, color: color)),
            const SizedBox(width: 4),
            Text(title, style: AppTypography.labelSm(color: AppColorsDark.textSecondary)),
          ],
        ),
        const SizedBox(height: 2),
        Text('$pct%', style: AppTypography.metricLg(color: Colors.white).copyWith(fontSize: 16)),
        Text(timeStr, style: AppTypography.labelSm(color: AppColorsDark.textMuted)),
      ],
    );
  }

  Widget _build7DayChart(List<SleepLog> logs) {
    // Generate simulated baseline points if array short
    final List<double> hours = [];
    if (logs.isEmpty) {
      hours.addAll([7.5, 6.8, 8.1, 7.2, 6.5, 7.4, 7.4]);
    } else {
      // Map valid offline entries
      final recent = logs.take(7).toList()..sort((a, b) => a.startTime.compareTo(b.startTime));
      for (final l in recent) {
        hours.add(l.endTime.difference(l.startTime).inMinutes / 60.0);
      }
      // Fill gaps if less than 7 points available
      while (hours.length < 7) {
        hours.insert(0, 7.2);
      }
    }

    final spots = <FlSpot>[];
    for (int i = 0; i < hours.length; i++) {
      spots.add(FlSpot(i.toDouble(), hours[i]));
    }

    return GlassCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Session Durations', style: AppTypography.labelSm(color: AppColorsDark.textSecondary)),
              Text('Target: 8h', style: AppTypography.labelSm(color: AppColorsDark.purple)),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 140,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: 2,
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
                      reservedSize: 28,
                      interval: 2,
                      getTitlesWidget: (value, meta) => Text(
                        '${value.toInt()}h',
                        style: AppTypography.labelSm(color: AppColorsDark.textMuted),
                      ),
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 1,
                      getTitlesWidget: (value, meta) {
                        final daysAgo = 6 - value.toInt();
                        final dt = DateTime.now().subtract(Duration(days: daysAgo));
                        return Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            DateFormat('E').format(dt),
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
                minY: 4,
                maxY: 10,
                lineBarsData: [
                  LineChartBarData(
                    spots: spots,
                    isCurved: true,
                    color: AppColorsDark.purple,
                    barWidth: 3,
                    isStrokeCapRound: true,
                    dotData: FlDotData(
                      show: true,
                      getDotPainter: (spot, percent, barData, index) => FlDotCirclePainter(
                        radius: 4,
                        color: AppColorsDark.purple,
                        strokeWidth: 2,
                        strokeColor: AppColorsDark.surface0,
                      ),
                    ),
                    belowBarData: BarAreaData(
                      show: true,
                      color: AppColorsDark.purple.withValues(alpha: 0.15),
                    ),
                  ),
                ],
                lineTouchData: LineTouchData(
                  touchTooltipData: LineTouchTooltipData(
                    getTooltipColor: (spot) => AppColorsDark.surface1,
                    getTooltipItems: (touchedSpots) {
                      return touchedSpots.map((spot) {
                        final hrs = spot.y.floor();
                        final mins = ((spot.y - hrs) * 60).round();
                        return LineTooltipItem(
                          '${hrs}h ${mins}m',
                          AppTypography.labelSm(color: AppColorsDark.purple).copyWith(fontWeight: FontWeight.bold),
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
