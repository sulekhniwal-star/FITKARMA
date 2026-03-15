// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'food_log_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FoodLogAdapter extends TypeAdapter<FoodLog> {
  @override
  final int typeId = 1;

  @override
  FoodLog read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FoodLog(
      id: fields[0] as String,
      userId: fields[1] as String,
      foodName: fields[2] as String,
      mealType: fields[3] as String,
      quantityG: fields[4] as double,
      calories: fields[5] as double,
      proteinG: fields[6] as double,
      carbsG: fields[7] as double,
      fatG: fields[8] as double,
      loggedAt: fields[9] as DateTime,
      syncStatus: fields[10] as String,
      recipeId: fields[11] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, FoodLog obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.userId)
      ..writeByte(2)
      ..write(obj.foodName)
      ..writeByte(3)
      ..write(obj.mealType)
      ..writeByte(4)
      ..write(obj.quantityG)
      ..writeByte(5)
      ..write(obj.calories)
      ..writeByte(6)
      ..write(obj.proteinG)
      ..writeByte(7)
      ..write(obj.carbsG)
      ..writeByte(8)
      ..write(obj.fatG)
      ..writeByte(9)
      ..write(obj.loggedAt)
      ..writeByte(10)
      ..write(obj.syncStatus)
      ..writeByte(11)
      ..write(obj.recipeId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FoodLogAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
