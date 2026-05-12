import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../shared/widgets/scaffold_patterns.dart';
import '../../shared/widgets/bento_card.dart';
import '../onboarding/onboarding_providers.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final user = authState.valueOrNull;

    return AppScaffold.patternB(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
          onPressed: () => context.pop(),
        ),
        title: Text('Application Settings', style: AppTypography.h2(color: Colors.white)),
        centerTitle: true,
      ),
      heroGradient: const LinearGradient(
        colors: [AppColorsDark.heroDeepStart, AppColorsDark.heroDeepEnd],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ),
      hero: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.settings_suggest_rounded, size: 64, color: AppColorsDark.teal),
          const SizedBox(height: 12),
          Text('System Controls', style: AppTypography.h1(color: Colors.white)),
          const SizedBox(height: 4),
          Text(user?.email ?? 'Client Core isolated setup', style: AppTypography.labelSm(color: AppColorsDark.textSecondary)),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 16),
          
          // Emergency Contacts Settings redirect
          Text('Safety Configuration', style: AppTypography.h3(color: Colors.white)),
          const SizedBox(height: 8),
          GlassCard(
            padding: const EdgeInsets.all(16),
            child: ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(color: AppColorsDark.rose.withOpacity(0.15), borderRadius: BorderRadius.circular(10)),
                child: const Icon(Icons.emergency_rounded, color: AppColorsDark.rose),
              ),
              title: Text('Emergency Response Contacts', style: AppTypography.labelLg(color: Colors.white)),
              subtitle: Text('Configure primary and backup medical companion responders.', style: AppTypography.labelSm(color: AppColorsDark.textMuted)),
              trailing: const Icon(Icons.chevron_right_rounded, color: AppColorsDark.textSecondary),
              onTap: () => context.push('/emergency'),
            ),
          ),
          const SizedBox(height: 24),

          // Security Setup
          Text('Hardware Tokens', style: AppTypography.h3(color: Colors.white)),
          const SizedBox(height: 8),
          GlassCard(
            padding: const EdgeInsets.all(16),
            child: ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(color: AppColorsDark.teal.withOpacity(0.15), borderRadius: BorderRadius.circular(10)),
                child: const Icon(Icons.fingerprint_rounded, color: AppColorsDark.teal),
              ),
              title: Text('Biometric Gates Context', style: AppTypography.labelLg(color: Colors.white)),
              subtitle: Text('Enforce device credentials before sensitive session screen transitions.', style: AppTypography.labelSm(color: AppColorsDark.textMuted)),
              trailing: Switch(
                value: true,
                activeColor: AppColorsDark.teal,
                onChanged: (val) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Biometric key storage state updated.'), backgroundColor: AppColorsDark.teal),
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Session Options
          Text('Cloud Session Engine', style: AppTypography.h3(color: Colors.white)),
          const SizedBox(height: 8),
          GlassCard(
            padding: const EdgeInsets.all(16),
            child: ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(color: AppColorsDark.surface2, borderRadius: BorderRadius.circular(10)),
                child: const Icon(Icons.logout_rounded, color: Colors.white),
              ),
              title: Text('Terminate Appwrite Session', style: AppTypography.labelLg(color: AppColorsDark.rose)),
              subtitle: Text('Clear runtime Appwrite connection cache models.', style: AppTypography.labelSm(color: AppColorsDark.textMuted)),
              onTap: () {
                ref.read(authProvider.notifier).logout();
                context.go('/');
              },
            ),
          ),
          const SizedBox(height: 48),
        ],
      ),
    );
  }
}
