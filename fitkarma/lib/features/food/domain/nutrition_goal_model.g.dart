// lib/features/food/domain/nutrition_goal_model.g.dart
// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'nutrition_goal_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class NutritionGoalAdapter extends TypeAdapter<NutritionGoal> {
  @override
  final int typeId = 11;

  @override
  NutritionGoal read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return NutritionGoal(
      id: fields[0] as String,
      userId: fields[1] as String,
      tdee: fields[2] as double,
      targetCalories: fields[3] as double,
      proteinGrams: fields[4] as double,
      carbsGrams: fields[5] as double,
      fatGrams: fields[6] as double,
      fiberGrams: fields[7] as double,
      waterLiters: fields[8] as double,
      ironMg: fields[9] as double,
      vitaminB12Mcg: fields[10] as double,
      vitaminDIU: fields[11] as double,
      calciumMg: fields[12] as double,
      activityLevel: fields[13] as String,
      fitnessGoal: fields[14] as String,
      calculatedAt: fields[15] as DateTime,
      validUntil: fields[16] as DateTime,
      syncStatus: fields[17] as String,
    );
  }

  @override
  void write(BinaryWriter writer, NutritionGoal obj) {
    writer
      ..writeByte(18)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.userId)
      ..writeByte(2)
      ..write(obj.tdee)
      ..writeByte(3)
      ..write(obj.targetCalories)
      ..writeByte(4)
      ..write(obj.proteinGrams)
      ..writeByte(5)
      ..write(obj.carbsGrams)
      ..writeByte(6)
      ..write(obj.fatGrams)
      ..writeByte(7)
      ..write(obj.fiberGrams)
      ..writeByte(8)
      ..write(obj.waterLiters)
      ..writeByte(9)
      ..write(obj.ironMg)
      ..writeByte(10)
      ..write(obj.vitaminB12Mcg)
      ..writeByte(11)
      ..write(obj.vitaminDIU)
      ..writeByte(12)
      ..write(obj.calciumMg)
      ..writeByte(13)
      ..write(obj.activityLevel)
      ..writeByte(14)
      ..write(obj.fitnessGoal)
      ..writeByte(15)
      ..write(obj.calculatedAt)
      ..writeByte(16)
      ..write(obj.validUntil)
      ..writeByte(17)
      ..write(obj.syncStatus);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NutritionGoalAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
