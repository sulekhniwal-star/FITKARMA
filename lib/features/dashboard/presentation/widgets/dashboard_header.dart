import 'package:flutter/material.dart';
import '../../../../shared/theme/app_colors.dart';
import '../../../../shared/theme/app_text_styles.dart';

class DashboardHeader extends StatelessWidget {
  const DashboardHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Avatar + Level Badge
          Stack(
            clipBehavior: Clip.none,
            children: [
              const CircleAvatar(
                radius: 20,
                backgroundColor: AppColors.divider,
                child: Icon(Icons.person, color: AppColors.textSecondary),
              ),
              Positioned(
                bottom: -4,
                left: -4,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.secondaryDark,
                    border: Border.all(color: AppColors.background, width: 1.5),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    'Lv.12',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.white,
                      fontSize: 8,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ),
          
          // Greeting & Level Title
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Namaste, User \u{1F64F}', style: AppTextStyles.h3),
                  Text('Level 12 Warrior', style: AppTextStyles.bodySmall),
                ],
              ),
            ),
          ),
          
          // Karma XP Badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.accentLight,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.bolt, color: AppColors.accentDark, size: 14),
                const SizedBox(width: 4),
                Text(
                  '1,250 XP',
                  style: AppTextStyles.labelSmall.copyWith(color: AppColors.accentDark),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
