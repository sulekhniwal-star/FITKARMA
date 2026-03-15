// lib/features/workout/screens/workout_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../shared/theme/app_colors.dart';
import '../domain/workout_model.dart';
import '../providers/workout_providers.dart';
import 'workout_play_screen.dart';

/// Workout detail screen showing workout info and Start button
class WorkoutDetailScreen extends ConsumerWidget {
  final String workoutId;

  const WorkoutDetailScreen({super.key, required this.workoutId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final workout = ref.watch(workoutByIdProvider(workoutId));

    if (workout == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Workout')),
        body: const Center(child: Text('Workout not found')),
      );
    }

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // App bar with thumbnail
          SliverAppBar(
            expandedHeight: 250,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  // Thumbnail
                  if (workout.thumbnailUrl != null)
                    CachedNetworkImage(
                      imageUrl: workout.thumbnailUrl!,
                      fit: BoxFit.cover,
                      placeholder: (_, __) =>
                          Container(color: Colors.grey[300]),
                      errorWidget: (_, __, ___) => Container(
                        color: Colors.grey[300],
                        child: const Icon(Icons.play_circle_fill, size: 64),
                      ),
                    )
                  else
                    Container(
                      color: Colors.grey[300],
                      child: const Icon(Icons.play_circle_fill, size: 64),
                    ),
                  // Gradient overlay
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.7),
                        ],
                      ),
                    ),
                  ),
                  // Play button overlay
                  Center(
                    child: IconButton(
                      icon: const Icon(
                        Icons.play_circle_fill,
                        size: 72,
                        color: Colors.white,
                      ),
                      onPressed: () => _startWorkout(context, ref, workout),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Content
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    workout.title,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Category and difficulty chips
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _buildChip(
                        icon: _getCategoryIcon(workout.category),
                        label: workout.displayCategory,
                        color: _getCategoryColor(workout.category),
                      ),
                      _buildChip(
                        icon: Icons.speed,
                        label: workout.displayDifficulty,
                        color: _getDifficultyColor(workout.difficulty),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Stats row
                  _buildStatsRow(workout),
                  const SizedBox(height: 24),

                  // Description
                  Text(
                    'About this workout',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    workout.description,
                    style: TextStyle(color: Colors.grey[700], height: 1.5),
                  ),
                  const SizedBox(height: 24),

                  // Tags
                  if (workout.tags.isNotEmpty) ...[
                    Text(
                      'Tags',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: workout.tags.map((tag) {
                        return Chip(
                          label: Text(
                            '#$tag',
                            style: const TextStyle(fontSize: 12),
                          ),
                          backgroundColor: AppColors.primary.withOpacity(0.1),
                          side: BorderSide.none,
                          padding: EdgeInsets.zero,
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 24),
                  ],

                  // Tips section
                  _buildTipsSection(context, workout),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
      // Start button
      bottomSheet: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: SafeArea(
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => _startWorkout(context, ref, workout),
              icon: const Icon(Icons.play_arrow),
              label: const Text('Start Workout'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                textStyle: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _startWorkout(BuildContext context, WidgetRef ref, Workout workout) {
    // Start the workout
    ref.read(workoutProvider.notifier).startWorkout(workout);

    // Navigate to play screen
    context.push('/home/workout/${workout.id}/play');
  }

  Widget _buildChip({
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(color: color, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsRow(Workout workout) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem(
            icon: Icons.timer,
            value: workout.formattedDuration,
            label: 'Duration',
          ),
          _buildStatDivider(),
          _buildStatItem(
            icon: Icons.local_fire_department,
            value: '${workout.caloriesBurn}',
            label: 'Calories',
          ),
          _buildStatDivider(),
          _buildStatItem(
            icon: Icons.fitness_center,
            value: workout.displayDifficulty,
            label: 'Level',
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
        Icon(icon, color: AppColors.primary),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        Text(label, style: TextStyle(color: Colors.grey[600], fontSize: 12)),
      ],
    );
  }

  Widget _buildStatDivider() {
    return Container(height: 40, width: 1, color: Colors.grey[300]);
  }

  Widget _buildTipsSection(BuildContext context, Workout workout) {
    final tips = _getTipsForWorkout(workout.category);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Tips',
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        ...tips.map(
          (tip) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.lightbulb_outline,
                  color: Colors.amber,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(tip, style: TextStyle(color: Colors.grey[700])),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  List<String> _getTipsForWorkout(String category) {
    switch (category.toLowerCase()) {
      case 'yoga':
        return [
          'Practice on an empty stomach or light snack 2-3 hours before',
          'Use a yoga mat for better grip and comfort',
          'Focus on breathing throughout the practice',
          'Listen to your body and modify poses as needed',
        ];
      case 'hiit':
        return [
          'Warm up for 5 minutes before starting',
          'Keep rest periods short for maximum benefit',
          'Stay hydrated throughout the workout',
          'Cool down properly to prevent injury',
        ];
      case 'strength':
        return [
          'Maintain proper form to prevent injury',
          'Start with lighter weights and increase gradually',
          'Rest 1-2 minutes between sets',
          'Focus on controlled movements',
        ];
      case 'dance':
        return [
          'Wear comfortable clothing that allows movement',
          'Start with basic moves and build up',
          'Have fun and let the music guide you',
          'Stay hydrated - dancing is great cardio!',
        ];
      case 'bollywood':
        return [
          'Learn the basic steps before combining them',
          'Keep your energy high throughout',
          'Don\'t worry about perfection - enjoy the movement',
          'Bollywood workouts are great for coordination',
        ];
      case 'pranayama':
        return [
          'Practice in a calm, quiet environment',
          'Breathe through your nose unless otherwise instructed',
          'Start with shorter sessions and build up',
          'Avoid practicing right after a heavy meal',
        ];
      default:
        return [
          'Warm up before starting',
          'Stay hydrated',
          'Listen to your body',
          'Cool down after the workout',
        ];
    }
  }

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
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
      case 'stretching':
        return Icons.accessibility_new;
      default:
        return Icons.fitness_center;
    }
  }

  Color _getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'yoga':
        return Colors.purple;
      case 'hiit':
        return Colors.orange;
      case 'strength':
        return Colors.blue;
      case 'dance':
        return Colors.pink;
      case 'bollywood':
        return Colors.red;
      case 'pranayama':
        return Colors.teal;
      case 'cardio':
        return Colors.green;
      case 'outdoor':
        return Colors.brown;
      case 'stretching':
        return Colors.indigo;
      default:
        return AppColors.primary;
    }
  }

  Color _getDifficultyColor(String difficulty) {
    switch (difficulty.toLowerCase()) {
      case 'beginner':
        return Colors.green;
      case 'intermediate':
        return Colors.orange;
      case 'advanced':
        return Colors.red;
      default:
        return Colors.green;
    }
  }
}
