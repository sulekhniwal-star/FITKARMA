import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class MealTypeTabBar extends StatefulWidget {
  final Function(String) onTabChanged;
  const MealTypeTabBar({super.key, required this.onTabChanged});

  @override
  State<MealTypeTabBar> createState() => _MealTypeTabBarState();
}

class _MealTypeTabBarState extends State<MealTypeTabBar> {
  int _selectedIndex = 0;
  final List<Map<String, String>> _meals = [
    {'en': 'Breakfast', 'hi': 'नाश्ता', 'icon': '🍳'},
    {'en': 'Lunch', 'hi': 'दोपहर का भोजन', 'icon': '🍱'},
    {'en': 'Dinner', 'hi': 'रात का खाना', 'icon': '🍛'},
    {'en': 'Snacks', 'hi': 'स्नैक्स', 'icon': '🍎'},
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: List.generate(_meals.length, (index) {
          final isSelected = _selectedIndex == index;
          return Padding(
            padding: const EdgeInsets.only(right: 12),
            child: GestureDetector(
              onTap: () {
                setState(() => _selectedIndex = index);
                widget.onTabChanged(_meals[index]['en']!);
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.surfaceWhite : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected ? AppColors.primaryOrange : AppColors.borderGrey,
                    width: 1.5,
                  ),
                  boxShadow: isSelected ? [
                    BoxShadow(
                      color: AppColors.primaryOrange.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    )
                  ] : [],
                ),
                child: Column(
                  children: [
                    Text(
                      _meals[index]['icon']!,
                      style: const TextStyle(fontSize: 20),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _meals[index]['en']!,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: isSelected ? AppColors.primaryOrange : AppColors.textBlack,
                      ),
                    ),
                     Text(
                      _meals[index]['hi']!,
                      style: TextStyle(
                        fontSize: 10,
                        color: isSelected ? AppColors.primaryOrange.withOpacity(0.8) : AppColors.textGrey,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
