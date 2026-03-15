// lib/features/karma/data/karma_hive_service.dart
import 'package:hive_flutter/hive_flutter.dart';
import '../../../core/constants/hive_boxes.dart';
import '../domain/karma_model.dart';

/// Service for managing karma/XP in Hive local storage
class KarmaHiveService {
  static Box<KarmaBalance>? _karmaBox;
  static Box<KarmaTransaction>? _transactionsBox;

  /// Initialize karma boxes
  static Future<void> init() async {
    if (!Hive.isAdapterRegistered(20)) {
      Hive.registerAdapter(KarmaTransactionAdapter());
    }
    if (!Hive.isAdapterRegistered(21)) {
      Hive.registerAdapter(KarmaBalanceAdapter());
    }
    _karmaBox = await Hive.openBox<KarmaBalance>(HiveBoxes.karma);
    _transactionsBox = await Hive.openBox<KarmaTransaction>(
      'karma_transactions_box',
    );
  }

  /// Get karma box
  static Box<KarmaBalance> get karmaBox {
    if (_karmaBox == null) {
      throw StateError('KarmaHiveService not initialized. Call init() first.');
    }
    return _karmaBox!;
  }

  /// Get transactions box
  static Box<KarmaTransaction> get transactionsBox {
    if (_transactionsBox == null) {
      throw StateError('KarmaHiveService not initialized. Call init() first.');
    }
    return _transactionsBox!;
  }

  /// Get user's karma balance
  static KarmaBalance? getBalance(String odId) {
    return karmaBox.get(odId);
  }

  /// Get or create user's karma balance
  static KarmaBalance getOrCreateBalance(String odId) {
    var balance = karmaBox.get(odId);
    if (balance == null) {
      balance = KarmaBalance(odId: odId);
      karmaBox.put(odId, balance);
    }
    return balance;
  }

  /// Update karma balance
  static Future<void> updateBalance(KarmaBalance balance) async {
    await karmaBox.put(balance.odId, balance);
  }

  /// Add XP to balance
  static Future<KarmaBalance> addXP({
    required String odId,
    required int amount,
    required String action,
    required String description,
    double multiplier = 1.0,
  }) async {
    // Get or create balance
    var balance = getOrCreateBalance(odId);

    // Check and update streak
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    int newStreak = balance.currentStreak;
    if (balance.lastActivityDate != null) {
      final lastDate = DateTime(
        balance.lastActivityDate!.year,
        balance.lastActivityDate!.month,
        balance.lastActivityDate!.day,
      );
      final daysDiff = today.difference(lastDate).inDays;

      if (daysDiff == 1) {
        // Consecutive day - increment streak
        newStreak++;
      } else if (daysDiff > 1) {
        // Streak broken - reset
        newStreak = 1;
      }
      // Same day - no change to streak
    } else {
      newStreak = 1;
    }

    // Calculate streak multiplier
    double streakMultiplier = 1.0;
    if (newStreak >= 30) {
      streakMultiplier = 2.0;
    } else if (newStreak >= 7) {
      streakMultiplier = 1.5;
    }

    // Apply multipliers
    final totalMultiplier = multiplier * streakMultiplier;
    final finalAmount = (amount * totalMultiplier).round();

    // Calculate new level
    final newTotalXP = balance.totalXP + finalAmount;
    int newLevel = balance.currentLevel;
    while ((100 * (newLevel + 1) * 1.5).round() <= newTotalXP) {
      newLevel++;
    }

    // Update weekly XP
    int newWeeklyXP = balance.weeklyXP;
    if (balance.weeklyResetDate != null) {
      final lastReset = DateTime(
        balance.weeklyResetDate!.year,
        balance.weeklyResetDate!.month,
        balance.weeklyResetDate!.day,
      );
      if (today.difference(lastReset).inDays >= 7) {
        // Reset weekly XP
        newWeeklyXP = finalAmount;
      } else {
        newWeeklyXP += finalAmount;
      }
    } else {
      newWeeklyXP = finalAmount;
    }

    // Create updated balance
    balance = balance.copyWith(
      totalXP: newTotalXP,
      currentLevel: newLevel,
      currentStreak: newStreak,
      lastActivityDate: now,
      weeklyXP: newWeeklyXP,
      weeklyResetDate: now,
    );

    await updateBalance(balance);

    // Create transaction record
    final transaction = KarmaTransaction.create(
      userId: odId,
      amount: amount,
      action: action,
      description: description,
      multiplier: totalMultiplier,
    );
    await addTransaction(transaction);

    return balance;
  }

  /// Add transaction
  static Future<void> addTransaction(KarmaTransaction transaction) async {
    await transactionsBox.put(transaction.id, transaction);
  }

  /// Get transaction history
  static List<KarmaTransaction> getTransactionHistory(
    String odId, {
    int limit = 50,
  }) {
    return transactionsBox.values.where((t) => t.userId == odId).toList()
      ..sort((a, b) => b.timestamp.compareTo(a.timestamp));
  }

  /// Get pending sync transactions
  static List<KarmaTransaction> getPendingSync() {
    return transactionsBox.values
        .where((t) => t.syncStatus == 'pending')
        .toList();
  }

  /// Mark transactions as synced
  static Future<void> markAsSynced(List<String> ids) async {
    for (final id in ids) {
      final transaction = transactionsBox.get(id);
      if (transaction != null) {
        final updated = KarmaTransaction(
          id: transaction.id,
          userId: transaction.userId,
          amount: transaction.amount,
          action: transaction.action,
          description: transaction.description,
          timestamp: transaction.timestamp,
          syncStatus: 'synced',
          multiplier: transaction.multiplier,
        );
        await transactionsBox.put(id, updated);
      }
    }
  }

  /// Clear all data (for testing/reset)
  static Future<void> clearAll() async {
    await karmaBox.clear();
    await transactionsBox.clear();
  }
}
