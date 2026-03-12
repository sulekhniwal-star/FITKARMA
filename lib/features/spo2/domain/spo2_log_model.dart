/// SpO2 log model for tracking oxygen saturation levels
/// Data is not encrypted by default (not considered sensitive medical data per spec)
class SpO2Log {
  final String id;
  final String userId;
  final double spo2Pct;
  final int pulse;
  final DateTime loggedAt;
  final String source; // 'manual' | 'wearable' | 'health_connect'
  final String syncStatus;

  SpO2Log({
    required this.id,
    required this.userId,
    required this.spo2Pct,
    required this.pulse,
    required this.loggedAt,
    this.source = 'manual',
    this.syncStatus = 'pending',
  });

  /// Check if SpO2 is in normal range (95-100%)
  bool get isNormal => spo2Pct >= 95 && spo2Pct <= 100;

  /// Check if SpO2 is below normal (needs attention)
  bool get isLow => spo2Pct < 95;

  /// Get status message for display
  String get statusMessage {
    if (spo2Pct >= 95) return 'Normal';
    if (spo2Pct >= 90) return 'Low - Monitor';
    return 'Critical - Seek Medical Attention';
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'spo2Pct': spo2Pct,
      'pulse': pulse,
      'loggedAt': loggedAt.toIso8601String(),
      'source': source,
      'syncStatus': syncStatus,
    };
  }

  factory SpO2Log.fromMap(Map<String, dynamic> map) {
    return SpO2Log(
      id: map['id'] ?? '',
      userId: map['userId'] ?? '',
      spo2Pct: (map['spo2Pct'] as num?)?.toDouble() ?? 0.0,
      pulse: (map['pulse'] as num?)?.toInt() ?? 0,
      loggedAt: DateTime.parse(
        map['loggedAt'] ?? DateTime.now().toIso8601String(),
      ),
      source: map['source'] ?? 'manual',
      syncStatus: map['syncStatus'] ?? 'synced',
    );
  }

  SpO2Log copyWith({
    String? id,
    String? userId,
    double? spo2Pct,
    int? pulse,
    DateTime? loggedAt,
    String? source,
    String? syncStatus,
  }) {
    return SpO2Log(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      spo2Pct: spo2Pct ?? this.spo2Pct,
      pulse: pulse ?? this.pulse,
      loggedAt: loggedAt ?? this.loggedAt,
      source: source ?? this.source,
      syncStatus: syncStatus ?? this.syncStatus,
    );
  }
}
