import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/router/app_router.dart';
import 'core/services/notification_service.dart';
import 'core/security/security_service.dart';
import 'features/settings/settings_providers.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService.init();

  await SentryFlutter.init(
    (options) {
      options.dsn = 'https://751ba1a16600fe85056a402495d48049@o4510979281190912.ingest.de.sentry.io/4510979283222608';
      // Set tracesSampleRate to 1.0 to capture 100% of transactions for tracing.
      // We recommend adjusting this value in production.
      options.tracesSampleRate = 1.0;
      // The sampling rate for profiling is relative to tracesSampleRate
      // Setting to 1.0 will profile 100% of sampled transactions:
      options.profilesSampleRate = 1.0;
    },
    appRunner: () => runApp(SentryWidget(child: 
    const ProviderScope(
      child: MyApp(),
    ),
  )),
  );
  // TODO: Remove this line after sending the first sample event to sentry.
  await Sentry.captureException(Exception('This is a sample exception.'));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);
    final settings = ref.watch(systemSettingsProvider);

    // Initialize TLS Certificate Pinning instantly upon startup execution
    Future.microtask(() {
      ref.read(securityServiceProvider).enableCertificatePinning();
    });

    return MaterialApp.router(
      title: 'FitKarma',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: settings.isDarkMode ? Brightness.dark : Brightness.light,
        ),
        fontFamily: settings.dyslexicFont ? 'OpenDyslexic' : 'PlusJakartaSans',
        useMaterial3: true,
      ),
      builder: (context, child) {
        final baseQuery = MediaQuery.of(context);
        // Combine dynamic system factor with app settings multiplier, strictly clamped between 0.85 and 1.3
        final targetScale = (baseQuery.textScaler.scale(settings.textScale)).clamp(0.85, 1.3);
        
        return MediaQuery(
          data: baseQuery.copyWith(
            textScaler: TextScaler.linear(targetScale),
          ),
          child: child ?? const SizedBox(),
        );
      },
      routerConfig: router,
    );
  }
}
