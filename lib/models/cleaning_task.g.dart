// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cleaning_task.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CleaningTaskAdapter extends TypeAdapter<CleaningTask> {
  @override
  final int typeId = 0;

  @override
  CleaningTask read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CleaningTask(
      name: fields[0] as String,
      subtasks: (fields[1] as List).cast<String>(),
      type: fields[2] as ExecutionType,
      weekdays: (fields[3] as List?)?.cast<int>(),
      monthDays: (fields[4] as List?)?.cast<int>(),
      executionTime: fields[5] as DateTime?,
      notificationsEnabled: fields[6] as bool,
      createdAt: fields[7] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, CleaningTask obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.subtasks)
      ..writeByte(2)
      ..write(obj.type)
      ..writeByte(3)
      ..write(obj.weekdays)
      ..writeByte(4)
      ..write(obj.monthDays)
      ..writeByte(5)
      ..write(obj.executionTime)
      ..writeByte(6)
      ..write(obj.notificationsEnabled)
      ..writeByte(7)
      ..write(obj.createdAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CleaningTaskAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ExecutionTypeAdapter extends TypeAdapter<ExecutionType> {
  @override
  final int typeId = 3;

  @override
  ExecutionType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return ExecutionType.daily;
      case 1:
        return ExecutionType.weekly;
      case 2:
        return ExecutionType.monthly;
      default:
        return ExecutionType.daily;
    }
  }

  @override
  void write(BinaryWriter writer, ExecutionType obj) {
    switch (obj) {
      case ExecutionType.daily:
        writer.writeByte(0);
        break;
      case ExecutionType.weekly:
        writer.writeByte(1);
        break;
      case ExecutionType.monthly:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ExecutionTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
