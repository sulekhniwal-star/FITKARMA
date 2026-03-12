import 'package:flutter/material.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/theme/app_text_styles.dart';
import '../../../shared/widgets/section_header.dart';
import '../../../shared/widgets/shimmer_loader.dart';

class PeriodScreen extends StatefulWidget {
  const PeriodScreen({super.key});

  @override
  State<PeriodScreen> createState() => _PeriodScreenState();
}

class _PeriodScreenState extends State<PeriodScreen> {
  // Mock data - in production this would be encrypted
  final List<_PeriodLog> _logs = [
    _PeriodLog(
      id: '1',
      startDate: DateTime.now().subtract(const Duration(days: 5)),
      endDate: DateTime.now().subtract(const Duration(days: 1)),
      flow: 'medium',
      symptoms: ['cramps', 'mood_swings'],
      loggedAt: DateTime.now(),
    ),
    _PeriodLog(
      id: '2',
      startDate: DateTime.now().subtract(const Duration(days: 30)),
      endDate: DateTime.now().subtract(const Duration(days: 25)),
      flow: 'light',
      symptoms: ['fatigue'],
      loggedAt: DateTime.now().subtract(const Duration(days: 25)),
    ),
    _PeriodLog(
      id: '3',
      startDate: DateTime.now().subtract(const Duration(days: 58)),
      endDate: DateTime.now().subtract(const Duration(days: 52)),
      flow: 'heavy',
      symptoms: ['cramps', 'headache', 'bloating'],
      loggedAt: DateTime.now().subtract(const Duration(days: 52)),
    ),
  ];

  bool _isLoading = false;

  String _getCyclePhase() {
    if (_logs.isEmpty) return 'Unknown';
    final lastPeriod = _logs.first;
    final daysSinceStart = DateTime.now()
        .difference(lastPeriod.startDate)
        .inDays;

    if (daysSinceStart <=
        lastPeriod.endDate.difference(lastPeriod.startDate).inDays) {
      return 'Menstruation';
    } else if (daysSinceStart <= 13) {
      return 'Follicular';
    } else if (daysSinceStart <= 14) {
      return 'Ovulation';
    } else {
      return 'Luteal';
    }
  }

  int _getDaysUntilNext() {
    if (_logs.isEmpty) return 0;
    // Average cycle length is 28 days
    final lastPeriod = _logs.first;
    final daysSinceStart = DateTime.now()
        .difference(lastPeriod.startDate)
        .inDays;
    return (28 - daysSinceStart).clamp(0, 28);
  }

  @override
  Widget build(BuildContext context) {
    final phase = _getCyclePhase();
    final daysUntil = _getDaysUntilNext();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.rose,
        foregroundColor: AppColors.white,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Period Tracker'),
            Text(
              'मासिक धर्म',
              style: AppTextStyles.caption.copyWith(color: AppColors.white70),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.lock),
            onPressed: () {},
            tooltip: 'End-to-end encrypted',
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
                  // Current Phase Card
                  _buildPhaseCard(phase, daysUntil),
                  const SizedBox(height: 20),
                  _buildQuickLogButton(),
                  const SizedBox(height: 24),
                  const SectionHeader(
                    englishTitle: 'Cycle Calendar',
                    hindiSubtitle: 'चक्र कैलेंडर',
                  ),
                  const SizedBox(height: 12),
                  _buildCalendarView(),
                  const SizedBox(height: 24),
                  const SectionHeader(
                    englishTitle: 'Recent Periods',
                    hindiSubtitle: 'हाल के पीरियड',
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
        onPressed: () => _showAddPeriodSheet(context),
        backgroundColor: AppColors.rose,
        foregroundColor: AppColors.white,
        icon: const Icon(Icons.add),
        label: const Text('Log Period'),
      ),
    );
  }

  Widget _buildPhaseCard(String phase, int daysUntil) {
    Color phaseColor;
    IconData phaseIcon;

    switch (phase) {
      case 'Menstruation':
        phaseColor = AppColors.rose;
        phaseIcon = Icons.water_drop;
        break;
      case 'Follicular':
        phaseColor = AppColors.success;
        phaseIcon = Icons.spa;
        break;
      case 'Ovulation':
        phaseColor = AppColors.primary;
        phaseIcon = Icons.favorite;
        break;
      case 'Luteal':
        phaseColor = AppColors.purple;
        phaseIcon = Icons.nights_stay;
        break;
      default:
        phaseColor = AppColors.textSecondary;
        phaseIcon = Icons.help_outline;
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [phaseColor, phaseColor.withValues(alpha: 0.7)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: phaseColor.withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(phaseIcon, color: AppColors.white, size: 32),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Current Phase',
                      style: TextStyle(color: AppColors.white70, fontSize: 14),
                    ),
                    Text(
                      phase,
                      style: const TextStyle(
                        color: AppColors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
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
                  daysUntil > 0 ? '$daysUntil days' : 'Today',
                  style: const TextStyle(
                    color: AppColors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildPhaseIndicator('Menstruation', phase == 'Menstruation'),
              _buildPhaseIndicator('Follicular', phase == 'Follicular'),
              _buildPhaseIndicator('Ovulation', phase == 'Ovulation'),
              _buildPhaseIndicator('Luteal', phase == 'Luteal'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPhaseIndicator(String label, bool isActive) {
    return Column(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isActive
                ? AppColors.white
                : AppColors.white.withValues(alpha: 0.3),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label.substring(0, 3),
          style: TextStyle(
            color: AppColors.white.withValues(alpha: isActive ? 1 : 0.7),
            fontSize: 10,
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }

  Widget _buildQuickLogButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () => _showAddPeriodSheet(context),
        icon: const Icon(Icons.add),
        label: const Text('Log Period'),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.rose,
          foregroundColor: AppColors.white,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  Widget _buildCalendarView() {
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
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.chevron_left),
                onPressed: () {},
              ),
              Text(
                'March 2026',
                style: AppTextStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.chevron_right),
                onPressed: () {},
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: ['S', 'M', 'T', 'W', 'T', 'F', 'S']
                .map(
                  (d) => SizedBox(
                    width: 36,
                    child: Center(child: Text(d, style: AppTextStyles.caption)),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 8),
          // Simple calendar grid - in production would be more sophisticated
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              mainAxisSpacing: 4,
            ),
            itemCount: 35,
            itemBuilder: (context, index) {
              final day = index - 5; // Adjust for starting day
              if (day < 1 || day > 31) return const SizedBox();

              // Check if this day is in a period
              bool isPeriod = false;
              for (final log in _logs) {
                if (day >= log.startDate.day && day <= log.endDate.day) {
                  isPeriod = true;
                  break;
                }
              }

              // Check if today
              final isToday = day == DateTime.now().day;

              return Container(
                decoration: BoxDecoration(
                  color: isPeriod
                      ? AppColors.rose
                      : (isToday
                            ? AppColors.rose.withValues(alpha: 0.2)
                            : null),
                  borderRadius: BorderRadius.circular(8),
                  border: isToday
                      ? Border.all(color: AppColors.rose, width: 2)
                      : null,
                ),
                child: Center(
                  child: Text(
                    '$day',
                    style: TextStyle(
                      color: isPeriod ? AppColors.white : AppColors.textPrimary,
                      fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ),
              );
            },
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
        final duration = log.endDate.difference(log.startDate).inDays + 1;
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
                  color: AppColors.rose.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.water_drop, color: AppColors.rose),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$duration days',
                      style: AppTextStyles.bodyLarge.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '${log.startDate.day}/${log.startDate.month} - ${log.endDate.day}/${log.endDate.month}',
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
                      color: _getFlowColor(log.flow).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      log.flow,
                      style: AppTextStyles.caption.copyWith(
                        color: _getFlowColor(log.flow),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  if (log.symptoms.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Wrap(
                      spacing: 4,
                      children: log.symptoms
                          .take(2)
                          .map((s) => Text(s, style: AppTextStyles.caption))
                          .toList(),
                    ),
                  ],
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Color _getFlowColor(String flow) {
    switch (flow) {
      case 'light':
        return AppColors.success;
      case 'medium':
        return AppColors.warning;
      case 'heavy':
        return AppColors.error;
      default:
        return AppColors.textSecondary;
    }
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
              Icon(Icons.lock, color: AppColors.success, size: 20),
              const SizedBox(width: 8),
              Text(
                'Privacy Protected',
                style: AppTextStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            '• All data is encrypted on your device',
            style: AppTextStyles.bodySmall,
          ),
          Text('• Sync to cloud is optional', style: AppTextStyles.bodySmall),
          Text(
            '• Data never shared with third parties',
            style: AppTextStyles.bodySmall,
          ),
        ],
      ),
    );
  }

  void _showAddPeriodSheet(BuildContext context) {
    DateTime startDate = DateTime.now();
    DateTime endDate = DateTime.now();
    String flow = 'medium';
    final List<String> selectedSymptoms = [];

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
                Text('Log Period', style: AppTextStyles.h3),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: _buildDatePicker(
                        'Start Date',
                        startDate,
                        (v) => setModalState(() => startDate = v),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildDatePicker(
                        'End Date',
                        endDate,
                        (v) => setModalState(() => endDate = v),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Text('Flow Intensity', style: AppTextStyles.labelLarge),
                const SizedBox(height: 8),
                Row(
                  children: [
                    _buildFlowChip(
                      'Light',
                      'light',
                      flow,
                      (v) => setModalState(() => flow = v),
                    ),
                    const SizedBox(width: 8),
                    _buildFlowChip(
                      'Medium',
                      'medium',
                      flow,
                      (v) => setModalState(() => flow = v),
                    ),
                    const SizedBox(width: 8),
                    _buildFlowChip(
                      'Heavy',
                      'heavy',
                      flow,
                      (v) => setModalState(() => flow = v),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Text('Symptoms', style: AppTextStyles.labelLarge),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children:
                      [
                            'cramps',
                            'bloating',
                            'headache',
                            'fatigue',
                            'mood_swings',
                            'back_pain',
                          ]
                          .map(
                            (s) => FilterChip(
                              label: Text(s.replaceAll('_', ' ')),
                              selected: selectedSymptoms.contains(s),
                              onSelected: (selected) {
                                setModalState(() {
                                  if (selected)
                                    selectedSymptoms.add(s);
                                  else
                                    selectedSymptoms.remove(s);
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
                          content: Text('Period logged! +5 XP'),
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

  Widget _buildDatePicker(
    String label,
    DateTime date,
    Function(DateTime) onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.labelLarge),
        const SizedBox(height: 8),
        InkWell(
          onTap: () async {
            final picked = await showDatePicker(
              context: context,
              initialDate: date,
              firstDate: DateTime(2020),
              lastDate: DateTime.now(),
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
                const Icon(
                  Icons.calendar_today,
                  color: AppColors.rose,
                  size: 18,
                ),
                const SizedBox(width: 8),
                Text(
                  '${date.day}/${date.month}/${date.year}',
                  style: AppTextStyles.bodyMedium,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFlowChip(
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
      selectedColor: AppColors.rose.withValues(alpha: 0.2),
      labelStyle: TextStyle(
        color: isSelected ? AppColors.rose : AppColors.textSecondary,
        fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
      ),
    );
  }
}

class _PeriodLog {
  final String id;
  final DateTime startDate;
  final DateTime endDate;
  final String flow;
  final List<String> symptoms;
  final DateTime loggedAt;
  _PeriodLog({
    required this.id,
    required this.startDate,
    required this.endDate,
    required this.flow,
    required this.symptoms,
    required this.loggedAt,
  });
}
