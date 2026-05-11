import 'dart:ui';
import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';

/// BottomNavBar — The main navigation bar for FitKarma.
///
/// Features a glassmorphic background and an active-state glow indicator.
class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const BottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(AppRadius.lg)),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
        child: Container(
          height: 88,
          decoration: BoxDecoration(
            color: isDark ? AppColorsDark.glass : AppColorsLight.glass,
            border: Border(
              top: BorderSide(
                color: isDark ? AppColorsDark.glassBorder : AppColorsLight.glassBorder,
              ),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _NavTab(
                index: 0,
                icon: Icons.grid_view_rounded,
                label: 'Home',
                isActive: currentIndex == 0,
                onTap: () => onTap(0),
              ),
              _NavTab(
                index: 1,
                icon: Icons.restaurant_rounded,
                label: 'Food',
                isActive: currentIndex == 1,
                onTap: () => onTap(1),
              ),
              _NavTab(
                index: 2,
                icon: Icons.fitness_center_rounded,
                label: 'Workout',
                isActive: currentIndex == 2,
                onTap: () => onTap(2),
              ),
              _NavTab(
                index: 3,
                icon: Icons.directions_walk_rounded,
                label: 'Steps',
                isActive: currentIndex == 3,
                onTap: () => onTap(3),
              ),
              _NavTab(
                index: 4,
                icon: Icons.auto_awesome_rounded,
                label: 'Karma',
                isActive: currentIndex == 4,
                onTap: () => onTap(4),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavTab extends StatelessWidget {
  final int index;
  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _NavTab({
    required this.index,
    required this.icon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = isActive ? AppColorsDark.primary : AppColorsDark.textSecondary;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 4),
          if (isActive)
            Container(
              width: 4,
              height: 4,
              decoration: const BoxDecoration(
                color: AppColorsDark.primary,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColorsDark.primaryGlow,
                    blurRadius: 4,
                    spreadRadius: 1,
                  ),
                ],
              ),
            )
          else
            const SizedBox(height: 4),
        ],
      ),
    );
  }
}
