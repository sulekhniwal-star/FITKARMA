// lib/features/steps/services/inactivity_service.dart
import 'dart:async';
import 'package:flutter/foundation.dart';

/// Service for detecting phone inactivity and sending movement reminders
///
/// This service monitors user activity and triggers callbacks/notifications
/// when the user has been inactive for a specified threshold.
class InactivityService {
  static final InactivityService _instance = InactivityService._internal();
  factory InactivityService() => _instance;
  InactivityService._internal();

  // Timer for checking inactivity
  Timer? _inactivityTimer;

  // Last activity timestamp
  DateTime? _lastActivityTime;

  // Settings
  int _inactivityThresholdMinutes = 60;
  bool _isEnabled = true;

  // Callback for inactivity
  Function()? onInactivityDetected;

  /// Initialize the service
  Future<void> init() async {
    _lastActivityTime = DateTime.now();
    _startMonitoring();
    debugPrint(
      'InactivityService initialized with threshold: $_inactivityThresholdMinutes minutes',
    );
  }

  /// Start monitoring for inactivity
  void _startMonitoring() {
    // Cancel existing timer
    _inactivityTimer?.cancel();

    // Check every minute
    _inactivityTimer = Timer.periodic(
      const Duration(minutes: 1),
      (_) => _checkInactivity(),
    );
  }

  /// Check if user has been inactive
  void _checkInactivity() {
    if (!_isEnabled || _lastActivityTime == null) return;

    final now = DateTime.now();
    final inactiveDuration = now.difference(_lastActivityTime!);

    if (inactiveDuration.inMinutes >= _inactivityThresholdMinutes) {
      _onInactivityDetected();
    }
  }

  /// Handle inactivity detected
  void _onInactivityDetected() {
    debugPrint('Inactivity detected: > $_inactivityThresholdMinutes minutes');

    // Call callback
    onInactivityDetected?.call();
  }

  /// Record user activity (call this when user interacts with app)
  void recordActivity() {
    _lastActivityTime = DateTime.now();
    debugPrint('Activity recorded at $_lastActivityTime');
  }

  /// Set inactivity threshold in minutes
  void setInactivityThreshold(int minutes) {
    _inactivityThresholdMinutes = minutes;
  }

  /// Enable/disable inactivity detection
  void setEnabled(bool enabled) {
    _isEnabled = enabled;
    if (enabled) {
      _startMonitoring();
    } else {
      _inactivityTimer?.cancel();
    }
  }

  /// Check if service is enabled
  bool get isEnabled => _isEnabled;

  /// Get current inactivity threshold
  int get inactivityThreshold => _inactivityThresholdMinutes;

  /// Get time since last activity
  Duration? get timeSinceLastActivity {
    if (_lastActivityTime == null) return null;
    return DateTime.now().difference(_lastActivityTime!);
  }

  /// Get formatted time since last activity
  String get formattedTimeSinceLastActivity {
    final duration = timeSinceLastActivity;
    if (duration == null) return 'Unknown';

    if (duration.inHours > 0) {
      return '${duration.inHours}h ${duration.inMinutes % 60}m';
    } else if (duration.inMinutes > 0) {
      return '${duration.inMinutes}m';
    }
    return 'Just now';
  }

  /// Dispose resources
  void dispose() {
    _inactivityTimer?.cancel();
  }
}
