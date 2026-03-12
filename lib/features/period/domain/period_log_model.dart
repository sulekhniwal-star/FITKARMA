/// Flow intensity levels
enum FlowIntensity { light, medium, heavy }

/// Cycle phase
enum CyclePhase {
  menstrual, // Day 1-5
  follicular, // Day 6-14
  ovulatory, // Day 15-16
  luteal, // Day 17-28
}

/// Period log model for tracking menstrual cycles
/// ALL FIELDS ARE AES-256 ENCRYPTED BEFORE ANY STORAGE OR SYNC
/// Sync to Appwrite is OPT-IN only - default is local-only
class PeriodLog {
  final String id;
  final String userId;
  final DateTime cycleStart;
  final DateTime? cycleEnd;
  final FlowIntensity? flowIntensity;
  final List<String> symptoms;
  final String? notes;
  final bool syncEnabled; // User opt-in - default false
  final String syncStatus;

  PeriodLog({
    required this.id,
    required this.userId,
    required this.cycleStart,
    this.cycleEnd,
    this.flowIntensity,
    this.symptoms = const [],
    this.notes,
    this.syncEnabled = false,
    this.syncStatus = 'local',
  });

  /// Available symptoms
  static const List<String> availableSymptoms = [
    'cramps',
    'bloating',
    'mood_swings',
    'headache',
    'fatigue',
    'spotting',
    'backache',
    'breast_tenderness',
    'acne',
    'food_cravings',
    'insomnia',
    'nausea',
  ];

  /// Calculate cycle length in days
  int? get cycleLength {
    if (cycleEnd == null) return null;
    return cycleEnd!.difference(cycleStart).inDays + 1;
  }

  /// Get current cycle day
  int get currentDay {
    return DateTime.now().difference(cycleStart).inDays + 1;
  }

  /// Get current phase
  CyclePhase get currentPhase {
    final day = currentDay;
    if (day <= 5) return CyclePhase.menstrual;
    if (day <= 14) return CyclePhase.follicular;
    if (day <= 16) return CyclePhase.ovulatory;
    return CyclePhase.luteal;
  }

  /// Get phase label
  String get phaseLabel {
    switch (currentPhase) {
      case CyclePhase.menstrual:
        return 'Menstrual';
      case CyclePhase.follicular:
        return 'Follicular';
      case CyclePhase.ovulatory:
        return 'Ovulatory';
      case CyclePhase.luteal:
        return 'Luteal';
    }
  }

  /// Get workout suggestion based on phase
  String get workoutSuggestion {
    switch (currentPhase) {
      case CyclePhase.menstrual:
        return 'Rest and light yoga recommended';
      case CyclePhase.follicular:
        return 'Great time for high-intensity workouts';
      case CyclePhase.ovulatory:
        return 'Maintain moderate intensity';
      case CyclePhase.luteal:
        return 'Focus on gentle exercise and stretching';
    }
  }

  /// Check if currently on period
  bool get isOnPeriod => currentPhase == CyclePhase.menstrual;

  /// Get flow intensity label
  String? get flowIntensityLabel {
    switch (flowIntensity) {
      case FlowIntensity.light:
        return 'Light';
      case FlowIntensity.medium:
        return 'Medium';
      case FlowIntensity.heavy:
        return 'Heavy';
      default:
        return null;
    }
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'cycleStart': cycleStart.toIso8601String(),
      'cycleEnd': cycleEnd?.toIso8601String(),
      'flowIntensity': flowIntensity?.name,
      'symptoms': symptoms,
      'notes': notes,
      'syncEnabled': syncEnabled,
      'syncStatus': syncStatus,
    };
  }

  factory PeriodLog.fromMap(Map<String, dynamic> map) {
    return PeriodLog(
      id: map['id'] ?? '',
      userId: map['userId'] ?? '',
      cycleStart: DateTime.parse(
        map['cycleStart'] ?? DateTime.now().toIso8601String(),
      ),
      cycleEnd: map['cycleEnd'] != null
          ? DateTime.parse(map['cycleEnd'])
          : null,
      flowIntensity: map['flowIntensity'] != null
          ? FlowIntensity.values.firstWhere(
              (e) => e.name == map['flowIntensity'],
              orElse: () => FlowIntensity.medium,
            )
          : null,
      symptoms: (map['symptoms'] as List<dynamic>?)?.cast<String>() ?? [],
      notes: map['notes'],
      syncEnabled: map['syncEnabled'] ?? false,
      syncStatus: map['syncStatus'] ?? 'local',
    );
  }

  PeriodLog copyWith({
    String? id,
    String? userId,
    DateTime? cycleStart,
    DateTime? cycleEnd,
    FlowIntensity? flowIntensity,
    List<String>? symptoms,
    String? notes,
    bool? syncEnabled,
    String? syncStatus,
  }) {
    return PeriodLog(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      cycleStart: cycleStart ?? this.cycleStart,
      cycleEnd: cycleEnd ?? this.cycleEnd,
      flowIntensity: flowIntensity ?? this.flowIntensity,
      symptoms: symptoms ?? this.symptoms,
      notes: notes ?? this.notes,
      syncEnabled: syncEnabled ?? this.syncEnabled,
      syncStatus: syncStatus ?? this.syncStatus,
    );
  }
}
