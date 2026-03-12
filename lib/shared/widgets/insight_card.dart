import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

class InsightCard extends StatelessWidget {
  final String text;
  final VoidCallback? onDismiss;
  final VoidCallback? onThumbsUp;
  final VoidCallback? onThumbsDown;

  const InsightCard({
    super.key,
    required this.text,
    this.onDismiss,
    this.onThumbsUp,
    this.onThumbsDown,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.accentLight,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.accent.withValues(alpha: 0.5), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: AppColors.accent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.lightbulb_outline, color: AppColors.white, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  text,
                  style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600),
                ),
              ),
              if (onDismiss != null)
                GestureDetector(
                  onTap: onDismiss,
                  child: const Padding(
                    padding: EdgeInsets.only(left: 8),
                    child: Icon(Icons.close, size: 20, color: AppColors.textSecondary),
                  ),
                ),
            ],
          ),
          if (onThumbsUp != null || onThumbsDown != null) ...[
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (onThumbsDown != null)
                  InkWell(
                    onTap: onThumbsDown,
                    borderRadius: BorderRadius.circular(4),
                    child: const Padding(
                      padding: EdgeInsets.all(6),
                      child: Icon(Icons.thumb_down_alt_outlined, size: 18, color: AppColors.textSecondary),
                    ),
                  ),
                const SizedBox(width: 8),
                if (onThumbsUp != null)
                  InkWell(
                    onTap: onThumbsUp,
                    borderRadius: BorderRadius.circular(4),
                    child: const Padding(
                      padding: EdgeInsets.all(6),
                      child: Icon(Icons.thumb_up_alt_outlined, size: 18, color: AppColors.textSecondary),
                    ),
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
