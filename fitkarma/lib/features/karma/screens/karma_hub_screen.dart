// lib/features/karma/screens/karma_hub_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/theme/app_colors.dart';
import '../providers/karma_providers.dart';

/// Karma Hub screen - shows level, XP bar, and transaction history
class KarmaHubScreen extends ConsumerStatefulWidget {
  const KarmaHubScreen({super.key});

  @override
  ConsumerState<KarmaHubScreen> createState() => _KarmaHubScreenState();
}

class _KarmaHubScreenState extends ConsumerState<KarmaHubScreen> {
  @override
  void initState() {
    super.initState();
    // Initialize karma
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(karmaProvider.notifier).init();
    });
  }

  @override
  Widget build(BuildContext context) {
    final karmaState = ref.watch(karmaProvider);
    final balance = karmaState.balance;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Karma Hub'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.read(karmaProvider.notifier).refresh(),
          ),
        ],
      ),
      body: karmaState.isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: () async {
                await ref.read(karmaProvider.notifier).refresh();
              },
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Level card
                    _buildLevelCard(balance),
                    const SizedBox(height: 24),

                    // XP Progress bar
                    _buildXPProgressBar(balance),
                    const SizedBox(height: 24),

                    // Streak info
                    _buildStreakCard(balance),
                    const SizedBox(height: 24),

                    // Transaction history
                    Text(
                      'Recent Activity',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 12),
                    _buildTransactionList(karmaState.transactions),
                  ],
                ),
              ),
            ),
    );
  }

  /// Build level card
  Widget _buildLevelCard(dynamic balance) {
    final level = balance?.currentLevel ?? 1;
    final totalXP = balance?.totalXP ?? 0;

    return Card(
      elevation: 4,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.primary,
              AppColors.primary.withValues(alpha: 0.7),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            // Level badge
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.2),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  '$level',
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Level $level',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '${_formatNumber(totalXP)} XP',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Colors.white70,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Build XP progress bar
  Widget _buildXPProgressBar(dynamic balance) {
    final progress = balance?.levelProgress ?? 0.0;
    final xpForNext = balance?.xpForNextLevel ?? 150;
    final currentXP = balance?.totalXP ?? 0;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Progress to Level ${(balance?.currentLevel ?? 1) + 1}',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Text(
                  '${(progress * 100).toInt()}%',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 16,
                backgroundColor: Colors.grey.shade200,
                valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '${_formatNumber(currentXP)} / ${_formatNumber(xpForNext)} XP',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Build streak card
  Widget _buildStreakCard(dynamic balance) {
    final streak = balance?.currentStreak ?? 0;
    final multiplier = balance?.streakMultiplier ?? 1.0;
    final weeklyXP = balance?.weeklyXP ?? 0;

    return Row(
      children: [
        Expanded(
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const Icon(Icons.local_fire_department, 
                    color: AppColors.warning, size: 32),
                  const SizedBox(height: 8),
                  Text(
                    '$streak days',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Streak',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const Icon(Icons.bolt, 
                    color: AppColors.success, size: 32),
                  const SizedBox(height: 8),
                  Text(
                    '×${multiplier.toStringAsFixed(1)}',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Multiplier',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const Icon(Icons.star, 
                    color: AppColors.info, size: 32),
                  const SizedBox(height: 8),
                  Text(
                    _formatNumber(weeklyXP),
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Weekly XP',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// Build transaction list
  Widget _buildTransactionList(List transactions) {
    if (transactions.isEmpty) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Center(
            child: Text(
              'No activity yet. Start tracking to earn XP!',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey,
              ),
            ),
          ),
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: transactions.length.clamp(0, 20),
      itemBuilder: (context, index) {
        final transaction = transactions[index];
        return _buildTransactionItem(transaction);
      },
    );
  }

  /// Build transaction item
  Widget _buildTransactionItem(dynamic transaction) {
    final icon = _getActionIcon(transaction.action);
    final color = _getActionColor(transaction.action);

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color),
        ),
        title: Text(transaction.description),
        subtitle: Text(
          _formatTimestamp(transaction.timestamp),
          style: const TextStyle(color: Colors.grey, fontSize: 12),
        ),
        trailing: Text(
          '+${transaction.finalAmount} XP',
          style: TextStyle(
            color: AppColors.success,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  /// Get icon for action
  IconData _getActionIcon(String action) {
    switch (action) {
      case 'steps':
        return Icons.directions_walk;
      case 'food_log':
        return Icons.restaurant;
      case 'workout':
        return Icons.fitness_center;
      case 'streak_bonus':
        return Icons.local_fire_department;
      default:
        return Icons.star;
    }
  }

  /// Get color for action
  Color _getActionColor(String action) {
    switch (action) {
      case 'steps':
        return AppColors.primary;
      case 'food_log':
        return AppColors.warning;
      case 'workout':
        return AppColors.success;
      case 'streak_bonus':
        return Colors.orange;
      default:
        return AppColors.info;
    }
  }

  /// Format timestamp
  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final diff = now.difference(timestamp);
    
    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    
    return '${timestamp.day}/${timestamp.month}/${timestamp.year}';
  }

  /// Format number with K suffix
  String _formatNumber(int number) {
    if (number >= 1000000) {
      return '${(number / 1000000).toStringAsFixed(1)}M';
    } else if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(1)}K';
    }
    return number.toString();
  }
}
