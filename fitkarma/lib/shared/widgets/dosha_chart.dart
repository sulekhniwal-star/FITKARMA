import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

/// Dosha donut chart widget
///
/// Three-segment donut chart showing Vata / Pitta / Kapha percentages
/// Per Section 2.1 Karma & Ayurveda Screen - Dosha Profile card
class DoshaDonutChart extends StatelessWidget {
  /// Vata percentage (0-100)
  final double vataPercentage;

  /// Pitta percentage (0-100)
  final double pittaPercentage;

  /// Kapha percentage (0-100)
  final double kaphaPercentage;

  /// Size of the chart
  final double size;

  /// Center widget (optional)
  final Widget? centerWidget;

  const DoshaDonutChart({
    super.key,
    required this.vataPercentage,
    required this.pittaPercentage,
    required this.kaphaPercentage,
    this.size = 150,
    this.centerWidget,
  });

  /// Factory constructor for common dosha types
  factory DoshaDonutChart.vataPitta({
    double vata = 45,
    double pitta = 35,
    double kapha = 20,
    double size = 150,
  }) {
    return DoshaDonutChart(
      vataPercentage: vata,
      pittaPercentage: pitta,
      kaphaPercentage: kapha,
      size: size,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          PieChart(
            PieChartData(
              sectionsSpace: 2,
              centerSpaceRadius: size * 0.35,
              sections: _buildSections(),
              pieTouchData: PieTouchData(
                touchCallback: (FlTouchEvent event, pieTouchResponse) {},
              ),
            ),
          ),
          if (centerWidget != null) centerWidget!,
        ],
      ),
    );
  }

  List<PieChartSectionData> _buildSections() {
    final total = vataPercentage + pittaPercentage + kaphaPercentage;
    if (total == 0) return [];

    return [
      PieChartSectionData(
        value: vataPercentage,
        color: AppColors.vata,
        title: '${vataPercentage.toInt()}%',
        titleStyle: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
        radius: size * 0.2,
      ),
      PieChartSectionData(
        value: pittaPercentage,
        color: AppColors.pitta,
        title: '${pittaPercentage.toInt()}%',
        titleStyle: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
        radius: size * 0.2,
      ),
      PieChartSectionData(
        value: kaphaPercentage,
        color: AppColors.kapha,
        title: '${kaphaPercentage.toInt()}%',
        titleStyle: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
        radius: size * 0.2,
      ),
    ];
  }
}

/// Dosha legend widget
class DoshaLegend extends StatelessWidget {
  final double vataPercentage;
  final double pittaPercentage;
  final double kaphaPercentage;

  const DoshaLegend({
    super.key,
    required this.vataPercentage,
    required this.pittaPercentage,
    required this.kaphaPercentage,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _LegendItem(
          color: AppColors.vata,
          label: 'Vata',
          percentage: vataPercentage,
        ),
        const SizedBox(height: 8),
        _LegendItem(
          color: AppColors.pitta,
          label: 'Pitta',
          percentage: pittaPercentage,
        ),
        const SizedBox(height: 8),
        _LegendItem(
          color: AppColors.kapha,
          label: 'Kapha',
          percentage: kaphaPercentage,
        ),
      ],
    );
  }
}

/// Legend item
class _LegendItem extends StatelessWidget {
  final Color color;
  final String label;
  final double percentage;

  const _LegendItem({
    required this.color,
    required this.label,
    required this.percentage,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 8),
        Text(label, style: AppTextStyles.bodyMedium),
        const Spacer(),
        Text(
          '${percentage.toInt()}%',
          style: AppTextStyles.labelMedium.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

/// Complete dosha profile card
class DoshaProfileCard extends StatelessWidget {
  final String doshaType;
  final double vataPercentage;
  final double pittaPercentage;
  final double kaphaPercentage;
  final VoidCallback? onViewGuidelines;

  const DoshaProfileCard({
    super.key,
    required this.doshaType,
    required this.vataPercentage,
    required this.pittaPercentage,
    required this.kaphaPercentage,
    this.onViewGuidelines,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColors.cardShadow,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Row(
            children: [
              const Text('🌿 ', style: TextStyle(fontSize: 18)),
              Text(
                'Your Dosha Profile: $doshaType',
                style: AppTextStyles.titleMedium,
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Chart and legend row
          Row(
            children: [
              // Donut chart
              DoshaDonutChart(
                vataPercentage: vataPercentage,
                pittaPercentage: pittaPercentage,
                kaphaPercentage: kaphaPercentage,
                size: 120,
              ),
              const SizedBox(width: 24),
              // Legend
              Expanded(
                child: DoshaLegend(
                  vataPercentage: vataPercentage,
                  pittaPercentage: pittaPercentage,
                  kaphaPercentage: kaphaPercentage,
                ),
              ),
            ],
          ),
          // View guidelines button
          if (onViewGuidelines != null) ...[
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: onViewGuidelines,
                child: const Text('View Seasonal Guidelines (Ritucharya)'),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
