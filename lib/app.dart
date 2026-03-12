import 'package:flutter/material.dart';
import 'package:fitkarma/l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:fitkarma/features/dashboard/presentation/dashboard_screen.dart';
import 'package:fitkarma/features/food/presentation/food_logging_screen.dart';
import 'package:fitkarma/shared/theme/app_theme.dart';
import 'package:fitkarma/core/l10n/l10n_helper.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

final router = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/',
  routes: [
    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      builder: (context, state, child) {
        return AppShell(child: child);
      },
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const DashboardScreen(),
        ),
        GoRoute(
          path: '/food',
          builder: (context, state) => const FoodLoggingScreen(),
        ),
        GoRoute(
          path: '/workout',
          builder: (context, state) => const PlaceholderScreen(title: 'Workout / व्यायाम'),
        ),
        GoRoute(
          path: '/steps',
          builder: (context, state) => const PlaceholderScreen(title: 'Steps / कदम'),
        ),
        GoRoute(
          path: '/me',
          builder: (context, state) => const PlaceholderScreen(title: 'Me / मैं'),
        ),
      ],
    ),
  ],
);

class AppShell extends StatelessWidget {
  final Widget child;
  const AppShell({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    // Determine the current index based on the child's context
    final location = GoRouterState.of(context).matchedLocation;
    int currentIndex = _getSelectedIndex(location);

    return Scaffold(
      body: child,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          switch (index) {
            case 0: context.go('/'); break;
            case 1: context.go('/food'); break;
            case 2: context.go('/workout'); break;
            case 3: context.go('/steps'); break;
            case 4: context.go('/me'); break;
          }
        },
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.home_outlined),
            activeIcon: const Icon(Icons.home),
            label: '${L10n.en.dashboard}\n${L10n.hi.dashboard}',
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.restaurant_outlined),
            activeIcon: const Icon(Icons.restaurant),
            label: '${L10n.en.logFood}\n${L10n.hi.logFood}',
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.fitness_center_outlined),
            activeIcon: const Icon(Icons.fitness_center),
            label: '${L10n.en.activeMinutes}\n${L10n.hi.activeMinutes}',
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.directions_walk_outlined),
            activeIcon: const Icon(Icons.directions_walk),
            label: '${L10n.en.steps}\n${L10n.hi.steps}',
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.person_outlined),
            activeIcon: const Icon(Icons.person),
            label: 'Me\nमैं', // Placeholder for "Me" as it's not in ARB yet
          ),
        ],
      ),
    );
  }

  int _getSelectedIndex(String location) {
    if (location == '/') return 0;
    if (location.startsWith('/food')) return 1;
    if (location.startsWith('/workout')) return 2;
    if (location.startsWith('/steps')) return 3;
    if (location.startsWith('/me')) return 4;
    return 0;
  }
}

class PlaceholderScreen extends StatelessWidget {
  final String title;
  const PlaceholderScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(child: Text(title)),
    );
  }
}

class FitKarmaApp extends StatelessWidget {
  const FitKarmaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'FitKarma',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      routerConfig: router,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: const Locale('en'), // Default to English for now, can be dynamic later
    );
  }
}
