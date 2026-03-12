import 'package:flutter/material.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/theme/app_text_styles.dart';
import '../../../shared/widgets/section_header.dart';
import '../../../shared/widgets/shimmer_loader.dart';
import '../domain/bp_log_model.dart';

class BloodPressureScreen extends StatefulWidget {
  const BloodPressureScreen({super.key});

  @override
  State<BloodPressureScreen> createState() => _BloodPressureScreenState();
}

class _BloodPressureScreenState extends State<BloodPressureScreen> {
  // Mock data for demonstration
  final List<BloodPressureLog> _logs = [
    BloodPressureLog(
      id: '1',
      userId: 'user1',
      systolic: 118,
      diastolic: 78,
      pulse: 72,
      loggedAt: DateTime.now().subtract(const Duration(hours: 2)),
    ),
    BloodPressureLog(
      id: '2',
      userId: 'user1',
      systolic: 122,
      diastolic: 82,
      pulse: 75,
      loggedAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
    BloodPressureLog(
      id: '3',
      userId: 'user1',
      systolic: 128,
      diastolic: 85,
      pulse: 78,
      loggedAt: DateTime.now().subtract(const Duration(days: 2)),
    ),
    BloodPressureLog(
      id: '4',
      userId: 'user1',
      systolic: 115,
      diastolic: 76,
      pulse: 70,
      loggedAt: DateTime.now().subtract(const Duration(days: 3)),
    ),
  ];

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.rose,
        foregroundColor: AppColors.white,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Blood Pressure'),
            Text(
              'ब्लड प्रेशर',
              style: AppTextStyles.caption.copyWith(color: AppColors.white70),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () => _showHistorySheet(context),
          ),
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
                  // Latest Reading Card
                  _buildLatestReadingCard(),
                  const SizedBox(height: 20),

                  // Quick Log Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () => _showAddBPSheet(context),
                      icon: const Icon(Icons.add),
                      label: const Text('Log Reading'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.rose,
                        foregroundColor: AppColors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Trend Section
                  const SectionHeader(
                    englishTitle: 'Trend',
                    hindiSubtitle: 'रुझान',
                  ),
                  const SizedBox(height: 12),
                  _buildTrendChart(),
                  const SizedBox(height: 24),

                  // Recent Logs
                  const SectionHeader(
                    englishTitle: 'Recent Readings',
                    hindiSubtitle: 'हाल की रीडिंग',
                  ),
                  const SizedBox(height: 12),
                  _buildRecentLogs(),
                  const SizedBox(height: 24),

                  // Info Card
                  _buildInfoCard(),
                  const SizedBox(height: 100),
                ],
              ),
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddBPSheet(context),
        backgroundColor: AppColors.rose,
        foregroundColor: AppColors.white,
        icon: const Icon(Icons.add),
        label: const Text('Log BP'),
      ),
    );
  }

  Widget _buildLatestReadingCard() {
    final latest = _logs.isNotEmpty ? _logs.first : null;
    final classification = latest != null
        ? _classifyBP(latest.systolic, latest.diastolic)
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
              : [AppColors.rose, AppColors.rose.withValues(alpha: 0.7)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.rose.withValues(alpha: 0.3),
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
                  latest != null ? _formatDate(latest.loggedAt) : 'No data',
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
                  '${latest.systolic}',
                  style: const TextStyle(
                    color: AppColors.white,
                    fontSize: 56,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  ' / ',
                  style: TextStyle(color: AppColors.white70, fontSize: 32),
                ),
                Text(
                  '${latest.diastolic}',
                  style: const TextStyle(
                    color: AppColors.white,
                    fontSize: 56,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 8),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(
                    'mmHg',
                    style: TextStyle(
                      color: AppColors.white.withValues(alpha: 0.8),
                      fontSize: 16,
                    ),
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
                Icons.favorite,
                color: AppColors.white.withValues(alpha: 0.8),
                size: 18,
              ),
              const SizedBox(width: 6),
              Text(
                latest != null ? '${latest.pulse} bpm' : '--',
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
              Row(
                children: [
                  _buildLegendItem('Systolic', AppColors.rose),
                  const SizedBox(width: 12),
                  _buildLegendItem('Diastolic', AppColors.teal),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: CustomPaint(
              size: const Size(double.infinity, 120),
              painter: _BPLineChartPainter(logs: _logs.reversed.toList()),
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
        final classification = _classifyBP(log.systolic, log.diastolic);
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
                      '${log.systolic}/${log.diastolic} mmHg',
                      style: AppTextStyles.bodyLarge.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _formatDate(log.loggedAt),
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
                  Row(
                    children: [
                      Icon(
                        Icons.favorite,
                        size: 14,
                        color: AppColors.textSecondary,
                      ),
                      const SizedBox(width: 4),
                      Text('${log.pulse} bpm', style: AppTextStyles.caption),
                    ],
                  ),
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
                'Understanding BP Readings',
                style: AppTextStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildBPRow('Normal', '< 120 / 80', AppColors.success),
          _buildBPRow('Elevated', '120-129 / < 80', AppColors.warning),
          _buildBPRow('High (Stage 1)', '130-139 / 80-89', AppColors.warning),
          _buildBPRow('High (Stage 2)', '≥ 140 / ≥ 90', AppColors.error),
          _buildBPRow('Crisis', '> 180 / > 120', AppColors.error),
        ],
      ),
    );
  }

  Widget _buildBPRow(String label, String range, Color color) {
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

  void _showAddBPSheet(BuildContext context) {
    int systolic = 120;
    int diastolic = 80;
    int pulse = 72;

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
                Text('Log Blood Pressure', style: AppTextStyles.h3),
                const SizedBox(height: 24),

                // Systolic
                Text('Systolic (mmHg)', style: AppTextStyles.labelLarge),
                const SizedBox(height: 8),
                Row(
                  children: [
                    IconButton(
                      onPressed: () => setModalState(() {
                        if (systolic > 60) systolic--;
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
                          child: Text('$systolic', style: AppTextStyles.h2),
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () => setModalState(() {
                        if (systolic < 250) systolic++;
                      }),
                      icon: const Icon(Icons.add_circle_outline),
                      color: AppColors.primary,
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Diastolic
                Text('Diastolic (mmHg)', style: AppTextStyles.labelLarge),
                const SizedBox(height: 8),
                Row(
                  children: [
                    IconButton(
                      onPressed: () => setModalState(() {
                        if (diastolic > 40) diastolic--;
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
                          child: Text('$diastolic', style: AppTextStyles.h2),
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () => setModalState(() {
                        if (diastolic < 150) diastolic++;
                      }),
                      icon: const Icon(Icons.add_circle_outline),
                      color: AppColors.primary,
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Pulse
                Text('Pulse (bpm) - Optional', style: AppTextStyles.labelLarge),
                const SizedBox(height: 8),
                Row(
                  children: [
                    IconButton(
                      onPressed: () => setModalState(() {
                        if (pulse > 40) pulse--;
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
                          child: Text('$pulse', style: AppTextStyles.h2),
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () => setModalState(() {
                        if (pulse < 200) pulse++;
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
                      // Save logic would go here
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('BP reading logged! +5 XP'),
                          backgroundColor: AppColors.success,
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.rose,
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

  void _showHistorySheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        decoration: const BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('All Readings', style: AppTextStyles.h3),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _logs.length,
                itemBuilder: (context, index) {
                  final log = _logs[index];
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: _classifyBP(
                        log.systolic,
                        log.diastolic,
                      ).color.withValues(alpha: 0.1),
                      child: Icon(
                        Icons.favorite,
                        color: _classifyBP(log.systolic, log.diastolic).color,
                      ),
                    ),
                    title: Text('${log.systolic}/${log.diastolic} mmHg'),
                    subtitle: Text(_formatDate(log.loggedAt)),
                    trailing: Text('${log.pulse} bpm'),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  _BPClassification _classifyBP(int systolic, int diastolic) {
    if (systolic >= 180 || diastolic >= 120) {
      return _BPClassification('Crisis', AppColors.error);
    }
    if (systolic >= 140 || diastolic >= 90) {
      return _BPClassification('High', AppColors.error);
    }
    if (systolic >= 130 || diastolic >= 80) {
      return _BPClassification('Elevated', AppColors.warning);
    }
    if (systolic >= 120 && diastolic < 80) {
      return _BPClassification('Normal', AppColors.success);
    }
    return _BPClassification('Normal', AppColors.success);
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

class _BPClassification {
  final String label;
  final Color color;

  _BPClassification(this.label, this.color);
}

class _BPLineChartPainter extends CustomPainter {
  final List<BloodPressureLog> logs;

  _BPLineChartPainter({required this.logs});

  @override
  void paint(Canvas canvas, Size size) {
    if (logs.isEmpty) return;

    final systolicPaint = Paint()
      ..color = AppColors.rose
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final diastolicPaint = Paint()
      ..color = AppColors.teal
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final gridPaint = Paint()
      ..color = AppColors.divider
      ..strokeWidth = 1;

    // Draw grid lines
    for (int i = 0; i <= 4; i++) {
      final y = size.height * i / 4;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    // Find min/max values
    int minSys = logs.map((l) => l.systolic).reduce((a, b) => a < b ? a : b);
    int maxSys = logs.map((l) => l.systolic).reduce((a, b) => a > b ? a : b);
    int minDia = logs.map((l) => l.diastolic).reduce((a, b) => a < b ? a : b);
    int maxDia = logs.map((l) => l.diastolic).reduce((a, b) => a > b ? a : b);

    final minVal = (minDia - 10).clamp(40, 200);
    final maxVal = (maxSys + 10).clamp(100, 250);

    // Draw lines
    final systolicPath = Path();
    final diastolicPath = Path();

    for (int i = 0; i < logs.length; i++) {
      final x = size.width * i / (logs.length - 1);
      final sysY =
          size.height -
          ((logs[i].systolic - minVal) / (maxVal - minVal) * size.height);
      final diaY =
          size.height -
          ((logs[i].diastolic - minVal) / (maxVal - minVal) * size.height);

      if (i == 0) {
        systolicPath.moveTo(x, sysY);
        diastolicPath.moveTo(x, diaY);
      } else {
        systolicPath.lineTo(x, sysY);
        diastolicPath.lineTo(x, diaY);
      }
    }

    canvas.drawPath(systolicPath, systolicPaint);
    canvas.drawPath(diastolicPath, diastolicPaint);

    // Draw dots
    for (int i = 0; i < logs.length; i++) {
      final x = size.width * i / (logs.length - 1);
      final sysY =
          size.height -
          ((logs[i].systolic - minVal) / (maxVal - minVal) * size.height);
      final diaY =
          size.height -
          ((logs[i].diastolic - minVal) / (maxVal - minVal) * size.height);

      canvas.drawCircle(Offset(x, sysY), 4, Paint()..color = AppColors.rose);
      canvas.drawCircle(Offset(x, diaY), 4, Paint()..color = AppColors.teal);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
