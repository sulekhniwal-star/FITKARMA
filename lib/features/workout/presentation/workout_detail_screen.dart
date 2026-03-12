import 'package:flutter/material.dart';
import '../../../../shared/theme/app_colors.dart';
import '../../../../shared/theme/app_text_styles.dart';
import '../../../../shared/widgets/primary_button.dart';
import 'widgets/exercise_list_tile.dart';

class WorkoutDetailScreen extends StatelessWidget {
  final String workoutId;
  final bool isPremiumLocked;

  const WorkoutDetailScreen({
    super.key,
    required this.workoutId,
    this.isPremiumLocked = false,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite_border, color: AppColors.white),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.share, color: AppColors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              // Dark Hero (Pattern B) - Image with gradient overlay
              SliverToBoxAdapter(
                child: Container(
                  height: 350,
                  decoration: const BoxDecoration(
                    color: AppColors.surfaceVariant, // Fallback
                    image: DecorationImage(
                      image: NetworkImage('https://via.placeholder.com/600x600/1D4ED8/FFFFFF?text=Squats+Workout'),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Container(
                    padding: const EdgeInsets.only(left: 16, right: 16, bottom: 40),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withValues(alpha: 0.1),
                          Colors.black.withValues(alpha: 0.6),
                          AppColors.background,
                        ],
                        stops: const [0.0, 0.7, 1.0],
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            _buildDifficultyChip('Advanced', AppColors.error),
                            const SizedBox(width: 8),
                            _buildDurationChip('45 min'),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text('Lower Body Power', style: AppTextStyles.h1.copyWith(color: AppColors.white)),
                        const SizedBox(height: 8),
                        Text('with Rahul Sharma', style: AppTextStyles.bodyLarge.copyWith(color: AppColors.white.withValues(alpha: 0.8))),
                      ],
                    ),
                  ),
                ),
              ),

              // Body content
              SliverToBoxAdapter(
                child: Container(
                  decoration: const BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(24),
                      topRight: Radius.circular(24),
                    ),
                  ),
                  transform: Matrix4.translationValues(0.0, -24.0, 0.0), // Pulled up over hero
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // 1. Tag pills row
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: [
                                  _buildTagChip('Strength'),
                                  const SizedBox(width: 8),
                                  _buildTagChip('Dumbbells'),
                                  const SizedBox(width: 8),
                                  _buildTagChip('Legs & Glutes'),
                                ],
                              ),
                            ),
                            const SizedBox(height: 24),

                            // 2. Stats row
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                _buildStatColumn(Icons.local_fire_department, '320', 'kcal'),
                                _buildStatColumn(Icons.fitness_center, '5', 'Exercises'),
                                _buildStatColumn(Icons.accessibility_new, 'High', 'Intensity'),
                              ],
                            ),
                            const SizedBox(height: 24),
                            const Divider(),
                            const SizedBox(height: 16),

                            // 3. Description
                            Text('Description', style: AppTextStyles.h4),
                            const SizedBox(height: 8),
                            Text(
                              'A high-intensity lower body workout designed to build strength and power in your quads, glutes, and hamstrings.',
                              style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
                            ),
                            const SizedBox(height: 24),
                            Text('Exercises', style: AppTextStyles.h4),
                            const SizedBox(height: 8),
                          ],
                        ),
                      ),

                      // 4. Exercise list (blurred if premium locked)
                      Stack(
                        children: [
                          Column(
                            children: [
                              ExerciseListTile(
                                index: 1,
                                title: 'Goblet Squats',
                                setsReps: '4 sets x 12 reps',
                                restTime: '60s',
                                muscleGroupIcon: Icons.accessibility,
                              ),
                              ExerciseListTile(
                                index: 2,
                                title: 'Romanian Deadlifts',
                                setsReps: '4 sets x 10 reps',
                                restTime: '60s',
                                muscleGroupIcon: Icons.accessibility,
                              ),
                              ExerciseListTile(
                                index: 3,
                                title: 'Walking Lunges',
                                setsReps: '3 sets x 20 steps',
                                restTime: '45s',
                                muscleGroupIcon: Icons.directions_walk,
                              ),
                              ExerciseListTile(
                                index: 4,
                                title: 'Leg Press',
                                setsReps: '3 sets x 15 reps',
                                restTime: '60s',
                                muscleGroupIcon: Icons.airline_seat_legroom_extra,
                              ),
                            ],
                          ),
                          if (isPremiumLocked)
                            Positioned.fill(
                              child: Container(
                                color: AppColors.white.withValues(alpha: 0.8),
                                child: Center(
                                  child: Container(
                                    margin: const EdgeInsets.symmetric(horizontal: 32),
                                    padding: const EdgeInsets.all(24),
                                    decoration: BoxDecoration(
                                      gradient: AppGradients.amberGradient,
                                      borderRadius: BorderRadius.circular(16),
                                      boxShadow: [
                                        BoxShadow(
                                          color: AppColors.accent.withValues(alpha: 0.2),
                                          blurRadius: 10,
                                          offset: const Offset(0, 4),
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(12),
                                          decoration: BoxDecoration(
                                            color: AppColors.white.withValues(alpha: 0.4),
                                            shape: BoxShape.circle,
                                          ),
                                          child: const Icon(Icons.workspace_premium, color: AppColors.textPrimary, size: 32),
                                        ),
                                        const SizedBox(height: 16),
                                        Text('Premium Workout', style: AppTextStyles.h3.copyWith(color: AppColors.textPrimary)),
                                        const SizedBox(height: 8),
                                        Text(
                                          'Unlock this routine and hundreds more by upgrading to FitKarma Premium.',
                                          textAlign: TextAlign.center,
                                          style: AppTextStyles.bodySmall.copyWith(color: AppColors.textPrimary),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 100), // FAB / Sticky CTA clearance
                    ],
                  ),
                ),
              ),
            ],
          ),

          // Sticky Bottom CTA
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.only(
                left: 16,
                right: 16,
                top: 16,
                bottom: MediaQuery.of(context).padding.bottom + 16,
              ),
              decoration: BoxDecoration(
                color: AppColors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: isPremiumLocked
                  ? PrimaryButton(
                      text: 'Unlock with Premium',
                      hindiSubLabel: 'प्रीमियम के साथ अनलॉक करें',
                      onPressed: () {},
                      leadingIcon: Icons.lock_open,
                    )
                  : PrimaryButton(
                      text: 'Start Workout',
                      hindiSubLabel: 'शुरू करें',
                      onPressed: () {},
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDifficultyChip(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(text, style: AppTextStyles.labelSmall.copyWith(color: AppColors.white, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildDurationChip(String duration) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.white.withValues(alpha: 0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.timer, size: 14, color: AppColors.white),
          const SizedBox(width: 4),
          Text(duration, style: AppTextStyles.labelSmall.copyWith(color: AppColors.white)),
        ],
      ),
    );
  }

  Widget _buildTagChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(label, style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildStatColumn(IconData icon, String value, String unit) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: AppColors.primary, size: 28),
        const SizedBox(height: 8),
        Text(value, style: AppTextStyles.h3),
        Text(unit, style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary)),
      ],
    );
  }
}
