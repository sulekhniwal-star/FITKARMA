// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'karma_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class KarmaTransactionAdapter extends TypeAdapter<KarmaTransaction> {
  @override
  final int typeId = 20;

  @override
  KarmaTransaction read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return KarmaTransaction(
      id: fields[0] as String,
      userId: fields[1] as String,
      amount: fields[2] as int,
      action: fields[3] as String,
      description: fields[4] as String,
      timestamp: fields[5] as DateTime,
      syncStatus: fields[6] as String,
      multiplier: fields[7] as double,
    );
  }

  @override
  void write(BinaryWriter writer, KarmaTransaction obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.userId)
      ..writeByte(2)
      ..write(obj.amount)
      ..writeByte(3)
      ..write(obj.action)
      ..writeByte(4)
      ..write(obj.description)
      ..writeByte(5)
      ..write(obj.timestamp)
      ..writeByte(6)
      ..write(obj.syncStatus)
      ..writeByte(7)
      ..write(obj.multiplier);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is KarmaTransactionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class KarmaBalanceAdapter extends TypeAdapter<KarmaBalance> {
  @override
  final int typeId = 21;

  @override
  KarmaBalance read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return KarmaBalance(
      odId: fields[0] as String,
      totalXP: fields[1] as int,
      currentLevel: fields[2] as int,
      currentStreak: fields[3] as int,
      lastActivityDate: fields[4] as DateTime?,
      weeklyXP: fields[5] as int,
      weeklyResetDate: fields[6] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, KarmaBalance obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.odId)
      ..writeByte(1)
      ..write(obj.totalXP)
      ..writeByte(2)
      ..write(obj.currentLevel)
      ..writeByte(3)
      ..write(obj.currentStreak)
      ..writeByte(4)
      ..write(obj.lastActivityDate)
      ..writeByte(5)
      ..write(obj.weeklyXP)
      ..writeByte(6)
      ..write(obj.weeklyResetDate);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is KarmaBalanceAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
