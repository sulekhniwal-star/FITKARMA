import 'package:flutter/material.dart';
import '../../../../shared/theme/app_colors.dart';
import '../../../../shared/theme/app_text_styles.dart';

class PortionSelectorState extends StatefulWidget {
  final ValueChanged<double> onPortionChanged;

  const PortionSelectorState({super.key, required this.onPortionChanged});

  @override
  State<PortionSelectorState> createState() => _PortionSelectorStateState();
}

class _PortionSelectorStateState extends State<PortionSelectorState> {
  String _selectedUnit = 'Katori';
  double _grams = 150.0;

  final List<String> _units = ['Katori', 'Piece', 'Cup', 'Custom (g)'];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text('Select Portion', style: AppTextStyles.labelLarge),
        const SizedBox(height: 12),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: _units.map((unit) {
              final isSelected = _selectedUnit == unit;
              return Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: ChoiceChip(
                  label: Text(unit),
                  selected: isSelected,
                  onSelected: (selected) {
                    if (selected) {
                      setState(() {
                        _selectedUnit = unit;
                        if (unit == 'Custom (g)') _grams = 100.0;
                        widget.onPortionChanged(_grams);
                      });
                    }
                  },
                  backgroundColor: AppColors.white,
                  selectedColor: AppColors.primarySurface,
                  labelStyle: TextStyle(
                    color: isSelected ? AppColors.primary : AppColors.textSecondary,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                  side: BorderSide(
                    color: isSelected ? AppColors.primary : AppColors.divider,
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        if (_selectedUnit == 'Custom (g)') ...[
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Grams', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary)),
              Text('${_grams.toInt()} g', style: AppTextStyles.h4),
            ],
          ),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: AppColors.primary,
              inactiveTrackColor: AppColors.divider,
              thumbColor: AppColors.primary,
              overlayColor: AppColors.primaryLight.withValues(alpha: 0.2),
            ),
            child: Slider(
              value: _grams,
              min: 10,
              max: 500,
              divisions: 49,
              onChanged: (value) {
                setState(() => _grams = value);
                widget.onPortionChanged(value);
              },
            ),
          ),
        ],
      ],
    );
  }
}
