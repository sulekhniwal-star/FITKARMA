import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

/// Bilingual label widget
///
/// Displays stacked English + Hindi Text widgets per Section 2.3 Bilingual UI Requirements
/// Used for navigation labels, screen titles, and section headers
class BilingualLabel extends StatelessWidget {
  /// English text (primary)
  final String englishText;

  /// Hindi/Devanagari text (sub-label)
  final String hindiText;

  /// Style for English text
  final TextStyle? englishStyle;

  /// Style for Hindi text
  final TextStyle? hindiStyle;

  /// Alignment of the text
  final TextAlign textAlign;

  /// Spacing between English and Hindi text
  final double spacing;

  const BilingualLabel({
    super.key,
    required this.englishText,
    required this.hindiText,
    this.englishStyle,
    this.hindiStyle,
    this.textAlign = TextAlign.center,
    this.spacing = 2,
  });

  /// Factory constructor for labels with default label styles
  factory BilingualLabel.label({
    required String englishText,
    required String hindiText,
    TextAlign textAlign = TextAlign.center,
  }) {
    return BilingualLabel(
      englishText: englishText,
      hindiText: hindiText,
      englishStyle: AppTextStyles.labelLarge,
      hindiStyle: AppTextStyles.hindiLabel,
      textAlign: textAlign,
      spacing: 2,
    );
  }

  /// Factory constructor for titles
  factory BilingualLabel.title({
    required String englishText,
    required String hindiText,
    TextAlign textAlign = TextAlign.center,
  }) {
    return BilingualLabel(
      englishText: englishText,
      hindiText: hindiText,
      englishStyle: AppTextStyles.titleLarge,
      hindiStyle: AppTextStyles.hindiLabel.copyWith(fontSize: 12),
      textAlign: textAlign,
      spacing: 4,
    );
  }

  /// Factory constructor for headlines
  factory BilingualLabel.headline({
    required String englishText,
    required String hindiText,
    TextAlign textAlign = TextAlign.center,
  }) {
    return BilingualLabel(
      englishText: englishText,
      hindiText: hindiText,
      englishStyle: AppTextStyles.headlineMedium,
      hindiStyle: AppTextStyles.hindiLabel.copyWith(fontSize: 14),
      textAlign: textAlign,
      spacing: 4,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: textAlign == TextAlign.center
          ? CrossAxisAlignment.center
          : textAlign == TextAlign.right
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.start,
      children: [
        Text(
          englishText,
          style: englishStyle ?? AppTextStyles.labelLarge,
          textAlign: textAlign,
        ),
        SizedBox(height: spacing),
        Text(
          hindiText,
          style: hindiStyle ?? AppTextStyles.hindiLabel,
          textAlign: textAlign,
        ),
      ],
    );
  }
}

/// Horizontal bilingual label (side by side)
class BilingualLabelHorizontal extends StatelessWidget {
  /// English text
  final String englishText;

  /// Hindi/Devanagari text
  final String hindiText;

  /// Style for text
  final TextStyle? style;

  /// Separator between texts
  final String separator;

  const BilingualLabelHorizontal({
    super.key,
    required this.englishText,
    required this.hindiText,
    this.style,
    this.separator = ' · ',
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      '$englishText$separator$hindiText',
      style: style ?? AppTextStyles.bodyMedium,
    );
  }
}

/// Bottom navigation bilingual item
class BilingualNavItem extends StatelessWidget {
  /// Icon for the navigation item
  final IconData icon;

  /// Selected icon
  final IconData? selectedIcon;

  /// English label
  final String labelEnglish;

  /// Hindi label
  final String labelHindi;

  /// Whether the item is selected
  final bool isSelected;

  /// Callback when tapped
  final VoidCallback? onTap;

  const BilingualNavItem({
    super.key,
    required this.icon,
    this.selectedIcon,
    required this.labelEnglish,
    required this.labelHindi,
    this.isSelected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final activeIcon = selectedIcon ?? icon;
    final color = isSelected ? AppColors.primary : AppColors.textSecondary;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(isSelected ? activeIcon : icon, color: color, size: 24),
            const SizedBox(height: 4),
            Text(
              labelEnglish,
              style: AppTextStyles.labelSmall.copyWith(color: color),
            ),
            Text(
              labelHindi,
              style: AppTextStyles.captionSmall.copyWith(color: color),
            ),
          ],
        ),
      ),
    );
  }
}
