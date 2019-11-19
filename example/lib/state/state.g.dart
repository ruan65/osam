// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'state.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AppStateAdapter extends TypeAdapter<AppState> {
  @override
  AppState read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AppState()
      ..count = fields[0] as int
      ..list = (fields[1] as List)?.cast<dynamic>()
      ..subState = fields[2] as dynamic;
  }

  @override
  void write(BinaryWriter writer, AppState obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.count)
      ..writeByte(1)
      ..write(obj.list)
      ..writeByte(2)
      ..write(obj.subState);
  }
}
