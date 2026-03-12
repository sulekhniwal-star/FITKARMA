import 'package:flutter/material.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/theme/app_text_styles.dart';
import '../../../shared/widgets/meal_tab_bar.dart';

import 'widgets/daily_nutrition_card.dart';
import 'widgets/food_item_card.dart';
import 'package:go_router/go_router.dart';

class FoodHomeScreen extends StatelessWidget {
  const FoodHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Column(
          children: [
            const Text('Food / खाना', style: AppTextStyles.h3),
            Text('Today', style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary)),
          ],
        ),
      ),
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              const SliverToBoxAdapter(
                child: DailyNutritionCard(
                  caloriesConsumed: 1240,
                  caloriesGoal: 2000,
                  proteinConsumed: 54.0,
                  proteinGoal: 100.0,
                  carbsConsumed: 120.0,
                  carbsGoal: 250.0,
                  fatConsumed: 45.0,
                  fatGoal: 65.0,
                ),
              ),
              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: MealTypeTabBar(),
                ),
              ),
              
              // Sticky Subtotal
              SliverPersistentHeader(
                pinned: true,
                delegate: _StickySubtotalDelegate(
                  child: Container(
                    color: AppColors.background,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Breakfast', style: AppTextStyles.h4),
                        Text('345 kcal', style: AppTextStyles.labelMedium.copyWith(color: AppColors.primary)),
                      ],
                    ),
                  ),
                ),
              ),

              SliverList(
                delegate: SliverChildListDelegate([
                  FoodItemCard(
                    title: 'Poha',
                    hindiTitle: 'पोहा',
                    kalCount: '250',
                    portion: '1 katori',
                    onTap: () {},
                  ),
                  FoodItemCard(
                    title: 'Masala Chai',
                    hindiTitle: 'मसाला चाय',
                    kalCount: '95',
                    portion: '1 cup',
                    onTap: () {},
                  ),
                  
                  // Empty state mock for a different tab
                  /*
                  const SizedBox(height: 32),
                  const EmptyState(
                    emoji: '🍽️',
                    title: 'Nothing logged yet',
                    subtitle: 'अभी तक कुछ नहीं',
                  ),
                  const SizedBox(height: 16),
                  Center(
                    child: OutlinedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.add, color: AppColors.primary),
                      label: const Text('Add Breakfast', style: TextStyle(color: AppColors.primary)),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: AppColors.primary),
                      ),
                    ),
                  ),
                  */
                  
                  const SizedBox(height: 120), // FAB Clearance
                ]),
              ),
            ],
          ),
          
          // Sticky calorie budget pill
          Positioned(
            bottom: 84, // Above FAB
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.primarySurface,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.primary),
                  boxShadow: [
                    BoxShadow(color: AppColors.primary.withValues(alpha: 0.2), blurRadius: 4, offset: const Offset(0, 2)),
                  ],
                ),
                child: Text('1,240 / 2,000 kcal left', style: AppTextStyles.labelSmall.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold)),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.go('/home/food/search'),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.white,
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _StickySubtotalDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;

  _StickySubtotalDelegate({required this.child});

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return child;
  }

  @override
  double get maxExtent => 40.0;

  @override
  double get minExtent => 40.0;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}
