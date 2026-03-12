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
    final dateKey = _getDateKey(date);
    return _waterBox.get(dateKey) ?? WaterLog(
      id: dateKey,
      date: date,
      amountGlasses: 0,
    );
  }

  Future<void> addGlass() async {
    final now = DateTime.now();
    final log = await getDailyWater(now);
    final updatedLog = log.copyWith(amountGlasses: log.amountGlasses + 1);
    await _waterBox.put(updatedLog.id, updatedLog);
  }

  String _getDateKey(DateTime date) {
    return "water-${date.year}-${date.month}-${date.day}";
  }
}
