import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/theme/app_text_styles.dart';
import '../../../shared/widgets/section_header.dart';
import '../../../shared/widgets/shimmer_loader.dart';
import '../../../shared/widgets/error_empty_states.dart';
import '../domain/body_measurement_model.dart';
import '../data/body_metrics_repository.dart';

/// Body metrics screen - displays body measurements and trends
class BodyMetricsScreen extends ConsumerStatefulWidget {
  const BodyMetricsScreen({super.key});

  @override
  ConsumerState<BodyMetricsScreen> createState() => _BodyMetricsScreenState();
}

class _BodyMetricsScreenState extends ConsumerState<BodyMetricsScreen> {
  int _selectedDays = 30;

  @override
  Widget build(BuildContext context) {
    final repository = ref.watch(bodyMetricsRepositoryProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => context.pop(),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Body Metrics',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            Text(
              'शारीरिक माप',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
      body: FutureBuilder<List<BodyMeasurement>>(
        future: repository.getAll(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const ShimmerLoader(
              child: Center(child: CircularProgressIndicator()),
            );
          }

          if (snapshot.hasError) {
            return FKErrorWidget(
              message: 'Failed to load body metrics',
              onRetry: () => setState(() {}),
            );
          }

          final measurements = snapshot.data ?? [];

          if (measurements.isEmpty) {
            return EmptyState(
              emoji: '📏',
              title: 'No Measurements Yet',
              subtitle: 'Start tracking your body measurements to see trends',
              ctaText: 'Add Measurement',
              onCtaPressed: () => context.push('/body-metrics/add'),
            );
          }

          final latest = measurements.first;
          final weightTrend = measurements
              .where((m) => m.weightKg != null)
              .take(_selectedDays)
              .toList();

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Current Stats Cards
              _buildCurrentStats(latest),

              const SizedBox(height: 24),

              // BMI Card
              _buildBmiCard(latest),

              const SizedBox(height: 24),

              // Body Composition
              const SectionHeader(
                englishTitle: 'Body Composition',
                hindiSubtitle: 'शरीर संरचना',
              ),
              _buildBodyComposition(latest),

              const SizedBox(height: 24),

              // Weight Trend Chart Section
              SectionHeader(
                englishTitle: 'Weight Trend',
                hindiSubtitle: 'वजन रुझान',
                trailing: _buildTimeRangeSelector(),
              ),
              _buildWeightChart(weightTrend),

              const SizedBox(height: 24),

              // Measurement History
              const SectionHeader(
                englishTitle: 'History',
                hindiSubtitle: 'इतिहास',
              ),
              ...measurements
                  .take(5)
                  .map(
                    (m) => _MeasurementHistoryCard(
                      measurement: m,
                      onTap: () => context.push('/body-metrics/${m.id}'),
                    ),
                  ),

              const SizedBox(height: 100),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/body-metrics/add'),
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('Add', style: TextStyle(color: Colors.white)),
      ),
    );
  }

  Widget _buildCurrentStats(BodyMeasurement measurement) {
    return Row(
      children: [
        Expanded(
          child: _StatCard(
            title: 'Weight',
            titleHi: 'वजन',
            value: measurement.weightKg != null
                ? '${measurement.weightKg!.toStringAsFixed(1)} kg'
                : '--',
            icon: Icons.monitor_weight,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _StatCard(
            title: 'BMI',
            titleHi: 'BMI',
            value: measurement.bmi?.toStringAsFixed(1) ?? '--',
            subtitle: measurement.bmiCategory,
            icon: Icons.analytics,
            color: _getBmiColor(measurement.bmi),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _StatCard(
            title: 'Body Fat',
            titleHi: 'शरीर में वसा',
            value: measurement.bodyFatPct != null
                ? '${measurement.bodyFatPct!.toStringAsFixed(1)}%'
                : '--',
            icon: Icons.percent,
            color: AppColors.teal,
          ),
        ),
      ],
    );
  }

  Widget _buildBmiCard(BodyMeasurement measurement) {
    final bmi = measurement.bmi;
    if (bmi == null) return const SizedBox.shrink();

    final color = _getBmiColor(bmi);
    final category = measurement.bmiCategory ?? 'Unknown';

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.analytics, color: color),
                const SizedBox(width: 8),
                Text('BMI Analysis', style: AppTextStyles.h4),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        bmi.toStringAsFixed(1),
                        style: AppTextStyles.displayMedium.copyWith(
                          color: color,
                        ),
                      ),
                      Text(
                        category,
                        style: AppTextStyles.bodyMedium.copyWith(color: color),
                      ),
                    ],
                  ),
                ),
                _buildBmiIndicator(bmi),
              ],
            ),
            const SizedBox(height: 12),
            _buildBmiScale(),
          ],
        ),
      ),
    );
  }

  Widget _buildBmiIndicator(double bmi) {
    return SizedBox(
      width: 60,
      height: 60,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CircularProgressIndicator(
            value: (bmi / 40).clamp(0, 1),
            backgroundColor: AppColors.divider,
            valueColor: AlwaysStoppedAnimation(_getBmiColor(bmi)),
            strokeWidth: 6,
          ),
          Text('${bmi.toInt()}', style: AppTextStyles.h4),
        ],
      ),
    );
  }

  Widget _buildBmiScale() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _bmiLabel('Underweight', '<18.5', AppColors.teal),
            _bmiLabel('Normal', '18.5-25', AppColors.success),
            _bmiLabel('Overweight', '25-30', AppColors.accent),
            _bmiLabel('Obese', '>30', AppColors.error),
          ],
        ),
        const SizedBox(height: 4),
        Container(
          height: 8,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            gradient: const LinearGradient(
              colors: [
                AppColors.teal,
                AppColors.success,
                AppColors.accent,
                AppColors.error,
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _bmiLabel(String label, String range, Color color) {
    return Column(
      children: [
        Text(label, style: AppTextStyles.caption.copyWith(fontSize: 10)),
        Text(
          range,
          style: AppTextStyles.caption.copyWith(fontSize: 8, color: color),
        ),
      ],
    );
  }

  Widget _buildBodyComposition(BodyMeasurement measurement) {
    final measurements = [
      {
        'label': 'Waist',
        'labelHi': 'कमर',
        'value': measurement.waistCm,
        'unit': 'cm',
      },
      {
        'label': 'Hips',
        'labelHi': 'कूल्हे',
        'value': measurement.hipsCm,
        'unit': 'cm',
      },
      {
        'label': 'Chest',
        'labelHi': 'छाती',
        'value': measurement.chestCm,
        'unit': 'cm',
      },
      {
        'label': 'Arms',
        'labelHi': 'बाहें',
        'value': measurement.armsCm,
        'unit': 'cm',
      },
      {
        'label': 'Thighs',
        'labelHi': 'जांघें',
        'value': measurement.thighsCm,
        'unit': 'cm',
      },
    ];

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Wrap(
          spacing: 16,
          runSpacing: 16,
          children: measurements.map((m) {
            final value = m['value'] as double?;
            return SizedBox(
              width: 100,
              child: Column(
                children: [
                  Text(m['label'] as String, style: AppTextStyles.caption),
                  Text(
                    m['labelHi'] as String,
                    style: AppTextStyles.caption.copyWith(
                      fontSize: 10,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value != null
                        ? '${value.toStringAsFixed(1)} ${m['unit']}'
                        : '--',
                    style: AppTextStyles.h4.copyWith(color: AppColors.primary),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildTimeRangeSelector() {
    return DropdownButton<int>(
      value: _selectedDays,
      underline: const SizedBox(),
      items: const [
        DropdownMenuItem(value: 7, child: Text('7 days')),
        DropdownMenuItem(value: 30, child: Text('30 days')),
        DropdownMenuItem(value: 90, child: Text('90 days')),
        DropdownMenuItem(value: 180, child: Text('180 days')),
      ],
      onChanged: (value) {
        if (value != null) {
          setState(() => _selectedDays = value);
        }
      },
    );
  }

  Widget _buildWeightChart(List<BodyMeasurement> measurements) {
    if (measurements.isEmpty) {
      return Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: const Padding(
          padding: EdgeInsets.all(32),
          child: Center(child: Text('No weight data in selected period')),
        ),
      );
    }

    // Simple visualization of weight trend
    final minWeight = measurements
        .map((m) => m.weightKg!)
        .reduce((a, b) => a < b ? a : b);
    final maxWeight = measurements
        .map((m) => m.weightKg!)
        .reduce((a, b) => a > b ? a : b);
    final range = maxWeight - minWeight;

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${measurements.length} entries',
                  style: AppTextStyles.caption,
                ),
                Text(
                  '${minWeight.toStringAsFixed(1)} - ${maxWeight.toStringAsFixed(1)} kg',
                  style: AppTextStyles.caption,
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 100,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: measurements.map((m) {
                  final height = range > 0
                      ? ((m.weightKg! - minWeight) / range * 80).clamp(
                          10.0,
                          80.0,
                        )
                      : 40.0;
                  return Expanded(
                    child: Container(
                      height: height,
                      margin: const EdgeInsets.symmetric(horizontal: 1),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getBmiColor(double? bmi) {
    if (bmi == null) return AppColors.textSecondary;
    if (bmi < 18.5) return AppColors.teal;
    if (bmi < 25) return AppColors.success;
    if (bmi < 30) return AppColors.accent;
    return AppColors.error;
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String titleHi;
  final String value;
  final String? subtitle;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.title,
    required this.titleHi,
    required this.value,
    this.subtitle,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 8),
            Text(value, style: AppTextStyles.h4.copyWith(color: color)),
            Text(title, style: AppTextStyles.caption),
            Text(
              titleHi,
              style: AppTextStyles.caption.copyWith(
                fontSize: 9,
                color: AppColors.textSecondary,
              ),
            ),
            if (subtitle != null)
              Text(
                subtitle!,
                style: AppTextStyles.caption.copyWith(
                  fontSize: 10,
                  color: color,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _MeasurementHistoryCard extends StatelessWidget {
  final BodyMeasurement measurement;
  final VoidCallback onTap;

  const _MeasurementHistoryCard({
    required this.measurement,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        onTap: onTap,
        leading: const CircleAvatar(
          backgroundColor: AppColors.primarySurface,
          child: Icon(Icons.calendar_today, color: AppColors.primary),
        ),
        title: Text(
          '${measurement.date.day}/${measurement.date.month}/${measurement.date.year}',
          style: AppTextStyles.bodyMedium,
        ),
        subtitle: Text(
          [
            if (measurement.weightKg != null)
              '${measurement.weightKg!.toStringAsFixed(1)} kg',
            if (measurement.waistCm != null)
              'Waist: ${measurement.waistCm!.toStringAsFixed(1)} cm',
          ].join(' • '),
          style: AppTextStyles.caption,
        ),
        trailing: const Icon(
          Icons.chevron_right,
          color: AppColors.textSecondary,
        ),
      ),
    );
  }
}
