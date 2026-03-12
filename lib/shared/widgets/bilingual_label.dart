import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class BilingualLabel extends StatelessWidget {
  final String english;
  final String hindi;
  final double englishSize;
  final double hindiSize;
  final Color? englishColor;
  final Color? hindiColor;
  final CrossAxisAlignment crossAxisAlignment;

  const BilingualLabel({
    super.key,
    required this.english,
    required this.hindi,
    this.englishSize = 16,
    this.hindiSize = 12,
    this.englishColor,
    this.hindiColor = AppColors.textGrey,
    this.crossAxisAlignment = CrossAxisAlignment.start,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: crossAxisAlignment,
      children: [
        Text(
          english,
          style: TextStyle(
            fontSize: englishSize,
            fontWeight: FontWeight.bold,
            color: englishColor ?? AppColors.textBlack,
          ),
        ),
        Text(
          hindi,
          style: TextStyle(
            fontSize: hindiSize,
            color: hindiColor,
          ),
        ),
      ],
    );
  }
}
