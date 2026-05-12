import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../core/providers/core_providers.dart';
import '../karma/karma_providers.dart';

class WaterTrackingState {
  final int dailyGoalMl;
  final int currentStreakDays;

  WaterTrackingState({
    this.dailyGoalMl = 3000,
    this.currentStreakDays = 5,
  });
}

class WaterNotifier extends Notifier<WaterTrackingState> {
  final FlutterSecureStorage _storage = const FlutterSecureStorage(
    aOptions: AndroidOptions(),
  );
  static const _streakKey = 'user_hydration_streak_count';

  @override
  WaterTrackingState build() {
    _loadStreak();
    return WaterTrackingState();
  }

  Future<void> _loadStreak() async {
    try {
      final str = await _storage.read(key: _streakKey);
      if (str != null) {
        final parsed = int.tryParse(str);
        if (parsed != null) {
          state = WaterTrackingState(dailyGoalMl: state.dailyGoalMl, currentStreakDays: parsed);
        }
      }
    } catch (_) {}
  }

  Future<void> addWater(int amountMl) async {
    final db = ref.read(appDatabaseProvider);
    await db.logWater(amountMl);

    // Reward Karma points for consistent health upkeep
    ref.read(karmaStateProvider.notifier).addKarmaEvent(
          'Hydration Logged (+${amountMl}ml)',
          'streak',
          15,
        );

    // Check if goal was met to potentially update streak logic
    final currentTotal = await db.getTodayWaterMl();
    if (currentTotal >= state.dailyGoalMl) {
      final newStreak = state.currentStreakDays + 1;
      state = WaterTrackingState(dailyGoalMl: state.dailyGoalMl, currentStreakDays: newStreak);
      try {
        await _storage.write(key: _streakKey, value: newStreak.toString());
      } catch (_) {}
    }
  }

  void updateDailyGoal(int newGoalMl) {
    state = WaterTrackingState(dailyGoalMl: newGoalMl, currentStreakDays: state.currentStreakDays);
  }
}

final waterTrackingProvider = NotifierProvider<WaterNotifier, WaterTrackingState>(WaterNotifier.new);

final todayWaterStreamProvider = StreamProvider<int>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return db.watchTodayWaterMl();
});
