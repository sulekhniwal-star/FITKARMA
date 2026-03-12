import 'package:flutter/material.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/theme/app_text_styles.dart';
import '../../../shared/widgets/primary_button.dart';
import 'widgets/macro_pill.dart';
import 'widgets/portion_selector.dart';

class FoodDetailScreen extends StatefulWidget {
  final String foodId;

  const FoodDetailScreen({super.key, required this.foodId});

  @override
  State<FoodDetailScreen> createState() => _FoodDetailScreenState();
}

class _FoodDetailScreenState extends State<FoodDetailScreen> {
  double _multiplier = 1.0;
  String _mealType = 'Breakfast';

  final double _baseKcal = 350.0;
  final double _baseProtein = 18.5;
  final double _baseCarbs = 42.0;
  final double _baseFat = 12.0;

  void _onPortionChanged(double val) {
    setState(() {
      _multiplier = (val / 100.0).clamp(0.1, 5.0);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        title: const Text('Food Details'), // Often 'Food Name'
        elevation: 0,
      ),
      body: CustomScrollView(
        slivers: [
          // 1. Hero Image
          SliverToBoxAdapter(
            child: Container(
              height: 200,
              width: double.infinity,
              decoration: const BoxDecoration(
                color: AppColors.surfaceVariant,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(16),
                  bottomRight: Radius.circular(16),
                ),
              ),
              child: const Center(
                child: Icon(Icons.restaurant, size: 80, color: AppColors.textMuted),
              ),
            ),
          ),
          
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // 2. Names
                Text('Paneer Makhani', style: AppTextStyles.h2),
                Text('पनीर मखनी', style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary)),
                const SizedBox(height: 20),

                // 3. Macro row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    MacroPill(
                      label: 'Kcal',
                      value: '${(_baseKcal * _multiplier).toInt()}',
                      color: AppColors.primary,
                    ),
                    MacroPill(
                      label: 'Protein',
                      value: '${(_baseProtein * _multiplier).toStringAsFixed(1)}g',
                      color: AppColors.success,
                    ),
                    MacroPill(
                      label: 'Carbs',
                      value: '${(_baseCarbs * _multiplier).toStringAsFixed(1)}g',
                      color: AppColors.accentDark,
                    ),
                    MacroPill(
                      label: 'Fat',
                      value: '${(_baseFat * _multiplier).toStringAsFixed(1)}g',
                      color: AppColors.purple,
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                
                // 4. Portion Selector
                PortionSelectorState(onPortionChanged: _onPortionChanged),
                const SizedBox(height: 24),
                const Divider(),
                
                // 5. Expandable micronutrients
                Theme(
                  data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                  child: ExpansionTile(
                    tilePadding: EdgeInsets.zero,
                    title: Text('Nutrition Details', style: AppTextStyles.h4),
                    children: [
                      _buildMicronutrientRow('Vitamin A', 0.45, '45%'),
                      _buildMicronutrientRow('Vitamin C', 0.20, '20%'),
                      _buildMicronutrientRow('Calcium', 0.85, '85%'),
                      _buildMicronutrientRow('Iron', 0.15, '15%'),
                    ],
                  ),
                ),
                
                const SizedBox(height: 32),
                
                // 6. Meal Type selector
                DropdownButtonFormField<String>(
                  initialValue: _mealType,
                  items: ['Breakfast', 'Lunch', 'Dinner', 'Snacks']
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  onChanged: (val) {
                    if (val != null) setState(() => _mealType = val);
                  },
                  decoration: const InputDecoration(labelText: 'Adding to Meal'),
                ),
                const SizedBox(height: 32),
                
                // 7. CTA
                PrimaryButton(
                  text: 'Add to $_mealType',
                  hindiSubLabel: 'नाश्ते में जोड़ें', // Hindi static mock
                  onPressed: () => Navigator.pop(context),
                ),
                const SizedBox(height: 48), // Bottom padding
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMicronutrientRow(String label, double valueProgress, String valueText) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(label, style: AppTextStyles.bodyMedium),
          ),
          Expanded(
            flex: 3,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: valueProgress,
                backgroundColor: AppColors.divider,
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.textSecondary.withValues(alpha: 0.5)),
                minHeight: 6,
              ),
            ),
          ),
          const SizedBox(width: 12),
          SizedBox(
            width: 40,
            child: Text(valueText, style: AppTextStyles.caption.copyWith(fontWeight: FontWeight.bold), textAlign: TextAlign.right),
          ),
        ],
      ),
    );
  }
}
