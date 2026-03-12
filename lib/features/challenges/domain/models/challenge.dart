import 'package:hive/hive.dart';

part 'challenge.g.dart';

@HiveType(typeId: 7)
class Challenge extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String titleEn;

  @HiveField(2)
  final String titleHi;

  @HiveField(3)
  final int xpReward;

  @HiveField(4)
  final bool isJoined;

  @HiveField(5)
  final String imageUrl;

  Challenge({
    required this.id,
    required this.titleEn,
    required this.titleHi,
    required this.xpReward,
    required this.isJoined,
    required this.imageUrl,
  });

  Challenge copyWith({bool? isJoined}) {
    return Challenge(
      id: id,
      titleEn: titleEn,
      titleHi: titleHi,
      xpReward: xpReward,
      isJoined: isJoined ?? this.isJoined,
      imageUrl: imageUrl,
    );
  }
}
