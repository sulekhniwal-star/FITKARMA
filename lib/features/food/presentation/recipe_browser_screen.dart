import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/theme/app_text_styles.dart';
import '../../../shared/widgets/category_chip_row.dart';
import '../../../shared/widgets/section_header.dart';
import 'widgets/recipe_grid_card.dart';

class RecipeBrowserScreen extends StatelessWidget {
  const RecipeBrowserScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Mock Data
    final recipes = [
      {'title': 'Protein Paneer Tikka', 'kcal': '320', 'time': '20m', 'srv': '2', 'comm': false},
      {'title': 'Oats Moong Dal Chilla', 'kcal': '240', 'time': '15m', 'srv': '1', 'comm': false},
      {'title': 'Sprouts Salad Bowl', 'kcal': '180', 'time': '10m', 'srv': '1', 'comm': true},
      {'title': 'Healthy Chicken Curry', 'kcal': '410', 'time': '40m', 'srv': '4', 'comm': true},
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Recipes / रेसिपी'),
      ),
      body: CustomScrollView(
        slivers: [
          // 1. Categories
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: CategoryChipRow(
                categories: ['My Recipes', 'North Indian', 'South Indian', 'Bengali', 'Gujarati', 'Public'],
                initialSelected: 'My Recipes',
              ),
            ),
          ),
          
          // 2. Section Header
          const SliverToBoxAdapter(
            child: SectionHeader(
              englishTitle: 'Saved Recipes',
              hindiSubtitle: 'सहेजी गई रेसिपी',
            ),
          ),
          
          // 3. Grid
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.8,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final r = recipes[index];
                  return RecipeGridCard(
                    title: r['title'] as String,
                    calories: r['kcal'] as String,
                    prepTime: r['time'] as String,
                    servings: r['srv'] as String,
                    isCommunity: r['comm'] as bool,
                    onTap: () {},
                  );
                },
                childCount: recipes.length,
              ),
            ),
          ),
          
          // 4. Community Header
          const SliverToBoxAdapter(
            child: SectionHeader(
              englishTitle: 'Shared by Community',
              hindiSubtitle: 'समुदाय द्वारा साझा',
            ),
          ),
          
          // 5. Community Grid (mocked with same data)
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.8,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final r = recipes[index];
                  return RecipeGridCard(
                    title: r['title'] as String,
                    calories: r['kcal'] as String,
                    prepTime: r['time'] as String,
                    servings: r['srv'] as String,
                    isCommunity: true, // Force community icon
                    onTap: () {},
                  );
                },
                childCount: recipes.length,
              ),
            ),
          ),
          
          const SliverPadding(padding: EdgeInsets.only(bottom: 100)), // FAB clearance
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          context.go('/home/food/recipes/new');
        },
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.add, color: AppColors.white),
        label: Text('New Recipe', style: AppTextStyles.labelLarge.copyWith(color: AppColors.white)),
      ),
    );
  }
}
