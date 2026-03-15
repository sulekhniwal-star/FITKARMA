// lib/features/workout/domain/workout_model.dart
import 'package:hive/hive.dart';

part 'workout_model.g.dart';

/// Workout categories
enum WorkoutCategory {
  yoga,
  hiit,
  strength,
  dance,
  bollywood,
  pranayama,
  cardio,
  stretching,
  outdoor,
  custom,
}

/// Difficulty levels
enum WorkoutDifficulty { beginner, intermediate, advanced }

/// Main workout model
@HiveType(typeId: 30)
class Workout extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String title;

  @HiveField(2)
  String description;

  @HiveField(3)
  String category; // yoga, hiit, strength, etc.

  @HiveField(4)
  String youtubeId;

  @HiveField(5)
  int durationMinutes;

  @HiveField(6)
  String difficulty; // beginner, intermediate, advanced

  @HiveField(7)
  String? thumbnailUrl;

  @HiveField(8)
  List<String> tags;

  @HiveField(9)
  int caloriesBurn;

  @HiveField(10)
  bool isCustom;

  @HiveField(11)
  DateTime? createdAt;

  Workout({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.youtubeId,
    required this.durationMinutes,
    required this.difficulty,
    this.thumbnailUrl,
    this.tags = const [],
    this.caloriesBurn = 0,
    this.isCustom = false,
    this.createdAt,
  });

  /// Create from Appwrite document
  factory Workout.fromAppwrite(Map<String, dynamic> data, String docId) {
    return Workout(
      id: docId,
      title: data['title'] as String? ?? '',
      description: data['description'] as String? ?? '',
      category: data['category'] as String? ?? 'general',
      youtubeId: data['youtube_id'] as String? ?? '',
      durationMinutes: data['duration_minutes'] as int? ?? 0,
      difficulty: data['difficulty'] as String? ?? 'beginner',
      thumbnailUrl: data['thumbnail_url'] as String?,
      tags: (data['tags'] as List<dynamic>?)?.cast<String>() ?? [],
      caloriesBurn: data['calories_burn'] as int? ?? 0,
      isCustom: data['is_custom'] as bool? ?? false,
      createdAt: data['created_at'] != null
          ? DateTime.parse(data['created_at'] as String)
          : null,
    );
  }

  /// Convert to Appwrite document
  Map<String, dynamic> toAppwrite() => {
    'title': title,
    'description': description,
    'category': category,
    'youtube_id': youtubeId,
    'duration_minutes': durationMinutes,
    'difficulty': difficulty,
    'thumbnail_url': thumbnailUrl,
    'tags': tags,
    'calories_burn': caloriesBurn,
    'is_custom': isCustom,
    'created_at':
        createdAt?.toIso8601String() ?? DateTime.now().toIso8601String(),
  };

  /// Get category enum
  WorkoutCategory get categoryEnum {
    switch (category.toLowerCase()) {
      case 'yoga':
        return WorkoutCategory.yoga;
      case 'hiit':
        return WorkoutCategory.hiit;
      case 'strength':
        return WorkoutCategory.strength;
      case 'dance':
        return WorkoutCategory.dance;
      case 'bollywood':
        return WorkoutCategory.bollywood;
      case 'pranayama':
        return WorkoutCategory.pranayama;
      case 'cardio':
        return WorkoutCategory.cardio;
      case 'stretching':
        return WorkoutCategory.stretching;
      case 'outdoor':
        return WorkoutCategory.outdoor;
      case 'custom':
        return WorkoutCategory.custom;
      default:
        return WorkoutCategory.yoga;
    }
  }

  /// Get difficulty enum
  WorkoutDifficulty get difficultyEnum {
    switch (difficulty.toLowerCase()) {
      case 'beginner':
        return WorkoutDifficulty.beginner;
      case 'intermediate':
        return WorkoutDifficulty.intermediate;
      case 'advanced':
        return WorkoutDifficulty.advanced;
      default:
        return WorkoutDifficulty.beginner;
    }
  }

  /// Get display category name
  String get displayCategory {
    switch (categoryEnum) {
      case WorkoutCategory.yoga:
        return 'Yoga';
      case WorkoutCategory.hiit:
        return 'HIIT';
      case WorkoutCategory.strength:
        return 'Strength';
      case WorkoutCategory.dance:
        return 'Dance';
      case WorkoutCategory.bollywood:
        return 'Bollywood';
      case WorkoutCategory.pranayama:
        return 'Pranayama';
      case WorkoutCategory.cardio:
        return 'Cardio';
      case WorkoutCategory.stretching:
        return 'Stretching';
      case WorkoutCategory.outdoor:
        return 'Outdoor';
      case WorkoutCategory.custom:
        return 'Custom';
    }
  }

  /// Get display difficulty
  String get displayDifficulty {
    switch (difficultyEnum) {
      case WorkoutDifficulty.beginner:
        return 'Beginner';
      case WorkoutDifficulty.intermediate:
        return 'Intermediate';
      case WorkoutDifficulty.advanced:
        return 'Advanced';
    }
  }

  /// Get formatted duration
  String get formattedDuration {
    if (durationMinutes < 60) {
      return '$durationMinutes min';
    }
    final hours = durationMinutes ~/ 60;
    final mins = durationMinutes % 60;
    if (mins == 0) {
      return '$hours hr';
    }
    return '$hours hr $mins min';
  }
}

/// Exercise within a custom workout
@HiveType(typeId: 31)
class WorkoutExercise extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  int sets;

  @HiveField(3)
  int reps;

  @HiveField(4)
  int restSeconds;

  @HiveField(5)
  int? durationSeconds; // For timed exercises

  @HiveField(6)
  String? notes;

  @HiveField(7)
  double? weightKg;

  WorkoutExercise({
    required this.id,
    required this.name,
    this.sets = 3,
    this.reps = 10,
    this.restSeconds = 30,
    this.durationSeconds,
    this.notes,
    this.weightKg,
  });

  /// Copy with modifications
  WorkoutExercise copyWith({
    String? id,
    String? name,
    int? sets,
    int? reps,
    int? restSeconds,
    int? durationSeconds,
    String? notes,
    double? weightKg,
  }) {
    return WorkoutExercise(
      id: id ?? this.id,
      name: name ?? this.name,
      sets: sets ?? this.sets,
      reps: reps ?? this.reps,
      restSeconds: restSeconds ?? this.restSeconds,
      durationSeconds: durationSeconds ?? this.durationSeconds,
      notes: notes ?? this.notes,
      weightKg: weightKg ?? this.weightKg,
    );
  }

  /// Get formatted rest time
  String get formattedRest {
    if (restSeconds < 60) {
      return '${restSeconds}s rest';
    }
    final mins = restSeconds ~/ 60;
    final secs = restSeconds % 60;
    if (secs == 0) {
      return '${mins}m rest';
    }
    return '${mins}m ${secs}s rest';
  }
}

/// Custom workout with exercises
@HiveType(typeId: 32)
class CustomWorkout extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String title;

  @HiveField(2)
  String description;

  @HiveField(3)
  List<WorkoutExercise> exercises;

  @HiveField(4)
  DateTime createdAt;

  @HiveField(5)
  DateTime? lastPerformed;

  CustomWorkout({
    required this.id,
    required this.title,
    this.description = '',
    this.exercises = const [],
    required this.createdAt,
    this.lastPerformed,
  });

  /// Calculate total duration in minutes
  int get totalDurationMinutes {
    int total = 0;
    for (final exercise in exercises) {
      // Time for sets (assuming avg 30 sec per rep)
      total += (exercise.sets * exercise.reps * 30) ~/ 60;
      // Rest time
      total += (exercise.sets * exercise.restSeconds) ~/ 60;
    }
    return total.clamp(1, 999);
  }

  /// Get formatted duration
  String get formattedDuration {
    final mins = totalDurationMinutes;
    if (mins < 60) {
      return '$mins min';
    }
    final hours = mins ~/ 60;
    final remainingMins = mins % 60;
    if (remainingMins == 0) {
      return '$hours hr';
    }
    return '$hours hr $remainingMins min';
  }
}

/// Workout log entry
@HiveType(typeId: 33)
class WorkoutLog extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String odId;

  @HiveField(2)
  String workoutId;

  @HiveField(3)
  String workoutTitle;

  @HiveField(4)
  DateTime startTime;

  @HiveField(5)
  DateTime? endTime;

  @HiveField(6)
  int durationMinutes;

  @HiveField(7)
  int caloriesBurned;

  @HiveField(8)
  String? notes;

  @HiveField(9)
  String syncStatus; // 'pending' | 'synced'

  @HiveField(10)
  String? category;

  @HiveField(11)
  String difficulty;

  @HiveField(12)
  double? distanceKm; // For outdoor workouts

  WorkoutLog({
    required this.id,
    required this.odId,
    required this.workoutId,
    required this.workoutTitle,
    required this.startTime,
    this.endTime,
    this.durationMinutes = 0,
    this.caloriesBurned = 0,
    this.notes,
    this.syncStatus = 'pending',
    this.category,
    this.difficulty = 'beginner',
    this.distanceKm,
  });

  /// Create a new workout log
  factory WorkoutLog.create({
    required String odId,
    required String workoutId,
    required String workoutTitle,
    String? category,
    String difficulty = 'beginner',
  }) {
    return WorkoutLog(
      id: '${odId}_${DateTime.now().millisecondsSinceEpoch}',
      odId: odId,
      workoutId: workoutId,
      workoutTitle: workoutTitle,
      startTime: DateTime.now(),
      category: category,
      difficulty: difficulty,
    );
  }

  /// Mark as completed
  void complete({
    int? durationMinutes,
    int? caloriesBurned,
    String? notes,
    double? distanceKm,
  }) {
    endTime = DateTime.now();
    if (durationMinutes != null) this.durationMinutes = durationMinutes;
    if (caloriesBurned != null) this.caloriesBurned = caloriesBurned;
    if (notes != null) this.notes = notes;
    if (distanceKm != null) this.distanceKm = distanceKm;
  }

  /// Convert to Appwrite document
  Map<String, dynamic> toAppwrite() => {
    'user_id': odId,
    'workout_id': workoutId,
    'workout_title': workoutTitle,
    'start_time': startTime.toIso8601String(),
    'end_time': endTime?.toIso8601String(),
    'duration_minutes': durationMinutes,
    'calories_burned': caloriesBurned,
    'notes': notes,
    'category': category,
    'difficulty': difficulty,
    'distance_km': distanceKm,
  };
}

/// Personal record for exercises
@HiveType(typeId: 34)
class PersonalRecord extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String odId;

  @HiveField(2)
  String exerciseName;

  @HiveField(3)
  double maxWeight; // kg

  @HiveField(4)
  int maxReps;

  @HiveField(5)
  int maxDuration; // seconds

  @HiveField(6)
  DateTime achievedAt;

  @HiveField(7)
  String? workoutLogId;

  @HiveField(8)
  String recordType; // 'weight', 'reps', 'duration'

  PersonalRecord({
    required this.id,
    required this.odId,
    required this.exerciseName,
    required this.maxWeight,
    required this.maxReps,
    required this.maxDuration,
    required this.achievedAt,
    this.workoutLogId,
    required this.recordType,
  });

  /// Create new personal record
  factory PersonalRecord.create({
    required String odId,
    required String exerciseName,
    double? maxWeight,
    int? maxReps,
    int? maxDuration,
    String? workoutLogId,
  }) {
    String recordType = 'weight';
    double weight = maxWeight ?? 0;
    int reps = maxReps ?? 0;
    int duration = maxDuration ?? 0;

    if (maxWeight != null) {
      recordType = 'weight';
    } else if (maxReps != null) {
      recordType = 'reps';
    } else if (maxDuration != null) {
      recordType = 'duration';
    }

    return PersonalRecord(
      id: '${odId}_${exerciseName}_${DateTime.now().millisecondsSinceEpoch}',
      odId: odId,
      exerciseName: exerciseName,
      maxWeight: weight,
      maxReps: reps,
      maxDuration: duration,
      achievedAt: DateTime.now(),
      workoutLogId: workoutLogId,
      recordType: recordType,
    );
  }

  /// Convert to Appwrite document
  Map<String, dynamic> toAppwrite() => {
    'user_id': odId,
    'exercise_name': exerciseName,
    'max_weight': maxWeight,
    'max_reps': maxReps,
    'max_duration': maxDuration,
    'achieved_at': achievedAt.toIso8601String(),
    'workout_log_id': workoutLogId,
    'record_type': recordType,
  };
}

/// Scheduled workout for calendar
@HiveType(typeId: 35)
class ScheduledWorkout extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String odId;

  @HiveField(2)
  String workoutId;

  @HiveField(3)
  String title;

  @HiveField(4)
  DateTime scheduledDate;

  @HiveField(5)
  String? workoutType; // 'video', 'custom', 'outdoor'

  @HiveField(6)
  bool isRestDay;

  @HiveField(7)
  String? notes;

  @HiveField(8)
  bool completed;

  @HiveField(9)
  String syncStatus;

  ScheduledWorkout({
    required this.id,
    required this.odId,
    required this.workoutId,
    required this.title,
    required this.scheduledDate,
    this.workoutType,
    this.isRestDay = false,
    this.notes,
    this.completed = false,
    this.syncStatus = 'pending',
  });

  /// Create a scheduled workout
  factory ScheduledWorkout.create({
    required String odId,
    required String workoutId,
    required String title,
    required DateTime scheduledDate,
    String? workoutType,
    String? notes,
    bool isRestDay = false,
  }) {
    return ScheduledWorkout(
      id: '${odId}_${scheduledDate.millisecondsSinceEpoch}',
      odId: odId,
      workoutId: workoutId,
      title: title,
      scheduledDate: scheduledDate,
      workoutType: workoutType,
      notes: notes,
      isRestDay: isRestDay,
    );
  }

  /// Create a rest day
  factory ScheduledWorkout.restDay({
    required String odId,
    required DateTime scheduledDate,
    String? notes,
  }) {
    return ScheduledWorkout(
      id: '${odId}_rest_${scheduledDate.millisecondsSinceEpoch}',
      odId: odId,
      workoutId: 'rest',
      title: 'Rest Day',
      scheduledDate: scheduledDate,
      workoutType: 'rest',
      notes: notes,
      isRestDay: true,
    );
  }

  /// Mark as completed
  void markCompleted() {
    completed = true;
  }

  /// Convert to Appwrite document
  Map<String, dynamic> toAppwrite() => {
    'user_id': odId,
    'workout_id': workoutId,
    'title': title,
    'scheduled_date': scheduledDate.toIso8601String(),
    'workout_type': workoutType,
    'is_rest_day': isRestDay,
    'notes': notes,
    'completed': completed,
  };
}
