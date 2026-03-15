// lib/core/network/connectivity_service.dart
import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';

/// Service for monitoring network connectivity.
///
/// Wraps connectivity_plus to expose a stream of connectivity status changes.
/// Used by the sync queue to determine when to flush pending operations.
class ConnectivityService {
  static ConnectivityService? _instance;
  static ConnectivityService get instance =>
      _instance ??= ConnectivityService._internal();
  ConnectivityService._internal();

  final Connectivity _connectivity = Connectivity();

  // Stream controller for broadcasting connectivity changes
  final StreamController<bool> _connectionController =
      StreamController<bool>.broadcast();

  // Current connectivity status
  bool _isOnline = false;
  bool get isOnline => _isOnline;

  /// Stream that emits true when online, false when offline
  Stream<bool> get isOnlineStream => _connectionController.stream;

  /// Initializes the connectivity service and starts listening.
  Future<void> init() async {
    // Check initial connectivity
    final results = await _connectivity.checkConnectivity();
    _updateStatus(results);

    // Listen for changes
    _connectivity.onConnectivityChanged.listen(_updateStatus);
  }

  /// Updates the connectivity status and broadcasts to listeners.
  void _updateStatus(List<ConnectivityResult> results) {
    final wasOnline = _isOnline;
    _isOnline =
        results.isNotEmpty && !results.contains(ConnectivityResult.none);

    // Only emit if status changed
    if (wasOnline != _isOnline) {
      _connectionController.add(_isOnline);
    }
  }

  /// Checks current connectivity status synchronously.
  Future<bool> checkConnectivity() async {
    final results = await _connectivity.checkConnectivity();
    _isOnline =
        results.isNotEmpty && !results.contains(ConnectivityResult.none);
    return _isOnline;
  }

  /// Disposes of the stream controller.
  void dispose() {
    _connectionController.close();
  }
}
