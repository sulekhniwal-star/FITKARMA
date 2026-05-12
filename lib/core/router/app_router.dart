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
import '../../shared/widgets/scaffold_patterns.dart';
import '../security/biometric_lock.dart';
import '../../features/health/blood_pressure_screen.dart';
import '../../features/health/glucose_screen.dart';
import '../../features/health/steps_screen.dart';
import '../../features/health/sleep_screen.dart';
import '../../features/karma/karma_screen.dart';
import '../../features/journal/journal_screen.dart';
import '../../features/mental_health/mental_health_screen.dart';
import '../../features/mental_health/breathing_circle_screen.dart';
import 'transitions.dart';

part 'app_router.g.dart';

@riverpod
GoRouter appRouter(Ref ref) {
  final authState = ref.watch(authProvider);
  final bool isAuthenticated = authState.value != null;

  return GoRouter(
    initialLocation: '/splash',
    debugLogDiagnostics: true,
    redirect: (context, state) {
      final isLoggingIn = state.matchedLocation.startsWith('/onboarding');
      final isSplash = state.matchedLocation == '/splash';

      if (isSplash) return null;
      if (!isAuthenticated && !isLoggingIn) return '/onboarding/welcome';
      if (isAuthenticated && isLoggingIn) return '/home/dashboard';

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
          } else if (state.matchedLocation.contains('/workout')) currentIndex = 2;
          else if (state.matchedLocation.contains('/steps')) currentIndex = 3;
          else if (state.matchedLocation.contains('/karma')) currentIndex = 4;

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
          GoRoute(path: '/home/workout', builder: (context, state) => const _PlaceholderScreen(title: 'Workouts')),
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
      GoRoute(path: '/profile', builder: (context, state) => const _PlaceholderScreen(title: 'Profile')),
      GoRoute(path: '/emergency', builder: (context, state) => const _PlaceholderScreen(title: 'Emergency')),
      GoRoute(
        path: '/lab-reports',
        builder: (context, state) => const SensitiveScreenGuard(
          screenId: 'lab-reports',
          child: _PlaceholderScreen(title: 'Lab Reports'),
        ),
      ),
      GoRoute(path: '/ai-coach', builder: (context, state) => const _PlaceholderScreen(title: 'AI Coach')),
      GoRoute(path: '/subscription', builder: (context, state) => const _PlaceholderScreen(title: 'Subscription')),
      GoRoute(path: '/settings', builder: (context, state) => const _PlaceholderScreen(title: 'Settings')),
      GoRoute(path: '/water', builder: (context, state) => const _PlaceholderScreen(title: 'Water Log')),
      GoRoute(path: '/medication', builder: (context, state) => const _PlaceholderScreen(title: 'Medication')),
      GoRoute(path: '/festival', builder: (context, state) => const _PlaceholderScreen(title: 'Festival')),
      GoRoute(path: '/wedding', builder: (context, state) => const _PlaceholderScreen(title: 'Wedding')),
      GoRoute(path: '/social', builder: (context, state) => const _PlaceholderScreen(title: 'Social')),

      GoRoute(
        path: '/workout/active/:workoutId',
        pageBuilder: (context, state) => AppTransitions.springSlideFade(
          key: state.pageKey,
          child: _PlaceholderScreen(title: 'Active Workout ${state.pathParameters['workoutId']}'),
        ),
      ),
    ],
  );
}

class _PlaceholderScreen extends StatelessWidget {
  final String title;
  const _PlaceholderScreen({required this.title});

  @override
  Widget build(BuildContext context) {
    return AppScaffold.patternA(
      appBar: AppBar(title: Text(title)),
      body: Center(child: Text('Content for $title')),
    );
  }
}
