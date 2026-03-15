import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../shared/widgets/app_navigation_shell.dart';
import '../../shared/theme/app_colors.dart';
import '../../features/auth/providers/auth_providers.dart';
import '../../features/auth/screens/login_screen.dart';
import '../../features/auth/screens/register_screen.dart';
import '../../features/auth/screens/onboarding_screen.dart';
import '../../features/dashboard/screens/dashboard_screen.dart';
import '../../features/steps/screens/steps_screen.dart';
import '../../features/karma/screens/karma_hub_screen.dart';
import '../../features/karma/screens/karma_store_screen.dart';
import '../../features/karma/screens/leaderboard_screen.dart';
import '../security/biometric_service.dart';

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
  static const String karmaStore = '/karma/store';
  static const String leaderboard = '/karma/leaderboard';
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

/// App router configuration using GoRouter
///
/// Route map from Section 19:
/// / → Splash
/// /onboarding → Onboarding
/// /login → Login
/// /register → Register
/// /home → Shell (bottom nav)
///   /home/dashboard → Dashboard
///   /home/food → Food Home
///   /home/workout → Workout Home
///   /home/steps → Steps Home
///   /home/social → Social Feed
/// /karma → Karma Hub
/// /profile → Profile
/// [and many more feature routes]
class AppRouter {
  AppRouter._();

  /// Global navigator key
  static final GlobalKey<NavigatorState> _rootNavigatorKey =
      GlobalKey<NavigatorState>(debugLabel: 'root');

  /// Shell navigator key for bottom nav
  static final GlobalKey<NavigatorState> _shellNavigatorKey =
      GlobalKey<NavigatorState>(debugLabel: 'shell');

  /// Router configuration
  static final GoRouter router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: AppRoutes.splash,
    debugLogDiagnostics: true,
    routes: [
      // Root routes (no shell)
      GoRoute(
        path: AppRoutes.splash,
        name: 'splash',
        builder: (context, state) => const _SplashScreen(),
      ),
      GoRoute(
        path: AppRoutes.onboarding,
        name: 'onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: AppRoutes.login,
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: AppRoutes.register,
        name: 'register',
        builder: (context, state) => const RegisterScreen(),
      ),

      // Home shell with bottom navigation
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) {
          return _HomeShell(child: child);
        },
        routes: [
          // Dashboard
          GoRoute(
            path: AppRoutes.dashboard,
            name: 'dashboard',
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: DashboardScreen()),
          ),

          // Food routes
          GoRoute(
            path: AppRoutes.food,
            name: 'food',
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: _FoodScreen()),
            routes: [
              GoRoute(
                path: 'search',
                name: 'foodSearch',
                builder: (context, state) => const _FoodSearchScreen(),
              ),
              GoRoute(
                path: 'scan',
                name: 'foodScan',
                builder: (context, state) => const _BarcodeScannerScreen(),
              ),
              GoRoute(
                path: 'photo',
                name: 'foodPhoto',
                builder: (context, state) => const _PhotoScannerScreen(),
              ),
              GoRoute(
                path: 'detail/:id',
                name: 'foodDetail',
                builder: (context, state) {
                  final id = state.pathParameters['id']!;
                  return _FoodDetailScreen(foodId: id);
                },
              ),
              GoRoute(
                path: 'recipes',
                name: 'foodRecipes',
                builder: (context, state) => const _RecipeBrowserScreen(),
              ),
              GoRoute(
                path: 'recipes/new',
                name: 'foodRecipesNew',
                builder: (context, state) => const _RecipeBuilderScreen(),
              ),
              GoRoute(
                path: 'planner',
                name: 'foodPlanner',
                builder: (context, state) => const _MealPlannerScreen(),
              ),
            ],
          ),

          // Workout routes
          GoRoute(
            path: AppRoutes.workout,
            name: 'workout',
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: _WorkoutScreen()),
            routes: [
              GoRoute(
                path: ':id',
                name: 'workoutDetail',
                builder: (context, state) {
                  final id = state.pathParameters['id']!;
                  return _WorkoutDetailScreen(workoutId: id);
                },
              ),
              GoRoute(
                path: ':id/play',
                name: 'workoutPlay',
                builder: (context, state) {
                  final id = state.pathParameters['id']!;
                  return _VideoPlayerScreen(workoutId: id);
                },
              ),
              GoRoute(
                path: 'custom',
                name: 'workoutCustom',
                builder: (context, state) =>
                    const _CustomWorkoutBuilderScreen(),
              ),
              GoRoute(
                path: 'calendar',
                name: 'workoutCalendar',
                builder: (context, state) => const _WorkoutCalendarScreen(),
              ),
            ],
          ),

          // Steps
          GoRoute(
            path: AppRoutes.steps,
            name: 'steps',
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: _StepsScreen()),
          ),

          // Social
          GoRoute(
            path: AppRoutes.social,
            name: 'social',
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: _SocialScreen()),
            routes: [
              GoRoute(
                path: 'groups',
                name: 'socialGroups',
                builder: (context, state) => const _CommunityGroupsScreen(),
              ),
              GoRoute(
                path: 'groups/:id',
                name: 'socialGroupDetail',
                builder: (context, state) {
                  final id = state.pathParameters['id']!;
                  return _GroupDetailScreen(groupId: id);
                },
              ),
              GoRoute(
                path: 'dm/:userId',
                name: 'socialDm',
                builder: (context, state) {
                  final userId = state.pathParameters['userId']!;
                  return _DirectMessagesScreen(userId: userId);
                },
              ),
            ],
          ),
        ],
      ),

      // Karma routes
      GoRoute(
        path: AppRoutes.karma,
        name: 'karma',
        builder: (context, state) => const KarmaHubScreen(),
        routes: [
          GoRoute(
            path: 'store',
            name: 'karmaStore',
            builder: (context, state) => const KarmaStoreScreen(),
          ),
          GoRoute(
            path: 'leaderboard',
            name: 'leaderboard',
            builder: (context, state) => const LeaderboardScreen(),
          ),
        ],
      ),
      GoRoute(
        path: AppRoutes.profile,
        name: 'profile',
        builder: (context, state) => const _ProfileScreen(),
      ),
      GoRoute(
        path: AppRoutes.sleep,
        name: 'sleep',
        builder: (context, state) => const _SleepScreen(),
      ),
      GoRoute(
        path: AppRoutes.mood,
        name: 'mood',
        builder: (context, state) => const _MoodScreen(),
      ),
      GoRoute(
        path: AppRoutes.habits,
        name: 'habits',
        builder: (context, state) => const _HabitsScreen(),
      ),
      GoRoute(
        path: AppRoutes.period,
        name: 'period',
        builder: (context, state) => const _PeriodScreen(),
      ),
      GoRoute(
        path: AppRoutes.medications,
        name: 'medications',
        builder: (context, state) => const _MedicationsScreen(),
      ),
      GoRoute(
        path: AppRoutes.bodyMetrics,
        name: 'bodyMetrics',
        builder: (context, state) => const _BodyMetricsScreen(),
      ),
      GoRoute(
        path: AppRoutes.ayurveda,
        name: 'ayurveda',
        builder: (context, state) => const _AyurvedaScreen(),
      ),
      GoRoute(
        path: AppRoutes.family,
        name: 'family',
        builder: (context, state) => const _FamilyScreen(),
      ),
      GoRoute(
        path: AppRoutes.emergency,
        name: 'emergency',
        builder: (context, state) => const _EmergencyScreen(),
      ),
      GoRoute(
        path: AppRoutes.bloodPressure,
        name: 'bloodPressure',
        builder: (context, state) => const _BloodPressureScreen(),
      ),
      GoRoute(
        path: AppRoutes.glucose,
        name: 'glucose',
        builder: (context, state) => const _GlucoseScreen(),
      ),
      GoRoute(
        path: AppRoutes.spo2,
        name: 'spo2',
        builder: (context, state) => const _Spo2Screen(),
      ),
      GoRoute(
        path: AppRoutes.chronicDisease,
        name: 'chronicDisease',
        builder: (context, state) => const _ChronicDiseaseScreen(),
      ),
      GoRoute(
        path: AppRoutes.fasting,
        name: 'fasting',
        builder: (context, state) => const _FastingScreen(),
      ),
      GoRoute(
        path: AppRoutes.meditation,
        name: 'meditation',
        builder: (context, state) => const _MeditationScreen(),
      ),
      GoRoute(
        path: AppRoutes.journal,
        name: 'journal',
        builder: (context, state) => const _JournalScreen(),
      ),
      GoRoute(
        path: AppRoutes.mentalHealth,
        name: 'mentalHealth',
        builder: (context, state) => const _MentalHealthScreen(),
      ),
      GoRoute(
        path: AppRoutes.wearables,
        name: 'wearables',
        builder: (context, state) => const _WearablesScreen(),
      ),
      GoRoute(
        path: AppRoutes.reports,
        name: 'reports',
        builder: (context, state) => const _ReportsScreen(),
      ),
      GoRoute(
        path: AppRoutes.personalRecords,
        name: 'personalRecords',
        builder: (context, state) => const _PersonalRecordsScreen(),
      ),
      GoRoute(
        path: AppRoutes.doctorAppointments,
        name: 'doctorAppointments',
        builder: (context, state) => const _DoctorAppointmentsScreen(),
      ),
      GoRoute(
        path: AppRoutes.referral,
        name: 'referral',
        builder: (context, state) => const _ReferralScreen(),
      ),
      GoRoute(
        path: AppRoutes.settings,
        name: 'settings',
        builder: (context, state) => const _SettingsScreen(),
      ),
      GoRoute(
        path: AppRoutes.subscription,
        name: 'subscription',
        builder: (context, state) => const _SubscriptionScreen(),
      ),
    ],
  );
}

/// Home shell with bottom navigation
class _HomeShell extends StatefulWidget {
  final Widget child;

  const _HomeShell({required this.child});

  @override
  State<_HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<_HomeShell> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return AppNavigationShell(
      currentIndex: _currentIndex,
      onTabChanged: (index) {
        setState(() => _currentIndex = index);
        // Navigate to the appropriate tab
        switch (index) {
          case 0:
            context.go(AppRoutes.dashboard);
            break;
          case 1:
            context.go(AppRoutes.food);
            break;
          case 2:
            context.go(AppRoutes.workout);
            break;
          case 3:
            context.go(AppRoutes.steps);
            break;
          case 4:
            context.go(AppRoutes.profile);
            break;
        }
      },
      child: widget.child,
    );
  }
}

// ==================== Placeholder Screens ====================

class _SplashScreen extends ConsumerStatefulWidget {
  const _SplashScreen();

  @override
  ConsumerState<_SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<_SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuth();
  }

  Future<void> _checkAuth() async {
    // Wait for a brief moment for the app to initialize
    await Future.delayed(const Duration(milliseconds: 500));

    // Check if user is authenticated
    final authService = ref.read(authServiceProvider);
    final isAuthenticated = await authService.isAuthenticated();

    if (mounted) {
      if (isAuthenticated) {
        // Navigate to Dashboard if authenticated
        context.go(AppRoutes.dashboard);
      } else {
        // Navigate to Login if not authenticated
        context.go(AppRoutes.login);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Loading...'),
          ],
        ),
      ),
    );
  }
}

// Onboarding screen is now in features/auth/screens/

// Food screen placeholder
class _FoodScreen extends StatelessWidget {
  const _FoodScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Food')),
      body: const Center(child: Text('Food Screen')),
    );
  }
}

class _FoodSearchScreen extends StatelessWidget {
  const _FoodSearchScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Search Food')),
      body: const Center(child: Text('Food Search Screen')),
    );
  }
}

class _BarcodeScannerScreen extends StatelessWidget {
  const _BarcodeScannerScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Barcode Scanner')),
      body: const Center(child: Text('Barcode Scanner Screen')),
    );
  }
}

class _PhotoScannerScreen extends StatelessWidget {
  const _PhotoScannerScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Photo Scanner')),
      body: const Center(child: Text('Photo Scanner Screen')),
    );
  }
}

class _FoodDetailScreen extends StatelessWidget {
  final String foodId;
  const _FoodDetailScreen({required this.foodId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Food Detail')),
      body: Center(child: Text('Food Detail: $foodId')),
    );
  }
}

class _RecipeBrowserScreen extends StatelessWidget {
  const _RecipeBrowserScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Recipes')),
      body: const Center(child: Text('Recipe Browser Screen')),
    );
  }
}

class _RecipeBuilderScreen extends StatelessWidget {
  const _RecipeBuilderScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Recipe Builder')),
      body: const Center(child: Text('Recipe Builder Screen')),
    );
  }
}

class _MealPlannerScreen extends StatelessWidget {
  const _MealPlannerScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Meal Planner')),
      body: const Center(child: Text('Meal Planner Screen')),
    );
  }
}

class _WorkoutScreen extends StatelessWidget {
  const _WorkoutScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Workout')),
      body: const Center(child: Text('Workout Screen')),
    );
  }
}

class _WorkoutDetailScreen extends StatelessWidget {
  final String workoutId;
  const _WorkoutDetailScreen({required this.workoutId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Workout Detail')),
      body: Center(child: Text('Workout: $workoutId')),
    );
  }
}

class _VideoPlayerScreen extends StatelessWidget {
  final String workoutId;
  const _VideoPlayerScreen({required this.workoutId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Video Player')),
      body: Center(child: Text('Video: $workoutId')),
    );
  }
}

class _CustomWorkoutBuilderScreen extends StatelessWidget {
  const _CustomWorkoutBuilderScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Custom Workout')),
      body: const Center(child: Text('Custom Workout Builder Screen')),
    );
  }
}

class _WorkoutCalendarScreen extends StatelessWidget {
  const _WorkoutCalendarScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Workout Calendar')),
      body: const Center(child: Text('Workout Calendar Screen')),
    );
  }
}

class _StepsScreen extends StatelessWidget {
  const _StepsScreen();

  @override
  Widget build(BuildContext context) {
    return const StepsScreen();
  }
}

class _SocialScreen extends StatelessWidget {
  const _SocialScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Social')),
      body: const Center(child: Text('Social Feed Screen')),
    );
  }
}

class _CommunityGroupsScreen extends StatelessWidget {
  const _CommunityGroupsScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Community Groups')),
      body: const Center(child: Text('Community Groups Screen')),
    );
  }
}

class _GroupDetailScreen extends StatelessWidget {
  final String groupId;
  const _GroupDetailScreen({required this.groupId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Group Detail')),
      body: Center(child: Text('Group: $groupId')),
    );
  }
}

class _DirectMessagesScreen extends StatelessWidget {
  final String userId;
  const _DirectMessagesScreen({required this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Direct Messages')),
      body: Center(child: Text('DM: $userId')),
    );
  }
}

class _KarmaScreen extends StatelessWidget {
  const _KarmaScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Karma')),
      body: const Center(child: Text('Karma Hub Screen')),
    );
  }
}

class _ProfileScreen extends StatelessWidget {
  const _ProfileScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: const Center(child: Text('Profile Screen')),
    );
  }
}

class _SleepScreen extends StatelessWidget {
  const _SleepScreen();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: Text('Sleep Tracker Screen')));
  }
}

class _MoodScreen extends StatelessWidget {
  const _MoodScreen();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: Text('Mood Tracker Screen')));
  }
}

class _HabitsScreen extends StatelessWidget {
  const _HabitsScreen();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: Text('Habit Tracker Screen')));
  }
}

class _PeriodScreen extends StatelessWidget {
  const _PeriodScreen();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: Text('Period Tracker Screen')));
  }
}

class _MedicationsScreen extends StatelessWidget {
  const _MedicationsScreen();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: Text('Medications Screen')));
  }
}

class _BodyMetricsScreen extends StatelessWidget {
  const _BodyMetricsScreen();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('Body Measurements Screen')),
    );
  }
}

class _AyurvedaScreen extends StatelessWidget {
  const _AyurvedaScreen();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: Text('Ayurveda Hub Screen')));
  }
}

class _FamilyScreen extends StatelessWidget {
  const _FamilyScreen();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: Text('Family Profiles Screen')));
  }
}

class _EmergencyScreen extends StatelessWidget {
  const _EmergencyScreen();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: Text('Emergency Card Screen')));
  }
}

class _BloodPressureScreen extends StatelessWidget {
  const _BloodPressureScreen();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: Text('Blood Pressure Screen')));
  }
}

class _GlucoseScreen extends StatelessWidget {
  const _GlucoseScreen();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: Text('Glucose Tracker Screen')));
  }
}

class _Spo2Screen extends StatelessWidget {
  const _Spo2Screen();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: Text('SpO2 Tracker Screen')));
  }
}

class _ChronicDiseaseScreen extends StatelessWidget {
  const _ChronicDiseaseScreen();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('Chronic Disease Hub Screen')),
    );
  }
}

class _FastingScreen extends StatelessWidget {
  const _FastingScreen();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: Text('Fasting Tracker Screen')));
  }
}

class _MeditationScreen extends StatelessWidget {
  const _MeditationScreen();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('Meditation & Pranayama Screen')),
    );
  }
}

class _JournalScreen extends StatelessWidget {
  const _JournalScreen();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: Text('Journal Screen')));
  }
}

class _MentalHealthScreen extends StatelessWidget {
  const _MentalHealthScreen();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('Mental Health Hub Screen')),
    );
  }
}

class _WearablesScreen extends StatelessWidget {
  const _WearablesScreen();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('Wearable Connections Screen')),
    );
  }
}

class _ReportsScreen extends StatelessWidget {
  const _ReportsScreen();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: Text('Health Reports Screen')));
  }
}

class _PersonalRecordsScreen extends StatelessWidget {
  const _PersonalRecordsScreen();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: Text('Personal Records Screen')));
  }
}

class _DoctorAppointmentsScreen extends StatelessWidget {
  const _DoctorAppointmentsScreen();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('Doctor Appointments Screen')),
    );
  }
}

class _ReferralScreen extends StatelessWidget {
  const _ReferralScreen();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: Text('Referral Program Screen')));
  }
}

class _SettingsScreen extends ConsumerStatefulWidget {
  const _SettingsScreen();

  @override
  ConsumerState<_SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<_SettingsScreen> {
  final BiometricService _biometricService = BiometricService();
  bool _biometricAvailable = false;
  bool _biometricEnabled = false;
  String _biometricType = 'Biometric';

  @override
  void initState() {
    super.initState();
    _loadBiometricSettings();
  }

  Future<void> _loadBiometricSettings() async {
    final available = await _biometricService.isBiometricAvailable();
    final enabled = await _biometricService.isBiometricEnabled();
    final type = await _biometricService.getBiometricTypeName();

    if (mounted) {
      setState(() {
        _biometricAvailable = available;
        _biometricEnabled = enabled;
        _biometricType = type;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          // Security Section
          const _SettingsSection(title: 'Security'),
          if (_biometricAvailable)
            _SettingsTile(
              icon: Icons.fingerprint,
              title: '$_biometricType Lock',
              subtitle: 'Require $_biometricType to unlock the app',
              trailing: Switch(
                value: _biometricEnabled,
                onChanged: (value) async {
                  if (value) {
                    // Verify biometric before enabling
                    final authenticated = await _biometricService.authenticate(
                      reason: 'Verify $_biometricType to enable lock',
                    );
                    if (authenticated) {
                      await _biometricService.enableBiometric();
                    }
                  } else {
                    await _biometricService.disableBiometric();
                  }
                  setState(() {
                    _biometricEnabled = value;
                  });
                },
              ),
            )
          else
            const _SettingsTile(
              icon: Icons.fingerprint,
              title: 'Biometric Lock',
              subtitle: 'Not available on this device',
            ),
          const Divider(),

          // Account Section
          const _SettingsSection(title: 'Account'),
          _SettingsTile(
            icon: Icons.person,
            title: 'Profile',
            subtitle: 'View and edit your profile',
            onTap: () {},
          ),
          _SettingsTile(
            icon: Icons.logout,
            title: 'Logout',
            subtitle: 'Sign out of your account',
            onTap: () {},
          ),
          const Divider(),

          // App Section
          const _SettingsSection(title: 'App'),
          _SettingsTile(
            icon: Icons.language,
            title: 'Language',
            subtitle: 'English',
            onTap: () {},
          ),
          _SettingsTile(
            icon: Icons.info,
            title: 'About',
            subtitle: 'Version 1.0.0',
            onTap: () {},
          ),
        ],
      ),
    );
  }
}

class _SettingsSection extends StatelessWidget {
  final String title;

  const _SettingsSection({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: AppColors.textSecondary,
        ),
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;

  const _SettingsTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primary),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: trailing ?? const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}

class _SubscriptionScreen extends StatelessWidget {
  const _SubscriptionScreen();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('Subscription Plans Screen')),
    );
  }
}
