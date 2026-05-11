import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../shared/widgets/scaffold_patterns.dart';
import 'onboarding_providers.dart';

class PermissionsScreen extends ConsumerStatefulWidget {
  const PermissionsScreen({super.key});

  @override
  ConsumerState<PermissionsScreen> createState() => _PermissionsScreenState();
}

class _PermissionsScreenState extends ConsumerState<PermissionsScreen> {
  bool _healthEnabled = false;
  bool _notificationsEnabled = false;
  bool _locationEnabled = false;

  @override
  Widget build(BuildContext context) {
    return AppScaffold.calmZone(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 60),
            Text(
              'Permissions & Privacy',
              style: AppTypography.h1(color: Colors.white).copyWith(fontSize: 28),
            ),
            const SizedBox(height: 12),
            Text(
              'Your data stays with you. We only ask for what we need to provide a personalized experience.',
              style: AppTypography.bodyLg(color: AppColorsDark.textSecondary),
            ),
            
            const SizedBox(height: 40),

            _PermissionTile(
              title: 'Health Data',
              subtitle: 'Sync steps, sleep, and activity from Apple Health / Google Fit.',
              icon: Icons.favorite_rounded,
              value: _healthEnabled,
              onChanged: (v) => setState(() => _healthEnabled = v),
            ),
            const SizedBox(height: 16),
            _PermissionTile(
              title: 'Notifications',
              subtitle: 'Stay on track with reminders and personalized insights.',
              icon: Icons.notifications_rounded,
              value: _notificationsEnabled,
              onChanged: (v) => setState(() => _notificationsEnabled = v),
            ),
            const SizedBox(height: 16),
            _PermissionTile(
              title: 'Location',
              subtitle: 'Used for detecting weather and nearby wellness spots.',
              icon: Icons.location_on_rounded,
              value: _locationEnabled,
              onChanged: (v) => setState(() => _locationEnabled = v),
            ),

            const Spacer(),

            // Privacy Commitment
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColorsDark.surface0,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColorsDark.primary.withOpacity(0.2)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.shield_rounded, color: AppColorsDark.primary, size: 32),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Our Privacy Commitment',
                          style: AppTypography.h3(color: Colors.white),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'We encrypt all health data locally. We never sell your data to third parties.',
                          style: AppTypography.labelMd(color: AppColorsDark.textSecondary),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            _FinishButton(
              onPressed: () async {
                await ref.read(authProvider.notifier).completeOnboarding();
                if (context.mounted) {
                  context.go('/home/dashboard');
                }
              },
            ),
            const SizedBox(height: 48),
          ],
        ),
      ),
    );
  }
}

class _PermissionTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _PermissionTile({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColorsDark.surface0,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColorsDark.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: AppColorsDark.primary),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTypography.h3(color: Colors.white),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: AppTypography.labelMd(color: AppColorsDark.textSecondary),
                ),
              ],
            ),
          ),
          Switch.adaptive(
            value: value,
            onChanged: onChanged,
            activeColor: AppColorsDark.primary,
          ),
        ],
      ),
    );
  }
}

class _FinishButton extends StatelessWidget {
  final VoidCallback onPressed;

  const _FinishButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColorsDark.primary.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColorsDark.primary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 0,
        ),
        child: Text(
          'Get Started',
          style: AppTypography.h3(color: Colors.white).copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
