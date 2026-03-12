import 'package:flutter/material.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/theme/app_text_styles.dart';
import '../../../shared/widgets/section_header.dart';
import '../../../shared/widgets/shimmer_loader.dart';

class SleepScreen extends StatefulWidget {
  const SleepScreen({super.key});

  @override
  State<SleepScreen> createState() => _SleepScreenState();
}

class _SleepScreenState extends State<SleepScreen> {
  // Mock data
  final List<_SleepLog> _logs = [
    _SleepLog(
      id: '1',
      bedtime: '22:30',
      wakeTime: '06:15',
      durationMin: 450,
      quality: 4,
      loggedAt: DateTime.now(),
    ),
    _SleepLog(
      id: '2',
      bedtime: '23:00',
      wakeTime: '06:30',
      durationMin: 390,
      quality: 3,
      loggedAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
    _SleepLog(
      id: '3',
      bedtime: '22:00',
      wakeTime: '06:00',
      durationMin: 480,
      quality: 5,
      loggedAt: DateTime.now().subtract(const Duration(days: 2)),
    ),
    _SleepLog(
      id: '4',
      bedtime: '23:30',
      wakeTime: '07:00',
      durationMin: 450,
      quality: 4,
      loggedAt: DateTime.now().subtract(const Duration(days: 3)),
    ),
  ];

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final avgDuration = _logs.isNotEmpty
        ? _logs.map((l) => l.durationMin).reduce((a, b) => a + b) ~/
              _logs.length
        : 0;
    final avgQuality = _logs.isNotEmpty
        ? _logs.map((l) => l.quality).reduce((a, b) => a + b) ~/ _logs.length
        : 0;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.secondary,
        foregroundColor: AppColors.white,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Sleep Tracker'),
            Text(
              'नींद',
              style: AppTextStyles.caption.copyWith(color: AppColors.white70),
            ),
          ],
        ),
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
                  // Stats Cards
                  Row(
                    children: [
                      Expanded(
                        child: _buildStatCard(
                          'Avg Sleep',
                          '${(avgDuration / 60).floor()}h ${avgDuration % 60}m',
                          Icons.bedtime,
                          AppColors.secondary,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildStatCard(
                          'Avg Quality',
                          '$avgQuality/5',
                          Icons.star,
                          AppColors.accent,
                        ),
                      ),
                    ],
                  ),
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
                    englishTitle: 'Recent Sleep',
                    hindiSubtitle: 'हाल की नींद',
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
        onPressed: () => _showAddSleepSheet(context),
        backgroundColor: AppColors.secondary,
        foregroundColor: AppColors.white,
        icon: const Icon(Icons.add),
        label: const Text('Log Sleep'),
      ),
    );
  }

  Widget _buildStatCard(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
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
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: AppTextStyles.h3.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(label, style: AppTextStyles.caption),
        ],
      ),
    );
  }

  Widget _buildQuickLogButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () => _showAddSleepSheet(context),
        icon: const Icon(Icons.add),
        label: const Text('Log Sleep'),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.secondary,
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
      height: 180,
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
          Text(
            'Last 7 Days',
            style: AppTextStyles.bodyMedium.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: CustomPaint(
              size: const Size(double.infinity, 100),
              painter: _SleepChartPainter(logs: _logs.reversed.toList()),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentLogs() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _logs.length,
      itemBuilder: (context, index) {
        final log = _logs[index];
        final hours = log.durationMin ~/ 60;
        final mins = log.durationMin % 60;
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
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.secondary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.bedtime, color: AppColors.secondary),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$hours h $mins m',
                      style: AppTextStyles.bodyLarge.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${log.bedtime} → ${log.wakeTime}',
                      style: AppTextStyles.caption,
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    children: List.generate(
                      5,
                      (i) => Icon(
                        i < log.quality ? Icons.star : Icons.star_border,
                        color: AppColors.accent,
                        size: 16,
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
                'Sleep Tips',
                style: AppTextStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            '• Adults need 7-9 hours of sleep per night',
            style: AppTextStyles.bodySmall,
          ),
          Text(
            '• Consistent sleep schedule helps regulate your body clock',
            style: AppTextStyles.bodySmall,
          ),
          Text(
            '• Avoid screens 1 hour before bedtime',
            style: AppTextStyles.bodySmall,
          ),
        ],
      ),
    );
  }

  void _showAddSleepSheet(BuildContext context) {
    TimeOfDay bedtime = const TimeOfDay(hour: 22, minute: 0);
    TimeOfDay wakeTime = const TimeOfDay(hour: 6, minute: 0);
    int quality = 3;

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
                Text('Log Sleep', style: AppTextStyles.h3),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: _buildTimePicker(
                        'Bedtime',
                        bedtime,
                        (v) => setModalState(() => bedtime = v),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildTimePicker(
                        'Wake Time',
                        wakeTime,
                        (v) => setModalState(() => wakeTime = v),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Text('Sleep Quality', style: AppTextStyles.labelLarge),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    5,
                    (i) => GestureDetector(
                      onTap: () => setModalState(() => quality = i + 1),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: Icon(
                          i < quality ? Icons.star : Icons.star_border,
                          color: AppColors.accent,
                          size: 36,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Sleep logged! +5 XP'),
                          backgroundColor: AppColors.success,
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.secondary,
                      foregroundColor: AppColors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Save'),
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

  Widget _buildTimePicker(
    String label,
    TimeOfDay time,
    Function(TimeOfDay) onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.labelLarge),
        const SizedBox(height: 8),
        InkWell(
          onTap: () async {
            final picked = await showTimePicker(
              context: context,
              initialTime: time,
            );
            if (picked != null) onChanged(picked);
          },
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
            decoration: BoxDecoration(
              color: AppColors.surfaceVariant,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.access_time, color: AppColors.secondary),
                const SizedBox(width: 8),
                Text(
                  '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}',
                  style: AppTextStyles.h3,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    final diff = DateTime.now().difference(date);
    if (diff.inDays == 0) return 'Today';
    if (diff.inDays == 1) return 'Yesterday';
    return '${diff.inDays} days ago';
  }
}

class _SleepLog {
  final String id;
  final String bedtime;
  final String wakeTime;
  final int durationMin;
  final int quality;
  final DateTime loggedAt;
  _SleepLog({
    required this.id,
    required this.bedtime,
    required this.wakeTime,
    required this.durationMin,
    required this.quality,
    required this.loggedAt,
  });
}

class _SleepChartPainter extends CustomPainter {
  final List<_SleepLog> logs;
  _SleepChartPainter({required this.logs});

  @override
  void paint(Canvas canvas, Size size) {
    if (logs.isEmpty) return;
    final paint = Paint()
      ..color = AppColors.secondary
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    final gridPaint = Paint()
      ..color = AppColors.divider
      ..strokeWidth = 1;
    for (int i = 0; i <= 4; i++) {
      final y = size.height * i / 4;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }
    final path = Path();
    for (int i = 0; i < logs.length; i++) {
      final x = size.width * i / (logs.length - 1).clamp(1, 100);
      final y =
          size.height -
          ((logs[i].durationMin - 300) / 300 * size.height).clamp(
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
    for (int i = 0; i < logs.length; i++) {
      final x = size.width * i / (logs.length - 1).clamp(1, 100);
      final y =
          size.height -
          ((logs[i].durationMin - 300) / 300 * size.height).clamp(
            0,
            size.height,
          );
      canvas.drawCircle(Offset(x, y), 4, Paint()..color = AppColors.secondary);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
