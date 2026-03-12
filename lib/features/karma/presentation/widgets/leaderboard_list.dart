import 'package:flutter/material.dart';
import '../../../../shared/theme/app_colors.dart';
import '../../../../shared/theme/app_text_styles.dart';

class LeaderboardList extends StatelessWidget {
  const LeaderboardList({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> mockData = [
      {'rank': 1, 'name': 'Rahul Sharma', 'xp': '4,520', 'isMe': false},
      {'rank': 2, 'name': 'Priya Patel', 'xp': '3,890', 'isMe': false},
      {'rank': 3, 'name': 'You', 'xp': '3,450', 'isMe': true},
      {'rank': 4, 'name': 'Amit Kumar', 'xp': '2,900', 'isMe': false},
      {'rank': 5, 'name': 'Neha Singh', 'xp': '2,100', 'isMe': false},
    ];

    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: mockData.length,
      separatorBuilder: (context, index) => const Divider(),
      itemBuilder: (context, index) {
        final item = mockData[index];
        final bool isMe = item['isMe'];
        final int rank = item['rank'];
        
        Color rankColor;
        if (rank == 1) {
          rankColor = const Color(0xFFFFD700); // Gold
        } else if (rank == 2) {
          rankColor = const Color(0xFFC0C0C0); // Silver
        } else if (rank == 3) {
          rankColor = const Color(0xFFCD7F32); // Bronze
        } else {
          rankColor = AppColors.textSecondary;
        }

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          decoration: BoxDecoration(
            color: isMe ? AppColors.primarySurface : AppColors.white,
            borderRadius: BorderRadius.circular(12),
            border: isMe ? Border.all(color: AppColors.primaryLight) : null,
          ),
          child: Row(
            children: [
              SizedBox(
                width: 24,
                child: Center(
                  child: Text(
                    '#$rank',
                    style: AppTextStyles.labelLarge.copyWith(color: rankColor, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              CircleAvatar(
                radius: 18,
                backgroundColor: AppColors.secondarySurface,
                child: Text(
                  item['name'][0],
                  style: AppTextStyles.labelLarge.copyWith(color: AppColors.secondaryDark),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  item['name'],
                  style: AppTextStyles.bodyMedium.copyWith(fontWeight: isMe ? FontWeight.bold : FontWeight.normal),
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.bolt, color: AppColors.accentDark, size: 16),
                  const SizedBox(width: 4),
                  Text(
                    item['xp'],
                    style: AppTextStyles.labelMedium.copyWith(color: AppColors.accentDark),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
