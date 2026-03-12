import 'package:flutter/material.dart';
import '../../../../shared/theme/app_colors.dart';
import '../../../../shared/theme/app_text_styles.dart';

class IngredientListTile extends StatelessWidget {
  final String title;
  final int grams;
  final VoidCallback onDelete;
  final ValueChanged<int> onQuantityChanged;

  const IngredientListTile({
    super.key,
    required this.title,
    required this.grams,
    required this.onDelete,
    required this.onQuantityChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.divider),
      ),
      child: Row(
        children: [
          const Icon(Icons.drag_handle, color: AppColors.textSecondary),
          const SizedBox(width: 12),
          Expanded(
            child: Text(title, style: AppTextStyles.bodyMedium),
          ),
          Container(
            width: 80,
            height: 36,
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.divider),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    initialValue: grams.toString(),
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.zero,
                    ),
                    onChanged: (val) {
                      final parsed = int.tryParse(val) ?? 0;
                      onQuantityChanged(parsed);
                    },
                  ),
                ),
                Text('g', style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary)),
                const SizedBox(width: 8),
              ],
            ),
          ),
          const SizedBox(width: 12),
          IconButton(
            onPressed: onDelete,
            icon: const Icon(Icons.close, color: AppColors.error, size: 20),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }
}
