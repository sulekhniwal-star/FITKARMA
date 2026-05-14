import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../features/onboarding/onboarding_providers.dart';
import '../../features/onboarding/welcome_screen.dart';
import '../../features/onboarding/auth_screen.dart';
import '../../features/onboarding/dosha_quiz_screen.dart';
import '../../features/onboarding/goals_screen.dart';
import '../../features/onboarding/permissions_screen.dart';
import '../../features/onboarding/splash_screen.dart';
import '../../features/dashboard/dashboard_screen.dart';
import '../../features/food/presentation/food_home_screen.dart';
import '../../shared/widgets/bottom_nav_bar.dart';
import '../security/biometric_lock.dart';
import '../../features/health/blood_pressure_screen.dart';
import '../../features/health/glucose_screen.dart';
import '../../features/health/steps_screen.dart';
import '../../features/health/sleep_screen.dart';
import '../../features/karma/karma_screen.dart';
import '../../features/journal/journal_screen.dart';
import '../../features/mental_health/mental_health_screen.dart';
import '../../features/mental_health/breathing_circle_screen.dart';
import '../../features/profile/profile_screen.dart';
import '../../features/workout/active_workout_screen.dart';
import '../../features/workout/workout_screen.dart';
import '../../features/emergency/emergency_screen.dart';
import '../../features/settings/settings_screen.dart';
import '../../features/reports/lab_reports_screen.dart';
import '../../features/water/water_screen.dart';
import '../../features/medication/medication_screen.dart';
import '../../features/festival/festival_screen.dart';
import '../../features/wedding/wedding_screen.dart';
import '../../features/social/social_screen.dart';
import '../../features/ai_coach/ai_coach_screen.dart';
import '../../features/subscription/subscription_screen.dart';
import '../../core/providers/core_providers.dart';

part 'app_router.g.dart';

class RouterNotifier extends ChangeNotifier {
  final Ref _ref;
  RouterNotifier(this._ref) {
    _ref.listen(authProvider, (previous, next) {
      notifyListeners();
    });
  }
}

@riverpod
GoRouter appRouter(Ref ref) {
  final notifier = RouterNotifier(ref);

  return GoRouter(
    initialLocation: '/splash',
    refreshListenable: notifier,
    debugLogDiagnostics: true,
    redirect: (context, state) async {
      final authState = ref.read(authProvider);
      final user = authState.value;
      final bool isAuthenticated = user != null;
      final isSplash = state.matchedLocation == '/splash';

      if (isSplash) return null;

      final isAuthScreen = state.matchedLocation == '/onboarding/welcome' ||
                           state.matchedLocation == '/onboarding/signup' ||
                           state.matchedLocation == '/onboarding/login';

      if (!isAuthenticated) {
        if (!isAuthScreen) return '/onboarding/welcome';
        return null;
      }

      // If authenticated, check local DB onboarding status
      final db = ref.read(appDatabaseProvider);
      final localUser = await (db.select(db.users)..where((t) => t.id.equals(user.$id))).getSingleOrNull();

      final bool onboardingCompleted = localUser?.onboardingCompleted ?? false;
      final String uxStage = localUser?.uxStage ?? 'onboarding';

      final isOnboardingFlowScreen = state.matchedLocation == '/onboarding/dosha' ||
                                     state.matchedLocation == '/onboarding/goals' ||
                                     state.matchedLocation == '/onboarding/permissions';

      if (!onboardingCompleted) {
        if (!isOnboardingFlowScreen) {
          if (uxStage == 'dosha_completed') return '/onboarding/goals';
          if (uxStage == 'goals_completed') return '/onboarding/permissions';
          return '/onboarding/dosha';
        }
        return null;
      }

      if (isAuthScreen || isOnboardingFlowScreen) {
        return '/home/dashboard';
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashScreen(),
      ),

      // Onboarding Branch
      GoRoute(
        path: '/onboarding/welcome',
        builder: (context, state) => const WelcomeScreen(),
      ),
      GoRoute(
        path: '/onboarding/signup',
        builder: (context, state) => const AuthScreen(isInitialSignUp: true),
      ),
      GoRoute(
        path: '/onboarding/login',
        builder: (context, state) => const AuthScreen(isInitialSignUp: false),
      ),
      GoRoute(
        path: '/onboarding/dosha',
        builder: (context, state) => const DoshaQuizScreen(),
      ),
      GoRoute(
        path: '/onboarding/goals',
        builder: (context, state) => const GoalsScreen(),
      ),
      GoRoute(
        path: '/onboarding/permissions',
        builder: (context, state) => const PermissionsScreen(),
      ),

      // Main App Shell (Bottom Nav)
      ShellRoute(
        builder: (context, state, child) {
          int currentIndex = 0;
          if (state.matchedLocation.contains('/food')) {
            currentIndex = 1;
          } else if (state.matchedLocation.contains('/workout')) {
            currentIndex = 2;
          } else if (state.matchedLocation.contains('/steps')) {
            currentIndex = 3;
          } else if (state.matchedLocation.contains('/karma')) {
            currentIndex = 4;
          }

          return Scaffold(
            body: child,
            bottomNavigationBar: BottomNavBar(
              currentIndex: currentIndex,
              onTap: (index) {
                switch (index) {
                  case 0: context.go('/home/dashboard'); break;
                  case 1: context.go('/home/food'); break;
                  case 2: context.go('/home/workout'); break;
                  case 3: context.go('/home/steps'); break;
                  case 4: context.go('/karma'); break;
                }
              },
            ),
          );
        },
        routes: [
          GoRoute(path: '/home/dashboard', builder: (context, state) => const DashboardScreen()),
          GoRoute(path: '/home/food', builder: (context, state) => const FoodHomeScreen()),
          GoRoute(path: '/home/workout', builder: (context, state) => const WorkoutScreen()),
          GoRoute(path: '/home/steps', builder: (context, state) => const StepsScreen()),
          GoRoute(path: '/karma', builder: (context, state) => const KarmaScreen()),
        ],
      ),

      // Standalone Feature Routes
      GoRoute(
        path: '/blood-pressure',
        builder: (context, state) => const SensitiveScreenGuard(
          screenId: 'blood-pressure',
          child: BloodPressureScreen(),
        ),
      ),
      GoRoute(
        path: '/glucose',
        builder: (context, state) => const SensitiveScreenGuard(
          screenId: 'glucose',
          child: GlucoseScreen(),
        ),
      ),
      GoRoute(
        path: '/sleep',
        builder: (context, state) => const SensitiveScreenGuard(
          screenId: 'sleep',
          child: SleepScreen(),
        ),
      ),
      GoRoute(
        path: '/journal',
        builder: (context, state) => const SensitiveScreenGuard(
          screenId: 'journal',
          child: JournalScreen(),
        ),
      ),
      GoRoute(
        path: '/mental-health',
        builder: (context, state) => const SensitiveScreenGuard(
          screenId: 'mental-health',
          child: MentalHealthScreen(),
        ),
      ),
      GoRoute(
        path: '/mental-health/breathing',
        builder: (context, state) => const BreathingCircleScreen(),
      ),
      GoRoute(path: '/profile', builder: (context, state) => const ProfileScreen()),
      GoRoute(
        path: '/workout/active/:workoutId',
        builder: (context, state) {
          final id = state.pathParameters['workoutId'] ?? 'default_wkt';
          return ActiveWorkoutScreen(workoutId: id);
        },
      ),
      GoRoute(path: '/emergency', builder: (context, state) => const EmergencyScreen()),
      GoRoute(
        path: '/lab-reports',
        builder: (context, state) => const SensitiveScreenGuard(
          screenId: 'lab-reports',
          child: LabReportsScreen(),
        ),
      ),
      GoRoute(path: '/ai-coach', builder: (context, state) => const AiCoachScreen()),
      GoRoute(path: '/subscription', builder: (context, state) => const SubscriptionScreen()),
      GoRoute(path: '/settings', builder: (context, state) => const SettingsScreen()),
      GoRoute(path: '/water', builder: (context, state) => const WaterScreen()),
      GoRoute(path: '/medication', builder: (context, state) => const MedicationScreen()),
      GoRoute(path: '/festival', builder: (context, state) => const FestivalScreen()),
      GoRoute(path: '/wedding', builder: (context, state) => const WeddingScreen()),
      GoRoute(path: '/social', builder: (context, state) => const SocialScreen()),
    ],
  );
}
