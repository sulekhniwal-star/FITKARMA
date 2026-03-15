// lib/features/workout/screens/outdoor_workout_screen.dart
import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../../../shared/theme/app_colors.dart';
import '../providers/workout_providers.dart';

/// GPS-based outdoor workout screen
class OutdoorWorkoutScreen extends ConsumerStatefulWidget {
  const OutdoorWorkoutScreen({super.key});

  @override
  ConsumerState<OutdoorWorkoutScreen> createState() => _OutdoorWorkoutScreenState();
}

class _OutdoorWorkoutScreenState extends ConsumerState<OutdoorWorkoutScreen> {
  final MapController _mapController = MapController();
  
  StreamSubscription<Position>? _positionStream;
  List<LatLng> _routePoints = [];
  
  bool _isTracking = false;
  bool _hasPermission = false;
  bool _isPaused = false;
  
  int _elapsedSeconds = 0;
  Timer? _timer;
  
  double _totalDistanceKm = 0;
  double _currentSpeed = 0;
  double _avgSpeed = 0;
  double? _maxSpeed;
  
  Position? _lastPosition;

  @override
  void initState() {
    super.initState();
    _checkPermissions();
  }

  Future<void> _checkPermissions() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      _showError('Location services are disabled');
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        _showError('Location permissions are denied');
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      _showError('Location permissions are permanently denied');
      return;
    }

    setState(() {
      _hasPermission = true;
    });
  }

  void _showError(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    }
  }

  void _startTracking() {
    setState(() {
      _isTracking = true;
      _isPaused = false;
    });
    
    _startTimer();
    _startLocationStream();
  }

  void _pauseTracking() {
    setState(() {
      _isPaused = true;
    });
    _positionStream?.pause();
    _timer?.cancel();
  }

  void _resumeTracking() {
    setState(() {
      _isPaused = false;
    });
    _positionStream?.resume();
    _startTimer();
  }

  void _stopTracking() {
    _positionStream?.cancel();
    _timer?.cancel();
    
    setState(() {
      _isTracking = false;
    });
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!_isPaused) {
        setState(() {
          _elapsedSeconds++;
        });
      }
    });
  }

  void _startLocationStream() {
    const locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 10, // Update every 10 meters
    );

    _positionStream = Geolocator.getPositionStream(locationSettings: locationSettings)
        .listen((Position position) {
      if (!_isPaused) {
        _updatePosition(position);
      }
    });
  }

  void _updatePosition(Position position) {
    final newPoint = LatLng(position.latitude, position.longitude);
    
    setState(() {
      _routePoints.add(newPoint);
      _currentSpeed = position.speed * 3.6; // Convert m/s to km/h
      
      if (_lastPosition != null) {
        final distance = Geolocator.distanceBetween(
          _lastPosition!.latitude,
          _lastPosition!.longitude,
          position.latitude,
          position.longitude,
        );
        _totalDistanceKm += distance / 1000;
        
        // Update average speed
        if (_elapsedSeconds > 0) {
          _avgSpeed = (_totalDistanceKm / _elapsedSeconds) * 3600;
        }
        
        // Update max speed
        if (_maxSpeed == null || _currentSpeed > _maxSpeed!) {
          _maxSpeed = _currentSpeed;
        }
      }
      
      _lastPosition = position;
    });

    // Center map on current position
    _mapController.move(newPoint, _mapController.camera.zoom);
  }

  String get _formattedTime {
    final hours = _elapsedSeconds ~/ 3600;
    final minutes = (_elapsedSeconds % 3600) ~/ 60;
    final seconds = _elapsedSeconds % 60;
    if (hours > 0) {
      return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    }
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  void _completeWorkout() async {
    _stopTracking();
    
    // Calculate calories (rough estimate: 60 cal per km for running)
    final caloriesBurned = (_totalDistanceKm * 60).round();
    
    // Save workout
    await ref.read(workoutProvider.notifier).completeWorkout(
      durationMinutes: _elapsedSeconds ~/ 60,
      caloriesBurned: caloriesBurned,
      distanceKm: _totalDistanceKm,
    );

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Outdoor workout completed! +20 XP earned'),
          backgroundColor: Colors.green,
        ),
      );
      context.go('/home/workout');
    }
  }

  @override
  void dispose() {
    _positionStream?.cancel();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Outdoor Workout'),
        actions: [
          if (_isTracking)
            IconButton(
              icon: Icon(_isPaused ? Icons.play_arrow : Icons.pause),
              onPressed: _isPaused ? _resumeTracking : _pauseTracking,
            ),
        ],
      ),
      body: !_hasPermission
          ? _buildPermissionRequest()
          : Column(
              children: [
                // Map
                Expanded(
                  flex: 2,
                  child: FlutterMap(
                    mapController: _mapController,
                    options: MapOptions(
                      initialCenter: _lastPosition != null
                          ? LatLng(_lastPosition!.latitude, _lastPosition!.longitude)
                          : const LatLng(28.6139, 77.2090), // Default to Delhi
                      initialZoom: 15,
                    ),
                    children: [
                      TileLayer(
                        urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                        userAgentPackageName: 'com.fitkarma.app',
                      ),
                      // Route polyline
                      PolylineLayer(
                        polylines: [
                          Polyline(
                            points: _routePoints,
                            strokeWidth: 4,
                            color: AppColors.primary,
                          ),
                        ],
                      ),
                      // Current position marker
                      if (_lastPosition != null)
                        MarkerLayer(
                          markers: [
                            Marker(
                              point: LatLng(_lastPosition!.latitude, _lastPosition!.longitude),
                              width: 30,
                              height: 30,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: AppColors.primary,
                                  shape: BoxShape.circle,
                                  border: Border.all(color: Colors.white, width: 3),
                                ),
                                child: const Icon(
                                  Icons.directions_run,
                                  color: Colors.white,
                                  size: 16,
                                ),
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
                
                // Stats panel
                Expanded(
                  flex: 1,
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, -5),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        // Timer
                        Text(
                          _formattedTime,
                          style: const TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(height: 16),
                        
                        // Stats row
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildStatItem(
                              icon: Icons.straighten,
                              label: 'Distance',
                              value: '${_totalDistanceKm.toStringAsFixed(2)} km',
                            ),
                            _buildStatItem(
                              icon: Icons.speed,
                              label: 'Speed',
                              value: '${_currentSpeed.toStringAsFixed(1)} km/h',
                            ),
                            _buildStatItem(
                              icon: Icons.timer,
                              label: 'Avg Pace',
                              value: _avgSpeed > 0 
                                  ? '${(60 / _avgSpeed).toStringAsFixed(1)} min/km'
                                  : '-- min/km',
                            ),
                          ],
                        ),
                        
                        const Spacer(),
                        
                        // Action buttons
                        Row(
                          children: [
                            if (!_isTracking)
                              Expanded(
                                child: ElevatedButton.icon(
                                  onPressed: _startTracking,
                                  icon: const Icon(Icons.play_arrow),
                                  label: const Text('Start'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.primary,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(vertical: 14),
                                  ),
                                ),
                              )
                            else
                              Expanded(
                                child: ElevatedButton.icon(
                                  onPressed: _completeWorkout,
                                  icon: const Icon(Icons.stop),
                                  label: const Text('Finish'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(vertical: 14),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildPermissionRequest() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.location_off,
              size: 64,
              color: Colors.grey,
            ),
            const SizedBox(height: 16),
            const Text(
              'Location Permission Required',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'We need location access to track your outdoor workout route.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey[600]),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _checkPermissions,
              child: const Text('Grant Permission'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Column(
      children: [
        Icon(icon, color: AppColors.primary),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}
