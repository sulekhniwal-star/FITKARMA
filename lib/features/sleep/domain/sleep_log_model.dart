/// Sleep quality score enum (1-5 emoji scale)
enum SleepQuality {
  veryPoor, // 1 - 😫
  poor, // 2 - 😞
  average, // 3 - 😐
  good, // 4 - 😊
  excellent, // 5 - 😴
}

/// Sleep log model for tracking sleep patterns
/// Data is synced to Appwrite but not encrypted (not considered sensitive)
class SleepLog {
  final String id;
  final String userId;
  final DateTime date;
  final String bedtime; // HH:MM format
  final String wakeTime; // HH:MM format
  final int durationMin; // Total sleep duration in minutes
  final int qualityScore; // 1-5 emoji scale
  final int deepSleepMin; // Deep sleep minutes (from wearable/health app)
  final String? notes;
  final String source; // 'manual' | 'health_connect' | 'healthkit' | 'wearable'
  final String syncStatus;

  SleepLog({
    required this.id,
    required this.userId,
    required this.date,
    required this.bedtime,
    required this.wakeTime,
    required this.durationMin,
    required this.qualityScore,
    this.deepSleepMin = 0,
    this.notes,
    this.source = 'manual',
    this.syncStatus = 'pending',
  });

  /// Get quality as enum
  SleepQuality get quality => SleepQuality.values[qualityScore.clamp(0, 4)];

  /// Get quality emoji
  String get qualityEmoji {
    switch (quality) {
      case SleepQuality.veryPoor:
        return '😫';
      case SleepQuality.poor:
        return '😞';
      case SleepQuality.average:
        return '😐';
      case SleepQuality.good:
        return '😊';
      case SleepQuality.excellent:
        return '😴';
    }
  }

  /// Get quality label
  String get qualityLabel {
    switch (quality) {
      case SleepQuality.veryPoor:
        return 'Very Poor';
      case SleepQuality.poor:
        return 'Poor';
      case SleepQuality.average:
        return 'Average';
      case SleepQuality.good:
        return 'Good';
      case SleepQuality.excellent:
        return 'Excellent';
    }
  }

  /// Get duration in hours and minutes
  String get durationFormatted {
    final hours = durationMin ~/ 60;
    final mins = durationMin % 60;
    if (hours == 0) return '${mins}m';
    if (mins == 0) return '${hours}h';
    return '${hours}h ${mins}m';
  }

  /// Check if sleep is in recommended range (7-9 hours)
  bool get isRecommended => durationMin >= 420 && durationMin <= 540;

  /// Get sleep debt (if any) - recommended is 8 hours
  int get sleepDebtMin {
    const recommended = 480; // 8 hours
    return recommended - durationMin;
  }

  /// Check if user is in sleep debt
  bool get hasSleepDebt => sleepDebtMin > 0;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'date': date.toIso8601String(),
      'bedtime': bedtime,
      'wakeTime': wakeTime,
      'durationMin': durationMin,
      'qualityScore': qualityScore,
      'deepSleepMin': deepSleepMin,
      'notes': notes,
      'source': source,
      'syncStatus': syncStatus,
    };
  }

  factory SleepLog.fromMap(Map<String, dynamic> map) {
    return SleepLog(
      id: map['id'] ?? '',
      userId: map['userId'] ?? '',
      date: DateTime.parse(map['date'] ?? DateTime.now().toIso8601String()),
      bedtime: map['bedtime'] ?? '00:00',
      wakeTime: map['wakeTime'] ?? '00:00',
      durationMin: (map['durationMin'] as num?)?.toInt() ?? 0,
      qualityScore: (map['qualityScore'] as num?)?.toInt() ?? 3,
      deepSleepMin: (map['deepSleepMin'] as num?)?.toInt() ?? 0,
      notes: map['notes'],
      source: map['source'] ?? 'manual',
      syncStatus: map['syncStatus'] ?? 'synced',
    );
  }

  SleepLog copyWith({
    String? id,
    String? userId,
    DateTime? date,
    String? bedtime,
    String? wakeTime,
    int? durationMin,
    int? qualityScore,
    int? deepSleepMin,
    String? notes,
    String? source,
    String? syncStatus,
  }) {
    return SleepLog(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      date: date ?? this.date,
      bedtime: bedtime ?? this.bedtime,
      wakeTime: wakeTime ?? this.wakeTime,
      durationMin: durationMin ?? this.durationMin,
      qualityScore: qualityScore ?? this.qualityScore,
      deepSleepMin: deepSleepMin ?? this.deepSleepMin,
      notes: notes ?? this.notes,
      source: source ?? this.source,
      syncStatus: syncStatus ?? this.syncStatus,
    );
  }
}
