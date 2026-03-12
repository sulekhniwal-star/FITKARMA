import 'package:flutter/material.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/theme/app_text_styles.dart';
import '../../../shared/widgets/category_chip_row.dart';
import '../../../shared/widgets/section_header.dart';
import '../../../shared/widgets/primary_button.dart';
import 'widgets/ingredient_list_tile.dart';

class RecipeBuilderScreen extends StatefulWidget {
  const RecipeBuilderScreen({super.key});

  @override
  State<RecipeBuilderScreen> createState() => _RecipeBuilderScreenState();
}

class _RecipeBuilderScreenState extends State<RecipeBuilderScreen> {
  int _servings = 2;
  bool _shareCommunity = false;

  final List<Map<String, dynamic>> _ingredients = [
    {'title': 'Paneer (Raw)', 'g': 200},
    {'title': 'Onions', 'g': 100},
  ];

  @override
  Widget build(BuildContext context) {
    // Live calculated mock data
    double totalKcal = 0;
    double totalP = 0;
    double totalC = 0;
    double totalF = 0;

    for (var i in _ingredients) {
      final g = (i['g'] as int).toDouble();
      totalKcal += (g * 2.5); // Mock metric
      totalP += (g * 0.15);
      totalC += (g * 0.20);
      totalF += (g * 0.10);
    }

    final double ppKcal = totalKcal / _servings;
    final double ppP = totalP / _servings;
    final double ppC = totalC / _servings;
    final double ppF = totalF / _servings;

    return Scaffold(
      backgroundColor: AppColors.background, // FDF6EC fallback mapping
      appBar: AppBar(
        title: const Text('New Recipe / नई रेसिपी'),
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. Recipe Name
                  TextFormField(
                    decoration: InputDecoration(
                      hintText: 'Recipe Name',
                      hintStyle: AppTextStyles.h2.copyWith(color: AppColors.textMuted),
                      border: InputBorder.none,
                    ),
                    style: AppTextStyles.h2,
                  ),
                  const SizedBox(height: 16),

                  // 2. Cuisine Chips
                  const CategoryChipRow(
                    categories: ['North Indian', 'South Indian', 'Bengali', 'Gujarati', 'Other'],
                    initialSelected: 'North Indian',
                  ),
                  const SizedBox(height: 24),

                  // 3. Ingredients Header
                  const SectionHeader(
                    englishTitle: 'Ingredients',
                    hindiSubtitle: 'सामग्री',
                  ),

                  // 4. Ingredient Search mock
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.divider),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.search, color: AppColors.textSecondary),
                        const SizedBox(width: 12),
                        Text('Add ingredient...', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // 5. Added Ingredients list
                  ReorderableListView(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    onReorder: (oldIndex, newIndex) {
                      setState(() {
                        if (oldIndex < newIndex) {
                          newIndex -= 1;
                        }
                        final item = _ingredients.removeAt(oldIndex);
                        _ingredients.insert(newIndex, item);
                      });
                    },
                    children: _ingredients.asMap().entries.map((entry) {
                      final idx = entry.key;
                      final ing = entry.value;
                      return Container(
                        key: ValueKey(ing['title']),
                        child: IngredientListTile(
                          title: ing['title'] as String,
                          grams: ing['g'] as int,
                          onDelete: () {
                            setState(() {
                              _ingredients.removeAt(idx);
                            });
                          },
                          onQuantityChanged: (val) {
                            setState(() {
                              _ingredients[idx]['g'] = val;
                            });
                          },
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 24),

                  // 6. Live Macro Summary
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)), // Dynamic highlight mock
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Total Recipe Macros', style: AppTextStyles.labelLarge),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _buildSummaryItem('Calories', '${totalKcal.toInt()} kcal', AppColors.primary),
                            _buildSummaryItem('Protein', '${totalP.toStringAsFixed(1)} g', AppColors.success),
                            _buildSummaryItem('Carbs', '${totalC.toStringAsFixed(1)} g', AppColors.accentDark),
                            _buildSummaryItem('Fat', '${totalF.toStringAsFixed(1)} g', AppColors.purple),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),

                  // 7. Servings Stepper
                  Text('Servings / सर्विंग्स', style: AppTextStyles.h4),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: AppColors.primarySurface,
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove, color: AppColors.primary),
                              onPressed: () {
                                if (_servings > 1) setState(() => _servings--);
                              },
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              child: Text('$_servings', style: AppTextStyles.h3),
                            ),
                            IconButton(
                              icon: const Icon(Icons.add, color: AppColors.primary),
                              onPressed: () {
                                setState(() => _servings++);
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // 8. Per Serving Summary
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceVariant,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Per Serving / प्रति सर्विंग', style: AppTextStyles.labelMedium.copyWith(color: AppColors.textSecondary)),
                        Text(
                          '${ppKcal.toInt()} kcal |  ${ppP.toStringAsFixed(1)} P  |  ${ppC.toStringAsFixed(1)} C  |  ${ppF.toStringAsFixed(1)} F',
                          style: AppTextStyles.caption.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),

                  // 9. Community Toggle & 10. CTA
                  SwitchListTile(
                    title: const Text('Share with community', style: AppTextStyles.bodyLarge),
                    subtitle: Text('Other FitKarma users can find and log this recipe.', style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary)),
                    value: _shareCommunity,
                    activeTrackColor: AppColors.secondary.withValues(alpha: 0.5),
                    activeThumbColor: AppColors.secondary,
                    contentPadding: EdgeInsets.zero,
                    onChanged: (val) {
                      setState(() => _shareCommunity = val);
                    },
                  ),
                  const SizedBox(height: 24),

                  PrimaryButton(
                    text: 'Save Recipe',
                    hindiSubLabel: 'रेसिपी सहेजें',
                    onPressed: () {},
                  ),
                  const SizedBox(height: 48), // Padding Bottom
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryItem(String label, String value, Color color) {
    return Column(
      children: [
        Text(value, style: AppTextStyles.h4.copyWith(color: color)),
        const SizedBox(height: 4),
        Text(label, style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary)),
      ],
    );
  }
}
