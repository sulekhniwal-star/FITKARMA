import 'package:fitkarma/features/gamification/data/repositories/progress_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/models/activity_log.dart';

part 'activity_repository.g.dart';

@Riverpod(keepAlive: true)
class ActivityRepository extends _$ActivityRepository {
  late Box<ActivityLog> _activityBox;

  @override
  FutureOr<void> build() async {
    _activityBox = await Hive.openBox<ActivityLog>('activity_logs');
  }

  Future<ActivityLog> getDailyActivity(DateTime date) async {
    final key = '${date.year}-${date.month}-${date.day}';
    return _activityBox.get(key) ?? ActivityLog(
      id: key,
      date: date,
      steps: 0,
      caloriesBurned: 0,
      activeMinutes: 0,
    );
  }

  Future<void> updateSteps(int steps) async {
    final today = DateTime.now();
    final activity = await getDailyActivity(today);
    final updated = activity.copyWith(steps: activity.steps + steps);
    await _activityBox.put(activity.id, updated);
    
    // Trigger XP: 1 XP per 100 steps
    if (steps >= 100) {
      await ref.read(progressRepositoryProvider.notifier).addXp(steps ~/ 100);
    }
  }

  Future<void> addActiveMinutes(int minutes) async {
    final today = DateTime.now();
    final activity = await getDailyActivity(today);
    final updated = activity.copyWith(activeMinutes: activity.activeMinutes + minutes);
    await _activityBox.put(activity.id, updated);

    // Trigger XP: 5 XP per active minute
    await ref.read(progressRepositoryProvider.notifier).addXp(minutes * 5);
  }
}
