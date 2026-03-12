import 'package:flutter/material.dart';
import '../../../../shared/theme/app_colors.dart';
import '../../../../shared/widgets/bilingual_label.dart';
import '../../domain/models/food_item.dart';

class FoodItemCard extends StatelessWidget {
  final FoodItem food;
  final VoidCallback onTap;

  const FoodItemCard({
    super.key,
    required this.food,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: AppColors.borderGrey),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  food.imageUrl,
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    width: 60,
                    height: 60,
                    color: AppColors.backgroundWarm,
                    child: const Icon(Icons.restaurant, color: AppColors.textGrey),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: BilingualLabel(
                  english: food.nameEn,
                  hindi: food.nameHi,
                  englishSize: 16,
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                   Text(
                    '${food.caloriesPer100g.toInt()} kcal',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.textBlack,
                    ),
                  ),
                  const Text(
                    'per 100g',
                    style: TextStyle(fontSize: 10, color: AppColors.textGrey),
                  ),
                ],
              ),
              const SizedBox(width: 8),
              const Icon(Icons.chevron_right, color: AppColors.textGrey, size: 20),
            ],
          ),
        ),
      ),
    );
  }
}
