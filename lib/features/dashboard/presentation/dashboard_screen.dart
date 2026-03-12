import 'package:flutter/material.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/widgets/activity_rings.dart';
import '../../../shared/widgets/insight_card.dart';
import '../../../shared/widgets/section_header.dart';
import '../../../shared/widgets/meal_tab_bar.dart';
import '../../../shared/widgets/quick_log_fab.dart';
import 'widgets/dashboard_header.dart';
import 'widgets/meal_summary_card.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background, // #FDF6EC per design
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 120), // Clearance for FAB
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const DashboardHeader(),
                  const SizedBox(height: 20),
                  
                  const Center(
                    child: ActivityRingsWidget(
                      caloriesProgress: 0.6,
                      stepsProgress: 0.85,
                      waterProgress: 0.5,
                      activeMinProgress: 0.58,
                      size: 200,
                    ),
                  ),
                  const SizedBox(height: 20),

                  InsightCard(
                    text: "You're 18g protein short today. Adding a katori of dal to dinner will help!",
                    onDismiss: () {},
                    onThumbsUp: () {},
                    onThumbsDown: () {},
                  ),
                  
                  const SectionHeader(
                    englishTitle: "Today's Meals",
                    hindiSubtitle: "आज का भोजन",
                    trailing: Text('See all', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
                  ),
                  
                  const MealTypeTabBar(),
                  const SizedBox(height: 8),
                  
                  MealSummaryCard(
                    icon: Icons.free_breakfast,
                    title: 'Breakfast',
                    itemCount: '2 items',
                    kalCount: '345',
                    onAdd: () {},
                  ),
                  
                  const SectionHeader(
                    englishTitle: "Latest Activity",
                    hindiSubtitle: "नवीनतम",
                  ),
                  
                  // Summary cards row mock
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () {},
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: AppColors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: AppColors.divider),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Icon(Icons.fitness_center, color: AppColors.primary),
                                  const SizedBox(height: 12),
                                  const Text('Yoga Core', style: TextStyle(fontWeight: FontWeight.bold)),
                                  Text('20 mins · 120 kcal', style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: InkWell(
                            onTap: () {},
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: AppColors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: AppColors.divider),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Icon(Icons.nightlight_round, color: AppColors.secondary),
                                  const SizedBox(height: 12),
                                  const Text('Sleep Recovery', style: TextStyle(fontWeight: FontWeight.bold)),
                                  Text('7h 30m · Good', style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 20),
                ],
              ),
            ),
            
            // Floating FAB
            const Positioned(
              bottom: 16,
              right: 16,
              child: QuickLogFAB(),
            ),
          ],
        ),
      ),
    );
  }
}

