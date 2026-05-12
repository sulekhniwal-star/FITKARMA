import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../shared/widgets/scaffold_patterns.dart';
import '../../shared/widgets/bento_card.dart';
import 'steps_providers.dart';
import 'widgets/step_arc_painter.dart';

class StepsScreen extends ConsumerWidget {
  const StepsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stepsAsync = ref.watch(stepsDataProvider);

    return AppScaffold.patternC(
      gradient: const LinearGradient(
        colors: [AppColorsDark.heroDeepStart, AppColorsDark.heroDeepEnd],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header Row
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
                  onPressed: () => context.pop(),
                ),
                Text('Daily Steps', style: AppTypography.h2(color: Colors.white)),
                // Refresh/Sensor Toggle Action
                IconButton(
                  icon: const Icon(Icons.refresh_rounded, color: AppColorsDark.textSecondary),
                  tooltip: 'Reload Sensor Logs',
                  onPressed: () => ref.read(stepsDataProvider.notifier).loadData(),
                ),
              ],
            ),
          ),

          // Scrollable Workspace
          Expanded(
            child: stepsAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => Center(
                child: Text('Sensor configuration unavailable', style: AppTypography.bodySm(color: AppColorsDark.rose)),
              ),
              data: (data) => _buildContent(context, ref, data),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context, WidgetRef ref, StepsData data) {
    final progress = data.totalSteps / data.dailyGoal;
    final formattedSteps = NumberFormat('#,###').format(data.totalSteps);

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (data.isUsingSimulatedData) ...[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: AppColorsDark.surface1.withValues(alpha: 0.8),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColorsDark.surface2),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.science_rounded, size: 14, color: AppColorsDark.primary),
                  const SizedBox(width: 8),
                  Text(
                    'Displaying demo metrics (Physical step logs idle)',
                    style: AppTypography.labelSm(color: AppColorsDark.textSecondary),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],

          // Semi-circle Arc containing Hero Step Display
          const SizedBox(height: 20),
          Center(
            child: SizedBox(
              width: 280,
              height: 150, // Height is half of width for semicircle arching up
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  // Progress Arc CustomPainter
                  Positioned.fill(
                    child: CustomPaint(
                      painter: StepArcPainter(
                        progress: progress,
                        fillColor: AppColorsDark.primary,
                        trackColor: AppColorsDark.surface1,
                        strokeWidth: 20,
                      ),
                    ),
                  ),

                  // Center Focal Display
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 10,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.directions_walk_rounded, color: AppColorsDark.primary, size: 28),
                        const SizedBox(height: 4),
                        // heroDisplay step count 72sp, white, glow
                        Text(
                          formattedSteps,
                          style: AppTypography.heroDisplay(color: Colors.white).copyWith(
                            shadows: [
                              const Shadow(
                                color: AppColorsDark.primaryGlow,
                                blurRadius: 20,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Goal: ${NumberFormat('#,###').format(data.dailyGoal)}',
                          style: AppTypography.labelMd(color: AppColorsDark.textSecondary),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 40),

          // Distance + Calories Burned MonoLg Cards Row
          Row(
            children: [
              Expanded(
                child: GlassCard(
                  padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                  child: Column(
                    children: [
                      const Icon(Icons.map_rounded, color: AppColorsDark.teal, size: 24),
                      const SizedBox(height: 8),
                      Text(
                        '${data.distanceKm}',
                        style: AppTypography.monoLg(color: Colors.white).copyWith(fontSize: 28, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 2),
                      Text('Distance (km)', style: AppTypography.labelSm(color: AppColorsDark.textMuted)),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: GlassCard(
                  padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                  child: Column(
                    children: [
                      const Icon(Icons.local_fire_department_rounded, color: AppColorsDark.primary, size: 24),
                      const SizedBox(height: 8),
                      Text(
                        '${data.caloriesBurned}',
                        style: AppTypography.monoLg(color: Colors.white).copyWith(fontSize: 28, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 2),
                      Text('Active Kcal', style: AppTypography.labelSm(color: AppColorsDark.textMuted)),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 28),

          // Hourly Bar Chart (last 12h)
          Text('Hourly Activity (Last 12h)', style: AppTypography.h3(color: Colors.white)),
          const SizedBox(height: 16),
          _buildHourlyChart(data.hourlySteps12h),
          
          const SizedBox(height: 24),
          // Native integration summary card
          GlassCard(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                const Icon(Icons.sync_rounded, color: AppColorsDark.textSecondary, size: 24),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Health Connect / HealthKit', style: AppTypography.labelLg(color: Colors.white)),
                      const SizedBox(height: 2),
                      Text(
                        'Continuous background read sync is managed seamlessly via OS permissions.',
                        style: AppTypography.labelSm(color: AppColorsDark.textMuted),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 48),
        ],
      ),
    );
  }

  Widget _buildHourlyChart(List<int> hourly) {
    double maxVal = 200;
    for (final v in hourly) {
      if (v > maxVal) maxVal = v.toDouble();
    }
    // Round max up slightly for headroom
    final maxY = maxVal * 1.15;

    final now = DateTime.now();

    return GlassCard(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
      child: SizedBox(
        height: 180,
        child: BarChart(
          BarChartData(
            gridData: FlGridData(
              show: true,
              drawVerticalLine: false,
              horizontalInterval: (maxY / 3).ceilToDouble(),
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
                  interval: (maxY / 3).ceilToDouble(),
                  getTitlesWidget: (value, meta) {
                    if (value == 0) return const SizedBox();
                    return Text(
                      value.toInt().toString(),
                      style: AppTypography.labelSm(color: AppColorsDark.textMuted),
                    );
                  },
                ),
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  interval: 1,
                  getTitlesWidget: (value, meta) {
                    final index = value.toInt();
                    if (index < 0 || index >= hourly.length) return const SizedBox();
                    
                    // Show hour label every 3 bars to prevent X-axis clutter
                    if (index % 3 != 0 && index != hourly.length - 1) return const SizedBox();

                    final hoursAgo = 11 - index;
                    final targetTime = now.subtract(Duration(hours: hoursAgo));
                    
                    return Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        DateFormat('ha').format(targetTime).toLowerCase(),
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
            maxY: maxY,
            barGroups: hourly.asMap().entries.map((e) {
              final val = e.value.toDouble();
              return BarChartGroupData(
                x: e.key,
                barRods: [
                  BarChartRodData(
                    toY: val,
                    color: val > 0 ? AppColorsDark.primary : AppColorsDark.surface2,
                    width: 12,
                    borderRadius: BorderRadius.circular(6),
                    backDrawRodData: BackgroundBarChartRodData(
                      show: true,
                      toY: maxY,
                      color: AppColorsDark.surface1,
                    ),
                  ),
                ],
              );
            }).toList(),
            barTouchData: BarTouchData(
              touchTooltipData: BarTouchTooltipData(
                getTooltipColor: (group) => AppColorsDark.surface1,
                getTooltipItem: (group, groupIndex, rod, rodIndex) {
                  return BarTooltipItem(
                    '${rod.toY.toInt()} steps',
                    AppTypography.labelSm(color: AppColorsDark.primary).copyWith(fontWeight: FontWeight.bold),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
