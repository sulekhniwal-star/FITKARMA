import 'package:flutter/material.dart';
import '../../../../shared/theme/app_colors.dart';
import '../../../../shared/theme/app_text_styles.dart';

class FoodItemCard extends StatelessWidget {
  final String title;
  final String hindiTitle;
  final String kalCount;
  final String portion;
  final bool isGrid;
  final VoidCallback onTap;
  final VoidCallback? onAdd;

  const FoodItemCard({
    super.key,
    required this.title,
    required this.hindiTitle,
    required this.kalCount,
    required this.portion,
    this.isGrid = false,
    required this.onTap,
    this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    if (isGrid) {
      return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.divider),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 3,
                child: Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: AppColors.surfaceVariant,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(11)),
                  ),
                  child: const Center(
                    child: Icon(Icons.restaurant, color: AppColors.textMuted, size: 32),
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(title, style: AppTextStyles.labelMedium, maxLines: 1, overflow: TextOverflow.ellipsis),
                      const SizedBox(height: 2),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              '$portion · $kalCount kcal',
                              style: AppTextStyles.caption,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (onAdd != null)
                            InkWell(
                              onTap: onAdd,
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: const BoxDecoration(
                                  color: AppColors.primarySurface,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.add, size: 14, color: AppColors.primary),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    // List Variant
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: const BoxDecoration(
          color: AppColors.white,
          border: Border(bottom: BorderSide(color: AppColors.divider)),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppColors.surfaceVariant,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.restaurant, color: AppColors.textMuted),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppTextStyles.bodyLarge),
                  const SizedBox(height: 2),
                  Text('$hindiTitle · $portion', style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary)),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(kalCount, style: AppTextStyles.labelLarge.copyWith(color: AppColors.primary)),
                const Text('kcal', style: AppTextStyles.caption),
              ],
            ),
            if (onAdd != null) ...[
              const SizedBox(width: 12),
              IconButton(
                onPressed: onAdd,
                icon: const Icon(Icons.add_circle, color: AppColors.primary),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ]
          ],
        ),
      ),
    );
  }
}
