// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subState.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SubStateAdapter extends TypeAdapter<SubState> {
  @override
  SubState read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SubState()..count = fields[0] as int;
  }

  @override
  void write(BinaryWriter writer, SubState obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.count);
  }
}
