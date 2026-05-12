import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../core/providers/core_providers.dart';

class GroupMemberScore {
  final String memberId;
  final String name;
  final int xpTotal;

  GroupMemberScore({
    required this.memberId,
    required this.name,
    required this.xpTotal,
  });

  Map<String, dynamic> toJson() => {
        'memberId': memberId,
        'name': name,
        'xpTotal': xpTotal,
      };

  factory GroupMemberScore.fromJson(Map<String, dynamic> json) => GroupMemberScore(
        memberId: json['memberId'] as String,
        name: json['name'] as String,
        xpTotal: json['xpTotal'] as int,
      );
}

class GroupPost {
  final String id;
  final String authorName;
  final String content;
  final DateTime timestamp;
  final int bonusKarma;

  GroupPost({
    required this.id,
    required this.authorName,
    required this.content,
    required this.timestamp,
    this.bonusKarma = 0,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'authorName': authorName,
        'content': content,
        'timestamp': timestamp.toIso8601String(),
        'bonusKarma': bonusKarma,
      };

  factory GroupPost.fromJson(Map<String, dynamic> json) => GroupPost(
        id: json['id'] as String,
        authorName: json['authorName'] as String,
        content: json['content'] as String,
        timestamp: DateTime.parse(json['timestamp'] as String),
        bonusKarma: json['bonusKarma'] as int? ?? 0,
      );
}

class SocialGroup {
  final String id;
  final String name;
  final List<GroupMemberScore> leaderboard;
  final List<GroupPost> feedPosts;

  SocialGroup({
    required this.id,
    required this.name,
    required this.leaderboard,
    required this.feedPosts,
  });

  SocialGroup copyWith({
    String? name,
    List<GroupMemberScore>? leaderboard,
    List<GroupPost>? feedPosts,
  }) {
    return SocialGroup(
      id: id,
      name: name ?? this.name,
      leaderboard: leaderboard ?? this.leaderboard,
      feedPosts: feedPosts ?? this.feedPosts,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'leaderboard': leaderboard.map((e) => e.toJson()).toList(),
        'feedPosts': feedPosts.map((e) => e.toJson()).toList(),
      };

  factory SocialGroup.fromJson(Map<String, dynamic> json) => SocialGroup(
        id: json['id'] as String,
        name: json['name'] as String,
        leaderboard: (json['leaderboard'] as List<dynamic>?)
                ?.map((e) => GroupMemberScore.fromJson(e as Map<String, dynamic>))
                .toList() ??
            [],
        feedPosts: (json['feedPosts'] as List<dynamic>?)
                ?.map((e) => GroupPost.fromJson(e as Map<String, dynamic>))
                .toList() ??
            [],
      );
}

class SocialGroupsNotifier extends StateNotifier<List<SocialGroup>> {
  final Ref ref;
  final FlutterSecureStorage _storage = const FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
  );
  static const _cacheKey = 'social_groups_network_data_cache';

  SocialGroupsNotifier(this.ref) : super([]) {
    _loadGroups();
  }

  Future<void> _loadGroups() async {
    try {
      final str = await _storage.read(key: _cacheKey);
      if (str != null) {
        final decoded = jsonDecode(str) as List<dynamic>;
        final parsed = decoded.map((e) => SocialGroup.fromJson(e as Map<String, dynamic>)).toList();
        if (parsed.isNotEmpty) {
          state = parsed;
          return;
        }
      }
    } catch (_) {}

    // Initial seeded groups arrays
    final seedArray = [
      SocialGroup(
        id: 'grp_family',
        name: '🔥 Super Family Clan',
        leaderboard: [
          GroupMemberScore(memberId: 'u1', name: 'Papa', xpTotal: 4850),
          GroupMemberScore(memberId: 'u2', name: 'Mummy', xpTotal: 4200),
          GroupMemberScore(memberId: 'u0', name: 'You', xpTotal: 3120),
          GroupMemberScore(memberId: 'u3', name: 'Rohan', xpTotal: 1950),
        ]..sort((a, b) => b.xpTotal.compareTo(a.xpTotal)),
        feedPosts: [
          GroupPost(
            id: 'p1',
            authorName: 'Papa',
            content: 'Completed morning walking routine! 6,200 steps mapped before 8 AM.',
            timestamp: DateTime.now().subtract(const Duration(minutes: 45)),
            bonusKarma: 15,
          ),
          GroupPost(
            id: 'p2',
            authorName: 'Mummy',
            content: 'Logged pure organic fluid hydration bases. Keep drinking water kids!',
            timestamp: DateTime.now().subtract(const Duration(hours: 3)),
            bonusKarma: 10,
          ),
        ],
      ),
      SocialGroup(
        id: 'grp_runners',
        name: '⚡ NCR Elite Cardio Squad',
        leaderboard: [
          GroupMemberScore(memberId: 'r1', name: 'Coach Dev', xpTotal: 9400),
          GroupMemberScore(memberId: 'r2', name: 'Pooja M.', xpTotal: 8100),
          GroupMemberScore(memberId: 'u0', name: 'You', xpTotal: 3120),
        ]..sort((a, b) => b.xpTotal.compareTo(a.xpTotal)),
        feedPosts: [
          GroupPost(
            id: 'p3',
            authorName: 'Coach Dev',
            content: 'Weekend tempo workout details seeded inside Active Workout pattern C endpoints. Prepare well!',
            timestamp: DateTime.now().subtract(const Duration(hours: 12)),
            bonusKarma: 50,
          ),
        ],
      ),
    ];

    state = seedArray;
    _cacheLocally(seedArray);
  }

  Future<void> _cacheLocally(List<SocialGroup> list) async {
    try {
      await _storage.write(key: _cacheKey, value: jsonEncode(list.map((e) => e.toJson()).toList()));
    } catch (_) {}
  }

  Future<void> createGroup(String name) async {
    final auth = ref.read(authProvider);
    final user = auth.valueOrNull;
    final myName = user?.name?.isNotEmpty == true ? user!.name : 'You';

    final newGrp = SocialGroup(
      id: 'grp_${DateTime.now().millisecondsSinceEpoch}',
      name: name,
      leaderboard: [
        GroupMemberScore(memberId: 'u0', name: myName, xpTotal: 3120),
      ],
      feedPosts: [
        GroupPost(
          id: 'p_init',
          authorName: myName,
          content: 'Created the group "$name". Let the fitness competition begin!',
          timestamp: DateTime.now(),
          bonusKarma: 50,
        ),
      ],
    );

    final updated = [newGrp, ...state];
    state = updated;
    await _cacheLocally(updated);
  }

  Future<void> addPost(String groupId, String content) async {
    final auth = ref.read(authProvider);
    final user = auth.valueOrNull;
    final myName = user?.name?.isNotEmpty == true ? user!.name : 'You';

    final newPost = GroupPost(
      id: 'p_${DateTime.now().millisecondsSinceEpoch}',
      authorName: myName,
      content: content,
      timestamp: DateTime.now(),
      bonusKarma: 20,
    );

    final updated = state.map((g) {
      if (g.id == groupId) {
        // Also update local user leaderboard score softly
        final mappedLb = g.leaderboard.map((lb) {
          if (lb.name == myName || lb.memberId == 'u0') {
            return GroupMemberScore(memberId: lb.memberId, name: lb.name, xpTotal: lb.xpTotal + 20);
          }
          return lb;
        }).toList()..sort((a, b) => b.xpTotal.compareTo(a.xpTotal));

        return g.copyWith(
          feedPosts: [newPost, ...g.feedPosts],
          leaderboard: mappedLb,
        );
      }
      return g;
    }).toList();

    state = updated;
    await _cacheLocally(updated);
  }
}

final socialGroupsProvider = StateNotifierProvider<SocialGroupsNotifier, List<SocialGroup>>((ref) {
  return SocialGroupsNotifier(ref);
});
