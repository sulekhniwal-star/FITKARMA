import 'package:flutter/material.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/theme/app_text_styles.dart';
import '../../../shared/widgets/section_header.dart';
import '../../../shared/widgets/shimmer_loader.dart';

class GlucoseScreen extends StatefulWidget {
  const GlucoseScreen({super.key});

  @override
  State<GlucoseScreen> createState() => _GlucoseScreenState();
}

class _GlucoseScreenState extends State<GlucoseScreen> {
  // Mock data
  final List<_GlucoseLog> _logs = [
    _GlucoseLog(
      id: '1',
      glucose: 95,
      readingType: 'fasting',
      loggedAt: DateTime.now().subtract(const Duration(hours: 2)),
    ),
    _GlucoseLog(
      id: '2',
      glucose: 142,
      readingType: 'post_meal',
      loggedAt: DateTime.now().subtract(const Duration(hours: 6)),
    ),
    _GlucoseLog(
      id: '3',
      glucose: 110,
      readingType: 'fasting',
      loggedAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
    _GlucoseLog(
      id: '4',
      glucose: 130,
      readingType: 'post_meal',
      loggedAt: DateTime.now().subtract(const Duration(days: 1, hours: 6)),
    ),
    _GlucoseLog(
      id: '5',
      glucose: 105,
      readingType: 'bedtime',
      loggedAt: DateTime.now().subtract(const Duration(days: 2)),
    ),
  ];

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.teal,
        foregroundColor: AppColors.white,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Blood Glucose'),
            Text(
              'ग्लूकोज',
              style: AppTextStyles.caption.copyWith(color: AppColors.white70),
            ),
          ],
        ),
        actions: [
          IconButton(icon: const Icon(Icons.history), onPressed: () {}),
        ],
      ),
      body: _isLoading
          ? const ShimmerLoader(
              child: Center(child: CircularProgressIndicator()),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildLatestReadingCard(),
                  const SizedBox(height: 20),
                  _buildQuickLogButton(),
                  const SizedBox(height: 24),
                  const SectionHeader(
                    englishTitle: 'Trend',
                    hindiSubtitle: 'रुझान',
                  ),
                  const SizedBox(height: 12),
                  _buildTrendChart(),
                  const SizedBox(height: 24),
                  const SectionHeader(
                    englishTitle: 'Recent Readings',
                    hindiSubtitle: 'हाल की रीडिंग',
                  ),
                  const SizedBox(height: 12),
                  _buildRecentLogs(),
                  const SizedBox(height: 24),
                  _buildInfoCard(),
                  const SizedBox(height: 100),
                ],
              ),
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddGlucoseSheet(context),
        backgroundColor: AppColors.teal,
        foregroundColor: AppColors.white,
        icon: const Icon(Icons.add),
        label: const Text('Log Glucose'),
      ),
    );
  }

  Widget _buildLatestReadingCard() {
    final latest = _logs.isNotEmpty ? _logs.first : null;
    final classification = latest != null
        ? _classifyGlucose(latest.glucose, latest.readingType)
        : null;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: classification?.color != null
              ? [
                  classification!.color!,
                  classification.color!.withValues(alpha: 0.7),
                ]
              : [AppColors.teal, AppColors.teal.withValues(alpha: 0.7)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.teal.withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Latest Reading',
                style: TextStyle(color: AppColors.white70, fontSize: 14),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: AppColors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  latest != null
                      ? _getReadingTypeLabel(latest.readingType)
                      : 'No data',
                  style: const TextStyle(color: AppColors.white, fontSize: 12),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (latest != null)
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${latest.glucose}',
                  style: const TextStyle(
                    color: AppColors.white,
                    fontSize: 56,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(bottom: 8, left: 4),
                  child: Text(
                    'mg/dL',
                    style: TextStyle(color: AppColors.white70, fontSize: 20),
                  ),
                ),
              ],
            )
          else
            const Text(
              'No readings yet',
              style: TextStyle(color: AppColors.white, fontSize: 24),
            ),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(
                Icons.access_time,
                color: AppColors.white.withValues(alpha: 0.8),
                size: 18,
              ),
              const SizedBox(width: 6),
              Text(
                latest != null ? _formatDate(latest.loggedAt) : '--',
                style: TextStyle(
                  color: AppColors.white.withValues(alpha: 0.8),
                  fontSize: 16,
                ),
              ),
              const Spacer(),
              if (classification != null)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    classification.label,
                    style: const TextStyle(
                      color: AppColors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickLogButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () => _showAddGlucoseSheet(context),
        icon: const Icon(Icons.add),
        label: const Text('Log Reading'),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.teal,
          foregroundColor: AppColors.white,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  Widget _buildTrendChart() {
    return Container(
      height: 200,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Last 7 Days',
                style: AppTextStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              _buildLegendItem('Glucose', AppColors.teal),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: CustomPaint(
              size: const Size(double.infinity, 120),
              painter: _GlucoseChartPainter(logs: _logs.reversed.toList()),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 3,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 4),
        Text(label, style: AppTextStyles.caption),
      ],
    );
  }

  Widget _buildRecentLogs() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _logs.length,
      itemBuilder: (context, index) {
        final log = _logs[index];
        final classification = _classifyGlucose(log.glucose, log.readingType);
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.03),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 4,
                height: 50,
                decoration: BoxDecoration(
                  color: classification.color,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${log.glucose} mg/dL',
                      style: AppTextStyles.bodyLarge.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _getReadingTypeLabel(log.readingType),
                      style: AppTextStyles.caption,
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: classification.color.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      classification.label,
                      style: AppTextStyles.caption.copyWith(
                        color: classification.color,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(_formatDate(log.loggedAt), style: AppTextStyles.caption),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildInfoCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.info_outline,
                color: AppColors.textSecondary,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'Understanding Glucose Readings',
                style: AppTextStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildGlucoseRow(
            'Normal (Fasting)',
            '< 100 mg/dL',
            AppColors.success,
          ),
          _buildGlucoseRow(
            'Prediabetic (Fasting)',
            '100-125 mg/dL',
            AppColors.warning,
          ),
          _buildGlucoseRow(
            'Diabetic (Fasting)',
            '≥ 126 mg/dL',
            AppColors.error,
          ),
          const Divider(),
          _buildGlucoseRow(
            'Normal (Post-meal)',
            '< 140 mg/dL',
            AppColors.success,
          ),
          _buildGlucoseRow(
            'Prediabetic (Post-meal)',
            '140-199 mg/dL',
            AppColors.warning,
          ),
          _buildGlucoseRow(
            'Diabetic (Post-meal)',
            '≥ 200 mg/dL',
            AppColors.error,
          ),
        ],
      ),
    );
  }

  Widget _buildGlucoseRow(String label, String range, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: AppTextStyles.bodySmall.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
          const Spacer(),
          Text(range, style: AppTextStyles.caption.copyWith(color: color)),
        ],
      ),
    );
  }

  void _showAddGlucoseSheet(BuildContext context) {
    int glucose = 100;
    String readingType = 'fasting';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Container(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          decoration: const BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppColors.divider,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text('Log Blood Glucose', style: AppTextStyles.h3),
                const SizedBox(height: 24),

                // Reading Type
                Text('Reading Type', style: AppTextStyles.labelLarge),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: [
                    _buildTypeChip(
                      'Fasting',
                      'fasting',
                      readingType,
                      (v) => setModalState(() => readingType = v),
                    ),
                    _buildTypeChip(
                      'Post-Meal',
                      'post_meal',
                      readingType,
                      (v) => setModalState(() => readingType = v),
                    ),
                    _buildTypeChip(
                      'Random',
                      'random',
                      readingType,
                      (v) => setModalState(() => readingType = v),
                    ),
                    _buildTypeChip(
                      'Bedtime',
                      'bedtime',
                      readingType,
                      (v) => setModalState(() => readingType = v),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Glucose Value
                Text('Glucose (mg/dL)', style: AppTextStyles.labelLarge),
                const SizedBox(height: 8),
                Row(
                  children: [
                    IconButton(
                      onPressed: () => setModalState(() {
                        if (glucose > 20) glucose -= 1;
                      }),
                      icon: const Icon(Icons.remove_circle_outline),
                      color: AppColors.primary,
                    ),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceVariant,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: Text('$glucose', style: AppTextStyles.h2),
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () => setModalState(() {
                        if (glucose < 600) glucose += 1;
                      }),
                      icon: const Icon(Icons.add_circle_outline),
                      color: AppColors.primary,
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Save Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Glucose reading logged! +5 XP'),
                          backgroundColor: AppColors.success,
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.teal,
                      foregroundColor: AppColors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Save Reading'),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTypeChip(
    String label,
    String value,
    String selected,
    Function(String) onTap,
  ) {
    final isSelected = value == selected;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (_) => onTap(value),
      selectedColor: AppColors.teal.withValues(alpha: 0.2),
      labelStyle: TextStyle(
        color: isSelected ? AppColors.teal : AppColors.textSecondary,
        fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
      ),
    );
  }

  _GlucoseClassification _classifyGlucose(double value, String type) {
    if (type == 'fasting') {
      if (value >= 126)
        return _GlucoseClassification('Diabetic', AppColors.error);
      if (value >= 100)
        return _GlucoseClassification('Prediabetic', AppColors.warning);
      return _GlucoseClassification('Normal', AppColors.success);
    } else if (type == 'post_meal') {
      if (value >= 200)
        return _GlucoseClassification('Diabetic', AppColors.error);
      if (value >= 140)
        return _GlucoseClassification('Prediabetic', AppColors.warning);
      return _GlucoseClassification('Normal', AppColors.success);
    } else {
      if (value >= 200) return _GlucoseClassification('High', AppColors.error);
      if (value >= 140)
        return _GlucoseClassification('Elevated', AppColors.warning);
      return _GlucoseClassification('Normal', AppColors.success);
    }
  }

  String _getReadingTypeLabel(String type) {
    switch (type) {
      case 'fasting':
        return 'Fasting';
      case 'post_meal':
        return 'Post-Meal';
      case 'random':
        return 'Random';
      case 'bedtime':
        return 'Bedtime';
      default:
        return type;
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);

    if (diff.inDays == 0) {
      return 'Today ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
    } else if (diff.inDays == 1) {
      return 'Yesterday';
    } else if (diff.inDays < 7) {
      return '${diff.inDays} days ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}

class _GlucoseLog {
  final String id;
  final double glucose;
  final String readingType;
  final DateTime loggedAt;

  _GlucoseLog({
    required this.id,
    required this.glucose,
    required this.readingType,
    required this.loggedAt,
  });
}

class _GlucoseClassification {
  final String label;
  final Color color;

  _GlucoseClassification(this.label, this.color);
}

class _GlucoseChartPainter extends CustomPainter {
  final List<_GlucoseLog> logs;

  _GlucoseChartPainter({required this.logs});

  @override
  void paint(Canvas canvas, Size size) {
    if (logs.isEmpty) return;

    final paint = Paint()
      ..color = AppColors.teal
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final gridPaint = Paint()
      ..color = AppColors.divider
      ..strokeWidth = 1;

    // Draw grid
    for (int i = 0; i <= 4; i++) {
      final y = size.height * i / 4;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    final minVal = 60.0;
    final maxVal = 200.0;

    final path = Path();
    for (int i = 0; i < logs.length; i++) {
      final x = size.width * i / (logs.length - 1).clamp(1, 100);
      final y =
          size.height -
          ((logs[i].glucose - minVal) / (maxVal - minVal) * size.height).clamp(
            0,
            size.height,
          );

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    canvas.drawPath(path, paint);

    // Draw dots
    for (int i = 0; i < logs.length; i++) {
      final x = size.width * i / (logs.length - 1).clamp(1, 100);
      final y =
          size.height -
          ((logs[i].glucose - minVal) / (maxVal - minVal) * size.height).clamp(
            0,
            size.height,
          );
      canvas.drawCircle(Offset(x, y), 4, Paint()..color = AppColors.teal);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
