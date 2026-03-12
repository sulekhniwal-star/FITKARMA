import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:fitkarma/shared/theme/app_colors.dart';
import 'package:fitkarma/shared/widgets/bilingual_label.dart';
import 'package:fitkarma/features/challenges/domain/models/challenge.dart';

class ChallengeCarousel extends ConsumerWidget {
  const ChallengeCarousel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ValueListenableBuilder(
      valueListenable: Hive.box<Challenge>('challenges').listenable(),
      builder: (context, box, _) {
        final challenges = box.values.toList();
        
        if (challenges.isEmpty) return const SizedBox();

        return SizedBox(
          height: 180,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: challenges.length,
            itemBuilder: (context, index) {
              final challenge = challenges[index];
              return _ChallengeCard(challenge: challenge);
            },
          ),
        );
      },
    );
  }
}

class _ChallengeCard extends StatelessWidget {
  final Challenge challenge;

  const _ChallengeCard({required this.challenge});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 280,
      margin: const EdgeInsets.only(right: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        image: DecorationImage(
          image: NetworkImage(challenge.imageUrl),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
            Colors.black.withOpacity(0.4),
            BlendMode.darken,
          ),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.primaryOrange,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '+${challenge.xpReward} XP',
                style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
              ),
            ),
            const Spacer(),
            BilingualLabel(
              english: challenge.titleEn,
              hindi: challenge.titleHi,
              englishSize: 18,
              englishColor: Colors.white,
              hindiColor: Colors.white.withOpacity(0.9),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () {
                challenge.copyWith(isJoined: !challenge.isJoined).save();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: challenge.isJoined ? Colors.white24 : Colors.white,
                foregroundColor: challenge.isJoined ? Colors.white : AppColors.textBlack,
                minimumSize: const Size(100, 36),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              ),
              child: Text(challenge.isJoined ? 'Joined' : 'Join Now'),
            ),
          ],
        ),
      ),
    );
  }
}
