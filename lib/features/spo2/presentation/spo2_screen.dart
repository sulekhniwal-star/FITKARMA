import 'package:flutter/material.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/theme/app_text_styles.dart';
import '../../../shared/widgets/section_header.dart';
import '../../../shared/widgets/shimmer_loader.dart';

class SpO2Screen extends StatefulWidget {
  const SpO2Screen({super.key});

  @override
  State<SpO2Screen> createState() => _SpO2ScreenState();
}

class _SpO2ScreenState extends State<SpO2Screen> {
  // Mock data
  final List<_SpO2Log> _logs = [
    _SpO2Log(
      id: '1',
      spo2: 98,
      pulse: 72,
      loggedAt: DateTime.now().subtract(const Duration(hours: 2)),
    ),
    _SpO2Log(
      id: '2',
      spo2: 97,
      pulse: 75,
      loggedAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
    _SpO2Log(
      id: '3',
      spo2: 99,
      pulse: 70,
      loggedAt: DateTime.now().subtract(const Duration(days: 2)),
    ),
    _SpO2Log(
      id: '4',
      spo2: 96,
      pulse: 78,
      loggedAt: DateTime.now().subtract(const Duration(days: 3)),
    ),
  ];

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.purple,
        foregroundColor: AppColors.white,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('SpO2 / Oxygen'),
            Text(
              'ऑक्सीजन',
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
        onPressed: () => _showAddSpO2Sheet(context),
        backgroundColor: AppColors.purple,
        foregroundColor: AppColors.white,
        icon: const Icon(Icons.add),
        label: const Text('Log SpO2'),
      ),
    );
  }

  Widget _buildLatestReadingCard() {
    final latest = _logs.isNotEmpty ? _logs.first : null;
    final isLow = latest != null && latest.spo2 < 95;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isLow
              ? [AppColors.warning, AppColors.warning.withValues(alpha: 0.7)]
              : [AppColors.purple, AppColors.purple.withValues(alpha: 0.7)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.purple.withValues(alpha: 0.3),
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
                  '${latest.spo2}',
                  style: const TextStyle(
                    color: AppColors.white,
                    fontSize: 56,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(bottom: 8, left: 4),
                  child: Text(
                    '%',
                    style: TextStyle(color: AppColors.white70, fontSize: 24),
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
                  latest != null
                      ? (latest.spo2 >= 95 ? 'Normal' : 'Low')
                      : '--',
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
        onPressed: () => _showAddSpO2Sheet(context),
        icon: const Icon(Icons.add),
        label: const Text('Log Reading'),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.purple,
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
              painter: _SpO2ChartPainter(logs: _logs.reversed.toList()),
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
        final isLow = log.spo2 < 95;
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
                  color: isLow ? AppColors.warning : AppColors.purple,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${log.spo2}%',
                      style: AppTextStyles.bodyLarge.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
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
                      color: (isLow ? AppColors.warning : AppColors.purple)
                          .withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      isLow ? 'Low' : 'Normal',
                      style: AppTextStyles.caption.copyWith(
                        color: isLow ? AppColors.warning : AppColors.purple,
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
                'Understanding SpO2',
                style: AppTextStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildRow('Normal', '95-100%', AppColors.success),
          _buildRow('Low', '< 95%', AppColors.warning),
          _buildRow('Critical', '< 90%', AppColors.error),
        ],
      ),
    );
  }

  Widget _buildRow(String label, String range, Color color) {
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

  void _showAddSpO2Sheet(BuildContext context) {
    int spo2 = 98;
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
                Text('Log SpO2', style: AppTextStyles.h3),
                const SizedBox(height: 24),
                Text('SpO2 (%)', style: AppTextStyles.labelLarge),
                const SizedBox(height: 8),
                Row(
                  children: [
                    IconButton(
                      onPressed: () => setModalState(() {
                        if (spo2 > 50) spo2--;
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
                          child: Text('$spo2%', style: AppTextStyles.h2),
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () => setModalState(() {
                        if (spo2 < 100) spo2++;
                      }),
                      icon: const Icon(Icons.add_circle_outline),
                      color: AppColors.primary,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text('Pulse (bpm)', style: AppTextStyles.labelLarge),
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
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('SpO2 reading logged! +5 XP'),
                          backgroundColor: AppColors.success,
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.purple,
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

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);
    if (diff.inDays == 0) return 'Today';
    if (diff.inDays == 1) return 'Yesterday';
    if (diff.inDays < 7) return '${diff.inDays} days ago';
    return '${date.day}/${date.month}/${date.year}';
  }
}

class _SpO2Log {
  final String id;
  final int spo2;
  final int pulse;
  final DateTime loggedAt;
  _SpO2Log({
    required this.id,
    required this.spo2,
    required this.pulse,
    required this.loggedAt,
  });
}

class _SpO2ChartPainter extends CustomPainter {
  final List<_SpO2Log> logs;
  _SpO2ChartPainter({required this.logs});

  @override
  void paint(Canvas canvas, Size size) {
    if (logs.isEmpty) return;
    final paint = Paint()
      ..color = AppColors.purple
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
          ((logs[i].spo2 - 90) / 15 * size.height).clamp(0, size.height);
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
          ((logs[i].spo2 - 90) / 15 * size.height).clamp(0, size.height);
      canvas.drawCircle(Offset(x, y), 4, Paint()..color = AppColors.purple);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
