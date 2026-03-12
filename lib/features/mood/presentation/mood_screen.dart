import 'package:flutter/material.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/theme/app_text_styles.dart';
import '../../../shared/widgets/section_header.dart';
import '../../../shared/widgets/shimmer_loader.dart';

class MoodScreen extends StatefulWidget {
  const MoodScreen({super.key});

  @override
  State<MoodScreen> createState() => _MoodScreenState();
}

class _MoodScreenState extends State<MoodScreen> {
  final List<_MoodLog> _logs = [
    _MoodLog(
      id: '1',
      mood: 4,
      energy: 7,
      stress: 3,
      tags: ['motivated', 'focused'],
      loggedAt: DateTime.now(),
    ),
    _MoodLog(
      id: '2',
      mood: 3,
      energy: 5,
      stress: 6,
      tags: ['anxious'],
      loggedAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
    _MoodLog(
      id: '3',
      mood: 5,
      energy: 8,
      stress: 2,
      tags: ['happy', 'energized'],
      loggedAt: DateTime.now().subtract(const Duration(days: 2)),
    ),
    _MoodLog(
      id: '4',
      mood: 2,
      energy: 4,
      stress: 7,
      tags: ['tired', 'irritable'],
      loggedAt: DateTime.now().subtract(const Duration(days: 3)),
    ),
  ];

  bool _isLoading = false;

  static const List<String> _moodEmojis = ['😢', '😔', '😐', '🙂', '😊'];
  static const List<String> _moodLabels = [
    'Very Low',
    'Low',
    'Neutral',
    'Good',
    'Great',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.accent,
        foregroundColor: AppColors.white,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Mood Tracker'),
            Text(
              'मूड',
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
                  _buildQuickLogButton(),
                  const SizedBox(height: 20),
                  const SectionHeader(
                    englishTitle: 'Today\'s Mood',
                    hindiSubtitle: 'आज का मूड',
                  ),
                  const SizedBox(height: 12),
                  _buildTodayMoodCard(),
                  const SizedBox(height: 24),
                  const SectionHeader(
                    englishTitle: 'Trend',
                    hindiSubtitle: 'रुझान',
                  ),
                  const SizedBox(height: 12),
                  _buildTrendChart(),
                  const SizedBox(height: 24),
                  const SectionHeader(
                    englishTitle: 'Recent Entries',
                    hindiSubtitle: 'हाल की एंट्री',
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
        onPressed: () => _showAddMoodSheet(context),
        backgroundColor: AppColors.accent,
        foregroundColor: AppColors.white,
        icon: const Icon(Icons.add),
        label: const Text('Log Mood'),
      ),
    );
  }

  Widget _buildQuickLogButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () => _showAddMoodSheet(context),
        icon: const Icon(Icons.add),
        label: const Text('How are you feeling?'),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.accent,
          foregroundColor: AppColors.white,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  Widget _buildTodayMoodCard() {
    final today = _logs.isNotEmpty ? _logs.first : null;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.accent, Color(0xFFFFD54F)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.accent.withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            today != null ? _moodEmojis[today.mood - 1] : '😐',
            style: const TextStyle(fontSize: 64),
          ),
          const SizedBox(height: 12),
          Text(
            today != null
                ? _moodLabels[today.mood - 1]
                : 'How are you feeling?',
            style: const TextStyle(
              color: AppColors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (today != null) ...[
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildMiniStat('⚡', 'Energy', '${today.energy}/10'),
                _buildMiniStat('😰', 'Stress', '${today.stress}/10'),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildMiniStat(String emoji, String label, String value) {
    return Column(
      children: [
        Text(emoji, style: const TextStyle(fontSize: 20)),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: AppColors.white.withValues(alpha: 0.8),
            fontSize: 12,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            color: AppColors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
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
              painter: _MoodChartPainter(logs: _logs.reversed.toList()),
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
              Text(
                _moodEmojis[log.mood - 1],
                style: const TextStyle(fontSize: 32),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _moodLabels[log.mood - 1],
                      style: AppTextStyles.bodyLarge.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Wrap(
                      spacing: 4,
                      children: log.tags
                          .map(
                            (t) => Chip(
                              label: Text(
                                t,
                                style: const TextStyle(fontSize: 10),
                              ),
                              padding: EdgeInsets.zero,
                              visualDensity: VisualDensity.compact,
                            ),
                          )
                          .toList(),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('⚡ ${log.energy}/10', style: AppTextStyles.caption),
                  Text('😰 ${log.stress}/10', style: AppTextStyles.caption),
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
              Icon(Icons.lightbulb_outline, color: AppColors.accent, size: 20),
              const SizedBox(width: 8),
              Text(
                'Mood Tips',
                style: AppTextStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            '• Regular exercise can improve mood',
            style: AppTextStyles.bodySmall,
          ),
          Text(
            '• Adequate sleep helps regulate emotions',
            style: AppTextStyles.bodySmall,
          ),
          Text(
            '• Tracking patterns can help identify triggers',
            style: AppTextStyles.bodySmall,
          ),
        ],
      ),
    );
  }

  void _showAddMoodSheet(BuildContext context) {
    int mood = 3;
    int energy = 5;
    int stress = 5;
    final List<String> selectedTags = [];

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
                Text('How are you feeling?', style: AppTextStyles.h3),
                const SizedBox(height: 24),
                // Mood selector
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      5,
                      (i) => GestureDetector(
                        onTap: () => setModalState(() => mood = i + 1),
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: mood == i + 1
                                ? AppColors.accent.withValues(alpha: 0.2)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(12),
                            border: mood == i + 1
                                ? Border.all(color: AppColors.accent, width: 2)
                                : null,
                          ),
                          child: Text(
                            _moodEmojis[i],
                            style: const TextStyle(fontSize: 32),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Center(
                  child: Text(
                    _moodLabels[mood - 1],
                    style: AppTextStyles.bodyMedium,
                  ),
                ),
                const SizedBox(height: 24),
                // Energy slider
                Text('Energy Level', style: AppTextStyles.labelLarge),
                Slider(
                  value: energy.toDouble(),
                  min: 1,
                  max: 10,
                  divisions: 9,
                  activeColor: AppColors.success,
                  onChanged: (v) => setModalState(() => energy = v.round()),
                ),
                Center(child: Text('$energy/10')),
                const SizedBox(height: 16),
                // Stress slider
                Text('Stress Level', style: AppTextStyles.labelLarge),
                Slider(
                  value: stress.toDouble(),
                  min: 1,
                  max: 10,
                  divisions: 9,
                  activeColor: AppColors.error,
                  onChanged: (v) => setModalState(() => stress = v.round()),
                ),
                Center(child: Text('$stress/10')),
                const SizedBox(height: 16),
                // Tags
                Text('Tags', style: AppTextStyles.labelLarge),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children:
                      [
                            'happy',
                            'sad',
                            'anxious',
                            'calm',
                            'focused',
                            'tired',
                            'motivated',
                            'stressed',
                          ]
                          .map(
                            (tag) => FilterChip(
                              label: Text(tag),
                              selected: selectedTags.contains(tag),
                              onSelected: (selected) {
                                setModalState(() {
                                  if (selected)
                                    selectedTags.add(tag);
                                  else
                                    selectedTags.remove(tag);
                                });
                              },
                            ),
                          )
                          .toList(),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Mood logged! +3 XP'),
                          backgroundColor: AppColors.success,
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.accent,
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

  String _formatDate(DateTime date) {
    final diff = DateTime.now().difference(date);
    if (diff.inDays == 0) return 'Today';
    if (diff.inDays == 1) return 'Yesterday';
    return '${diff.inDays} days ago';
  }
}

class _MoodLog {
  final String id;
  final int mood;
  final int energy;
  final int stress;
  final List<String> tags;
  final DateTime loggedAt;
  _MoodLog({
    required this.id,
    required this.mood,
    required this.energy,
    required this.stress,
    required this.tags,
    required this.loggedAt,
  });
}

class _MoodChartPainter extends CustomPainter {
  final List<_MoodLog> logs;
  _MoodChartPainter({required this.logs});

  @override
  void paint(Canvas canvas, Size size) {
    if (logs.isEmpty) return;
    final paint = Paint()
      ..color = AppColors.accent
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
      final y = size.height - ((logs[i].mood - 1) / 4 * size.height);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    canvas.drawPath(path, paint);
    for (int i = 0; i < logs.length; i++) {
      final x = size.width * i / (logs.length - 1).clamp(1, 100);
      final y = size.height - ((logs[i].mood - 1) / 4 * size.height);
      canvas.drawCircle(Offset(x, y), 4, Paint()..color = AppColors.accent);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
