/// Mood log model for tracking emotional wellbeing
/// Voice notes are stored locally only - never uploaded
class MoodLog {
  final String id;
  final String userId;
  final DateTime loggedAt;
  final int moodScore; // 1-5 (emoji scale)
  final int energyLevel; // 1-10
  final int stressLevel; // 1-10
  final List<String> tags;
  final String? voiceNotePath; // Local path only - never uploaded
  final int? screenTimeMin; // From Digital Wellbeing
  final String syncStatus;

  MoodLog({
    required this.id,
    required this.userId,
    required this.loggedAt,
    required this.moodScore,
    required this.energyLevel,
    required this.stressLevel,
    this.tags = const [],
    this.voiceNotePath,
    this.screenTimeMin,
    this.syncStatus = 'pending',
  });

  /// Available mood tags
  static const List<String> availableTags = [
    'anxious',
    'calm',
    'focused',
    'tired',
    'motivated',
    'irritable',
    'happy',
    'sad',
    'stressed',
    'relaxed',
    'energetic',
    'hopeful',
    'grateful',
    'frustrated',
    'peaceful',
  ];

  /// Get mood emoji
  String get moodEmoji {
    switch (moodScore) {
      case 1:
        return '😢';
      case 2:
        return '😞';
      case 3:
        return '😐';
      case 4:
        return '😊';
      case 5:
        return '😄';
      default:
        return '😐';
    }
  }

  /// Get mood label
  String get moodLabel {
    switch (moodScore) {
      case 1:
        return 'Very Low';
      case 2:
        return 'Low';
      case 3:
        return 'Neutral';
      case 4:
        return 'Good';
      case 5:
        return 'Great';
      default:
        return 'Neutral';
    }
  }

  /// Get energy label
  String get energyLabel {
    if (energyLevel <= 3) return 'Low';
    if (energyLevel <= 6) return 'Moderate';
    return 'High';
  }

  /// Get stress label
  String get stressLabel {
    if (stressLevel <= 3) return 'Low';
    if (stressLevel <= 6) return 'Moderate';
    return 'High';
  }

  /// Check if mood indicates potential burnout
  bool get indicatesBurnout =>
      moodScore <= 2 && energyLevel <= 4 && stressLevel >= 7;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'loggedAt': loggedAt.toIso8601String(),
      'moodScore': moodScore,
      'energyLevel': energyLevel,
      'stressLevel': stressLevel,
      'tags': tags,
      'voiceNotePath': voiceNotePath,
      'screenTimeMin': screenTimeMin,
      'syncStatus': syncStatus,
    };
  }

  factory MoodLog.fromMap(Map<String, dynamic> map) {
    return MoodLog(
      id: map['id'] ?? '',
      userId: map['userId'] ?? '',
      loggedAt: DateTime.parse(
        map['loggedAt'] ?? DateTime.now().toIso8601String(),
      ),
      moodScore: (map['moodScore'] as num?)?.toInt() ?? 3,
      energyLevel: (map['energyLevel'] as num?)?.toInt() ?? 5,
      stressLevel: (map['stressLevel'] as num?)?.toInt() ?? 5,
      tags: (map['tags'] as List<dynamic>?)?.cast<String>() ?? [],
      voiceNotePath: map['voiceNotePath'],
      screenTimeMin: (map['screenTimeMin'] as num?)?.toInt(),
      syncStatus: map['syncStatus'] ?? 'synced',
    );
  }

  MoodLog copyWith({
    String? id,
    String? userId,
    DateTime? loggedAt,
    int? moodScore,
    int? energyLevel,
    int? stressLevel,
    List<String>? tags,
    String? voiceNotePath,
    int? screenTimeMin,
    String? syncStatus,
  }) {
    return MoodLog(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      loggedAt: loggedAt ?? this.loggedAt,
      moodScore: moodScore ?? this.moodScore,
      energyLevel: energyLevel ?? this.energyLevel,
      stressLevel: stressLevel ?? this.stressLevel,
      tags: tags ?? this.tags,
      voiceNotePath: voiceNotePath ?? this.voiceNotePath,
      screenTimeMin: screenTimeMin ?? this.screenTimeMin,
      syncStatus: syncStatus ?? this.syncStatus,
    );
  }
}
