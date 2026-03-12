// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dosha_profile.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DoshaProfileAdapter extends TypeAdapter<DoshaProfile> {
  @override
  final int typeId = 5;

  @override
  DoshaProfile read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DoshaProfile(
      vata: fields[0] as double,
      pitta: fields[1] as double,
      kapha: fields[2] as double,
      lastUpdated: fields[3] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, DoshaProfile obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.vata)
      ..writeByte(1)
      ..write(obj.pitta)
      ..writeByte(2)
      ..write(obj.kapha)
      ..writeByte(3)
      ..write(obj.lastUpdated);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DoshaProfileAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
