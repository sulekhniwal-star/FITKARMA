import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../../../shared/theme/app_colors.dart';
import '../../../gamification/domain/models/user_progress.dart';

class KarmaLevelBadge extends ConsumerWidget {
  const KarmaLevelBadge({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ValueListenableBuilder(
      valueListenable: Hive.box<UserProgress>('user_progress').listenable(),
      builder: (context, box, _) {
        final progress = box.get('current') ?? UserProgress.initial();
        
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.accentAmber.withOpacity(0.2),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.monetization_on, color: AppColors.accentAmber, size: 16),
              const SizedBox(width: 4),
              Text(
                '${progress.totalXp} XP',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textBlack,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
