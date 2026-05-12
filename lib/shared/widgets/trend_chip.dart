import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';

/// TrendChip — Displays a percentage or value change with an arrow.
class TrendChip extends StatelessWidget {
  final double value;
  final String? suffix;
  final bool reverse; // If true, negative is success (e.g. weight loss)

  const TrendChip({
    super.key,
    required this.value,
    this.suffix = '%',
    this.reverse = false,
  });

  @override
  Widget build(BuildContext context) {
    final isPositive = value >= 0;
    final isSuccess = reverse ? !isPositive : isPositive;
    final color = isSuccess ? AppColorsDark.success : AppColorsDark.error;
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(100),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isPositive ? Icons.north_east : Icons.south_east,
            size: 12,
            color: color,
          ),
          const SizedBox(width: 4),
          Text(
            '${value.abs().toStringAsFixed(1)}${suffix ?? ''}',
            style: AppTypography.labelMd(color: color).copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
