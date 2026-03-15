// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'step_log_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class StepLogAdapter extends TypeAdapter<StepLog> {
  @override
  final int typeId = 10;

  @override
  StepLog read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return StepLog(
      id: fields[0] as String,
      userId: fields[1] as String,
      stepCount: fields[2] as int,
      date: fields[3] as DateTime,
      goalSteps: fields[4] as int,
      xpEarned: fields[5] as double,
      syncStatus: fields[6] as String,
      source: fields[7] as String,
      lastUpdated: fields[8] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, StepLog obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.userId)
      ..writeByte(2)
      ..write(obj.stepCount)
      ..writeByte(3)
      ..write(obj.date)
      ..writeByte(4)
      ..write(obj.goalSteps)
      ..writeByte(5)
      ..write(obj.xpEarned)
      ..writeByte(6)
      ..write(obj.syncStatus)
      ..writeByte(7)
      ..write(obj.source)
      ..writeByte(8)
      ..write(obj.lastUpdated);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StepLogAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
