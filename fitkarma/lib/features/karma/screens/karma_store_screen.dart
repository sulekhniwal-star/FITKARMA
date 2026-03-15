// lib/features/karma/screens/karma_store_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/theme/app_colors.dart';
import '../providers/karma_providers.dart';

/// Reward item model
class RewardItem {
  final String id;
  final String name;
  final String description;
  final int xpCost;
  final IconData icon;
  final Color color;

  const RewardItem({
    required this.id,
    required this.name,
    required this.description,
    required this.xpCost,
    required this.icon,
    required this.color,
  });
}

/// Available rewards
final List<RewardItem> availableRewards = [
  RewardItem(
    id: 'theme_1',
    name: 'Dark Theme',
    description: 'Unlock dark mode for 24 hours',
    xpCost: 50,
    icon: Icons.dark_mode,
    color: Colors.indigo,
  ),
  RewardItem(
    id: 'badge_1',
    name: 'Early Bird Badge',
    description: 'Exclusive badge for your profile',
    xpCost: 100,
    icon: Icons.emoji_events,
    color: Colors.amber,
  ),
  RewardItem(
    id: 'meal_1',
    name: 'Premium Recipe',
    description: 'Access to premium recipes',
    xpCost: 150,
    icon: Icons.restaurant_menu,
    color: Colors.orange,
  ),
  RewardItem(
    id: 'workout_1',
    name: 'Yoga Session',
    description: 'Unlock a premium yoga workout',
    xpCost: 200,
    icon: Icons.self_improvement,
    color: Colors.teal,
  ),
  RewardItem(
    id: 'discount_1',
    name: '10% Off',
    description: '10% discount on premium features',
    xpCost: 300,
    icon: Icons.local_offer,
    color: Colors.purple,
  ),
  RewardItem(
    id: 'consult_1',
    name: 'Dietitian Consult',
    description: 'One free dietitian consultation',
    xpCost: 500,
    icon: Icons.health_and_safety,
    color: Colors.green,
  ),
];

/// Karma Store screen - rewards redeemable with XP
class KarmaStoreScreen extends ConsumerWidget {
  const KarmaStoreScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final balance = ref.watch(karmaBalanceProvider);
    final currentXP = balance?.totalXP ?? 0;

    return Scaffold(
      appBar: AppBar(title: const Text('Karma Store'), centerTitle: true),
      body: Column(
        children: [
          // XP balance header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.star, color: AppColors.warning),
                const SizedBox(width: 8),
                Text(
                  'Your XP: ${currentXP.toString()}',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),

          // Rewards grid
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.85,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: availableRewards.length,
              itemBuilder: (context, index) {
                final reward = availableRewards[index];
                final canAfford = currentXP >= reward.xpCost;

                return _RewardCard(
                  reward: reward,
                  canAfford: canAfford,
                  onRedeem: () =>
                      _redeemReward(context, ref, reward, currentXP),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  /// Redeem reward
  void _redeemReward(
    BuildContext context,
    WidgetRef ref,
    RewardItem reward,
    int currentXP,
  ) {
    if (currentXP < reward.xpCost) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Not enough XP!'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Redeem ${reward.name}?'),
        content: Text('This will cost ${reward.xpCost} XP. Continue?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              // Deduct XP and show success
              ref
                  .read(karmaProvider.notifier)
                  .addXP(
                    amount: -reward.xpCost,
                    action: 'redeem',
                    description: 'Redeemed: ${reward.name}',
                  );
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Successfully redeemed ${reward.name}!'),
                  backgroundColor: AppColors.success,
                ),
              );
            },
            child: const Text('Redeem'),
          ),
        ],
      ),
    );
  }
}

/// Reward card widget
class _RewardCard extends StatelessWidget {
  final RewardItem reward;
  final bool canAfford;
  final VoidCallback onRedeem;

  const _RewardCard({
    required this.reward,
    required this.canAfford,
    required this.onRedeem,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: canAfford ? onRedeem : null,
        borderRadius: BorderRadius.circular(12),
        child: Opacity(
          opacity: canAfford ? 1.0 : 0.6,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Icon
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: reward.color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(reward.icon, color: reward.color, size: 32),
                ),
                const SizedBox(height: 12),

                // Name
                Text(
                  reward.name,
                  style: Theme.of(
                    context,
                  ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),

                // Description
                Text(
                  reward.description,
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: Colors.grey),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),

                // Cost
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: canAfford
                        ? AppColors.primary.withValues(alpha: 0.1)
                        : Colors.grey.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${reward.xpCost} XP',
                    style: TextStyle(
                      color: canAfford ? AppColors.primary : Colors.grey,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
