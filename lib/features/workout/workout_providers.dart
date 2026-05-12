import 'dart:async';
import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:uuid/uuid.dart';
import '../../core/database/app_database.dart';
import '../../core/providers/core_providers.dart';
import '../karma/karma_providers.dart';

class WorkoutSet {
  final int setNumber;
  final double weightKg;
  final int reps;
  final bool isCompleted;

  WorkoutSet({
    required this.setNumber,
    required this.weightKg,
    required this.reps,
    this.isCompleted = true,
  });

  Map<String, dynamic> toJson() => {
        'setNumber': setNumber,
        'weightKg': weightKg,
        'reps': reps,
        'isCompleted': isCompleted,
      };

  factory WorkoutSet.fromJson(Map<String, dynamic> json) => WorkoutSet(
        setNumber: json['setNumber'] as int,
        weightKg: (json['weightKg'] as num).toDouble(),
        reps: json['reps'] as int,
        isCompleted: json['isCompleted'] as bool? ?? true,
      );
}

class ExerciseSession {
  final String name;
  final String category;
  final List<WorkoutSet> sets;

  ExerciseSession({
    required this.name,
    required this.category,
    required this.sets,
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'category': category,
        'sets': sets.map((s) => s.toJson()).toList(),
      };

  factory ExerciseSession.fromJson(Map<String, dynamic> json) => ExerciseSession(
        name: json['name'] as String,
        category: json['category'] as String? ?? 'Strength',
        sets: (json['sets'] as List<dynamic>).map((e) => WorkoutSet.fromJson(e as Map<String, dynamic>)).toList(),
      );
}

class ActiveWorkoutState {
  final String workoutId;
  final String workoutType;
  final int elapsedSeconds;
  final int currentExerciseIndex;
  final List<ExerciseSession> exercises;

  ActiveWorkoutState({
    required this.workoutId,
    required this.workoutType,
    required this.elapsedSeconds,
    required this.currentExerciseIndex,
    required this.exercises,
  });

  int get estimatedCaloriesBurned {
    // Metabolic equivalent burn rule estimate: ~8 kcal per minute of vigorous strength exercise
    return (8.0 * (elapsedSeconds / 60.0)).round();
  }

  ExerciseSession? get currentExercise {
    if (exercises.isEmpty || currentExerciseIndex < 0 || currentExerciseIndex >= exercises.length) return null;
    return exercises[currentExerciseIndex];
  }

  factory ActiveWorkoutState.initial(String id, String type) {
    return ActiveWorkoutState(
      workoutId: id,
      workoutType: type,
      elapsedSeconds: 0,
      currentExerciseIndex: 0,
      exercises: [
        ExerciseSession(name: 'Barbell Deadlift', category: 'Posterior Chain', sets: []),
        ExerciseSession(name: 'Overhead Barbell Press', category: 'Shoulders', sets: []),
        ExerciseSession(name: 'Weighted Pull-Ups', category: 'Lats', sets: []),
        ExerciseSession(name: 'Hanging Leg Raises', category: 'Core Stability', sets: []),
      ],
    );
  }
}

class ActiveWorkoutNotifier extends FamilyNotifier<ActiveWorkoutState, String> {
  Timer? _timer;
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  @override
  ActiveWorkoutState build(String arg) {
    final parts = arg.split('_');
    final typeStr = parts.length > 1 ? Uri.decodeComponent(parts.sublist(1).join('_')) : 'Hypertrophy Power Circuit';
    final stateObj = ActiveWorkoutState.initial(parts[0], typeStr);

    ref.onDispose(() {
      _timer?.cancel();
    });

    _startTimer(stateObj);
    return stateObj;
  }

  void _startTimer(ActiveWorkoutState initialState) {
    _timer?.cancel();
    // Schedule periodic update
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      state = ActiveWorkoutState(
        workoutId: state.workoutId,
        workoutType: state.workoutType,
        elapsedSeconds: state.elapsedSeconds + 1,
        currentExerciseIndex: state.currentExerciseIndex,
        exercises: state.exercises,
      );
    });
  }

  void logSet(double weightKg, int reps) {
    if (state.currentExercise == null) return;

    final updatedExercises = [...state.exercises];
    final activeEx = updatedExercises[state.currentExerciseIndex];
    
    final nextSetNum = activeEx.sets.length + 1;
    final newSet = WorkoutSet(setNumber: nextSetNum, weightKg: weightKg, reps: reps);

    final updatedSets = [...activeEx.sets, newSet];
    updatedExercises[state.currentExerciseIndex] = ExerciseSession(
      name: activeEx.name,
      category: activeEx.category,
      sets: updatedSets,
    );

    state = ActiveWorkoutState(
      workoutId: state.workoutId,
      workoutType: state.workoutType,
      elapsedSeconds: state.elapsedSeconds,
      currentExerciseIndex: state.currentExerciseIndex,
      exercises: updatedExercises,
    );
  }

  void nextExercise() {
    if (state.currentExerciseIndex < state.exercises.length - 1) {
      state = ActiveWorkoutState(
        workoutId: state.workoutId,
        workoutType: state.workoutType,
        elapsedSeconds: state.elapsedSeconds,
        currentExerciseIndex: state.currentExerciseIndex + 1,
        exercises: state.exercises,
      );
    }
  }

  void previousExercise() {
    if (state.currentExerciseIndex > 0) {
      state = ActiveWorkoutState(
        workoutId: state.workoutId,
        workoutType: state.workoutType,
        elapsedSeconds: state.elapsedSeconds,
        currentExerciseIndex: state.currentExerciseIndex - 1,
        exercises: state.exercises,
      );
    }
  }

  Future<void> finalizeWorkout(WidgetRef ref) async {
    _timer?.cancel();

    final db = ref.read(appDatabaseProvider);
    final finalId = const Uuid().v4();
    final durationMins = (state.elapsedSeconds / 60.0).ceil();
    final cals = state.estimatedCaloriesBurned;

    // 1. Save to Drift on complete
    // syncStatus 'pending' naturally initiates cloud synchronization pipeline loops
    await db.into(db.workouts).insert(
          WorkoutsCompanion.insert(
            id: finalId,
            userId: 'active_session_user',
            type: state.workoutType,
            durationMinutes: durationMins > 0 ? durationMins : 1,
            caloriesBurned: cals > 0 ? cals : 15,
            startedAt: DateTime.now().subtract(Duration(seconds: state.elapsedSeconds)),
          ),
        );

    // 2. Persist detailed sets list payload metadata inside isolated secure storage cache keys
    final setsPayload = jsonEncode(state.exercises.map((e) => e.toJson()).toList());
    await _storage.write(key: 'wkt_meta_$finalId', value: setsPayload);

    // 3. Award substantial Karma loyalty rewards
    ref.read(karmaStateProvider.notifier).addKarmaEvent(
          'Completed ${state.workoutType}',
          'workout',
          120,
        );
  }
}

final activeWorkoutProvider = NotifierProvider.family<ActiveWorkoutNotifier, ActiveWorkoutState, String>(ActiveWorkoutNotifier.new);
