import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

class PrimaryButton extends StatelessWidget {
  final String text;
  final String? hindiSubLabel;
  final VoidCallback? onPressed;
  final bool isLoading;
  final IconData? leadingIcon;

  const PrimaryButton({
    super.key,
    required this.text,
    this.hindiSubLabel,
    required this.onPressed,
    this.isLoading = false,
    this.leadingIcon,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: ElevatedButton.styleFrom(
        disabledBackgroundColor: AppColors.primaryLight,
        backgroundColor: AppColors.primary,
        padding: EdgeInsets.zero,
      ),
      child: SizedBox(
        height: 52,
        width: double.infinity,
        child: Center(
          child: isLoading
              ? const SizedBox(
                  height: 24,
                  width: 24,
                  child: CircularProgressIndicator(color: AppColors.white, strokeWidth: 2.5),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (leadingIcon != null) ...[
                      Icon(leadingIcon, color: AppColors.white, size: 20),
                      const SizedBox(width: 8),
                    ],
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(text, style: AppTextStyles.buttonLarge),
                        if (hindiSubLabel != null)
                          Text(
                            hindiSubLabel!,
                            style: AppTextStyles.caption.copyWith(color: AppColors.white70),
                          ),
                      ],
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
