import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';

/// EncryptionBadge — A subtle indicator of AES-256 encryption.
///
/// Promotes trust by highlighting data security.
class EncryptionBadge extends StatelessWidget {
  final bool showLabel;

  const EncryptionBadge({super.key, this.showLabel = true});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColorsDark.teal.withOpacity(0.1),
        borderRadius: BorderRadius.circular(100),
        border: Border.all(color: AppColorsDark.teal.withOpacity(0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.lock_outline,
            size: 14,
            color: AppColorsDark.teal,
          ),
          if (showLabel) ...[
            const SizedBox(width: 6),
            Text(
              'AES-256',
              style: AppTypography.labelMd(color: AppColorsDark.teal).copyWith(
                fontWeight: FontWeight.w700,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
