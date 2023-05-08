// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hive_type.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HivePersonAdapter extends TypeAdapter<HivePerson> {
  @override
  final int typeId = 1;

  @override
  HivePerson read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HivePerson(
      fields[0] as String,
    );
  }

  @override
  void write(BinaryWriter writer, HivePerson obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.test);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HivePersonAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
