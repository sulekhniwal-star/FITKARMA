import 'package:flutter/material.dart';

import '../theme/app_text_styles.dart';

class EncryptionBadge extends StatelessWidget {
  const EncryptionBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFE8F5E9), // green 50
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFA5D6A7), width: 1), // green 200
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.lock, size: 12, color: Color(0xFF2E7D32)), // green 800
          const SizedBox(width: 4),
          Text(
            'AES-256 Encrypted',
            style: AppTextStyles.labelSmall.copyWith(
              color: const Color(0xFF2E7D32),
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }
}
