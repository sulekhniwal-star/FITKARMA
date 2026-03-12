import 'package:fitkarma/features/gamification/data/repositories/progress_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/models/water_log.dart';

part 'water_repository.g.dart';

@Riverpod(keepAlive: true)
class WaterRepository extends _$WaterRepository {
  late Box<WaterLog> _waterBox;

  @override
  FutureOr<void> build() async {
    _waterBox = await Hive.openBox<WaterLog>('water_logs');
  }

  Future<WaterLog> getDailyWater(DateTime date) async {
    final key = 'water-${date.year}-${date.month}-${date.day}';
    return _waterBox.get(key) ?? WaterLog(
      id: key,
      date: date,
      amountGlasses: 0,
    );
  }

  Future<void> addWater(int glasses) async {
    final today = DateTime.now();
    final water = await getDailyWater(today);
    final updated = water.copyWith(amountGlasses: water.amountGlasses + glasses);
    await _waterBox.put(water.id, updated);

    // Trigger XP: 5 XP per glass
    await ref.read(progressRepositoryProvider.notifier).addXp(glasses * 5);
  }
}
