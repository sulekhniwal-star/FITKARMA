import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class InsightCard extends StatelessWidget {
  final String content;
  final VoidCallback? onLike;
  final VoidCallback? onDislike;

  const InsightCard({
    super.key,
    required this.content,
    this.onLike,
    this.onDislike,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.accentAmber.withOpacity(0.9),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 0,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.lightbulb_outline,
                  color: AppColors.textBlack,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    content,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textBlack,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  onPressed: onLike ?? () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Glad you liked it!')),
                    );
                  },
                  icon: const Icon(Icons.thumb_up_outlined, size: 18),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  visualDensity: VisualDensity.compact,
                ),
                const SizedBox(width: 16),
                IconButton(
                  onPressed: onDislike ?? () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('We\'ll improve!')),
                    );
                  },
                  icon: const Icon(Icons.thumb_down_outlined, size: 18),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  visualDensity: VisualDensity.compact,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
