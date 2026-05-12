import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';

/// DLQAlertBanner — Notifies the user of sync persistent failures (Dead Letter Queue).
class DLQAlertBanner extends StatelessWidget {
  final VoidCallback onRetry;

  const DLQAlertBanner({super.key, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(
        color: AppColorsDark.error,
      ),
      child: Row(
        children: [
          const Icon(Icons.sync_problem_rounded, color: Colors.white, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Some data failed to sync after multiple attempts.',
              style: AppTypography.labelMd(color: Colors.white),
            ),
          ),
          TextButton(
            onPressed: onRetry,
            style: TextButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Colors.white.withValues(alpha: 0.2),
              padding: const EdgeInsets.symmetric(horizontal: 12),
              minimumSize: const Size(0, 32),
            ),
            child: const Text('Retry Now'),
          ),
        ],
      ),
    );
  }
}
