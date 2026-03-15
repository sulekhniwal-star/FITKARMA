// lib/features/steps/services/step_tracking_service.dart
import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:pedometer/pedometer.dart';
import '../data/step_hive_service.dart';
import '../domain/step_log_model.dart';

/// Step tracking source
enum StepSource { healthConnect, pedometer, manual }

/// Service for tracking steps using Health Connect (Android) / HealthKit (iOS)
/// with pedometer fallback
///
/// Note: Health Connect/HealthKit integration requires platform-specific setup.
/// This service gracefully falls back to pedometer if health platform is unavailable.
class StepTrackingService {
  static final StepTrackingService _instance = StepTrackingService._internal();
  factory StepTrackingService() => _instance;
  StepTrackingService._internal();

  // Pedometer
  StreamSubscription<StepCount>? _stepCountSubscription;
  StreamSubscription<PedestrianStatus>? _pedestrianStatusSubscription;
  int _pedometerSteps = 0;
  DateTime? _pedometerLastReset;

  // Current state
  StepSource _currentSource = StepSource.pedometer;
  int _currentSteps = 0;
  int _currentGoal = 8000; // Default goal
  bool _isHealthAvailable = false;

  // Callbacks
  Function(int steps)? onStepCountUpdated;
  Function(String status)? onWalkingStatusChanged;

  /// Initialize step tracking
  Future<void> init() async {
    _initPedometer();
    await _checkHealthPlatform();
  }

  /// Check and initialize health platform (Health Connect on Android, HealthKit on iOS)
  Future<void> _checkHealthPlatform() async {
    try {
      // Health Connect is Android-only
      if (Platform.isAndroid) {
        // Try to use health package for Health Connect
        // For now, we'll use pedometer as the primary source
        // Health Connect integration can be added with proper platform configuration
        _isHealthAvailable = false;
        debugPrint(
          'Health Connect: Using pedometer (health integration requires additional setup)',
        );
      } else if (Platform.isIOS) {
        // HealthKit integration would go here
        _isHealthAvailable = false;
        debugPrint(
          'HealthKit: Using pedometer (health integration requires additional setup)',
        );
      }
    } catch (e) {
      debugPrint('Error checking health platform: $e');
      _isHealthAvailable = false;
    }
  }

  /// Initialize pedometer for step counting
  void _initPedometer() {
    try {
      _stepCountSubscription = Pedometer.stepCountStream.listen(
        _onStepCount,
        onError: _onStepCountError,
      );

      _pedestrianStatusSubscription = Pedometer.pedestrianStatusStream.listen(
        _onPedestrianStatusChanged,
        onError: _onPedestrianStatusError,
      );
    } catch (e) {
      debugPrint('Error initializing pedometer: $e');
    }
  }

  void _onStepCount(StepCount event) {
    // Check if we need to reset for a new day
    final now = DateTime.now();
    if (_pedometerLastReset == null || now.day != _pedometerLastReset!.day) {
      _pedometerLastReset = now;
      _pedometerSteps = 0;
    }

    _pedometerSteps = event.steps;
    _currentSteps = _pedometerSteps;
    _currentSource = StepSource.pedometer;

    onStepCountUpdated?.call(_currentSteps);
  }

  void _onStepCountError(dynamic error) {
    debugPrint('Step count error: $error');
  }

  void _onPedestrianStatusChanged(PedestrianStatus event) {
    onWalkingStatusChanged?.call(event.status);
  }

  void _onPedestrianStatusError(dynamic error) {
    debugPrint('Pedestrian status error: $error');
  }

  /// Get current step count
  Future<int> getTodayStepCount() async {
    // Use pedometer value
    return _pedometerSteps;
  }

  /// Get step count for a specific date from local storage
  Future<int> getStepCountForDate(DateTime date) async {
    // Return from local storage
    final log = StepHiveService.getStepLogForDate(date);
    return log?.stepCount ?? 0;
  }

  /// Get the current step source
  StepSource get currentSource => _currentSource;

  /// Check if health platform is available
  bool get isHealthAvailable => _isHealthAvailable;

  /// Get current steps
  int get currentSteps => _currentSteps;

  /// Set daily goal
  void setDailyGoal(int goal) {
    _currentGoal = goal;
  }

  /// Get daily goal
  int get dailyGoal => _currentGoal;

  /// Calculate adaptive goal based on 7-day average
  int calculateAdaptiveGoal() {
    final average = StepHiveService.calculate7DayAverage();
    if (average > 0) {
      return average;
    }
    return _currentGoal;
  }

  /// Save today's step count to Hive
  Future<StepLog> saveTodaySteps(String userId) async {
    final steps = await getTodayStepCount();
    final goal = calculateAdaptiveGoal();

    return await StepHiveService.updateTodaySteps(
      userId: userId,
      stepCount: steps,
      goalSteps: goal,
      source: _currentSource == StepSource.healthConnect
          ? 'health_connect'
          : 'pedometer',
    );
  }

  /// Request health platform permissions (for future use)
  Future<bool> requestHealthPermissions() async {
    // Placeholder for health platform permission request
    // Would integrate with health package when properly configured
    return false;
  }

  /// Dispose resources
  void dispose() {
    _stepCountSubscription?.cancel();
    _pedestrianStatusSubscription?.cancel();
  }
}
