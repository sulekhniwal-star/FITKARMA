import 'package:flutter/material.dart';
import '../../../../shared/theme/app_colors.dart';
import '../../../../shared/theme/app_text_styles.dart';
import '../../../../shared/widgets/primary_button.dart';
import 'macro_pill.dart';
import 'portion_selector.dart';

Future<void> showPortionBottomSheet({
  required BuildContext context,
  required String foodName,
  required String hindiName,
  required double baseKcal,
  required double baseProtein,
  required double baseCarbs,
  required double baseFat,
  bool fromFab = false,
}) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (context) {
      return _PortionBottomSheetContent(
        foodName: foodName,
        hindiName: hindiName,
        baseKcal: baseKcal,
        baseProtein: baseProtein,
        baseCarbs: baseCarbs,
        baseFat: baseFat,
        fromFab: fromFab,
      );
    },
  );
}

class _PortionBottomSheetContent extends StatefulWidget {
  final String foodName;
  final String hindiName;
  final double baseKcal;
  final double baseProtein;
  final double baseCarbs;
  final double baseFat;
  final bool fromFab;

  const _PortionBottomSheetContent({
    required this.foodName,
    required this.hindiName,
    required this.baseKcal,
    required this.baseProtein,
    required this.baseCarbs,
    required this.baseFat,
    required this.fromFab,
  });

  @override
  State<_PortionBottomSheetContent> createState() => _PortionBottomSheetContentState();
}

class _PortionBottomSheetContentState extends State<_PortionBottomSheetContent> {
  double _multiplier = 1.0;
  String _mealType = 'Breakfast';

  void _onPortionChanged(double gramsOrMultiplier) {
    // Basic mock: scaling values based on slider or choice selection
    setState(() {
      _multiplier = (gramsOrMultiplier / 100.0).clamp(0.1, 5.0); // Simple hack for mock UI scaling
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      // Padding for safe area/keyboard
      padding: EdgeInsets.only(
        top: 16,
        left: 16,
        right: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Drag handle
          Center(
            child: Container(
              width: 48,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.divider,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Titles
          Text(widget.foodName, style: AppTextStyles.h2),
          Text(widget.hindiName, style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary)),
          const SizedBox(height: 20),

          // Portion Selector
          PortionSelectorState(onPortionChanged: _onPortionChanged),
          const SizedBox(height: 20),

          // Macros Live Preview row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              MacroPill(
                label: 'Kcal',
                value: '${(widget.baseKcal * _multiplier).toInt()}',
                color: AppColors.primary,
              ),
              MacroPill(
                label: 'Protein',
                value: '${(widget.baseProtein * _multiplier).toStringAsFixed(1)}g',
                color: AppColors.success,
              ),
              MacroPill(
                label: 'Carbs',
                value: '${(widget.baseCarbs * _multiplier).toStringAsFixed(1)}g',
                color: AppColors.accentDark,
              ),
              MacroPill(
                label: 'Fat',
                value: '${(widget.baseFat * _multiplier).toStringAsFixed(1)}g',
                color: AppColors.purple,
              ),
            ],
          ),
          const SizedBox(height: 24),

          if (widget.fromFab) ...[
            DropdownButtonFormField<String>(
              initialValue: _mealType,
              items: ['Breakfast', 'Lunch', 'Dinner', 'Snacks']
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: (val) {
                if (val != null) setState(() => _mealType = val);
              },
              decoration: const InputDecoration(
                labelText: 'Adding to Meal',
              ),
            ),
            const SizedBox(height: 24),
          ],

          PrimaryButton(
            text: 'Add to ${widget.fromFab ? _mealType : 'Log'}',
            hindiSubLabel: 'लॉग में जोड़ें',
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }
}
