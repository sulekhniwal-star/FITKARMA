import 'package:flutter/material.dart';

import '../../../../shared/theme/app_text_styles.dart';

class InactivityNudgeBanner extends StatelessWidget {
  final int minutesInactive;
  final VoidCallback onDismiss;

  const InactivityNudgeBanner({
    super.key,
    required this.minutesInactive,
    required this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFE0F2F1), // Teal background fallback
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF00897B).withValues(alpha: 0.3)), // Dark teal border
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('🚶', style: TextStyle(fontSize: 24)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Time to move!",
                  style: AppTextStyles.labelLarge.copyWith(color: const Color(0xFF004D40)), // Deep teal
                ),
                const SizedBox(height: 2),
                Text(
                  "You've been sitting for $minutesInactive min. Take a quick walk!",
                  style: AppTextStyles.bodySmall.copyWith(color: const Color(0xFF00695C)), // Mid teal
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: onDismiss,
            icon: const Icon(Icons.close, size: 20, color: Color(0xFF00695C)),
            constraints: const BoxConstraints(),
            padding: EdgeInsets.zero,
          ),
        ],
      ),
    );
  }
}
