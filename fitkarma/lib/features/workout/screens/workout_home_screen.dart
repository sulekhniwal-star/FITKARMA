// lib/features/workout/screens/workout_home_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../shared/theme/app_colors.dart';
import '../domain/workout_model.dart';
import '../providers/workout_providers.dart';

/// Main workout home screen with category grid
class WorkoutHomeScreen extends ConsumerStatefulWidget {
  const WorkoutHomeScreen({super.key});

  @override
  ConsumerState<WorkoutHomeScreen> createState() => _WorkoutHomeScreenState();
}

class _WorkoutHomeScreenState extends ConsumerState<WorkoutHomeScreen> {
  @override
  void initState() {
    super.initState();
    // Initialize workout data
    Future.microtask(() {
      ref.read(workoutProvider.notifier).init();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(workoutProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Workouts'),
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_month),
            onPressed: () => context.push('/home/workout/calendar'),
            tooltip: 'Workout Calendar',
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => context.push('/home/workout/custom'),
            tooltip: 'Create Custom Workout',
          ),
        ],
      ),
      body: state.isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: () => ref.read(workoutProvider.notifier).refresh(),
              child: CustomScrollView(
                slivers: [
                  // Stats summary
                  SliverToBoxAdapter(child: _buildStatsSummary(state)),

                  // Category grid
                  SliverPadding(
                    padding: const EdgeInsets.all(16),
                    sliver: SliverToBoxAdapter(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Categories',
                            style: Theme.of(context).textTheme.titleLarge
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 16),
                          _buildCategoryGrid(),
                        ],
                      ),
                    ),
                  ),

                  // Featured workouts
                  SliverPadding(
                    padding: const EdgeInsets.all(16),
                    sliver: SliverToBoxAdapter(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Quick Start',
                            style: Theme.of(context).textTheme.titleLarge
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 16),
                          _buildQuickStartList(state),
                        ],
                      ),
                    ),
                  ),

                  // Recent workouts
                  if (state.logs.isNotEmpty)
                    SliverPadding(
                      padding: const EdgeInsets.all(16),
                      sliver: SliverToBoxAdapter(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Recent Workouts',
                              style: Theme.of(context).textTheme.titleLarge
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 16),
                            _buildRecentWorkouts(state),
                          ],
                        ),
                      ),
                    ),

                  // Bottom padding
                  const SliverToBoxAdapter(child: SizedBox(height: 80)),
                ],
              ),
            ),
    );
  }

  Widget _buildStatsSummary(WorkoutState state) {
    final weeklyStats = state.weeklyStats;
    final streak = state.streak;

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary, AppColors.primary.withOpacity(0.8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem(
            icon: Icons.local_fire_department,
            value: '${weeklyStats['workout_count'] ?? 0}',
            label: 'This Week',
          ),
          _buildStatItem(
            icon: Icons.timer,
            value: '${weeklyStats['total_duration'] ?? 0}',
            label: 'Minutes',
          ),
          _buildStatItem(
            icon: Icons.bolt,
            value: '${weeklyStats['total_calories'] ?? 0}',
            label: 'Calories',
          ),
          _buildStatItem(
            icon: Icons.whatshot,
            value: '$streak',
            label: 'Day Streak',
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String value,
    required String label,
  }) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 24),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildCategoryGrid() {
    final categories = [
      {
        'id': 'yoga',
        'name': 'Yoga',
        'icon': Icons.self_improvement,
        'color': Colors.purple,
      },
      {
        'id': 'hiit',
        'name': 'HIIT',
        'icon': Icons.flash_on,
        'color': Colors.orange,
      },
      {
        'id': 'strength',
        'name': 'Strength',
        'icon': Icons.fitness_center,
        'color': Colors.blue,
      },
      {
        'id': 'dance',
        'name': 'Dance',
        'icon': Icons.music_note,
        'color': Colors.pink,
      },
      {
        'id': 'bollywood',
        'name': 'Bollywood',
        'icon': Icons.movie,
        'color': Colors.red,
      },
      {
        'id': 'pranayama',
        'name': 'Pranayama',
        'icon': Icons.air,
        'color': Colors.teal,
      },
      {
        'id': 'cardio',
        'name': 'Cardio',
        'icon': Icons.directions_run,
        'color': Colors.green,
      },
      {
        'id': 'stretching',
        'name': 'Stretching',
        'icon': Icons.accessibility_new,
        'color': Colors.indigo,
      },
      {
        'id': 'outdoor',
        'name': 'Outdoor',
        'icon': Icons.directions_bike,
        'color': Colors.brown,
      },
      {
        'id': 'custom',
        'name': 'Custom',
        'icon': Icons.add_circle,
        'color': Colors.amber,
      },
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.5,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final category = categories[index];
        return _buildCategoryCard(
          id: category['id'] as String,
          name: category['name'] as String,
          icon: category['icon'] as IconData,
          color: category['color'] as Color,
        );
      },
    );
  }

  Widget _buildCategoryCard({
    required String id,
    required String name,
    required IconData icon,
    required Color color,
  }) {
    return InkWell(
      onTap: () {
        ref.read(workoutProvider.notifier).selectCategory(id);
        _showCategoryWorkouts(context, id, name);
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: color.withOpacity(0.15),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 8),
            Text(
              name,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showCategoryWorkouts(
    BuildContext context,
    String categoryId,
    String categoryName,
  ) {
    final workouts = ref.read(workoutsByCategoryProvider(categoryId));

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (context, scrollController) => Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.symmetric(vertical: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Text(
                      categoryName,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '${workouts.length} workouts',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: workouts.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.fitness_center,
                              size: 64,
                              color: Colors.grey[300],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'No workouts in this category',
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        controller: scrollController,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: workouts.length,
                        itemBuilder: (context, index) {
                          final workout = workouts[index];
                          return _buildWorkoutListItem(workout);
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWorkoutListItem(Workout workout) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () => context.push('/home/workout/${workout.id}'),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              // Thumbnail placeholder
              Container(
                width: 80,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: workout.thumbnailUrl != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          workout.thumbnailUrl!,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Icon(
                            Icons.play_circle_fill,
                            color: Colors.grey[400],
                            size: 32,
                          ),
                        ),
                      )
                    : Icon(
                        Icons.play_circle_fill,
                        color: Colors.grey[400],
                        size: 32,
                      ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      workout.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.timer, size: 14, color: Colors.grey[600]),
                        const SizedBox(width: 4),
                        Text(
                          workout.formattedDuration,
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Icon(
                          Icons.local_fire_department,
                          size: 14,
                          color: Colors.orange[400],
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${workout.caloriesBurn} cal',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickStartList(WorkoutState state) {
    // Show popular workouts
    final quickWorkouts = state.workouts.take(5).toList();

    return SizedBox(
      height: 160,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: quickWorkouts.length,
        itemBuilder: (context, index) {
          final workout = quickWorkouts[index];
          return _buildQuickStartCard(workout);
        },
      ),
    );
  }

  Widget _buildQuickStartCard(Workout workout) {
    return Container(
      width: 140,
      margin: const EdgeInsets.only(right: 12),
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () => context.push('/home/workout/${workout.id}'),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Thumbnail
              Container(
                height: 90,
                width: double.infinity,
                color: Colors.grey[200],
                child: workout.thumbnailUrl != null
                    ? Image.network(
                        workout.thumbnailUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => const Icon(
                          Icons.play_circle_fill,
                          size: 40,
                          color: Colors.grey,
                        ),
                      )
                    : const Icon(
                        Icons.play_circle_fill,
                        size: 40,
                        color: Colors.grey,
                      ),
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      workout.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      workout.formattedDuration,
                      style: TextStyle(color: Colors.grey[600], fontSize: 10),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRecentWorkouts(WorkoutState state) {
    final recentLogs = state.logs.take(5).toList();

    return Column(
      children: recentLogs.map((log) => _buildRecentWorkoutItem(log)).toList(),
    );
  }

  Widget _buildRecentWorkoutItem(WorkoutLog log) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: AppColors.primary.withOpacity(0.1),
          child: Icon(_getCategoryIcon(log.category), color: AppColors.primary),
        ),
        title: Text(log.workoutTitle),
        subtitle: Text(
          '${log.durationMinutes} min • ${log.caloriesBurned} cal',
          style: TextStyle(color: Colors.grey[600]),
        ),
        trailing: Text(
          _formatDate(log.startTime),
          style: TextStyle(color: Colors.grey[500], fontSize: 12),
        ),
      ),
    );
  }

  IconData _getCategoryIcon(String? category) {
    switch (category) {
      case 'yoga':
        return Icons.self_improvement;
      case 'hiit':
        return Icons.flash_on;
      case 'strength':
        return Icons.fitness_center;
      case 'dance':
        return Icons.music_note;
      case 'bollywood':
        return Icons.movie;
      case 'pranayama':
        return Icons.air;
      case 'cardio':
        return Icons.directions_run;
      case 'outdoor':
        return Icons.directions_bike;
      default:
        return Icons.fitness_center;
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final dateOnly = DateTime(date.year, date.month, date.day);

    if (dateOnly == today) {
      return 'Today';
    } else if (dateOnly == today.subtract(const Duration(days: 1))) {
      return 'Yesterday';
    } else {
      return '${date.day}/${date.month}';
    }
  }
}
