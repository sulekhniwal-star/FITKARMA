import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

/// Meal type tab bar widget
///
/// Horizontal row of meal-type tabs: Breakfast · Lunch · Dinner · Snacks
/// Per Section 2.1 Dashboard Screen - Today's Meals Section
/// Each tab shows a food category icon and label
class MealTypeTabBar extends StatelessWidget {
  /// Currently selected meal type
  final MealType selectedMeal;

  /// Callback when meal type is selected
  final ValueChanged<MealType>? onMealSelected;

  /// Whether to show all tabs or scrollable
  final bool isScrollable;

  const MealTypeTabBar({
    super.key,
    required this.selectedMeal,
    this.onMealSelected,
    this.isScrollable = false,
  });

  @override
  Widget build(BuildContext context) {
    if (isScrollable) {
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: MealType.values.map((meal) {
            final isSelected = meal == selectedMeal;
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: _MealTab(
                meal: meal,
                isSelected: isSelected,
                onTap: () => onMealSelected?.call(meal),
              ),
            );
          }).toList(),
        ),
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: MealType.values.map((meal) {
        final isSelected = meal == selectedMeal;
        return Expanded(
          child: _MealTab(
            meal: meal,
            isSelected: isSelected,
            onTap: () => onMealSelected?.call(meal),
          ),
        );
      }).toList(),
    );
  }
}

/// Individual meal tab
class _MealTab extends StatelessWidget {
  final MealType meal;
  final bool isSelected;
  final VoidCallback? onTap;

  const _MealTab({required this.meal, required this.isSelected, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withValues(alpha: 0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.divider,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              meal.icon,
              color: isSelected ? AppColors.primary : AppColors.textSecondary,
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              meal.labelEnglish,
              style: AppTextStyles.labelSmall.copyWith(
                color: isSelected ? AppColors.primary : AppColors.textSecondary,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
            Text(
              meal.labelHindi,
              style: AppTextStyles.captionSmall.copyWith(
                color: isSelected
                    ? AppColors.primary.withValues(alpha: 0.8)
                    : AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Meal type enum
enum MealType {
  breakfast(
    labelEnglish: 'Breakfast',
    labelHindi: 'नाश्ता',
    icon: Icons.wb_sunny_outlined,
  ),
  lunch(
    labelEnglish: 'Lunch',
    labelHindi: 'दोपहर का खाना',
    icon: Icons.restaurant_outlined,
  ),
  dinner(
    labelEnglish: 'Dinner',
    labelHindi: 'रात का खाना',
    icon: Icons.nightlight_outlined,
  ),
  snacks(
    labelEnglish: 'Snacks',
    labelHindi: 'स्नैक्स',
    icon: Icons.cookie_outlined,
  );

  final String labelEnglish;
  final String labelHindi;
  final IconData icon;

  const MealType({
    required this.labelEnglish,
    required this.labelHindi,
    required this.icon,
  });
}

/// Vertical meal type selector
class MealTypeSelector extends StatelessWidget {
  final MealType selectedMeal;
  final ValueChanged<MealType>? onMealSelected;

  const MealTypeSelector({
    super.key,
    required this.selectedMeal,
    this.onMealSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: MealType.values.map((meal) {
        final isSelected = meal == selectedMeal;
        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: _MealTypeButton(
            meal: meal,
            isSelected: isSelected,
            onTap: () => onMealSelected?.call(meal),
          ),
        );
      }).toList(),
    );
  }
}

/// Vertical meal type button
class _MealTypeButton extends StatelessWidget {
  final MealType meal;
  final bool isSelected;
  final VoidCallback? onTap;

  const _MealTypeButton({
    required this.meal,
    required this.isSelected,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 64,
        height: 64,
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.divider,
            width: 2,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              meal.icon,
              color: isSelected
                  ? AppColors.textOnPrimary
                  : AppColors.textSecondary,
              size: 24,
            ),
            const SizedBox(height: 2),
            Text(
              meal.labelEnglish.substring(0, 1),
              style: TextStyle(
                color: isSelected
                    ? AppColors.textOnPrimary
                    : AppColors.textSecondary,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Meal summary card showing total calories for a meal
class MealSummaryCard extends StatelessWidget {
  final MealType mealType;
  final int calories;
  final double? protein;
  final double? carbs;
  final double? fat;
  final VoidCallback? onTap;

  const MealSummaryCard({
    super.key,
    required this.mealType,
    required this.calories,
    this.protein,
    this.carbs,
    this.fat,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: AppColors.cardShadow,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Icon
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(mealType.icon, color: AppColors.primary),
            ),
            const SizedBox(width: 12),
            // Meal info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(mealType.labelEnglish, style: AppTextStyles.titleSmall),
                  Text('${calories} kcal', style: AppTextStyles.bodySmall),
                ],
              ),
            ),
            // Arrow
            const Icon(Icons.chevron_right, color: AppColors.textSecondary),
          ],
        ),
      ),
    );
  }
}
