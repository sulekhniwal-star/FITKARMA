import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class KarmaEvent {
  final String id;
  final String title;
  final String category; // food, workout, steps, streak
  final int xpAwarded;
  final DateTime timestamp;

  KarmaEvent({
    required this.id,
    required this.title,
    required this.category,
    required this.xpAwarded,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'category': category,
        'xpAwarded': xpAwarded,
        'timestamp': timestamp.toIso8601String(),
      };

  factory KarmaEvent.fromJson(Map<String, dynamic> json) => KarmaEvent(
        id: json['id'] as String,
        title: json['title'] as String,
        category: json['category'] as String,
        xpAwarded: json['xpAwarded'] as int,
        timestamp: DateTime.parse(json['timestamp'] as String),
      );
}

class Achievement {
  final String id;
  final String title;
  final String description;
  final String icon;
  final bool isUnlocked;
  final int currentProgress;
  final int maxProgress;

  Achievement({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.isUnlocked,
    this.currentProgress = 1,
    this.maxProgress = 1,
  });

  double get progressRatio => (currentProgress / maxProgress).clamp(0.0, 1.0);
}

class Challenge {
  final String id;
  final String title;
  final String reward;
  final int currentDays;
  final int targetDays;

  Challenge({
    required this.id,
    required this.title,
    required this.reward,
    required this.currentDays,
    required this.targetDays,
  });

  double get progressRatio => (currentDays / targetDays).clamp(0.0, 1.0);
}

class KarmaLeaderboardUser {
  final String id;
  final String name;
  final int xp;
  final bool isCurrentUser;
  final String avatarStr;

  KarmaLeaderboardUser({
    required this.id,
    required this.name,
    required this.xp,
    this.isCurrentUser = false,
    required this.avatarStr,
  });
}

class KarmaState {
  final int totalXp;
  final int currentLevel;
  final String badgeTitle;
  final int nextLevelXp;
  final List<KarmaEvent> todayEvents;
  final Map<String, int> xpBreakdown; // category -> XP
  final List<Achievement> achievements;
  final List<Challenge> activeChallenges;
  final List<KarmaLeaderboardUser> leaderboard;

  KarmaState({
    required this.totalXp,
    required this.currentLevel,
    required this.badgeTitle,
    required this.nextLevelXp,
    required this.todayEvents,
    required this.xpBreakdown,
    required this.achievements,
    required this.activeChallenges,
    required this.leaderboard,
  });

  double get levelProgressRatio {
    final prevLevelXp = (currentLevel - 1) * 600;
    final currentTierRange = nextLevelXp - prevLevelXp;
    final earnedInTier = totalXp - prevLevelXp;
    if (currentTierRange <= 0) return 1.0;
    return (earnedInTier / currentTierRange).clamp(0.0, 1.0);
  }

  factory KarmaState.initial() {
    final now = DateTime.now();
    return KarmaState(
      totalXp: 4820,
      currentLevel: 8,
      badgeTitle: '⚡ Level 8 Warrior',
      nextLevelXp: 5000, // Level 8 range: 4200 -> 5000
      todayEvents: [
        KarmaEvent(
          id: 'ev_1',
          title: 'Logged Nutritious Lunch',
          category: 'food',
          xpAwarded: 25,
          timestamp: DateTime(now.year, now.month, now.day, 12, 30),
        ),
        KarmaEvent(
          id: 'ev_2',
          title: 'Hit Daily Step Target',
          category: 'steps',
          xpAwarded: 40,
          timestamp: DateTime(now.year, now.month, now.day, 11, 0),
        ),
        KarmaEvent(
          id: 'ev_3',
          title: 'Hydration Goal Met',
          category: 'streak',
          xpAwarded: 15,
          timestamp: DateTime(now.year, now.month, now.day, 10, 0),
        ),
        KarmaEvent(
          id: 'ev_4',
          title: 'Morning Yoga Mastery',
          category: 'workout',
          xpAwarded: 50,
          timestamp: DateTime(now.year, now.month, now.day, 8, 15),
        ),
      ],
      xpBreakdown: {
        'food': 1420,
        'workout': 2100,
        'steps': 850,
        'streak': 450,
      },
      achievements: [
        Achievement(
          id: 'ach_1',
          title: 'Early Bird',
          description: 'Log physical workouts before 7:00 AM consistently.',
          icon: '🌅',
          isUnlocked: true,
        ),
        Achievement(
          id: 'ach_2',
          title: 'Zen Master',
          description: 'Achieve 7 consecutive nights of quality recovery sleep.',
          icon: '🧘',
          isUnlocked: true,
        ),
        Achievement(
          id: 'ach_3',
          title: 'Hydration Hero',
          description: 'Exceed 3 liters of daily fluid intake across 10 days.',
          icon: '💧',
          isUnlocked: true,
        ),
        Achievement(
          id: 'ach_4',
          title: 'Century Marathon',
          description: 'Track 100 cumulative kilometers of distance.',
          icon: '🏃',
          isUnlocked: false,
          currentProgress: 82,
          maxProgress: 100,
        ),
        Achievement(
          id: 'ach_5',
          title: 'Chef de Partie',
          description: 'Log 30 wholesome home-cooked meals.',
          icon: '🥗',
          isUnlocked: false,
          currentProgress: 18,
          maxProgress: 30,
        ),
      ],
      activeChallenges: [
        Challenge(
          id: 'chal_1',
          title: '7-Day Refined Sugar Detox',
          reward: '+150 XP Bonus',
          currentDays: 4,
          targetDays: 7,
        ),
        Challenge(
          id: 'chal_2',
          title: 'Weekend Steps Showdown',
          reward: '+100 XP Bonus',
          currentDays: 14,
          targetDays: 20, // thousands
        ),
      ],
      leaderboard: [
        KarmaLeaderboardUser(id: 'usr_1', name: 'Rohan Sharma', xp: 5420, avatarStr: 'RS'),
        KarmaLeaderboardUser(id: 'usr_curr', name: 'You', xp: 4820, isCurrentUser: true, avatarStr: 'ME'),
        KarmaLeaderboardUser(id: 'usr_2', name: 'Aanya Patel', xp: 4100, avatarStr: 'AP'),
        KarmaLeaderboardUser(id: 'usr_3', name: 'Kabir Mehta', xp: 3890, avatarStr: 'KM'),
      ],
    );
  }
}

class KarmaNotifier extends StateNotifier<KarmaState> {
  final FlutterSecureStorage _storage = const FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
  );
  static const _storageKey = 'karma_state_cache';

  KarmaNotifier() : super(KarmaState.initial()) {
    _loadState();
  }

  Future<void> _loadState() async {
    try {
      final jsonStr = await _storage.read(key: _storageKey);
      if (jsonStr != null) {
        final map = jsonDecode(jsonStr) as Map<String, dynamic>;
        final int xp = map['totalXp'] as int? ?? 4820;
        final int lvl = _calcLevel(xp);
        final nextXp = _calcNextLevelTarget(lvl);
        
        // Restore dynamic custom state updates
        state = KarmaState(
          totalXp: xp,
          currentLevel: lvl,
          badgeTitle: '⚡ Level $lvl Warrior',
          nextLevelXp: nextXp,
          todayEvents: state.todayEvents,
          xpBreakdown: {
            'food': (xp * 0.3).round(),
            'workout': (xp * 0.44).round(),
            'steps': (xp * 0.17).round(),
            'streak': (xp * 0.09).round(),
          },
          achievements: state.achievements,
          activeChallenges: state.activeChallenges,
          leaderboard: state.leaderboard.map((u) {
            if (u.isCurrentUser) {
              return KarmaLeaderboardUser(id: u.id, name: u.name, xp: xp, isCurrentUser: true, avatarStr: u.avatarStr);
            }
            return u;
          }).toList()..sort((a, b) => b.xp.compareTo(a.xp)),
        );
      }
    } catch (_) {
      // Keep initial fallback defaults
    }
  }

  Future<void> _saveState(int newXp) async {
    try {
      await _storage.write(key: _storageKey, value: jsonEncode({'totalXp': newXp}));
    } catch (_) {}
  }

  int _calcLevel(int xp) {
    // Arbitrary scale: Level N target = N * 600
    return (xp ~/ 600) + 1;
  }

  int _calcNextLevelTarget(int level) {
    return level * 600;
  }

  void addKarmaEvent(String title, String category, int xp) {
    final now = DateTime.now();
    final newEvent = KarmaEvent(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      category: category,
      xpAwarded: xp,
      timestamp: now,
    );

    final newXp = state.totalXp + xp;
    final newLvl = _calcLevel(newXp);
    final nextXp = _calcNextLevelTarget(newLvl);

    final updatedBreakdown = {...state.xpBreakdown};
    updatedBreakdown[category] = (updatedBreakdown[category] ?? 0) + xp;

    final updatedLeaderboard = state.leaderboard.map((u) {
      if (u.isCurrentUser) {
        return KarmaLeaderboardUser(id: u.id, name: u.name, xp: newXp, isCurrentUser: true, avatarStr: u.avatarStr);
      }
      return u;
    }).toList()..sort((a, b) => b.xp.compareTo(a.xp));

    state = KarmaState(
      totalXp: newXp,
      currentLevel: newLvl,
      badgeTitle: '⚡ Level $newLvl Warrior',
      nextLevelXp: nextXp,
      todayEvents: [newEvent, ...state.todayEvents],
      xpBreakdown: updatedBreakdown,
      achievements: state.achievements,
      activeChallenges: state.activeChallenges,
      leaderboard: updatedLeaderboard,
    );

    _saveState(newXp);
  }
}

final karmaStateProvider = StateNotifierProvider<KarmaNotifier, KarmaState>((ref) {
  return KarmaNotifier();
});
