// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cleaning_record.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CleaningRecordAdapter extends TypeAdapter<CleaningRecord> {
  @override
  final int typeId = 2;

  @override
  CleaningRecord read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CleaningRecord(
      taskId: fields[0] as String,
      date: fields[1] as DateTime,
      completedSubtasks: (fields[2] as List).cast<bool>(),
    );
  }

  @override
  void write(BinaryWriter writer, CleaningRecord obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.taskId)
      ..writeByte(1)
      ..write(obj.date)
      ..writeByte(2)
      ..write(obj.completedSubtasks);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CleaningRecordAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
