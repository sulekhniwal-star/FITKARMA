import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/network/sync_queue.dart';
import '../../../core/di/providers.dart';

class WorkoutCalendarItem {
  final String dateStr; // ISO Date
  final List<String> workoutIds;
  final bool isRestDay;

  WorkoutCalendarItem({
    required this.dateStr,
    this.workoutIds = const [],
    this.isRestDay = false,
  });

  Map<String, dynamic> toMap() => {
    'date': dateStr,
    'workout_ids': workoutIds,
    'is_rest_day': isRestDay,
  };

  factory WorkoutCalendarItem.fromMap(Map<String, dynamic> map) => WorkoutCalendarItem(
    dateStr: map['date'] ?? '',
    workoutIds: List<String>.from(map['workout_ids'] ?? []),
    isRestDay: map['is_rest_day'] ?? false,
  );
}

class WorkoutCalendarRepository {
  final SyncQueue _syncQueue;

  WorkoutCalendarRepository(this._syncQueue);

  Future<void> scheduleWorkout(DateTime date, String workoutId) async {
    // Implementation for scheduling
  }
}

final workoutCalendarRepoProvider = Provider<WorkoutCalendarRepository>((ref) {
  final syncQueue = ref.watch(syncQueueProvider);
  return WorkoutCalendarRepository(syncQueue);
});
