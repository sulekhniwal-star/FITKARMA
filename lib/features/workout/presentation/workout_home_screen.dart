import 'package:flutter/material.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/theme/app_text_styles.dart';
import '../../../shared/widgets/category_chip_row.dart';
import '../../../shared/widgets/section_header.dart';
import 'widgets/featured_workout_banner.dart';
import 'widgets/active_program_card.dart';
import 'widgets/workout_grid_card.dart';

class WorkoutHomeScreen extends StatelessWidget {
  const WorkoutHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Workouts / वर्कआउट'),
      ),
      body: CustomScrollView(
        slivers: [
          // 1. Featured Banner
          SliverToBoxAdapter(
            child: FeaturedWorkoutBanner(
              title: 'Surya Namaskar Flow',
              duration: '15 min',
              difficulty: 'Beginner',
              imageUrl: 'https://via.placeholder.com/600x400/1D4ED8/FFFFFF?text=Featured+Workout',
              onTap: () {},
            ),
          ),
          
          // 2. Categories
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: CategoryChipRow(
                categories: ['Yoga', 'HIIT', 'Strength', 'Cardio', 'Dance', 'Pranayama'],
                initialSelected: 'Yoga',
              ),
            ),
          ),
          
          // 3. Active Program
          SliverToBoxAdapter(
            child: ActiveProgramCard(
              title: '30 Days to Fit',
              progressText: 'Day 12 of 30',
              progressValue: 12 / 30,
              nextWorkoutTitle: 'Upper Body Strength & Core',
              onResume: () {},
            ),
          ),
          
          // 4. Section Header
          const SliverToBoxAdapter(
            child: SectionHeader(
              englishTitle: 'All Workouts',
              hindiSubtitle: 'सभी वर्कआउट',
              trailing: Icon(Icons.filter_list, color: AppColors.primary),
            ),
          ),
          
          // 5. Grid
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.8, // Tailored aspect for thumbnail + text wrap
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final workouts = [
                    {'title': 'Full Body HIIT Blast', 'dur': '20m', 'diff': 'Advanced', 'prem': true},
                    {'title': 'Morning Vinyasa Flow', 'dur': '30m', 'diff': 'Intermediate', 'prem': false},
                    {'title': 'No Equipment Core', 'dur': '10m', 'diff': 'Beginner', 'prem': false},
                    {'title': 'Bollywood Dance Cardio', 'dur': '45m', 'diff': 'Beginner', 'prem': true},
                  ];
                  final w = workouts[index];
                  return WorkoutGridCard(
                    title: w['title'] as String,
                    duration: w['dur'] as String,
                    difficulty: w['diff'] as String,
                    isPremium: w['prem'] as bool,
                    onTap: () {},
                  );
                },
                childCount: 4,
              ),
            ),
          ),
          
          // 6. Custom Builder CTA
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 80), // 80px bottom clear
              child: InkWell(
                onTap: () {},
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: AppColors.primarySurface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: AppColors.primary,
                      width: 2,
                    ), // Note: standard border used as dash borders require custom painters.
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.add_circle_outline, color: AppColors.primary),
                      const SizedBox(width: 12),
                      Text('Build Custom Workout', style: AppTextStyles.h4.copyWith(color: AppColors.primary)),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
