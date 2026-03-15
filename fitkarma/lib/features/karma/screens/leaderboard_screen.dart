// lib/features/karma/screens/leaderboard_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/theme/app_colors.dart';
import '../data/karma_aw_service.dart';

/// Leaderboard tab enum
enum LeaderboardTab { friends, city, national }

/// Leaderboard entry
class LeaderboardEntry {
  final String odId;
  final String name;
  final String? avatarUrl;
  final int weeklyXP;
  final int rank;

  const LeaderboardEntry({
    required this.odId,
    required this.name,
    this.avatarUrl,
    required this.weeklyXP,
    required this.rank,
  });
}

/// State for leaderboard
class LeaderboardState {
  final List<LeaderboardEntry> entries;
  final LeaderboardTab currentTab;
  final bool isLoading;
  final String? error;

  const LeaderboardState({
    this.entries = const [],
    this.currentTab = LeaderboardTab.friends,
    this.isLoading = false,
    this.error,
  });

  LeaderboardState copyWith({
    List<LeaderboardEntry>? entries,
    LeaderboardTab? currentTab,
    bool? isLoading,
    String? error,
  }) {
    return LeaderboardState(
      entries: entries ?? this.entries,
      currentTab: currentTab ?? this.currentTab,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

/// Notifier for leaderboard state
class LeaderboardNotifier extends StateNotifier<LeaderboardState> {
  LeaderboardNotifier() : super(const LeaderboardState());

  /// Change tab
  void changeTab(LeaderboardTab tab) {
    state = state.copyWith(currentTab: tab);
    _loadLeaderboard();
  }

  /// Load leaderboard data
  Future<void> _loadLeaderboard() async {
    state = state.copyWith(isLoading: true);

    try {
      // Fetch from Appwrite
      final data = await KarmaAwService.getWeeklyLeaderboard();

      // Convert to entries (mock data for demo)
      final entries = <LeaderboardEntry>[];
      for (int i = 0; i < data.length; i++) {
        entries.add(
          LeaderboardEntry(
            odId: data[i]['user_id'] as String,
            name: 'User ${data[i]['user_id'].toString().substring(0, 6)}',
            weeklyXP: data[i]['weekly_xp'] as int,
            rank: i + 1,
          ),
        );
      }

      // If no data, show mock data for demo
      if (entries.isEmpty) {
        entries.addAll(_getMockData(state.currentTab));
      }

      state = state.copyWith(entries: entries, isLoading: false);
    } catch (e) {
      // Show mock data on error
      state = state.copyWith(
        entries: _getMockData(state.currentTab),
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  /// Get mock data for demo
  List<LeaderboardEntry> _getMockData(LeaderboardTab tab) {
    switch (tab) {
      case LeaderboardTab.friends:
        return const [
          LeaderboardEntry(odId: '1', name: 'You', weeklyXP: 1250, rank: 1),
          LeaderboardEntry(odId: '2', name: 'Rahul S.', weeklyXP: 980, rank: 2),
          LeaderboardEntry(odId: '3', name: 'Priya M.', weeklyXP: 875, rank: 3),
          LeaderboardEntry(odId: '4', name: 'Amit K.', weeklyXP: 720, rank: 4),
          LeaderboardEntry(odId: '5', name: 'Sarah J.', weeklyXP: 650, rank: 5),
        ];
      case LeaderboardTab.city:
        return const [
          LeaderboardEntry(
            odId: '1',
            name: 'Mumbai Runners',
            weeklyXP: 15000,
            rank: 1,
          ),
          LeaderboardEntry(
            odId: '2',
            name: 'Delhi Fitness',
            weeklyXP: 12500,
            rank: 2,
          ),
          LeaderboardEntry(
            odId: '3',
            name: 'Bangalore Gym',
            weeklyXP: 9800,
            rank: 3,
          ),
          LeaderboardEntry(
            odId: '4',
            name: 'Chennai Sports',
            weeklyXP: 8200,
            rank: 4,
          ),
          LeaderboardEntry(
            odId: '5',
            name: 'Hyd Warriors',
            weeklyXP: 7500,
            rank: 5,
          ),
        ];
      case LeaderboardTab.national:
        return const [
          LeaderboardEntry(
            odId: '1',
            name: 'FitIndia Team',
            weeklyXP: 250000,
            rank: 1,
          ),
          LeaderboardEntry(
            odId: '2',
            name: 'Health Warriors',
            weeklyXP: 180000,
            rank: 2,
          ),
          LeaderboardEntry(
            odId: '3',
            name: 'Yoga Champions',
            weeklyXP: 145000,
            rank: 3,
          ),
          LeaderboardEntry(
            odId: '4',
            name: 'Run4Life',
            weeklyXP: 120000,
            rank: 4,
          ),
          LeaderboardEntry(
            odId: '5',
            name: 'Wellness Plus',
            weeklyXP: 95000,
            rank: 5,
          ),
        ];
    }
  }

  /// Refresh leaderboard
  Future<void> refresh() async {
    await _loadLeaderboard();
  }
}

/// Provider for leaderboard
final leaderboardProvider =
    StateNotifierProvider<LeaderboardNotifier, LeaderboardState>((ref) {
      return LeaderboardNotifier();
    });

/// Leaderboard screen with tabs
class LeaderboardScreen extends ConsumerStatefulWidget {
  const LeaderboardScreen({super.key});

  @override
  ConsumerState<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends ConsumerState<LeaderboardScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(_onTabChanged);

    // Load initial data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(leaderboardProvider.notifier).refresh();
    });
  }

  void _onTabChanged() {
    if (!_tabController.indexIsChanging) {
      final tabs = [
        LeaderboardTab.friends,
        LeaderboardTab.city,
        LeaderboardTab.national,
      ];
      ref
          .read(leaderboardProvider.notifier)
          .changeTab(tabs[_tabController.index]);
    }
  }

  @override
  void dispose() {
    _tabController.removeListener(_onTabChanged);
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(leaderboardProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Leaderboard'),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Friends'),
            Tab(text: 'City'),
            Tab(text: 'National'),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.read(leaderboardProvider.notifier).refresh(),
          ),
        ],
      ),
      body: state.isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: () => ref.read(leaderboardProvider.notifier).refresh(),
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: state.entries.length,
                itemBuilder: (context, index) {
                  final entry = state.entries[index];
                  return _LeaderboardTile(entry: entry);
                },
              ),
            ),
    );
  }
}

/// Leaderboard tile
class _LeaderboardTile extends StatelessWidget {
  final LeaderboardEntry entry;

  const _LeaderboardTile({required this.entry});

  @override
  Widget build(BuildContext context) {
    final isTopThree = entry.rank <= 3;

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: _buildRankBadge(),
        title: Text(
          entry.name,
          style: TextStyle(
            fontWeight: isTopThree ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        subtitle: Text(
          'Weekly XP: ${_formatNumber(entry.weeklyXP)}',
          style: const TextStyle(color: Colors.grey),
        ),
        trailing: isTopThree
            ? Icon(
                _getMedalIcon(entry.rank),
                color: _getMedalColor(entry.rank),
                size: 28,
              )
            : Text(
                '#${entry.rank}',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(color: Colors.grey),
              ),
      ),
    );
  }

  Widget _buildRankBadge() {
    if (entry.rank <= 3) {
      return Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: _getMedalColor(entry.rank).withValues(alpha: 0.1),
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Text(
            '${entry.rank}',
            style: TextStyle(
              color: _getMedalColor(entry.rank),
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
      );
    }

    return CircleAvatar(
      backgroundColor: Colors.grey.shade200,
      child: Text('${entry.rank}'),
    );
  }

  IconData _getMedalIcon(int rank) {
    switch (rank) {
      case 1:
        return Icons.emoji_events;
      case 2:
        return Icons.workspace_premium;
      case 3:
        return Icons.military_tech;
      default:
        return Icons.star;
    }
  }

  Color _getMedalColor(int rank) {
    switch (rank) {
      case 1:
        return Colors.amber;
      case 2:
        return Colors.grey.shade400;
      case 3:
        return Colors.brown.shade300;
      default:
        return Colors.grey;
    }
  }

  String _formatNumber(int number) {
    if (number >= 1000000) {
      return '${(number / 1000000).toStringAsFixed(1)}M';
    } else if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(1)}K';
    }
    return number.toString();
  }
}
