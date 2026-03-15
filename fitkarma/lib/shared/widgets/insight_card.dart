import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

/// Insight card widget
///
/// Amber/yellow card with a lightbulb icon and actionable nudge text
/// Per Section 2.1 Dashboard Screen - Insight Card
/// Thumbs-up / thumbs-down rating buttons at the bottom right
class InsightCard extends StatelessWidget {
  /// Insight message text
  final String message;

  /// Optional icon (defaults to lightbulb)
  final IconData? icon;

  /// Callback when thumbs up is pressed
  final VoidCallback? onThumbsUp;

  /// Callback when thumbs down is pressed
  final VoidCallback? onThumbsDown;

  /// Background color (defaults to amber per Section 2.2)
  final Color? backgroundColor;

  /// Icon color
  final Color? iconColor;

  const InsightCard({
    super.key,
    required this.message,
    this.icon,
    this.onThumbsUp,
    this.onThumbsDown,
    this.backgroundColor,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: backgroundColor ?? AppColors.accent.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.accent.withValues(alpha: 0.5),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                icon ?? Icons.lightbulb_outline,
                color: iconColor ?? AppColors.accentDark,
                size: 24,
              ),
              const SizedBox(width: 12),
              Expanded(child: Text(message, style: AppTextStyles.insight)),
            ],
          ),
          if (onThumbsUp != null || onThumbsDown != null) ...[
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (onThumbsUp != null)
                  _RatingButton(
                    icon: Icons.thumb_up_outlined,
                    isPositive: true,
                    onTap: onThumbsUp,
                  ),
                if (onThumbsDown != null) ...[
                  const SizedBox(width: 8),
                  _RatingButton(
                    icon: Icons.thumb_down_outlined,
                    isPositive: false,
                    onTap: onThumbsDown,
                  ),
                ],
              ],
            ),
          ],
        ],
      ),
    );
  }
}

/// Rating button (thumbs up/down)
class _RatingButton extends StatelessWidget {
  final IconData icon;
  final bool isPositive;
  final VoidCallback? onTap;

  const _RatingButton({
    required this.icon,
    required this.isPositive,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: isPositive ? AppColors.success : AppColors.error,
              width: 1,
            ),
          ),
          child: Icon(
            icon,
            size: 16,
            color: isPositive ? AppColors.success : AppColors.error,
          ),
        ),
      ),
    );
  }
}

/// Personalized insight card with avatar
class InsightCardWithAvatar extends StatelessWidget {
  final String message;
  final String? avatarUrl;
  final String? avatarLabel;
  final VoidCallback? onThumbsUp;
  final VoidCallback? onThumbsDown;

  const InsightCardWithAvatar({
    super.key,
    required this.message,
    this.avatarUrl,
    this.avatarLabel,
    this.onThumbsUp,
    this.onThumbsDown,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.accent.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.accent.withValues(alpha: 0.5),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (avatarUrl != null)
                CircleAvatar(
                  radius: 16,
                  backgroundImage: NetworkImage(avatarUrl!),
                )
              else if (avatarLabel != null)
                CircleAvatar(
                  radius: 16,
                  backgroundColor: AppColors.secondary,
                  child: Text(
                    avatarLabel!,
                    style: const TextStyle(fontSize: 12, color: Colors.white),
                  ),
                ),
              const SizedBox(width: 8),
              Icon(
                Icons.lightbulb_outline,
                color: AppColors.accentDark,
                size: 20,
              ),
              const Spacer(),
              if (onThumbsUp != null)
                _RatingButton(
                  icon: Icons.thumb_up_outlined,
                  isPositive: true,
                  onTap: onThumbsUp,
                ),
              if (onThumbsDown != null) ...[
                const SizedBox(width: 8),
                _RatingButton(
                  icon: Icons.thumb_down_outlined,
                  isPositive: false,
                  onTap: onThumbsDown,
                ),
              ],
            ],
          ),
          const SizedBox(height: 12),
          Text(message, style: AppTextStyles.insight),
        ],
      ),
    );
  }
}
