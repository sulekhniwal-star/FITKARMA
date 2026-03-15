// lib/features/workout/screens/workout_play_screen.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../../../shared/theme/app_colors.dart';
import '../domain/workout_model.dart';
import '../providers/workout_providers.dart';

/// Workout play screen with YouTube player
class WorkoutPlayScreen extends ConsumerStatefulWidget {
  final String workoutId;

  const WorkoutPlayScreen({super.key, required this.workoutId});

  @override
  ConsumerState<WorkoutPlayScreen> createState() => _WorkoutPlayScreenState();
}

class _WorkoutPlayScreenState extends ConsumerState<WorkoutPlayScreen> {
  YoutubePlayerController? _youtubeController;
  Timer? _workoutTimer;
  int _elapsedSeconds = 0;
  bool _isPlaying = false;
  bool _showCompletionDialog = false;

  @override
  void initState() {
    super.initState();
    _startTimer();
    _initYoutubePlayer();
  }

  void _initYoutubePlayer() {
    final workout = ref.read(workoutByIdProvider(widget.workoutId));
    if (workout != null && workout.youtubeId.isNotEmpty) {
      _youtubeController = YoutubePlayerController(
        initialVideoId: workout.youtubeId,
        flags: const YoutubePlayerFlags(
          autoPlay: true,
          mute: false,
          enableCaption: false,
          hideControls: false,
          loop: true,
        ),
      );
      _youtubeController?.addListener(() {
        if (_youtubeController != null) {
          setState(() {
            _isPlaying = _youtubeController!.value.isPlaying;
          });
        }
      });
    }
  }

  void _startTimer() {
    _workoutTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _elapsedSeconds++;
      });
    });
  }

  String get _formattedTime {
    final hours = _elapsedSeconds ~/ 3600;
    final minutes = (_elapsedSeconds % 3600) ~/ 60;
    final seconds = _elapsedSeconds % 60;
    if (hours > 0) {
      return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    }
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  int get _elapsedMinutes => _elapsedSeconds ~/ 60;

  void _completeWorkout() {
    setState(() {
      _showCompletionDialog = true;
    });
  }

  Future<void> _saveWorkout() async {
    // Calculate calories burned (rough estimate: 5-10 cal per minute depending on intensity)
    final caloriesBurned = _elapsedMinutes * 7;

    await ref
        .read(workoutProvider.notifier)
        .completeWorkout(
          durationMinutes: _elapsedMinutes,
          caloriesBurned: caloriesBurned,
        );

    if (mounted) {
      // Show success and go back
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Workout completed! +20 XP earned'),
          backgroundColor: Colors.green,
        ),
      );
      context.go('/home/workout');
    }
  }

  void _cancelWorkout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cancel Workout?'),
        content: const Text(
          'Are you sure you want to cancel? Your progress will not be saved.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Continue'),
          ),
          TextButton(
            onPressed: () {
              ref.read(workoutProvider.notifier).cancelWorkout();
              Navigator.pop(context);
              context.go('/home/workout');
            },
            child: const Text('Cancel Workout'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _workoutTimer?.cancel();
    _youtubeController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final workout = ref.watch(workoutByIdProvider(widget.workoutId));

    if (workout == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Workout')),
        body: const Center(child: Text('Workout not found')),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: Text(workout.title, style: const TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: _cancelWorkout,
        ),
      ),
      body: Column(
        children: [
          // YouTube Player
          if (_youtubeController != null)
            AspectRatio(
              aspectRatio: 16 / 9,
              child: YoutubePlayer(
                controller: _youtubeController!,
                showVideoProgressIndicator: true,
                progressIndicatorColor: AppColors.primary,
                onEnded: (metaData) {
                  // Optionally loop or show completion
                },
              ),
            )
          else
            Container(
              height: 200,
              color: Colors.grey[900],
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.fitness_center,
                      size: 64,
                      color: Colors.grey[600],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'No video available',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
            ),

          // Workout info and timer
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Column(
                children: [
                  // Timer section
                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        // Timer display
                        Text(
                          _formattedTime,
                          style: const TextStyle(
                            fontSize: 48,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _isPlaying ? 'Workout in progress' : 'Paused',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Control buttons
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Play/Pause button
                            IconButton(
                              onPressed: () {
                                if (_youtubeController != null) {
                                  if (_youtubeController!.value.isPlaying) {
                                    _youtubeController!.pause();
                                  } else {
                                    _youtubeController!.play();
                                  }
                                }
                                setState(() {
                                  _isPlaying = !_isPlaying;
                                });
                              },
                              icon: Icon(
                                _isPlaying
                                    ? Icons.pause_circle_filled
                                    : Icons.play_circle_filled,
                                size: 64,
                                color: AppColors.primary,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Workout stats
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(20),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Workout Stats',
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: _buildStatCard(
                                  icon: Icons.timer,
                                  label: 'Duration',
                                  value: '${_elapsedMinutes} min',
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: _buildStatCard(
                                  icon: Icons.local_fire_department,
                                  label: 'Est. Calories',
                                  value: '${_elapsedMinutes * 7} cal',
                                ),
                              ),
                            ],
                          ),
                          const Spacer(),

                          // Complete button
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: _completeWorkout,
                              icon: const Icon(Icons.check),
                              label: const Text('Complete Workout'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: AppColors.primary, size: 28),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Text(label, style: TextStyle(color: Colors.grey[600], fontSize: 12)),
        ],
      ),
    );
  }
}
