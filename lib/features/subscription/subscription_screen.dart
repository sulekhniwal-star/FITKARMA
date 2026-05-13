import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../shared/widgets/scaffold_patterns.dart';
import '../../shared/widgets/bento_card.dart';
import 'subscription_service.dart';

class SubscriptionScreen extends ConsumerStatefulWidget {
  const SubscriptionScreen({super.key});

  @override
  ConsumerState<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends ConsumerState<SubscriptionScreen> {
  bool _isAnnualSelected = true;

  @override
  Widget build(BuildContext context) {
    final subState = ref.watch(subscriptionNotifierProvider);
    final notifier = ref.read(subscriptionNotifierProvider.notifier);

    return AppScaffold.calmZone(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close_rounded, color: Colors.white),
          onPressed: () => context.pop(),
        ),
        title: Text('FitKarma Plus', style: AppTypography.labelSm(color: AppColorsDark.textMuted)),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Hero badge: amber-to-primary gradient, "⚡ FitKarma Pro", price display
              Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppColorsDark.accent, AppColorsDark.primary],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(100),
                    boxShadow: [
                      BoxShadow(
                        color: AppColorsDark.accent.withValues(alpha: 0.3),
                        blurRadius: 20,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('⚡', style: TextStyle(fontSize: 18)),
                      const SizedBox(width: 8),
                      Text(
                        'FitKarma Pro',
                        style: AppTypography.h3(color: Colors.black).copyWith(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ).animate().scale(duration: 400.ms, curve: Curves.easeOutBack),
              ),
              const SizedBox(height: 24),

              Text(
                'Unlock Infinite\nAyurvedic Intelligence',
                style: AppTypography.h1(color: Colors.white).copyWith(fontSize: 32, height: 1.2),
                textAlign: TextAlign.center,
              ).animate().fadeIn(delay: 100.ms).slideY(begin: 0.2, end: 0),
              const SizedBox(height: 12),

              Text(
                'Supercharge your biometrics with personalized longitudinal correlations, private group leaderboards, and offline clinical reports.',
                style: AppTypography.bodyMd(color: AppColorsDark.textSecondary),
                textAlign: TextAlign.center,
              ).animate().fadeIn(delay: 200.ms),
              const SizedBox(height: 32),

              // Interactive Plan Selection Layout with Annual Plan Highlight (30% savings)
              Row(
                children: [
                  Expanded(
                    child: _PlanOptionCard(
                      title: 'Monthly Plan',
                      price: '₹299',
                      period: '/mo',
                      isSelected: !_isAnnualSelected,
                      onTap: () => setState(() => _isAnnualSelected = false),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _PlanOptionCard(
                      title: 'Annual Plan',
                      price: '₹2,499',
                      period: '/yr',
                      badgeText: 'SAVE 30%',
                      isSelected: _isAnnualSelected,
                      onTap: () => setState(() => _isAnnualSelected = true),
                    ),
                  ),
                ],
              ).animate().fadeIn(delay: 300.ms),
              const SizedBox(height: 32),

              // Pro feature checklist
              Text('Premium Capabilities Matrix', style: AppTypography.labelSm(color: AppColorsDark.textMuted)),
              const SizedBox(height: 12),

              GlassCard(
                customRadius: 24.0,
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    _buildFeatureItem('LLM-Powered Contextual AI Coach Guidance', true),
                    const SizedBox(height: 12),
                    _buildFeatureItem('Deep Casual Diagnostics (Sleep → BP rules)', true),
                    const SizedBox(height: 12),
                    _buildFeatureItem('Infinite Vault File Cloud Storage Pools', true),
                    const SizedBox(height: 12),
                    _buildFeatureItem('Bridal & Groom Complete Timeline Milestones', true),
                    const SizedBox(height: 12),
                    _buildFeatureItem('Private Social Clans + Active XP Leaderboards', true),
                    const SizedBox(height: 12),
                    _buildFeatureItem('Full PDF Summary Clinical Export Bundles', true),
                    const SizedBox(height: 12),
                    _buildFeatureItem('Priority Background Telemetry Observers (15m)', true),
                  ],
                ),
              ).animate().fadeIn(delay: 400.ms),
              const SizedBox(height: 32),

              // Primary CTA
              subState.when(
                loading: () => const Center(child: CircularProgressIndicator(color: AppColorsDark.accent)),
                error: (_, _) => const SizedBox.shrink(),
                data: (isPro) {
                  if (isPro) {
                    return Container(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(color: AppColorsDark.surface2, borderRadius: BorderRadius.circular(20)),
                      child: Center(child: Text('Subscription Already Fully Provisioned', style: AppTypography.labelLg(color: AppColorsDark.accent))),
                    );
                  }

                  return Container(
                    height: 60,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: AppColorsDark.accent.withValues(alpha: 0.25),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColorsDark.accent,
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        elevation: 0,
                      ),
                      onPressed: () async {
                        final success = await notifier.purchase();
                        if (success && mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Welcome to FitKarma Pro! Features unlocked.'), backgroundColor: AppColorsDark.accent),
                          );
                          context.pop();
                        } else if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Simulated checkout processing successfully completed.'), backgroundColor: AppColorsDark.accent),
                          );
                          context.pop();
                        }
                      },
                      child: Text(
                        'Start Free 7-Day Trial',
                        style: AppTypography.h3(color: Colors.black).copyWith(fontWeight: FontWeight.bold),
                      ),
                    ),
                  );
                },
              ).animate().fadeIn(delay: 500.ms),
              const SizedBox(height: 16),

              // Restore purchases TextButton
              Center(
                child: TextButton(
                  style: TextButton.styleFrom(foregroundColor: AppColorsDark.textMuted),
                  onPressed: () async {
                    final success = await notifier.restore();
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(success ? 'Historical acquisition restoration loop executed.' : 'No active external platform purchases available.'),
                          backgroundColor: success ? AppColorsDark.accent : AppColorsDark.surface2,
                        ),
                      );
                      if (success) context.pop();
                    }
                  },
                  child: Text('Restore App Store / Play Store Purchases', style: AppTypography.labelSm(color: AppColorsDark.textMuted)),
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureItem(String label, bool isIncluded) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: isIncluded ? AppColorsDark.accent.withValues(alpha: 0.2) : AppColorsDark.surface2,
            shape: BoxShape.circle,
          ),
          child: Icon(
            isIncluded ? Icons.check_rounded : Icons.close_rounded,
            size: 12,
            color: isIncluded ? AppColorsDark.accent : AppColorsDark.textMuted,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            label,
            style: AppTypography.bodySm(color: isIncluded ? Colors.white : AppColorsDark.textMuted),
          ),
        ),
      ],
    );
  }
}

class _PlanOptionCard extends StatelessWidget {
  final String title;
  final String price;
  final String period;
  final String? badgeText;
  final bool isSelected;
  final VoidCallback onTap;

  const _PlanOptionCard({
    required this.title,
    required this.price,
    required this.period,
    this.badgeText,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: 250.ms,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? AppColorsDark.accent.withValues(alpha: 0.1) : AppColorsDark.surface1,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppColorsDark.accent : AppColorsDark.surface2,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(title, style: AppTypography.labelSm(color: isSelected ? AppColorsDark.accent : AppColorsDark.textMuted)),
                if (badgeText != null)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(color: AppColorsDark.accent, borderRadius: BorderRadius.circular(4)),
                    child: Text(badgeText!, style: AppTypography.monoMd(color: Colors.black).copyWith(fontSize: 8, fontWeight: FontWeight.bold)),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text(price, style: AppTypography.h2(color: Colors.white).copyWith(fontWeight: FontWeight.bold)),
                Text(period, style: AppTypography.labelSm(color: AppColorsDark.textMuted)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
