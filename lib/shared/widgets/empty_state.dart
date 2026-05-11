import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import 'bilingual_label.dart';

/// EmptyState — A reusable component for empty data views.
class EmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String hindiTitle;
  final String? message;
  final String? hindiMessage;

  const EmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.hindiTitle,
    this.message,
    this.hindiMessage,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 64,
            color: AppColorsDark.surface2,
          ),
          const SizedBox(height: 24),
          BilingualLabel(
            english: title,
            hindi: hindiTitle,
            crossAxisAlignment: CrossAxisAlignment.center,
            englishStyle: AppTypography.h2(),
          ),
          if (message != null && hindiMessage != null) ...[
            const SizedBox(height: 12),
            Text(
              message!,
              textAlign: TextAlign.center,
              style: AppTypography.bodyMd(color: AppColorsDark.textSecondary),
            ),
            Text(
              hindiMessage!,
              textAlign: TextAlign.center,
              style: AppTypography.hindi(color: AppColorsDark.textMuted),
            ),
          ],
        ],
      ),
    );
  }
}
