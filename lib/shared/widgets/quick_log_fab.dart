import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import 'package:go_router/go_router.dart';

/// QuickLogFab — A persistent FAB that opens the quick logging menu.
class QuickLogFab extends StatelessWidget {
  const QuickLogFab({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () => _showQuickLogMenu(context),
      backgroundColor: AppColorsDark.primary,
      foregroundColor: Colors.white,
      shape: const CircleBorder(),
      child: const Icon(Icons.add, size: 32),
    );
  }

  void _showQuickLogMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const _QuickLogBottomSheet(),
    );
  }
}

class _QuickLogBottomSheet extends StatelessWidget {
  const _QuickLogBottomSheet();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColorsDark.bg1,
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.lg)),
      ),
      padding: const EdgeInsets.all(AppSpacing.screenH),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColorsDark.surface2,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Quick Log',
            style: AppTypography.h1(),
          ),
          const SizedBox(height: 24),
          GridView.count(
            shrinkWrap: true,
            crossAxisCount: 3,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 0.9,
            children: const [
              _QuickLogItem(label: 'Food', icon: Icons.restaurant, color: AppColorsDark.accent, route: '/home/food'),
              _QuickLogItem(label: 'Water', icon: Icons.water_drop, color: AppColorsDark.teal, route: '/water'),
              _QuickLogItem(label: 'Workout', icon: Icons.fitness_center, color: AppColorsDark.secondary, route: '/home/workout'),
              _QuickLogItem(label: 'Meds', icon: Icons.medication, color: AppColorsDark.rose, route: '/medication'),
              _QuickLogItem(label: 'Mood', icon: Icons.mood, color: AppColorsDark.purple, route: '/journal'),
              _QuickLogItem(label: 'BP', icon: Icons.favorite, color: AppColorsDark.error, route: '/blood-pressure'),
            ],
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}

class _QuickLogItem extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final String route;

  const _QuickLogItem({
    required this.label,
    required this.icon,
    required this.color,
    required this.route,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        context.pop(); // Dismiss menu overlay
        context.push(route);
      },
      borderRadius: BorderRadius.circular(AppRadius.md),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppRadius.md),
              border: Border.all(color: color.withValues(alpha: 0.2)),
            ),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: AppTypography.labelMd(color: AppColorsDark.textPrimary),
          ),
        ],
      ),
    );
  }
}
