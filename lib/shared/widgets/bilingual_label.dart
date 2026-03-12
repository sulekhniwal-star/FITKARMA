import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

class BilingualLabel extends StatelessWidget {
  final String englishText;
  final String hindiText;
  final TextStyle? englishStyle;
  final TextStyle? hindiStyle;
  final bool isSectionHeader;
  final bool isNavLabel;
  final bool isSelected;

  const BilingualLabel({
    super.key,
    required this.englishText,
    required this.hindiText,
    this.englishStyle,
    this.hindiStyle,
  })  : isSectionHeader = false,
        isNavLabel = false,
        isSelected = true;

  const BilingualLabel.sectionHeader({
    super.key,
    required this.englishText,
    required this.hindiText,
  })  : isSectionHeader = true,
        isNavLabel = false,
        isSelected = true,
        englishStyle = AppTextStyles.sectionHeader,
        hindiStyle = AppTextStyles.sectionHeaderHindi;

  const BilingualLabel.navLabel({
    super.key,
    required this.englishText,
    required this.hindiText,
    this.isSelected = true,
  })  : isSectionHeader = false,
        isNavLabel = true,
        englishStyle = null,
        hindiStyle = null;

  @override
  Widget build(BuildContext context) {
    TextStyle enStyle = englishStyle ?? AppTextStyles.bodyLarge;
    TextStyle hiStyle = hindiStyle ?? AppTextStyles.bodySmall;

    if (isNavLabel) {
      enStyle = AppTextStyles.navLabelEn.copyWith(
        color: isSelected ? AppColors.primary : AppColors.textMuted,
      );
      hiStyle = AppTextStyles.navLabelHi.copyWith(
        color: isSelected ? AppColors.primary : AppColors.textMuted,
      );
    }

    Widget content = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: isNavLabel ? CrossAxisAlignment.center : CrossAxisAlignment.start,
      children: [
        Text(englishText, style: enStyle),
        const SizedBox(height: 2),
        Text(hindiText, style: hiStyle),
      ],
    );

    if (isSectionHeader) {
      return Container(
        decoration: const BoxDecoration(
          border: Border(left: BorderSide(color: AppColors.primary, width: 3)),
        ),
        padding: const EdgeInsets.only(left: 8),
        child: content,
      );
    }

    return content;
  }
}
