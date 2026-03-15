// lib/features/steps/providers/steps_providers.dart
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/step_hive_service.dart';
import '../domain/step_log_model.dart';
import '../services/step_tracking_service.dart';
import '../services/inactivity_service.dart';

/// Provider for step tracking service
final stepTrackingServiceProvider = Provider<StepTrackingService>((ref) {
  final service = StepTrackingService();
  ref.onDispose(() => service.dispose());
  return service;
});

/// Provider for inactivity service
final inactivityServiceProvider = Provider<InactivityService>((ref) {
  final service = InactivityService();
  ref.onDispose(() => service.dispose());
  return service;
});

/// State for steps data
class StepsState {
  final int todaySteps;
  final int goalSteps;
  final double xpEarned;
  final int weeklyAverage;
  final List<StepLog> weeklyLogs;
  final bool isLoading;
  final String? error;
  final StepSource source;

  const StepsState({
    this.todaySteps = 0,
    this.goalSteps = 8000,
    this.xpEarned = 0,
    this.weeklyAverage = 0,
    this.weeklyLogs = const [],
    this.isLoading = false,
    this.error,
    this.source = StepSource.pedometer,
  });

  StepsState copyWith({
    int? todaySteps,
    int? goalSteps,
    double? xpEarned,
    int? weeklyAverage,
    List<StepLog>? weeklyLogs,
    bool? isLoading,
    String? error,
    StepSource? source,
  }) {
    return StepsState(
      todaySteps: todaySteps ?? this.todaySteps,
      goalSteps: goalSteps ?? this.goalSteps,
      xpEarned: xpEarned ?? this.xpEarned,
      weeklyAverage: weeklyAverage ?? this.weeklyAverage,
      weeklyLogs: weeklyLogs ?? this.weeklyLogs,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      source: source ?? this.source,
    );
  }

  /// Calculate progress percentage
  double get progressPercentage {
    if (goalSteps <= 0) return 0;
    return (todaySteps / goalSteps * 100).clamp(0, 100);
  }

  /// Check if goal is achieved
  bool get isGoalAchieved => todaySteps >= goalSteps;

  /// Get steps remaining to goal
  int get stepsRemaining => (goalSteps - todaySteps).clamp(0, goalSteps);

  /// Format steps for display
  String get formattedSteps => _formatNumber(todaySteps);
  String get formattedGoal => _formatNumber(goalSteps);
  String get formattedWeeklyAverage => _formatNumber(weeklyAverage);

  String _formatNumber(int number) {
    if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(1)}k';
    }
    return number.toString();
  }
}

/// Notifier for steps state management
class StepsNotifier extends StateNotifier<StepsState> {
  final StepTrackingService _trackingService;
  final InactivityService _inactivityService;
  final String _userId;

  StepsNotifier(this._trackingService, this._inactivityService, this._userId)
    : super(const StepsState());

  /// Initialize step tracking
  Future<void> init() async {
    state = state.copyWith(isLoading: true);

    try {
      // Initialize services
      await _trackingService.init();
      await _inactivityService.init();

      // Set up callbacks
      _trackingService.onStepCountUpdated = (steps) {
        state = state.copyWith(todaySteps: steps);
      };

      _inactivityService.onInactivityDetected = () {
        // Handle inactivity - could show notification or update UI
        debugPrint('Inactivity detected - user should move!');
      };

      // Load initial data
      await refreshSteps();
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  /// Refresh step data
  Future<void> refreshSteps() async {
    state = state.copyWith(isLoading: true);

    try {
      // Get today's steps
      final todaySteps = await _trackingService.getTodayStepCount();

      // Get or calculate goal
      final goalSteps = _trackingService.calculateAdaptiveGoal();
      _trackingService.setDailyGoal(goalSteps);

      // Get weekly data
      final weeklyLogs = StepHiveService.getWeeklyStepLogs();
      final weeklyAverage = StepHiveService.calculate7DayAverage();

      // Calculate XP
      final xpEarned = StepLog.calculateXP(todaySteps);

      // Save today's steps
      await _trackingService.saveTodaySteps(_userId);

      state = state.copyWith(
        todaySteps: todaySteps,
        goalSteps: goalSteps,
        xpEarned: xpEarned,
        weeklyAverage: weeklyAverage,
        weeklyLogs: weeklyLogs,
        isLoading: false,
        source: _trackingService.currentSource,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  /// Record activity to reset inactivity timer
  void recordActivity() {
    _inactivityService.recordActivity();
  }

  /// Set custom goal
  void setGoal(int goal) {
    _trackingService.setDailyGoal(goal);
    state = state.copyWith(goalSteps: goal);
  }

  /// Calculate and return adaptive goal
  int getAdaptiveGoal() {
    return _trackingService.calculateAdaptiveGoal();
  }
}

/// Provider for steps state
final stepsProvider = StateNotifierProvider<StepsNotifier, StepsState>((ref) {
  final trackingService = ref.watch(stepTrackingServiceProvider);
  final inactivityService = ref.watch(inactivityServiceProvider);

  // Get user ID from auth (would need to be passed in or obtained from auth provider)
  const userId = 'default_user';

  return StepsNotifier(trackingService, inactivityService, userId);
});

/// Provider for today's step log
final todayStepLogProvider = Provider<StepLog?>((ref) {
  return StepHiveService.getTodayStepLog();
});

/// Provider for weekly step logs
final weeklyStepLogsProvider = Provider<List<StepLog>>((ref) {
  return StepHiveService.getWeeklyStepLogs();
});

/// Provider for 7-day average
final weeklyAverageProvider = Provider<int>((ref) {
  return StepHiveService.calculate7DayAverage();
});
