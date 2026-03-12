/// Habit definition model for tracking daily habits
/// Supports both preset and custom habits with streak tracking
class Habit {
  final String id;
  final String userId;
  final String name;
  final String nameHi; // Hindi translation
  final String icon; // Emoji or icon name
  final int targetCount; // e.g., 8 for glasses of water
  final String unit; // glasses, minutes, pages, etc.
  final HabitFrequency frequency;
  final int currentStreak;
  final int longestStreak;
  final String? reminderTime; // HH:MM format
  final bool isPreset;
  final DateTime createdAt;
  final bool isActive;

  Habit({
    required this.id,
    required this.userId,
    required this.name,
    required this.nameHi,
    required this.icon,
    required this.targetCount,
    required this.unit,
    required this.frequency,
    this.currentStreak = 0,
    this.longestStreak = 0,
    this.reminderTime,
    this.isPreset = false,
    required this.createdAt,
    this.isActive = true,
  });

  /// Preset habits available for all users
  static List<Habit> get presetHabits => [
    Habit(
      id: 'water_8',
      userId: '',
      name: 'Drink Water',
      nameHi: 'पानी पिएं',
      icon: '💧',
      targetCount: 8,
      unit: 'glasses',
      frequency: HabitFrequency.daily,
      isPreset: true,
      createdAt: DateTime.now(),
    ),
    Habit(
      id: 'meditation_10',
      userId: '',
      name: 'Meditate',
      nameHi: 'ध्यान करें',
      icon: '🧘',
      targetCount: 10,
      unit: 'minutes',
      frequency: HabitFrequency.daily,
      isPreset: true,
      createdAt: DateTime.now(),
    ),
    Habit(
      id: 'walk_30',
      userId: '',
      name: 'Walk',
      nameHi: 'पैदल चलें',
      icon: '🚶',
      targetCount: 30,
      unit: 'minutes',
      frequency: HabitFrequency.daily,
      isPreset: true,
      createdAt: DateTime.now(),
    ),
    Habit(
      id: 'read_10',
      userId: '',
      name: 'Read',
      nameHi: 'पढ़ें',
      icon: '📖',
      targetCount: 10,
      unit: 'pages',
      frequency: HabitFrequency.daily,
      isPreset: true,
      createdAt: DateTime.now(),
    ),
    Habit(
      id: 'no_sugar',
      userId: '',
      name: 'No Sugar',
      nameHi: 'चीनी नहीं',
      icon: '🍬',
      targetCount: 1,
      unit: 'day',
      frequency: HabitFrequency.daily,
      isPreset: true,
      createdAt: DateTime.now(),
    ),
  ];

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'name': name,
      'nameHi': nameHi,
      'icon': icon,
      'targetCount': targetCount,
      'unit': unit,
      'frequency': frequency.name,
      'currentStreak': currentStreak,
      'longestStreak': longestStreak,
      'reminderTime': reminderTime,
      'isPreset': isPreset,
      'createdAt': createdAt.toIso8601String(),
      'isActive': isActive,
    };
  }

  factory Habit.fromMap(Map<String, dynamic> map) {
    return Habit(
      id: map['id'] ?? '',
      userId: map['userId'] ?? '',
      name: map['name'] ?? '',
      nameHi: map['nameHi'] ?? '',
      icon: map['icon'] ?? '✅',
      targetCount: map['targetCount'] ?? 1,
      unit: map['unit'] ?? 'times',
      frequency: HabitFrequency.values.firstWhere(
        (e) => e.name == map['frequency'],
        orElse: () => HabitFrequency.daily,
      ),
      currentStreak: map['currentStreak'] ?? 0,
      longestStreak: map['longestStreak'] ?? 0,
      reminderTime: map['reminderTime'],
      isPreset: map['isPreset'] ?? false,
      createdAt: DateTime.parse(
        map['createdAt'] ?? DateTime.now().toIso8601String(),
      ),
      isActive: map['isActive'] ?? true,
    );
  }

  Habit copyWith({
    String? id,
    String? userId,
    String? name,
    String? nameHi,
    String? icon,
    int? targetCount,
    String? unit,
    HabitFrequency? frequency,
    int? currentStreak,
    int? longestStreak,
    String? reminderTime,
    bool? isPreset,
    DateTime? createdAt,
    bool? isActive,
  }) {
    return Habit(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      nameHi: nameHi ?? this.nameHi,
      icon: icon ?? this.icon,
      targetCount: targetCount ?? this.targetCount,
      unit: unit ?? this.unit,
      frequency: frequency ?? this.frequency,
      currentStreak: currentStreak ?? this.currentStreak,
      longestStreak: longestStreak ?? this.longestStreak,
      reminderTime: reminderTime ?? this.reminderTime,
      isPreset: isPreset ?? this.isPreset,
      createdAt: createdAt ?? this.createdAt,
      isActive: isActive ?? this.isActive,
    );
  }
}

/// Habit frequency options
enum HabitFrequency { daily, weekdays, custom }

/// Record of habit completion for a specific day
class HabitCompletion {
  final String id;
  final String habitId;
  final String userId;
  final DateTime date;
  final int completedCount;
  final bool isCompleted; // true if target reached
  final DateTime? completedAt;

  HabitCompletion({
    required this.id,
    required this.habitId,
    required this.userId,
    required this.date,
    required this.completedCount,
    required this.isCompleted,
    this.completedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'habitId': habitId,
      'userId': userId,
      'date': date.toIso8601String().split('T')[0],
      'completedCount': completedCount,
      'isCompleted': isCompleted,
      'completedAt': completedAt?.toIso8601String(),
    };
  }

  factory HabitCompletion.fromMap(Map<String, dynamic> map) {
    return HabitCompletion(
      id: map['id'] ?? '',
      habitId: map['habitId'] ?? '',
      userId: map['userId'] ?? '',
      date: DateTime.parse(map['date'] ?? DateTime.now().toIso8601String()),
      completedCount: map['completedCount'] ?? 0,
      isCompleted: map['isCompleted'] ?? false,
      completedAt: map['completedAt'] != null
          ? DateTime.parse(map['completedAt'])
          : null,
    );
  }
}
