import 'package:flutter/material.dart';
import '../../shared/theme/app_colors.dart';

class MealTypeTabBar extends StatelessWidget {
  const MealTypeTabBar({super.key});

  @override
  Widget build(BuildContext context) {
    // Temporary hardcoded statelist
    final List<Map<String, dynamic>> tabs = [
      {'icon': Icons.free_breakfast, 'label': 'Breakfast', 'isActive': true},
      {'icon': Icons.lunch_dining, 'label': 'Lunch', 'isActive': false},
      {'icon': Icons.dinner_dining, 'label': 'Dinner', 'isActive': false},
      {'icon': Icons.cookie, 'label': 'Snacks', 'isActive': false},
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: tabs.map((tab) => _buildTab(tab)).toList(),
      ),
    );
  }

  Widget _buildTab(Map<String, dynamic> tab) {
    final isActive = tab['isActive'] as bool;
    return Container(
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isActive ? AppColors.primarySurface : AppColors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isActive ? AppColors.primary : AppColors.divider,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            tab['icon'] as IconData,
            size: 18,
            color: isActive ? AppColors.primary : AppColors.textSecondary,
          ),
          const SizedBox(width: 8),
          Text(
            tab['label'] as String,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: isActive ? AppColors.primary : AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
