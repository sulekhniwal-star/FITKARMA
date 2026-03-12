import 'package:hive/hive.dart';

part 'water_log.g.dart';

@HiveType(typeId: 2)
class WaterLog extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final DateTime date;

  @HiveField(2)
  final int amountGlasses;

  @HiveField(3)
  final bool isSynced;

  WaterLog({
    required this.id,
    required this.date,
    required this.amountGlasses,
    this.isSynced = false,
  });

  WaterLog copyWith({
    String? id,
    DateTime? date,
    int? amountGlasses,
    bool? isSynced,
  }) {
    return WaterLog(
      id: id ?? this.id,
      date: date ?? this.date,
      amountGlasses: amountGlasses ?? this.amountGlasses,
      isSynced: isSynced ?? this.isSynced,
    );
  }
}
