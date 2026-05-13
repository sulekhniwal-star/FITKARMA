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

  Achievement copyWith({
    String? id,
    String? title,
    String? description,
    String? icon,
    bool? isUnlocked,
    int? currentProgress,
    int? maxProgress,
  }) {
    return Achievement(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      icon: icon ?? this.icon,
      isUnlocked: isUnlocked ?? this.isUnlocked,
      currentProgress: currentProgress ?? this.currentProgress,
      maxProgress: maxProgress ?? this.maxProgress,
    );
  }
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
          id: 'first_food',
          title: 'First Food Log',
          description: 'Logged your very first healthy nutritional entry.',
          icon: '🥗',
          isUnlocked: true,
          currentProgress: 1,
          maxProgress: 1,
        ),
        Achievement(
          id: 'workout_1',
          title: 'First Workout Session',
          description: 'Completed your opening physical conditioning exercise.',
          icon: '💪',
          isUnlocked: true,
          currentProgress: 1,
          maxProgress: 1,
        ),
        Achievement(
          id: 'streak_7',
          title: '7-Day Continuous Streak',
          description: 'Maintained uninterrupted tracking rituals for a solid week.',
          icon: '🔥',
          isUnlocked: true,
          currentProgress: 7,
          maxProgress: 7,
        ),
        Achievement(
          id: 'streak_30',
          title: '30-Day Devotion Milestone',
          description: 'Unlocked supreme dedication over an entire active month.',
          icon: '⚡',
          isUnlocked: false,
          currentProgress: 12,
          maxProgress: 30,
        ),
        Achievement(
          id: 'steps_10k',
          title: '10,000 Daily Steps',
          description: 'Crushed the golden step marker standard in a single epoch.',
          icon: '🚶',
          isUnlocked: false,
          currentProgress: 7432,
          maxProgress: 10000,
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

class KarmaNotifier extends Notifier<KarmaState> {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  static const _storageKey = 'karma_state_cache';

  @override
  KarmaState build() {
    Future.microtask(() => _loadState());
    return KarmaState.initial();
  }

  static String getLevelTitle(int level) {
    const names = [
      'Newcomer',
      'Beginner',
      'Starter',
      'Mover',
      'Achiever',
      'Consistent',
      'Dedicated',
      'Warrior',
      'Champion',
      'Elite',
      'Legend',
      'Grandmaster',
      'Karma Master',
    ];
    if (level <= 0) return names.first;
    if (level > names.length) return names.last;
    return names[level - 1];
  }

  Future<void> _loadState() async {
    try {
      final jsonStr = await _storage.read(key: _storageKey);
      if (jsonStr != null) {
        final map = jsonDecode(jsonStr) as Map<String, dynamic>;
        final int xp = map['totalXp'] as int? ?? 4820;
        final int lvl = _calcLevel(xp);
        final nextXp = _calcNextLevelTarget(lvl);
        final titleStr = getLevelTitle(lvl);
        
        // Restore dynamic custom state updates
        state = KarmaState(
          totalXp: xp,
          currentLevel: lvl,
          badgeTitle: '⚡ Level $lvl $titleStr',
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
    final titleStr = getLevelTitle(newLvl);

    final updatedBreakdown = {...state.xpBreakdown};
    updatedBreakdown[category] = (updatedBreakdown[category] ?? 0) + xp;

    final updatedLeaderboard = state.leaderboard.map((u) {
      if (u.isCurrentUser) {
        return KarmaLeaderboardUser(id: u.id, name: u.name, xp: newXp, isCurrentUser: true, avatarStr: u.avatarStr);
      }
      return u;
    }).toList()..sort((a, b) => b.xp.compareTo(a.xp));

    final updatedAchievements = state.achievements.map((ach) {
      if (ach.isUnlocked) return ach;

      bool shouldUnlock = false;
      if (ach.id == 'first_food' && category == 'food') {
        shouldUnlock = true;
      } else if (ach.id == 'workout_1' && category == 'workout') {
        shouldUnlock = true;
      } else if (ach.id == 'steps_10k' && category == 'steps') {
        shouldUnlock = true;
      } else if (ach.id == 'streak_7' && title.contains('7-Day')) {
        shouldUnlock = true;
      } else if (ach.id == 'streak_30' && title.contains('30-Day')) {
        shouldUnlock = true;
      }

      if (shouldUnlock) {
        return ach.copyWith(isUnlocked: true, currentProgress: ach.maxProgress);
      }
      return ach;
    }).toList();

    state = KarmaState(
      totalXp: newXp,
      currentLevel: newLvl,
      badgeTitle: '⚡ Level $newLvl $titleStr',
      nextLevelXp: nextXp,
      todayEvents: [newEvent, ...state.todayEvents],
      xpBreakdown: updatedBreakdown,
      achievements: updatedAchievements,
      activeChallenges: state.activeChallenges,
      leaderboard: updatedLeaderboard,
    );

    _saveState(newXp);
  }
}

final karmaStateProvider = NotifierProvider<KarmaNotifier, KarmaState>(KarmaNotifier.new);
