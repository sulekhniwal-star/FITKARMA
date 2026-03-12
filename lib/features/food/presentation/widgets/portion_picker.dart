import 'package:flutter/material.dart';
import '../../../../shared/theme/app_colors.dart';
import '../../../../shared/widgets/bilingual_label.dart';
import '../../domain/models/food_item.dart';

class PortionPicker extends StatefulWidget {
  final FoodItem food;
  final Function(double amount, String unit, double totalCalories) onConfirm;

  const PortionPicker({
    super.key,
    required this.food,
    required this.onConfirm,
  });

  @override
  State<PortionPicker> createState() => _PortionPickerState();
}

class _PortionPickerState extends State<PortionPicker> {
  late String _selectedUnit;
  double _amount = 1.0;

  @override
  void initState() {
    super.initState();
    _selectedUnit = widget.food.portionMultipliers.keys.first;
  }

  double get _totalCalories {
    final multiplier = widget.food.portionMultipliers[_selectedUnit] ?? 1.0;
    // Calculation: (Calories per 100g / 100) * (Amount * Multiplier * ReferenceGrams)
    // For simplicity in this local db: Multiplier is 'kcal per unit' if not 'gram'
    if (_selectedUnit == 'gram') {
      return (widget.food.caloriesPer100g / 100) * _amount;
    }
    // In our seed data, multipliers for 'katori', 'piece' etc are relative to 100g or direct kcal?
    // Let's assume the multiplier converts 'unit' to '100g units'.
    // e.g. 1 Katori = 1.5 * 100g calories.
    return widget.food.caloriesPer100g * (widget.food.portionMultipliers[_selectedUnit] ?? 1.0) * _amount;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: BilingualLabel(
        english: 'Log ${widget.food.nameEn}',
        hindi: '${widget.food.nameHi} दर्ज करें',
        englishSize: 18,
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Expanded(
                flex: 2,
                child: TextField(
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Amount'),
                  onChanged: (val) {
                    setState(() {
                      _amount = double.tryParse(val) ?? 1.0;
                    });
                  },
                  controller: TextEditingController(text: '1.0'),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                flex: 3,
                child: DropdownButtonFormField<String>(
                  value: _selectedUnit,
                  items: widget.food.portionMultipliers.keys.map((unit) {
                    return DropdownMenuItem(
                      value: unit,
                      child: Text(unit.toUpperCase()),
                    );
                  }).toList(),
                  onChanged: (val) {
                    if (val != null) setState(() => _selectedUnit = val);
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.primaryOrange.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Total Calories', style: TextStyle(fontWeight: FontWeight.bold)),
                Text(
                  '${_totalCalories.toInt()} kcal',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryOrange,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            widget.onConfirm(_amount, _selectedUnit, _totalCalories);
            Navigator.pop(context);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryOrange,
            foregroundColor: Colors.white,
          ),
          child: const Text('Add to Log'),
        ),
      ],
    );
  }
}
