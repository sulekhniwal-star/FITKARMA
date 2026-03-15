// lib/features/workout/screens/custom_workout_builder_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../shared/theme/app_colors.dart';
import '../domain/workout_model.dart';
import '../providers/workout_providers.dart';

/// Custom workout builder screen
class CustomWorkoutBuilderScreen extends ConsumerStatefulWidget {
  const CustomWorkoutBuilderScreen({super.key});

  @override
  ConsumerState<CustomWorkoutBuilderScreen> createState() =>
      _CustomWorkoutBuilderScreenState();
}

class _CustomWorkoutBuilderScreenState
    extends ConsumerState<CustomWorkoutBuilderScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  List<WorkoutExercise> _exercises = [];
  bool _isEditing = false;
  int? _editingIndex;

  // Exercise form controllers
  final _exerciseNameController = TextEditingController();
  int _sets = 3;
  int _reps = 10;
  int _restSeconds = 30;
  int? _durationSeconds;
  double? _weightKg;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _exerciseNameController.dispose();
    super.dispose();
  }

  void _addExercise() {
    if (_exerciseNameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter exercise name')),
      );
      return;
    }

    final exercise = WorkoutExercise(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: _exerciseNameController.text,
      sets: _sets,
      reps: _reps,
      restSeconds: _restSeconds,
      durationSeconds: _durationSeconds,
      weightKg: _weightKg,
    );

    setState(() {
      if (_isEditing && _editingIndex != null) {
        _exercises[_editingIndex!] = exercise;
        _isEditing = false;
        _editingIndex = null;
      } else {
        _exercises.add(exercise);
      }

      // Reset form
      _exerciseNameController.clear();
      _sets = 3;
      _reps = 10;
      _restSeconds = 30;
      _durationSeconds = null;
      _weightKg = null;
    });
  }

  void _editExercise(int index) {
    final exercise = _exercises[index];
    setState(() {
      _isEditing = true;
      _editingIndex = index;
      _exerciseNameController.text = exercise.name;
      _sets = exercise.sets;
      _reps = exercise.reps;
      _restSeconds = exercise.restSeconds;
      _durationSeconds = exercise.durationSeconds;
      _weightKg = exercise.weightKg;
    });
  }

  void _deleteExercise(int index) {
    setState(() {
      _exercises.removeAt(index);
    });
  }

  void _saveWorkout() async {
    if (!_formKey.currentState!.validate()) return;

    if (_exercises.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please add at least one exercise')),
      );
      return;
    }

    final workout = CustomWorkout(
      id: 'custom_${DateTime.now().millisecondsSinceEpoch}',
      title: _titleController.text,
      description: _descriptionController.text,
      exercises: _exercises,
      createdAt: DateTime.now(),
    );

    await ref.read(workoutProvider.notifier).addCustomWorkout(workout);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Custom workout saved!'),
          backgroundColor: Colors.green,
        ),
      );
      context.go('/home/workout');
    }
  }

  int get _totalDurationMinutes {
    int total = 0;
    for (final exercise in _exercises) {
      // Estimate 30 seconds per rep
      total += (exercise.sets * exercise.reps * 30) ~/ 60;
      total += (exercise.sets * exercise.restSeconds) ~/ 60;
    }
    return total.clamp(1, 999);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Custom Workout'),
        actions: [
          TextButton(onPressed: _saveWorkout, child: const Text('Save')),
        ],
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    TextFormField(
                      controller: _titleController,
                      decoration: const InputDecoration(
                        labelText: 'Workout Name',
                        hintText: 'e.g., Morning Strength',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Description
                    TextFormField(
                      controller: _descriptionController,
                      decoration: const InputDecoration(
                        labelText: 'Description (optional)',
                        hintText: 'Describe your workout...',
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 2,
                    ),
                    const SizedBox(height: 24),

                    // Exercise form
                    _buildExerciseForm(),
                    const SizedBox(height: 24),

                    // Exercises list
                    if (_exercises.isNotEmpty) ...[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Exercises (${_exercises.length})',
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'Est. ${_totalDurationMinutes} min',
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      ..._exercises.asMap().entries.map((entry) {
                        return _buildExerciseItem(entry.key, entry.value);
                      }),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExerciseForm() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _isEditing ? 'Edit Exercise' : 'Add Exercise',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),

          // Exercise name
          TextFormField(
            controller: _exerciseNameController,
            decoration: const InputDecoration(
              labelText: 'Exercise Name',
              hintText: 'e.g., Push-ups',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),

          // Sets and Reps
          Row(
            children: [
              Expanded(
                child: _buildNumberField(
                  label: 'Sets',
                  value: _sets,
                  min: 1,
                  max: 10,
                  onChanged: (value) => setState(() => _sets = value),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildNumberField(
                  label: 'Reps',
                  value: _reps,
                  min: 1,
                  max: 100,
                  onChanged: (value) => setState(() => _reps = value),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Rest time
          _buildNumberField(
            label: 'Rest between sets (seconds)',
            value: _restSeconds,
            min: 0,
            max: 300,
            step: 5,
            onChanged: (value) => setState(() => _restSeconds = value),
          ),
          const SizedBox(height: 12),

          // Weight (optional)
          Row(
            children: [
              Expanded(
                child: _buildNumberField(
                  label: 'Weight (kg) - optional',
                  value: _weightKg?.toInt() ?? 0,
                  min: 0,
                  max: 500,
                  allowZero: true,
                  onChanged: (value) => setState(
                    () => _weightKg = value > 0 ? value.toDouble() : null,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Add button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _addExercise,
              icon: Icon(_isEditing ? Icons.check : Icons.add),
              label: Text(_isEditing ? 'Update Exercise' : 'Add Exercise'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
              ),
            ),
          ),

          if (_isEditing)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: TextButton(
                onPressed: () {
                  setState(() {
                    _isEditing = false;
                    _editingIndex = null;
                    _exerciseNameController.clear();
                    _sets = 3;
                    _reps = 10;
                    _restSeconds = 30;
                    _weightKg = null;
                  });
                },
                child: const Text('Cancel Edit'),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildNumberField({
    required String label,
    required int value,
    required int min,
    required int max,
    int step = 1,
    bool allowZero = false,
    required Function(int) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            IconButton(
              onPressed: (allowZero ? value > min : value > min + step - 1)
                  ? () => onChanged(
                      (value - step).clamp(
                        allowZero ? min : min + step - 1,
                        max,
                      ),
                    )
                  : null,
              icon: const Icon(Icons.remove_circle_outline),
              color: AppColors.primary,
            ),
            Expanded(
              child: Text(
                '$value',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            IconButton(
              onPressed: value < max
                  ? () => onChanged(
                      (value + step).clamp(
                        allowZero ? min : min + step - 1,
                        max,
                      ),
                    )
                  : null,
              icon: const Icon(Icons.add_circle_outline),
              color: AppColors.primary,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildExerciseItem(int index, WorkoutExercise exercise) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: AppColors.primary.withOpacity(0.1),
          child: Text(
            '${index + 1}',
            style: const TextStyle(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: Text(exercise.name),
        subtitle: Text(
          '${exercise.sets} sets × ${exercise.reps} reps • ${exercise.formattedRest}',
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit, size: 20),
              onPressed: () => _editExercise(index),
            ),
            IconButton(
              icon: const Icon(Icons.delete, size: 20, color: Colors.red),
              onPressed: () => _deleteExercise(index),
            ),
          ],
        ),
      ),
    );
  }
}
