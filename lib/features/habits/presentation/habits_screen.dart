import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/theme/app_text_styles.dart';
import '../../../shared/widgets/section_header.dart';
import '../../../shared/widgets/shimmer_loader.dart';
import '../../../shared/widgets/bilingual_label.dart';
import '../../../shared/widgets/primary_button.dart';
import '../../../shared/widgets/secondary_button.dart';
import '../../../shared/widgets/error_empty_states.dart';
import '../domain/habit_model.dart';
import '../data/habits_repository.dart';

class HabitsScreen extends ConsumerStatefulWidget {
  const HabitsScreen({super.key});

  @override
  ConsumerState<HabitsScreen> createState() => _HabitsScreenState();
}

class _HabitsScreenState extends ConsumerState<HabitsScreen> {
  List<Habit> _habits = [];
  Map<String, HabitCompletion> _todayCompletions = {};
  bool _isLoading = true;

  // Mock user ID - in production, get from auth
  final String _userId = 'user_123';

  @override
  void initState() {
    super.initState();
    _loadHabits();
  }

  Future<void> _loadHabits() async {
    setState(() => _isLoading = true);

    try {
      final repo = ref.read(habitsRepositoryProvider);

      // Initialize preset habits if first time
      await repo.initializePresetHabits(_userId);

      // Load habits
      final habits = await repo.getHabits(_userId);

      // Load today's completions
      final completions = <String, HabitCompletion>{};
      for (var habit in habits) {
        final completion = await repo.getTodayCompletion(habit.id);
        if (completion != null) {
          completions[habit.id] = completion;
        }
      }

      setState(() {
        _habits = habits;
        _todayCompletions = completions;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _logHabitCompletion(Habit habit, int count) async {
    try {
      final repo = ref.read(habitsRepositoryProvider);
      final completion = await repo.logCompletion(
        habitId: habit.id,
        userId: _userId,
        count: count,
        habit: habit,
      );

      setState(() {
        _todayCompletions[habit.id] = completion;

        // Update habit in list with new streak
        final index = _habits.indexWhere((h) => h.id == habit.id);
        if (index != -1) {
          final updatedHabit = habit.copyWith(
            currentStreak: habit.currentStreak + 1,
            longestStreak: habit.longestStreak > (habit.currentStreak + 1)
                ? habit.longestStreak
                : habit.currentStreak + 1,
          );
          _habits[index] = updatedHabit;
        }
      });

      // Show XP earned if completed
      if (completion.isCompleted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Habit completed! +2 XP'),
            backgroundColor: AppColors.success,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e'), backgroundColor: AppColors.error),
      );
    }
  }

  void _showAddHabitDialog() {
    final nameController = TextEditingController();
    String selectedIcon = '✅';
    int targetCount = 1;
    String selectedUnit = 'times';

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
                Text('Create New Habit', style: AppTextStyles.h3),
                const SizedBox(height: 24),

                // Icon selector
                Text('Icon', style: AppTextStyles.labelLarge),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children:
                      [
                            '💧',
                            '🧘',
                            '🚶',
                            '📖',
                            '🍬',
                            '💪',
                            '🌿',
                            '☀️',
                            '😴',
                            '🍎',
                          ]
                          .map(
                            (icon) => GestureDetector(
                              onTap: () =>
                                  setModalState(() => selectedIcon = icon),
                              child: Container(
                                width: 44,
                                height: 44,
                                decoration: BoxDecoration(
                                  color: selectedIcon == icon
                                      ? AppColors.primary.withValues(alpha: 0.1)
                                      : AppColors.surfaceVariant,
                                  borderRadius: BorderRadius.circular(12),
                                  border: selectedIcon == icon
                                      ? Border.all(
                                          color: AppColors.primary,
                                          width: 2,
                                        )
                                      : null,
                                ),
                                child: Center(
                                  child: Text(
                                    icon,
                                    style: const TextStyle(fontSize: 20),
                                  ),
                                ),
                              ),
                            ),
                          )
                          .toList(),
                ),
                const SizedBox(height: 16),

                // Name
                Text('Habit Name', style: AppTextStyles.labelLarge),
                const SizedBox(height: 8),
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    hintText: 'e.g., Drink Turmeric Milk',
                    filled: true,
                    fillColor: AppColors.surfaceVariant,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Target
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Daily Target', style: AppTextStyles.labelLarge),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              color: AppColors.surfaceVariant,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                IconButton(
                                  onPressed: () => setModalState(() {
                                    if (targetCount > 1) targetCount--;
                                  }),
                                  icon: const Icon(Icons.remove_circle_outline),
                                  color: AppColors.primary,
                                ),
                                Text('$targetCount', style: AppTextStyles.h3),
                                IconButton(
                                  onPressed: () =>
                                      setModalState(() => targetCount++),
                                  icon: const Icon(Icons.add_circle_outline),
                                  color: AppColors.primary,
                                ),
                              ],
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
                          Text('Unit', style: AppTextStyles.labelLarge),
                          const SizedBox(height: 8),
                          DropdownButtonFormField<String>(
                            value: selectedUnit,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: AppColors.surfaceVariant,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                            ),
                            items:
                                [
                                      'times',
                                      'glasses',
                                      'minutes',
                                      'pages',
                                      'hours',
                                    ]
                                    .map(
                                      (u) => DropdownMenuItem(
                                        value: u,
                                        child: Text(u),
                                      ),
                                    )
                                    .toList(),
                            onChanged: (v) =>
                                setModalState(() => selectedUnit = v!),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Save Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (nameController.text.isEmpty) return;

                      final repo = ref.read(habitsRepositoryProvider);
                      await repo.createHabit(
                        Habit(
                          id: '',
                          userId: _userId,
                          name: nameController.text,
                          nameHi:
                              nameController.text, // Would use translation API
                          icon: selectedIcon,
                          targetCount: targetCount,
                          unit: selectedUnit,
                          frequency: HabitFrequency.daily,
                          createdAt: DateTime.now(),
                        ),
                      );

                      if (mounted) {
                        Navigator.pop(context);
                        _loadHabits();
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
                    child: const Text('Create Habit'),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.white,
        title: const BilingualLabel(englishText: 'Habits', hindiText: 'आदतें'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _showAddHabitDialog,
          ),
        ],
      ),
      body: _isLoading
          ? const ShimmerLoader(
              child: Center(child: CircularProgressIndicator()),
            )
          : _habits.isEmpty
          ? EmptyState(
              emoji: '🎯',
              title: 'No Habits Yet',
              subtitle: 'Create your first habit to start tracking!',
              ctaText: 'Add Habit',
              onCtaPressed: _showAddHabitDialog,
            )
          : RefreshIndicator(
              onRefresh: _loadHabits,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  // Today's Progress
                  _buildTodayProgressCard(),
                  const SizedBox(height: 24),

                  // Habits List
                  const SectionHeader(
                    englishTitle: 'My Habits',
                    hindiSubtitle: 'मेरी आदतें',
                  ),
                  const SizedBox(height: 12),
                  ..._habits.map((habit) => _buildHabitCard(habit)),

                  const SizedBox(height: 24),

                  // Weekly Heatmap
                  _buildWeeklyHeatmap(),
                  const SizedBox(height: 100),
                ],
              ),
            ),
    );
  }

  Widget _buildTodayProgressCard() {
    final completedCount = _todayCompletions.values
        .where((c) => c.isCompleted)
        .length;
    final totalCount = _habits.length;
    final progress = totalCount > 0 ? completedCount / totalCount : 0.0;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.secondary, AppColors.secondaryDark],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.secondary.withValues(alpha: 0.3),
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
                "Today's Progress",
                style: TextStyle(color: AppColors.white70, fontSize: 14),
              ),
              Text(
                '$completedCount / $totalCount',
                style: const TextStyle(
                  color: AppColors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: AppColors.white.withValues(alpha: 0.2),
              valueColor: const AlwaysStoppedAnimation(AppColors.accent),
              minHeight: 8,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            completedCount == totalCount
                ? '🎉 All habits completed!'
                : '${totalCount - completedCount} habits remaining',
            style: TextStyle(
              color: AppColors.white.withValues(alpha: 0.8),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHabitCard(Habit habit) {
    final todayCompletion = _todayCompletions[habit.id];
    final isCompleted = todayCompletion?.isCompleted ?? false;
    final currentCount = todayCompletion?.completedCount ?? 0;
    final progress = currentCount / habit.targetCount;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
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
          // Icon and info
          GestureDetector(
            onTap: () => _logHabitCompletion(habit, 1),
            child: Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: isCompleted
                    ? AppColors.success.withValues(alpha: 0.1)
                    : AppColors.primarySurface,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Center(
                child: isCompleted
                    ? const Icon(
                        Icons.check_circle,
                        color: AppColors.success,
                        size: 28,
                      )
                    : Text(habit.icon, style: const TextStyle(fontSize: 28)),
              ),
            ),
          ),
          const SizedBox(width: 16),

          // Habit details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        habit.name,
                        style: AppTextStyles.bodyLarge.copyWith(
                          fontWeight: FontWeight.w600,
                          decoration: isCompleted
                              ? TextDecoration.lineThrough
                              : null,
                        ),
                      ),
                    ),
                    if (habit.currentStreak > 0)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.accent.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text('🔥', style: TextStyle(fontSize: 12)),
                            const SizedBox(width: 4),
                            Text(
                              '${habit.currentStreak}',
                              style: AppTextStyles.caption.copyWith(
                                color: AppColors.accentDark,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  '$currentCount / ${habit.targetCount} ${habit.unit}',
                  style: AppTextStyles.caption,
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: progress.clamp(0.0, 1.0),
                    backgroundColor: AppColors.surfaceVariant,
                    valueColor: AlwaysStoppedAnimation(
                      isCompleted ? AppColors.success : AppColors.primary,
                    ),
                    minHeight: 4,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 12),

          // Quick add button
          IconButton(
            onPressed: currentCount < habit.targetCount
                ? () => _logHabitCompletion(habit, 1)
                : null,
            icon: Icon(
              Icons.add_circle,
              color: currentCount < habit.targetCount
                  ? AppColors.primary
                  : AppColors.textMuted,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeeklyHeatmap() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const BilingualLabel(
            englishText: 'This Week',
            hindiText: 'इस सप्ताह',
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(7, (index) {
              final date = DateTime.now().subtract(Duration(days: 6 - index));
              final dayLetter = [
                'M',
                'T',
                'W',
                'T',
                'F',
                'S',
                'S',
              ][date.weekday - 1];

              // Mock data - in production would come from repository
              final hasData = index < 5;

              return Column(
                children: [
                  Text(
                    dayLetter,
                    style: AppTextStyles.caption.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: hasData
                          ? AppColors.success.withValues(alpha: 0.8)
                          : AppColors.surfaceVariant,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: hasData
                        ? const Icon(
                            Icons.check,
                            color: AppColors.white,
                            size: 18,
                          )
                        : null,
                  ),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }
}
