// lib/features/karma/domain/karma_model.dart
import 'package:hive/hive.dart';

part 'karma_model.g.dart';

/// Karma/XP transaction entry
@HiveType(typeId: 20)
class KarmaTransaction extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String userId;

  @HiveField(2)
  int amount;

  @HiveField(3)
  String action; // 'steps', 'food_log', 'workout', 'streak_bonus', etc.

  @HiveField(4)
  String description;

  @HiveField(5)
  DateTime timestamp;

  @HiveField(6)
  String syncStatus; // 'pending' | 'synced'

  @HiveField(7)
  double multiplier; // 1.0, 1.5, 2.0 for streaks

  KarmaTransaction({
    required this.id,
    required this.userId,
    required this.amount,
    required this.action,
    required this.description,
    required this.timestamp,
    this.syncStatus = 'pending',
    this.multiplier = 1.0,
  });

  /// Create a new transaction
  factory KarmaTransaction.create({
    required String userId,
    required int amount,
    required String action,
    required String description,
    double multiplier = 1.0,
  }) {
    return KarmaTransaction(
      id: '${userId}_${DateTime.now().millisecondsSinceEpoch}',
      userId: userId,
      amount: amount,
      action: action,
      description: description,
      timestamp: DateTime.now(),
      syncStatus: 'pending',
      multiplier: multiplier,
    );
  }

  /// Get final amount with multiplier applied
  int get finalAmount => (amount * multiplier).round();

  /// Convert to Appwrite document
  Map<String, dynamic> toAppwrite() => {
    'user_id': userId,
    'amount': amount,
    'action': action,
    'description': description,
    'timestamp': timestamp.toIso8601String(),
    'multiplier': multiplier,
  };
}

/// User's karma balance snapshot
@HiveType(typeId: 21)
class KarmaBalance extends HiveObject {
  @HiveField(0)
  String odId;

  @HiveField(1)
  int totalXP;

  @HiveField(2)
  int currentLevel;

  @HiveField(3)
  int currentStreak;

  @HiveField(4)
  DateTime? lastActivityDate;

  @HiveField(5)
  int weeklyXP;

  @HiveField(6)
  DateTime? weeklyResetDate;

  KarmaBalance({
    required this.odId,
    this.totalXP = 0,
    this.currentLevel = 1,
    this.currentStreak = 0,
    this.lastActivityDate,
    this.weeklyXP = 0,
    this.weeklyResetDate,
  });

  /// Calculate XP needed for next level (100 * level^1.5)
  int get xpForNextLevel => (100 * (currentLevel + 1) * 1.5).round();

  /// Calculate progress to next level
  double get levelProgress {
    final xpForCurrent = (100 * currentLevel * 1.5).round();
    final xpNeeded = xpForNextLevel - xpForCurrent;
    if (xpNeeded <= 0) return 1.0;
    final xpInLevel = totalXP - xpForCurrent;
    return (xpInLevel / xpNeeded).clamp(0.0, 1.0);
  }

  /// Get streak multiplier
  double get streakMultiplier {
    if (currentStreak >= 30) return 2.0;
    if (currentStreak >= 7) return 1.5;
    return 1.0;
  }

  /// Copy with modifications
  KarmaBalance copyWith({
    String? odId,
    int? totalXP,
    int? currentLevel,
    int? currentStreak,
    DateTime? lastActivityDate,
    int? weeklyXP,
    DateTime? weeklyResetDate,
  }) {
    return KarmaBalance(
      odId: odId ?? this.odId,
      totalXP: totalXP ?? this.totalXP,
      currentLevel: currentLevel ?? this.currentLevel,
      currentStreak: currentStreak ?? this.currentStreak,
      lastActivityDate: lastActivityDate ?? this.lastActivityDate,
      weeklyXP: weeklyXP ?? this.weeklyXP,
      weeklyResetDate: weeklyResetDate ?? this.weeklyResetDate,
    );
  }
}
