import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

/// App navigation shell with bottom navigation bar
///
/// 5-tab bottom navigation with bilingual labels per Section 2.1 Dashboard Screen:
/// Home (जैसे, मुख्यपृष्ठ) · Food · Workout · Steps · Me
///
/// White background, active icon in primary orange per Section 2.2
class AppNavigationShell extends StatelessWidget {
  /// Current navigation index
  final int currentIndex;

  /// Callback when tab is changed
  final ValueChanged<int> onTabChanged;

  /// Child navigator (for nested navigation)
  final Widget child;

  const AppNavigationShell({
    super.key,
    required this.currentIndex,
    required this.onTabChanged,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: _BottomNavBar(
        currentIndex: currentIndex,
        onTabChanged: onTabChanged,
      ),
    );
  }
}

/// Bottom navigation bar widget
class _BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTabChanged;

  const _BottomNavBar({required this.currentIndex, required this.onTabChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        boxShadow: [
          BoxShadow(
            color: AppColors.cardShadow,
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _NavItem(
                icon: Icons.home_outlined,
                selectedIcon: Icons.home,
                labelEnglish: 'Home',
                labelHindi: 'मुख्यपृष्ठ',
                isSelected: currentIndex == 0,
                onTap: () => onTabChanged(0),
              ),
              _NavItem(
                icon: Icons.restaurant_outlined,
                selectedIcon: Icons.restaurant,
                labelEnglish: 'Food',
                labelHindi: 'भोजन',
                isSelected: currentIndex == 1,
                onTap: () => onTabChanged(1),
              ),
              _NavItem(
                icon: Icons.fitness_center_outlined,
                selectedIcon: Icons.fitness_center,
                labelEnglish: 'Workout',
                labelHindi: 'व्यायाम',
                isSelected: currentIndex == 2,
                onTap: () => onTabChanged(2),
              ),
              _NavItem(
                icon: Icons.directions_walk_outlined,
                selectedIcon: Icons.directions_walk,
                labelEnglish: 'Steps',
                labelHindi: 'कदम',
                isSelected: currentIndex == 3,
                onTap: () => onTabChanged(3),
              ),
              _NavItem(
                icon: Icons.person_outlined,
                selectedIcon: Icons.person,
                labelEnglish: 'Me',
                labelHindi: 'मैं',
                isSelected: currentIndex == 4,
                onTap: () => onTabChanged(4),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Individual navigation item
class _NavItem extends StatelessWidget {
  final IconData icon;
  final IconData selectedIcon;
  final String labelEnglish;
  final String labelHindi;
  final bool isSelected;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.selectedIcon,
    required this.labelEnglish,
    required this.labelHindi,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = isSelected ? AppColors.primary : AppColors.textSecondary;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(isSelected ? selectedIcon : icon, color: color, size: 24),
            const SizedBox(height: 4),
            Text(
              labelEnglish,
              style: AppTextStyles.labelSmall.copyWith(
                color: color,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
            Text(
              labelHindi,
              style: AppTextStyles.captionSmall.copyWith(
                color: color,
                fontSize: 9,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Navigation route paths
class AppRoutes {
  AppRoutes._();

  // Root routes
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String register = '/register';

  // Home shell routes
  static const String home = '/home';
  static const String dashboard = '/home/dashboard';
  static const String food = '/home/food';
  static const String foodSearch = '/home/food/search';
  static const String foodScan = '/home/food/scan';
  static const String foodPhoto = '/home/food/photo';
  static String foodDetail(String id) => '/home/food/detail/$id';
  static const String foodRecipes = '/home/food/recipes';
  static const String foodRecipesNew = '/home/food/recipes/new';
  static const String foodPlanner = '/home/food/planner';
  static const String workout = '/home/workout';
  static String workoutDetail(String id) => '/home/workout/$id';
  static String workoutPlay(String id) => '/home/workout/$id/play';
  static const String workoutCustom = '/home/workout/custom';
  static const String workoutCalendar = '/home/workout/calendar';
  static const String steps = '/home/steps';
  static const String social = '/home/social';
  static const String socialGroups = '/home/social/groups';
  static String socialGroupDetail(String id) => '/home/social/groups/$id';
  static String socialDm(String userId) => '/home/social/dm/$userId';

  // Feature routes
  static const String karma = '/karma';
  static const String profile = '/profile';
  static const String sleep = '/sleep';
  static const String mood = '/mood';
  static const String habits = '/habits';
  static const String period = '/period';
  static const String medications = '/medications';
  static const String bodyMetrics = '/body-metrics';
  static const String ayurveda = '/ayurveda';
  static const String family = '/family';
  static const String emergency = '/emergency';
  static const String bloodPressure = '/blood-pressure';
  static const String glucose = '/glucose';
  static const String spo2 = '/spo2';
  static const String chronicDisease = '/chronic-disease';
  static const String fasting = '/fasting';
  static const String meditation = '/meditation';
  static const String journal = '/journal';
  static const String mentalHealth = '/mental-health';
  static const String wearables = '/wearables';
  static const String reports = '/reports';
  static const String personalRecords = '/personal-records';
  static const String doctorAppointments = '/doctor-appointments';
  static const String referral = '/referral';
  static const String settings = '/settings';
  static const String subscription = '/subscription';
}
