import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../karma/karma_service.dart';

class StreakState {
  final int currentStreak;
  final DateTime? lastActivityDate;
  final Set<int> claimedMilestones;

  StreakState({
    required this.currentStreak,
    this.lastActivityDate,
    required this.claimedMilestones,
  });

  Map<String, dynamic> toJson() => {
        'currentStreak': currentStreak,
        'lastActivityDate': lastActivityDate?.toIso8601String(),
        'claimedMilestones': claimedMilestones.toList(),
      };

  factory StreakState.fromJson(Map<String, dynamic> json) => StreakState(
        currentStreak: json['currentStreak'] as int? ?? 0,
        lastActivityDate: json['lastActivityDate'] != null ? DateTime.tryParse(json['lastActivityDate'] as String) : null,
        claimedMilestones: (json['claimedMilestones'] as List<dynamic>? ?? []).map((e) => e as int).toSet(),
      );

  factory StreakState.initial() => StreakState(currentStreak: 0, claimedMilestones: {});
}

class StreakNotifier extends Notifier<StreakState> {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  static const _storageKey = 'user_streak_state_v2';

  @override
  StreakState build() {
    Future.microtask(() => _load());
    return StreakState.initial();
  }

  Future<void> _load() async {
    try {
      final str = await _storage.read(key: _storageKey);
      if (str != null) {
        state = StreakState.fromJson(jsonDecode(str));
      }
    } catch (_) {}
  }

  Future<void> _save(StreakState s) async {
    try {
      await _storage.write(key: _storageKey, value: jsonEncode(s.toJson()));
    } catch (_) {}
  }

  Future<void> logActivity() async {
    final now = DateTime.now();
    final last = state.lastActivityDate;

    int newStreak = state.currentStreak;
    final milestones = Set<int>.from(state.claimedMilestones);

    if (last == null) {
      newStreak = 1;
    } else {
      final diff = DateTime(now.year, now.month, now.day).difference(DateTime(last.year, last.month, last.day)).inDays;
      if (diff == 1) {
        newStreak += 1;
      } else if (diff > 1) {
        newStreak = 1;
        milestones.clear();
      }
    }

    state = StreakState(
      currentStreak: newStreak,
      lastActivityDate: now,
      claimedMilestones: milestones,
    );
    await _save(state);

    // 7-day streak detection -> award streak_7day XP
    if (newStreak >= 7 && !milestones.contains(7)) {
      milestones.add(7);
      state = StreakState(currentStreak: newStreak, lastActivityDate: now, claimedMilestones: milestones);
      await _save(state);
      try {
        await ref.read(karmaServiceProvider).awardXP('streak_7day');
      } catch (_) {}
    }

    // 30-day streak detection -> award streak_30day XP
    if (newStreak >= 30 && !milestones.contains(30)) {
      milestones.add(30);
      state = StreakState(currentStreak: newStreak, lastActivityDate: now, claimedMilestones: milestones);
      await _save(state);
      try {
        await ref.read(karmaServiceProvider).awardXP('streak_30day');
      } catch (_) {}
    }
  }
}

final streakStateProvider = NotifierProvider<StreakNotifier, StreakState>(StreakNotifier.new);
