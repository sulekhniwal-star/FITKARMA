// lib/features/dashboard/providers/dashboard_providers.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Dashboard state containing all data needed for the dashboard
class DashboardState {
  // User info
  final String? userName;
  final int karmaLevel;
  final int currentXp;
  final String levelTitle;

  // Activity rings data
  final double caloriesValue;
  final double caloriesTarget;
  final double stepsValue;
  final double stepsTarget;
  final double waterValue;
  final double waterTarget;
  final double activeMinutesValue;
  final double activeMinutesTarget;

  // Today's meals
  final Map<String, double> mealsCalories;

  // Latest workout
  final String? latestWorkoutName;
  final int? latestWorkoutDuration;
  final String? latestWorkoutDate;

  // Sleep
  final int? sleepScore;
  final int? sleepHours;

  // Loading states
  final bool isLoading;
  final bool isSyncing;

  DashboardState({
    this.userName,
    this.karmaLevel = 1,
    this.currentXp = 0,
    this.levelTitle = 'Beginner',
    this.caloriesValue = 0,
    this.caloriesTarget = 2000,
    this.stepsValue = 0,
    this.stepsTarget = 10000,
    this.waterValue = 0,
    this.waterTarget = 8,
    this.activeMinutesValue = 0,
    this.activeMinutesTarget = 30,
    this.mealsCalories = const {},
    this.latestWorkoutName,
    this.latestWorkoutDuration,
    this.latestWorkoutDate,
    this.sleepScore,
    this.sleepHours,
    this.isLoading = true,
    this.isSyncing = false,
  });

  DashboardState copyWith({
    String? userName,
    int? karmaLevel,
    int? currentXp,
    String? levelTitle,
    double? caloriesValue,
    double? caloriesTarget,
    double? stepsValue,
    double? stepsTarget,
    double? waterValue,
    double? waterTarget,
    double? activeMinutesValue,
    double? activeMinutesTarget,
    Map<String, double>? mealsCalories,
    String? latestWorkoutName,
    int? latestWorkoutDuration,
    String? latestWorkoutDate,
    int? sleepScore,
    int? sleepHours,
    bool? isLoading,
    bool? isSyncing,
  }) {
    return DashboardState(
      userName: userName ?? this.userName,
      karmaLevel: karmaLevel ?? this.karmaLevel,
      currentXp: currentXp ?? this.currentXp,
      levelTitle: levelTitle ?? this.levelTitle,
      caloriesValue: caloriesValue ?? this.caloriesValue,
      caloriesTarget: caloriesTarget ?? this.caloriesTarget,
      stepsValue: stepsValue ?? this.stepsValue,
      stepsTarget: stepsTarget ?? this.stepsTarget,
      waterValue: waterValue ?? this.waterValue,
      waterTarget: waterTarget ?? this.waterTarget,
      activeMinutesValue: activeMinutesValue ?? this.activeMinutesValue,
      activeMinutesTarget: activeMinutesTarget ?? this.activeMinutesTarget,
      mealsCalories: mealsCalories ?? this.mealsCalories,
      latestWorkoutName: latestWorkoutName ?? this.latestWorkoutName,
      latestWorkoutDuration:
          latestWorkoutDuration ?? this.latestWorkoutDuration,
      latestWorkoutDate: latestWorkoutDate ?? this.latestWorkoutDate,
      sleepScore: sleepScore ?? this.sleepScore,
      sleepHours: sleepHours ?? this.sleepHours,
      isLoading: isLoading ?? this.isLoading,
      isSyncing: isSyncing ?? this.isSyncing,
    );
  }

  // Progress calculations
  double get caloriesProgress =>
      caloriesTarget > 0 ? (caloriesValue / caloriesTarget).clamp(0.0, 1.0) : 0;
  double get stepsProgress =>
      stepsTarget > 0 ? (stepsValue / stepsTarget).clamp(0.0, 1.0) : 0;
  double get waterProgress =>
      waterTarget > 0 ? (waterValue / waterTarget).clamp(0.0, 1.0) : 0;
  double get activeMinutesProgress => activeMinutesTarget > 0
      ? (activeMinutesValue / activeMinutesTarget).clamp(0.0, 1.0)
      : 0;
}

/// Dashboard notifier - loads data from Hive
class DashboardNotifier extends StateNotifier<DashboardState> {
  DashboardNotifier() : super(DashboardState()) {
    loadDashboardData();
  }

  /// Load all dashboard data from Hive (fast, no network)
  Future<void> loadDashboardData() async {
    state = state.copyWith(isLoading: true);

    try {
      // In production, load from Hive boxes
      // For now, using mock data for demonstration

      // Simulate loading from Hive - very fast
      await Future.delayed(const Duration(milliseconds: 100));

      state = state.copyWith(
        userName: 'User',
        karmaLevel: 12,
        currentXp: 450,
        levelTitle: 'Warrior',
        caloriesValue: 1200,
        caloriesTarget: 2000,
        stepsValue: 6500,
        stepsTarget: 10000,
        waterValue: 5,
        waterTarget: 8,
        activeMinutesValue: 20,
        activeMinutesTarget: 30,
        mealsCalories: {'breakfast': 350, 'lunch': 550, 'dinner': 300},
        latestWorkoutName: 'Morning Yoga',
        latestWorkoutDuration: 30,
        latestWorkoutDate: 'Today',
        sleepScore: 78,
        sleepHours: 7,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false);
    }
  }

  /// Sync with Appwrite in background after initial render
  Future<void> syncWithAppwrite() async {
    state = state.copyWith(isSyncing: true);

    try {
      // Background sync with Appwrite - in production this would fetch updates
      await Future.delayed(const Duration(milliseconds: 500));

      // Reload data after sync
      await loadDashboardData();
    } catch (e) {
      // Sync failed silently - data will be synced later
    } finally {
      state = state.copyWith(isSyncing: false);
    }
  }

  /// Update user name
  void updateUserName(String name) {
    state = state.copyWith(userName: name);
  }

  /// Get level title based on karma level
  static String getLevelTitle(int level) {
    if (level < 5) return 'Beginner';
    if (level < 10) return 'Health Seeker';
    if (level < 15) return 'Wellness Warrior';
    if (level < 20) return 'Ayurveda Champion';
    if (level < 30) return 'Fitness Master';
    if (level < 40) return 'Health Guru';
    return 'Enlightened';
  }
}

/// Dashboard provider
final dashboardProvider =
    StateNotifierProvider<DashboardNotifier, DashboardState>((ref) {
      return DashboardNotifier();
    });

/// Quick log action types
enum QuickLogType { food, water, mood, workout, bloodPressure, glucose }
