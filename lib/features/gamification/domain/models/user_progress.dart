import 'package:hive/hive.dart';

part 'user_progress.g.dart';

@HiveType(typeId: 6)
class UserProgress extends HiveObject {
  @HiveField(0)
  final int totalXp;

  @HiveField(1)
  final int level;

  @HiveField(2)
  final String title;

  UserProgress({
    required this.totalXp,
    required this.level,
    required this.title,
  });

  factory UserProgress.initial() {
    return UserProgress(
      totalXp: 0,
      level: 1,
      title: 'Sadhaka',
    );
  }

  UserProgress copyWith({
    int? totalXp,
    int? level,
    String? title,
  }) {
    return UserProgress(
      totalXp: totalXp ?? this.totalXp,
      level: level ?? this.level,
      title: title ?? this.title,
    );
  }
}
