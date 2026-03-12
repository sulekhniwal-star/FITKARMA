import 'package:hive/hive.dart';

part 'activity_log.g.dart';

@HiveType(typeId: 1)
class ActivityLog extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final DateTime date;

  @HiveField(2)
  final int steps;

  @HiveField(3)
  final int activeMinutes;

  @HiveField(4)
  final double caloriesBurned;

  @HiveField(5)
  final bool isSynced;

  ActivityLog({
    required this.id,
    required this.date,
    required this.steps,
    required this.activeMinutes,
    required this.caloriesBurned,
    this.isSynced = false,
  });

  ActivityLog copyWith({
    String? id,
    DateTime? date,
    int? steps,
    int? activeMinutes,
    double? caloriesBurned,
    bool? isSynced,
  }) {
    return ActivityLog(
      id: id ?? this.id,
      date: date ?? this.date,
      steps: steps ?? this.steps,
      activeMinutes: activeMinutes ?? this.activeMinutes,
      caloriesBurned: caloriesBurned ?? this.caloriesBurned,
      isSynced: isSynced ?? this.isSynced,
    );
  }
}
