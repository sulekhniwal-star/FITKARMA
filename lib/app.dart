import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'shared/theme/app_theme.dart';
import 'shared/widgets/main_shell.dart';
import 'features/dashboard/presentation/dashboard_screen.dart';
import 'features/food/presentation/food_home_screen.dart';
import 'features/food/presentation/food_search_screen.dart';
import 'features/food/presentation/food_detail_screen.dart';
import 'features/food/presentation/recipe_browser_screen.dart';
import 'features/food/presentation/recipe_builder_screen.dart';
import 'features/workout/presentation/workout_home_screen.dart';
import 'features/workout/presentation/workout_detail_screen.dart';
import 'features/workout/presentation/workout_calendar_screen.dart';
import 'features/steps/presentation/steps_home_screen.dart';
import 'features/karma/presentation/karma_hub_screen.dart';
import 'features/medications/presentation/medications_screen.dart';
import 'features/medications/presentation/add_medication_screen.dart';
import 'features/body_metrics/presentation/body_metrics_screen.dart';
import 'features/body_metrics/presentation/add_body_measurement_screen.dart';
import 'features/medical/presentation/blood_pressure_screen.dart';
import 'features/glucose/presentation/glucose_screen.dart';
import 'features/spo2/presentation/spo2_screen.dart';
import 'features/sleep/presentation/sleep_screen.dart';
import 'features/mood/presentation/mood_screen.dart';
import 'features/period/presentation/period_screen.dart';

final router = GoRouter(
  initialLocation: '/home/dashboard',
  routes: [
    GoRoute(path: '/', redirect: (context, state) => '/home/dashboard'),
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return MainShell(navigationShell: navigationShell);
      },
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/home/dashboard',
              builder: (context, state) => const DashboardScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/home/food',
              builder: (context, state) => const FoodHomeScreen(),
              routes: [
                GoRoute(
                  path: 'search',
                  builder: (context, state) => const FoodSearchScreen(),
                ),
                GoRoute(
                  path: 'detail/:id',
                  builder: (context, state) => FoodDetailScreen(
                    foodId: state.pathParameters['id'] ?? 'unknown',
                  ),
                ),
                GoRoute(
                  path: 'recipes',
                  builder: (context, state) => const RecipeBrowserScreen(),
                  routes: [
                    GoRoute(
                      path: 'new',
                      builder: (context, state) => const RecipeBuilderScreen(),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/home/workout',
              builder: (context, state) => const WorkoutHomeScreen(),
              routes: [
                GoRoute(
                  path: 'calendar',
                  builder: (context, state) => const WorkoutCalendarScreen(),
                ),
                GoRoute(
                  path: ':id',
                  builder: (context, state) => WorkoutDetailScreen(
                    workoutId: state.pathParameters['id'] ?? 'unknown',
                    isPremiumLocked:
                        state.pathParameters['id'] ==
                        'premium', // basic mock trigger
                  ),
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/home/steps',
              builder: (context, state) => const StepsHomeScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/home/me',
              builder: (context, state) => const KarmaHubScreen(),
              routes: [
                GoRoute(
                  path: 'medications',
                  builder: (context, state) => const MedicationsScreen(),
                  routes: [
                    GoRoute(
                      path: 'add',
                      builder: (context, state) => const AddMedicationScreen(),
                    ),
                    GoRoute(
                      path: ':id',
                      builder: (context, state) => AddMedicationScreen(
                        medicationId: state.pathParameters['id'],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ],
    ),
    // Body Metrics routes - standalone routes
    GoRoute(
      path: '/body-metrics',
      builder: (context, state) => const BodyMetricsScreen(),
      routes: [
        GoRoute(
          path: 'add',
          builder: (context, state) => const AddBodyMeasurementScreen(),
        ),
        GoRoute(
          path: ':id',
          builder: (context, state) => AddBodyMeasurementScreen(
            measurementId: state.pathParameters['id'],
          ),
        ),
      ],
    ),
    // Blood Pressure route
    GoRoute(
      path: '/blood-pressure',
      builder: (context, state) => const BloodPressureScreen(),
    ),
    // Glucose route
    GoRoute(
      path: '/glucose',
      builder: (context, state) => const GlucoseScreen(),
    ),
    // SpO2 route
    GoRoute(path: '/spo2', builder: (context, state) => const SpO2Screen()),
    // Sleep route
    GoRoute(path: '/sleep', builder: (context, state) => const SleepScreen()),
    // Mood route
    GoRoute(path: '/mood', builder: (context, state) => const MoodScreen()),
    // Period route
    GoRoute(path: '/period', builder: (context, state) => const PeriodScreen()),
  ],
);

class FitKarmaApp extends StatelessWidget {
  const FitKarmaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'FitKarma',
      theme: AppTheme.lightTheme,
      routerConfig: router,
      debugShowCheckedModeBanner: false,
    );
  }
}
