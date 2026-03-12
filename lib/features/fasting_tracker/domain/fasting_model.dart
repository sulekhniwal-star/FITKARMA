import 'package:flutter/material.dart' show TimeOfDay;

/// Fasting protocol types supported by FitKarma
enum FastingProtocol {
  protocol16_8, // 16 hours fasting, 8 hours eating
  protocol18_6, // 18 hours fasting, 6 hours eating
  protocol5_2, // 5 days normal, 2 days restricted
  omad, // One Meal A Day (23:1)
  custom, // Custom fasting window
}

/// Fasting stage based on elapsed time
enum FastingStage {
  fed, // Eating window
  earlyFast, // 0-8 hours
  fatBurning, // 8-12 hours
  ketosis, // 12-16 hours
  deepFast, // 16+ hours
}

/// Fasting session model
class FastingSession {
  final String id;
  final String userId;
  final FastingProtocol protocol;
  final DateTime fastStart;
  final DateTime? fastEnd;
  final String eatingWindowStart; // HH:MM
  final String eatingWindowEnd; // HH:MM
  final bool completed;
  final String? notes;
  final String syncStatus;
  final DateTime createdAt;

  FastingSession({
    required this.id,
    required this.userId,
    required this.protocol,
    required this.fastStart,
    this.fastEnd,
    required this.eatingWindowStart,
    required this.eatingWindowEnd,
    this.completed = false,
    this.notes,
    this.syncStatus = 'pending',
    required this.createdAt,
  });

  /// Get fasting duration in hours
  Duration get fastingDuration {
    final end = fastEnd ?? DateTime.now();
    return end.difference(fastStart);
  }

  /// Get current fasting stage
  FastingStage get currentStage {
    final hours = fastingDuration.inHours;
    if (hours < 4) return FastingStage.fed;
    if (hours < 8) return FastingStage.earlyFast;
    if (hours < 12) return FastingStage.fatBurning;
    if (hours < 16) return FastingStage.ketosis;
    return FastingStage.deepFast;
  }

  /// Check if currently in eating window
  bool get isInEatingWindow {
    final now = TimeOfDay.now();
    final startParts = eatingWindowStart.split(':');
    final endParts = eatingWindowEnd.split(':');

    final startTime = TimeOfDay(
      hour: int.parse(startParts[0]),
      minute: int.parse(startParts[1]),
    );
    final endTime = TimeOfDay(
      hour: int.parse(endParts[0]),
      minute: int.parse(endParts[1]),
    );

    // Handle overnight eating windows
    if (endTime.hour < startTime.hour) {
      return now.hour >= startTime.hour || now.hour < endTime.hour;
    }

    return now.hour >= startTime.hour && now.hour < endTime.hour;
  }

  /// Get protocol display name
  String get protocolName {
    switch (protocol) {
      case FastingProtocol.protocol16_8:
        return '16:8';
      case FastingProtocol.protocol18_6:
        return '18:6';
      case FastingProtocol.protocol5_2:
        return '5:2';
      case FastingProtocol.omad:
        return 'OMAD';
      case FastingProtocol.custom:
        return 'Custom';
    }
  }

  /// Get protocol fasting hours
  int get protocolFastingHours {
    switch (protocol) {
      case FastingProtocol.protocol16_8:
        return 16;
      case FastingProtocol.protocol18_6:
        return 18;
      case FastingProtocol.protocol5_2:
        return 24; // 2 days at ~500 cal = ~24h spread
      case FastingProtocol.omad:
        return 23;
      case FastingProtocol.custom:
        return 16; // Default
    }
  }

  /// Get progress percentage
  double get progressPercentage {
    final targetHours = protocolFastingHours;
    final elapsedHours = fastingDuration.inMinutes / 60;
    return (elapsedHours / targetHours).clamp(0.0, 1.0);
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'protocol': protocol.name,
      'fastStart': fastStart.toIso8601String(),
      'fastEnd': fastEnd?.toIso8601String(),
      'eatingWindowStart': eatingWindowStart,
      'eatingWindowEnd': eatingWindowEnd,
      'completed': completed,
      'notes': notes,
      'syncStatus': syncStatus,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory FastingSession.fromMap(Map<String, dynamic> map) {
    return FastingSession(
      id: map['id'] ?? '',
      userId: map['userId'] ?? '',
      protocol: FastingProtocol.values.firstWhere(
        (e) => e.name == map['protocol'],
        orElse: () => FastingProtocol.protocol16_8,
      ),
      fastStart: DateTime.parse(map['fastStart']),
      fastEnd: map['fastEnd'] != null ? DateTime.parse(map['fastEnd']) : null,
      eatingWindowStart: map['eatingWindowStart'] ?? '12:00',
      eatingWindowEnd: map['eatingWindowEnd'] ?? '20:00',
      completed: map['completed'] ?? false,
      notes: map['notes'],
      syncStatus: map['syncStatus'] ?? 'synced',
      createdAt: DateTime.parse(
        map['createdAt'] ?? DateTime.now().toIso8601String(),
      ),
    );
  }

  FastingSession copyWith({
    String? id,
    String? userId,
    FastingProtocol? protocol,
    DateTime? fastStart,
    DateTime? fastEnd,
    String? eatingWindowStart,
    String? eatingWindowEnd,
    bool? completed,
    String? notes,
    String? syncStatus,
    DateTime? createdAt,
  }) {
    return FastingSession(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      protocol: protocol ?? this.protocol,
      fastStart: fastStart ?? this.fastStart,
      fastEnd: fastEnd ?? this.fastEnd,
      eatingWindowStart: eatingWindowStart ?? this.eatingWindowStart,
      eatingWindowEnd: eatingWindowEnd ?? this.eatingWindowEnd,
      completed: completed ?? this.completed,
      notes: notes ?? this.notes,
      syncStatus: syncStatus ?? this.syncStatus,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
