import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import 'bento_card.dart';

/// InsightCard — A widget to display AI-powered health insights with feedback.
class InsightCard extends StatelessWidget {
  final String title;
  final String body;
  final VoidCallback? onUpvote;
  final VoidCallback? onDownvote;

  const InsightCard({
    super.key,
    required this.title,
    required this.body,
    this.onUpvote,
    this.onDownvote,
  });

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      glowColor: AppColorsDark.accentGlow,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.auto_awesome,
                size: 16,
                color: AppColorsDark.accent,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title.toUpperCase(),
                  style: AppTypography.labelMd(color: AppColorsDark.accent),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            body,
            style: AppTypography.bodyMd(color: AppColorsDark.textPrimary),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                'Was this helpful?',
                style: AppTypography.labelMd(color: AppColorsDark.textMuted),
              ),
              const SizedBox(width: 8),
              _FeedbackButton(
                icon: Icons.thumb_up_outlined,
                onPressed: onUpvote,
              ),
              const SizedBox(width: 8),
              _FeedbackButton(
                icon: Icons.thumb_down_outlined,
                onPressed: onDownvote,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _FeedbackButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;

  const _FeedbackButton({required this.icon, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      icon: Icon(icon, size: 18),
      visualDensity: VisualDensity.compact,
      color: AppColorsDark.textSecondary,
      style: IconButton.styleFrom(
        backgroundColor: AppColorsDark.surface2.withValues(alpha: 0.5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}
