import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/theme/app_text_styles.dart';
import '../../../shared/widgets/shimmer_loader.dart';
import '../../../shared/widgets/bilingual_label.dart';
import '../../../shared/widgets/section_header.dart';
import '../domain/fasting_model.dart';
import '../data/fasting_repository.dart';

class FastingScreen extends ConsumerStatefulWidget {
  const FastingScreen({super.key});

  @override
  ConsumerState<FastingScreen> createState() => _FastingScreenState();
}

class _FastingScreenState extends ConsumerState<FastingScreen> {
  FastingSession? _activeSession;
  bool _isLoading = true;
  Timer? _timer;

  // Mock user ID - in production, get from auth
  final String _userId = 'user_123';

  @override
  void initState() {
    super.initState();
    _loadSession();
    // Update timer every second
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _loadSession() async {
    setState(() => _isLoading = true);

    try {
      final repo = ref.read(fastingRepositoryProvider);
      final session = await repo.getActiveSession(_userId);

      setState(() {
        _activeSession = session;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _startFast() async {
    FastingProtocol selectedProtocol = FastingProtocol.protocol16_8;
    String eatingStart = '12:00';
    String eatingEnd = '20:00';

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
                Text('Start Fasting', style: AppTextStyles.h3),
                const SizedBox(height: 8),
                Text(
                  'Choose your fasting protocol',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 24),

                // Protocol selection
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: FastingProtocol.values.map((protocol) {
                    final isSelected = selectedProtocol == protocol;
                    String name;
                    switch (protocol) {
                      case FastingProtocol.protocol16_8:
                        name = '16:8';
                        break;
                      case FastingProtocol.protocol18_6:
                        name = '18:6';
                        break;
                      case FastingProtocol.protocol5_2:
                        name = '5:2';
                        break;
                      case FastingProtocol.omad:
                        name = 'OMAD';
                        break;
                      case FastingProtocol.custom:
                        name = 'Custom';
                        break;
                    }

                    return GestureDetector(
                      onTap: () =>
                          setModalState(() => selectedProtocol = protocol),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.primary.withValues(alpha: 0.1)
                              : AppColors.surfaceVariant,
                          borderRadius: BorderRadius.circular(12),
                          border: isSelected
                              ? Border.all(color: AppColors.primary, width: 2)
                              : null,
                        ),
                        child: Text(
                          name,
                          style: TextStyle(
                            color: isSelected
                                ? AppColors.primary
                                : AppColors.textPrimary,
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 24),

                // Eating window
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Eating Window Start',
                            style: AppTextStyles.labelLarge,
                          ),
                          const SizedBox(height: 8),
                          GestureDetector(
                            onTap: () async {
                              final time = await showTimePicker(
                                context: context,
                                initialTime: TimeOfDay.now(),
                              );
                              if (time != null) {
                                setModalState(() {
                                  eatingStart =
                                      '${time.hour}:${time.minute.toString().padLeft(2, '0')}';
                                });
                              }
                            },
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: AppColors.surfaceVariant,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(eatingStart, style: AppTextStyles.h4),
                                  const Icon(
                                    Icons.access_time,
                                    color: AppColors.textSecondary,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Eating Window End',
                            style: AppTextStyles.labelLarge,
                          ),
                          const SizedBox(height: 8),
                          GestureDetector(
                            onTap: () async {
                              final time = await showTimePicker(
                                context: context,
                                initialTime: TimeOfDay.now(),
                              );
                              if (time != null) {
                                setModalState(() {
                                  eatingEnd =
                                      '${time.hour}:${time.minute.toString().padLeft(2, '0')}';
                                });
                              }
                            },
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: AppColors.surfaceVariant,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(eatingEnd, style: AppTextStyles.h4),
                                  const Icon(
                                    Icons.access_time,
                                    color: AppColors.textSecondary,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Start button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      final repo = ref.read(fastingRepositoryProvider);
                      await repo.startFast(
                        userId: _userId,
                        protocol: selectedProtocol,
                        eatingWindowStart: eatingStart,
                        eatingWindowEnd: eatingEnd,
                      );

                      if (mounted) {
                        Navigator.pop(context);
                        _loadSession();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: AppColors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Start Fasting'),
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

  Future<void> _endFast() async {
    if (_activeSession == null) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('End Fast?'),
        content: const Text('Are you sure you want to end your current fast?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
            child: const Text('End Fast'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final repo = ref.read(fastingRepositoryProvider);
      await repo.endFast(_userId, _activeSession!.id);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Fast completed! +15 XP'),
            backgroundColor: AppColors.success,
          ),
        );
        _loadSession();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.teal,
        foregroundColor: AppColors.white,
        title: const BilingualLabel(englishText: 'Fasting', hindiText: 'उपवास'),
      ),
      body: _isLoading
          ? const ShimmerLoader(
              child: Center(child: CircularProgressIndicator()),
            )
          : _activeSession == null
          ? _buildNoActiveFast()
          : _buildActiveFast(),
    );
  }

  Widget _buildNoActiveFast() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: AppColors.teal.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.timer_outlined,
                size: 60,
                color: AppColors.teal,
              ),
            ),
            const SizedBox(height: 24),
            Text('Ready to Fast?', style: AppTextStyles.h2),
            const SizedBox(height: 8),
            Text(
              'Start your intermittent fasting journey',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: _startFast,
              icon: const Icon(Icons.play_arrow),
              label: const Text('Start Fast'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.teal,
                foregroundColor: AppColors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 48),

            // Protocol info cards
            const SectionHeader(
              englishTitle: 'Popular Protocols',
              hindiSubtitle: 'लोकप्रिय प्रोटोकॉल',
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                _buildProtocolCard('16:8', '16h fast, 8h eat'),
                const SizedBox(width: 12),
                _buildProtocolCard('18:6', '18h fast, 6h eat'),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                _buildProtocolCard('OMAD', '23h fast'),
                const SizedBox(width: 12),
                _buildProtocolCard('5:2', '2 days/week'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProtocolCard(String title, String subtitle) {
    return Expanded(
      child: Container(
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
        child: Column(
          children: [
            Text(title, style: AppTextStyles.h4),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: AppTextStyles.caption,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActiveFast() {
    final session = _activeSession!;
    final duration = session.fastingDuration;
    final progress = session.progressPercentage;
    final stage = session.currentStage;

    // Format duration
    final hours = duration.inHours;
    final minutes = duration.inMinutes % 60;
    final seconds = duration.inSeconds % 60;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Progress Ring
          Container(
            width: 280,
            height: 280,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.surface,
              boxShadow: [
                BoxShadow(
                  color: AppColors.teal.withValues(alpha: 0.2),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 240,
                  height: 240,
                  child: CircularProgressIndicator(
                    value: progress,
                    strokeWidth: 12,
                    backgroundColor: AppColors.surfaceVariant,
                    valueColor: const AlwaysStoppedAnimation(AppColors.teal),
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}',
                      style: AppTextStyles.displayMedium.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.teal,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _getStageLabel(stage),
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: _getStageColor(stage),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Protocol info
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildInfoItem('Protocol', session.protocolName),
                _buildInfoItem('Target', '${session.protocolFastingHours}h'),
                _buildInfoItem(
                  'Eating Window',
                  '${session.eatingWindowStart} - ${session.eatingWindowEnd}',
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Stage indicator
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: _getStageColor(stage).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: _getStageColor(stage)),
            ),
            child: Row(
              children: [
                Icon(
                  _getStageIcon(stage),
                  color: _getStageColor(stage),
                  size: 32,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _getStageTitle(stage),
                        style: AppTextStyles.h4.copyWith(
                          color: _getStageColor(stage),
                        ),
                      ),
                      Text(
                        _getStageDescription(stage),
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Stats
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  'Fasted',
                  '${(progress * 100).toInt()}%',
                  Icons.trending_up,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  'Remaining',
                  '${((1 - progress) * session.protocolFastingHours).toStringAsFixed(1)}h',
                  Icons.hourglass_bottom,
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),

          // End fast button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _endFast,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.error,
                foregroundColor: AppColors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('End Fast'),
            ),
          ),
          const SizedBox(height: 100),
        ],
      ),
    );
  }

  Widget _buildInfoItem(String label, String value) {
    return Column(
      children: [
        Text(label, style: AppTextStyles.caption),
        const SizedBox(height: 4),
        Text(
          value,
          style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.w600),
        ),
      ],
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.teal),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: AppTextStyles.caption),
              Text(value, style: AppTextStyles.h4),
            ],
          ),
        ],
      ),
    );
  }

  String _getStageLabel(FastingStage stage) {
    switch (stage) {
      case FastingStage.fed:
        return 'Eating Window';
      case FastingStage.earlyFast:
        return 'Early Fasting';
      case FastingStage.fatBurning:
        return 'Fat Burning';
      case FastingStage.ketosis:
        return 'Ketosis';
      case FastingStage.deepFast:
        return 'Deep Fasting';
    }
  }

  Color _getStageColor(FastingStage stage) {
    switch (stage) {
      case FastingStage.fed:
        return AppColors.warning;
      case FastingStage.earlyFast:
        return AppColors.primary;
      case FastingStage.fatBurning:
        return AppColors.teal;
      case FastingStage.ketosis:
        return AppColors.secondary;
      case FastingStage.deepFast:
        return AppColors.success;
    }
  }

  IconData _getStageIcon(FastingStage stage) {
    switch (stage) {
      case FastingStage.fed:
        return Icons.restaurant;
      case FastingStage.earlyFast:
        return Icons.hourglass_empty;
      case FastingStage.fatBurning:
        return Icons.local_fire_department;
      case FastingStage.ketosis:
        return Icons.bolt;
      case FastingStage.deepFast:
        return Icons.star;
    }
  }

  String _getStageTitle(FastingStage stage) {
    switch (stage) {
      case FastingStage.fed:
        return 'You\'re in the Eating Window';
      case FastingStage.earlyFast:
        return 'Early Fasting Stage';
      case FastingStage.fatBurning:
        return 'Entering Fat Burning';
      case FastingStage.ketosis:
        return 'Ketosis Zone';
      case FastingStage.deepFast:
        return 'Deep Fasting';
    }
  }

  String _getStageDescription(FastingStage stage) {
    switch (stage) {
      case FastingStage.fed:
        return 'Enjoy your meals within your eating window';
      case FastingStage.earlyFast:
        return 'Your body is beginning to use stored energy';
      case FastingStage.fatBurning:
        return 'Your body is now burning fat for energy';
      case FastingStage.ketosis:
        return 'Maximum fat burning and metabolic benefits';
      case FastingStage.deepFast:
        return 'Autophagy and cellular repair peak';
    }
  }
}
