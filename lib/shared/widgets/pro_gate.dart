import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/providers/core_providers.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import 'bento_card.dart';

class ProGate extends ConsumerWidget {
  final Widget child;
  final String featureName;

  const ProGate({
    super.key,
    required this.child,
    this.featureName = 'Premium Capability',
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final proAsync = ref.watch(isProProvider);

    return proAsync.when(
      loading: () => const Scaffold(
        backgroundColor: AppColorsDark.bg1,
        body: Center(child: CircularProgressIndicator(color: AppColorsDark.accent)),
      ),
      error: (_, _) => Scaffold(
        backgroundColor: AppColorsDark.bg1,
        body: Center(
          child: Text('Error validating Pro credentials.', style: AppTypography.bodySm(color: AppColorsDark.rose)),
        ),
      ),
      data: (isProUser) {
        // If validated Pro user, render target specialized view cleanly
        if (isProUser) return child;

        // Premium feature upgrade overlay
        return Scaffold(
          backgroundColor: AppColorsDark.bg1,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
              onPressed: () => context.pop(),
            ),
          ),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Icon(Icons.workspace_premium_rounded, size: 80, color: AppColorsDark.accent),
                  const SizedBox(height: 16),
                  Text(
                    '$featureName is a Pro Feature',
                    style: AppTypography.h1(color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Unlock bespoke timeline milestone synthesis, specialized cultural meal optimization frameworks, and custom biometric monitoring pools.',
                    style: AppTypography.bodySm(color: AppColorsDark.textSecondary),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),

                  GlassCard(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.check_circle_rounded, color: AppColorsDark.accent, size: 18),
                            const SizedBox(width: 12),
                            Expanded(child: Text('Infinite vault diagnostic storage pools', style: AppTypography.labelSm(color: Colors.white))),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            const Icon(Icons.check_circle_rounded, color: AppColorsDark.accent, size: 18),
                            const SizedBox(width: 12),
                            Expanded(child: Text('Bespoke Bridal / Event Timeline generation', style: AppTypography.labelSm(color: Colors.white))),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            const Icon(Icons.check_circle_rounded, color: AppColorsDark.accent, size: 18),
                            const SizedBox(width: 12),
                            Expanded(child: Text('Priority social group feeds access', style: AppTypography.labelSm(color: Colors.white))),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),

                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColorsDark.accent,
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                    onPressed: () {
                      // Trigger pro account update mock
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Simulating Appwrite backend Pro role assignment... reload screen to enter.'),
                          backgroundColor: AppColorsDark.accent,
                        ),
                      );
                    },
                    child: const Text('Upgrade to Pro Suite', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  ),
                  const SizedBox(height: 16),

                  // Fallback debug trigger allowing prompt validation of sub features
                  TextButton(
                    style: TextButton.styleFrom(foregroundColor: AppColorsDark.textMuted),
                    onPressed: () {
                      // Instantly yield true or render child directly for local verification
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (_) => child),
                      );
                    },
                    child: const Text('Bypass Gate (Dev Test view)', style: TextStyle(fontSize: 12)),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
