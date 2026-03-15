// lib/features/steps/domain/step_log_model.dart
import 'package:hive/hive.dart';

part 'step_log_model.g.dart';

/// Step log entry - stored in Hive, synced to Appwrite
@HiveType(typeId: 10)
class StepLog extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String userId;

  @HiveField(2)
  int stepCount;

  @HiveField(3)
  DateTime date;

  @HiveField(4)
  int goalSteps;

  @HiveField(5)
  double xpEarned;

  @HiveField(6)
  String syncStatus; // 'pending' | 'synced' | 'conflict'

  @HiveField(7)
  String source; // 'health_connect' | 'pedometer' | 'manual'

  @HiveField(8)
  DateTime? lastUpdated;

  StepLog({
    required this.id,
    required this.userId,
    required this.stepCount,
    required this.date,
    required this.goalSteps,
    this.xpEarned = 0,
    this.syncStatus = 'pending',
    this.source = 'health_connect',
    this.lastUpdated,
  });

  /// Create a new StepLog with a generated ID
  factory StepLog.create({
    required String userId,
    required int stepCount,
    required DateTime date,
    required int goalSteps,
    String source = 'health_connect',
  }) {
    final now = DateTime.now();
    return StepLog(
      id: '${userId}_${date.year}_${date.month}_${date.day}',
      userId: userId,
      stepCount: stepCount,
      date: DateTime(date.year, date.month, date.day),
      goalSteps: goalSteps,
      xpEarned: calculateXP(stepCount),
      syncStatus: 'pending',
      source: source,
      lastUpdated: now,
    );
  }

  /// Calculate XP earned from steps: +5 XP per 1,000 steps (max 50 XP/day)
  static double calculateXP(int steps) {
    if (steps <= 0) return 0;
    final xpPerThousand = (steps / 1000).floor() * 5;
    return xpPerThousand > 50 ? 50 : xpPerThousand.toDouble();
  }

  /// Get the goal achievement percentage
  double get goalProgress {
    if (goalSteps <= 0) return 0;
    return (stepCount / goalSteps * 100).clamp(0, 100);
  }

  /// Check if goal is achieved
  bool get isGoalAchieved => stepCount >= goalSteps;

  /// Serialise for Appwrite document creation
  Map<String, dynamic> toAppwrite() => {
    'user_id': userId,
    'step_count': stepCount,
    'date': date.toIso8601String(),
    'goal_steps': goalSteps,
    'xp_earned': xpEarned,
    'source': source,
    'last_updated': lastUpdated?.toIso8601String(),
  };

  /// Copy with modifications
  StepLog copyWith({
    String? id,
    String? userId,
    int? stepCount,
    DateTime? date,
    int? goalSteps,
    double? xpEarned,
    String? syncStatus,
    String? source,
    DateTime? lastUpdated,
  }) {
    return StepLog(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      stepCount: stepCount ?? this.stepCount,
      date: date ?? this.date,
      goalSteps: goalSteps ?? this.goalSteps,
      xpEarned: xpEarned ?? this.xpEarned,
      syncStatus: syncStatus ?? this.syncStatus,
      source: source ?? this.source,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }

  @override
  String toString() {
    return 'StepLog(id: $id, steps: $stepCount, goal: $goalSteps, xp: $xpEarned)';
  }
}
