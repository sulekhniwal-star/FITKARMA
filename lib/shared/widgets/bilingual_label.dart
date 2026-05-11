import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';

/// BilingualLabel — A standardized English + Hindi label.
///
/// Used for category headers, empty states, and critical information.
class BilingualLabel extends StatelessWidget {
  final String english;
  final String hindi;
  final TextStyle? englishStyle;
  final Color? color;
  final CrossAxisAlignment crossAxisAlignment;

  const BilingualLabel({
    super.key,
    required this.english,
    required this.hindi,
    this.englishStyle,
    this.color,
    this.crossAxisAlignment = CrossAxisAlignment.start,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: crossAxisAlignment,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          english,
          style: englishStyle ?? AppTypography.h3(color: color ?? AppColorsDark.textPrimary),
        ),
        const SizedBox(height: 2),
        Text(
          hindi,
          style: AppTypography.hindi(color: color ?? AppColorsDark.textSecondary),
        ),
      ],
    );
  }
}
