import 'package:flutter/material.dart';
import '../../../../shared/theme/app_colors.dart';


class CategoryChipRow extends StatefulWidget {
  final List<String> categories;
  final String? initialSelected;
  final ValueChanged<String>? onSelected;

  const CategoryChipRow({
    super.key,
    required this.categories,
    this.initialSelected,
    this.onSelected,
  });

  @override
  State<CategoryChipRow> createState() => _CategoryChipRowState();
}

class _CategoryChipRowState extends State<CategoryChipRow> {
  late String _selected;

  @override
  void initState() {
    super.initState();
    _selected = widget.initialSelected ?? widget.categories.first;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: widget.categories.map((category) {
          final isSelected = _selected == category;
          return Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: ChoiceChip(
              label: Text(category),
              selected: isSelected,
              onSelected: (selected) {
                if (selected) {
                  setState(() => _selected = category);
                  if (widget.onSelected != null) {
                    widget.onSelected!(category);
                  }
                }
              },
              backgroundColor: AppColors.white,
              selectedColor: AppColors.primary,
              labelStyle: TextStyle(
                color: isSelected ? AppColors.white : AppColors.textPrimary,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
              side: BorderSide(
                color: isSelected ? AppColors.primary : AppColors.divider,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
