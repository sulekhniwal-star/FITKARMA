import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:fitkarma/features/gamification/domain/models/user_progress.dart';

part 'progress_repository.g.dart';

@Riverpod(keepAlive: true)
class ProgressRepository extends _$ProgressRepository {
  late Box<UserProgress> _progressBox;

  @override
  FutureOr<void> build() async {
    _progressBox = await Hive.openBox<UserProgress>('user_progress');
  }

  Future<UserProgress> getProgress() async {
    return _progressBox.get('current') ?? UserProgress.initial();
  }

  Future<void> addXp(int xp) async {
    final current = await getProgress();
    final newTotalXp = current.totalXp + xp;
    
    // Simple leveling logic: level = floor(sqrt(xp/100)) + 1
    // e.g., 0 xp = Lvl 1, 400 xp = Lvl 3, 900 xp = Lvl 4
    final newLevel = (newTotalXp / 250).floor() + 1;
    final newTitle = _getTitleForLevel(newLevel);

    final updated = current.copyWith(
      totalXp: newTotalXp,
      level: newLevel,
      title: newTitle,
    );

    await _progressBox.put('current', updated);
  }

  String _getTitleForLevel(int level) {
    if (level >= 10) return 'Paramatma';
    if (level >= 7) return 'Atman';
    if (level >= 5) return 'Rishi';
    if (level >= 3) return 'Yoddha';
    return 'Sadhaka';
  }
}
