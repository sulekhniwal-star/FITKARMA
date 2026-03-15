import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

/// Food item card widget
///
/// Displays food photo (rounded corners), name, portion in Indian units,
/// calorie count, and + circular button on the bottom-right
/// Per Section 2.1 Food Logging Screen
///
/// Food card images: 72 × 72px rounded thumbnails per Section 2.2
class FoodItemCard extends StatelessWidget {
  /// Food name (English)
  final String name;

  /// Food name in Hindi (optional for bilingual display)
  final String? nameHindi;

  /// Food image URL (optional)
  final String? imageUrl;

  /// Portion size text (e.g., "1 Katori (150g)")
  final String portion;

  /// Calorie count
  final double calories;

  /// Optional protein in grams
  final double? protein;

  /// Optional carbs in grams
  final double? carbs;

  /// Optional fat in grams
  final double? fat;

  /// Callback when + button is pressed
  final VoidCallback? onAdd;

  /// Callback when card is tapped
  final VoidCallback? onTap;

  const FoodItemCard({
    super.key,
    required this.name,
    this.nameHindi,
    this.imageUrl,
    required this.portion,
    required this.calories,
    this.protein,
    this.carbs,
    this.fat,
    this.onAdd,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Food image
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(12),
              ),
              child: SizedBox(
                height: 72,
                width: double.infinity,
                child: imageUrl != null
                    ? Image.network(
                        imageUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            _PlaceholderImage(),
                      )
                    : _PlaceholderImage(),
              ),
            ),
            // Food details
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Food name
                  Text(
                    name,
                    style: AppTextStyles.titleSmall,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  // Hindi name
                  if (nameHindi != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      nameHindi!,
                      style: AppTextStyles.captionSmall,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                  const SizedBox(height: 4),
                  // Portion
                  Text(
                    portion,
                    style: AppTextStyles.caption,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  // Calories and macros
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${calories.toInt()} kcal',
                        style: AppTextStyles.labelMedium.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      // Add button
                      _AddButton(onTap: onAdd),
                    ],
                  ),
                  // Macros (optional)
                  if (protein != null || carbs != null || fat != null) ...[
                    const SizedBox(height: 4),
                    _MacroRow(protein: protein, carbs: carbs, fat: fat),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Placeholder for missing food image
class _PlaceholderImage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.divider,
      child: const Center(
        child: Icon(Icons.restaurant, color: AppColors.textSecondary, size: 32),
      ),
    );
  }
}

/// Add button (+)
class _AddButton extends StatelessWidget {
  final VoidCallback? onTap;

  const _AddButton({this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          width: 28,
          height: 28,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.primary,
          ),
          child: const Icon(
            Icons.add,
            color: AppColors.textOnPrimary,
            size: 18,
          ),
        ),
      ),
    );
  }
}

/// Macro nutrients row
class _MacroRow extends StatelessWidget {
  final double? protein;
  final double? carbs;
  final double? fat;

  const _MacroRow({this.protein, this.carbs, this.fat});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (protein != null) _MacroChip(label: 'P', value: protein!),
        if (carbs != null) ...[
          const SizedBox(width: 4),
          _MacroChip(label: 'C', value: carbs!),
        ],
        if (fat != null) ...[
          const SizedBox(width: 4),
          _MacroChip(label: 'F', value: fat!),
        ],
      ],
    );
  }
}

/// Individual macro chip
class _MacroChip extends StatelessWidget {
  final String label;
  final double value;

  const _MacroChip({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      decoration: BoxDecoration(
        color: AppColors.divider,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        '$label: ${value.toInt()}g',
        style: AppTextStyles.captionSmall,
      ),
    );
  }
}

/// Horizontal food item card variant
class FoodItemCardHorizontal extends StatelessWidget {
  final String name;
  final String? nameHindi;
  final String? imageUrl;
  final String portion;
  final double calories;
  final VoidCallback? onAdd;
  final VoidCallback? onTap;

  const FoodItemCardHorizontal({
    super.key,
    required this.name,
    this.nameHindi,
    this.imageUrl,
    required this.portion,
    required this.calories,
    this.onAdd,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: AppColors.cardShadow,
              blurRadius: 2,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Row(
          children: [
            // Thumbnail
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: SizedBox(
                width: 56,
                height: 56,
                child: imageUrl != null
                    ? Image.network(
                        imageUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            _PlaceholderImage(),
                      )
                    : _PlaceholderImage(),
              ),
            ),
            const SizedBox(width: 12),
            // Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: AppTextStyles.titleSmall,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    portion,
                    style: AppTextStyles.caption,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${calories.toInt()} kcal',
                    style: AppTextStyles.labelMedium.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ),
            // Add button
            _AddButton(onTap: onAdd),
          ],
        ),
      ),
    );
  }
}
