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
    final dateKey = _getDateKey(date);
    return _activityBox.get(dateKey) ?? ActivityLog(
      id: dateKey,
      date: date,
      steps: 0,
      activeMinutes: 0,
      caloriesBurned: 0,
    );
  }

  Future<void> saveSteps(int steps) async {
    final now = DateTime.now();
    final log = await getDailyActivity(now);
    final updatedLog = log.copyWith(steps: steps);
    await _activityBox.put(updatedLog.id, updatedLog);
  }

  Future<void> saveActiveMinutes(int minutes) async {
    final now = DateTime.now();
    final log = await getDailyActivity(now);
    final updatedLog = log.copyWith(activeMinutes: log.activeMinutes + minutes);
    await _activityBox.put(updatedLog.id, updatedLog);
  }

  String _getDateKey(DateTime date) {
    return "${date.year}-${date.month}-${date.day}";
  }
}
