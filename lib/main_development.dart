import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fitkarma_ui/fitkarma_ui.dart';
import 'core/theme/theme_provider.dart';
import 'core/theme/dosha_theme.dart';
import 'core/storage/hive_service.dart';
import 'core/security/encryption_service.dart';
import 'core/providers/storage_providers.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive
  await HiveService.init();

  // Setup Encryption
  final encryptionService = EncryptionService();
  final encryptionKey = await encryptionService.getOrCreateKey();

  runApp(
    ProviderScope(
      overrides: [
        encryptionKeyProvider.overrideWithValue(encryptionKey),
      ],
      child: const FitKarmaApp(),
    ),
  );
}

class FitKarmaApp extends ConsumerWidget {
  const FitKarmaApp({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dosha = ref.watch(doshaThemeProvider);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: DoshaTheme.getTheme(dosha),
      home: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.blueGrey, Colors.black],
            ),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const FKGlassCard(
                  child: Padding(
                    padding: EdgeInsets.all(40),
                    child: Text(
                      'Cultural Premium',
                      style: TextStyle(color: Colors.white, fontSize: 24),
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: DoshaType.values.map((d) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: ElevatedButton(
                        onPressed: () =>
                            ref.read(doshaThemeProvider.notifier).setDosha(d),
                        child: Text(d.name.toUpperCase()),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Privacy Shield Active',
                  style: TextStyle(color: Colors.greenAccent, fontSize: 12),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
