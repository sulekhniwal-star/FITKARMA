import 'package:appwrite/models.dart' as models;

class WorkoutLog {
  final String id;
  final String userId;
  final String workoutId;
  final String workoutTitle;
  final int durationMinutes;
  final int caloriesBurned;
  final DateTime completedAt;
  final String syncStatus;

  WorkoutLog({
    required this.id,
    required this.userId,
    required this.workoutId,
    required this.workoutTitle,
    required this.durationMinutes,
    required this.caloriesBurned,
    required this.completedAt,
    this.syncStatus = 'synced',
  });

  factory WorkoutLog.fromAppwrite(models.Document doc) {
    return WorkoutLog(
      id: doc.$id,
      userId: doc.data['user_id'] ?? '',
      workoutId: doc.data['workout_id'] ?? '',
      workoutTitle: doc.data['workout_title'] ?? '',
      durationMinutes: doc.data['duration_minutes'] ?? 0,
      caloriesBurned: doc.data['calories_burned'] ?? 0,
      completedAt: DateTime.parse(doc.data['completed_at'] ?? doc.$createdAt),
      syncStatus: 'synced',
    );
  }

  Map<String, dynamic> toAppwrite() {
    return {
      'user_id': userId,
      'workout_id': workoutId,
      'workout_title': workoutTitle,
      'duration_minutes': durationMinutes,
      'calories_burned': caloriesBurned,
      'completed_at': completedAt.toIso8601String(),
    };
  }
}
