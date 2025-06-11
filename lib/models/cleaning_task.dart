import 'package:hive/hive.dart';

part 'cleaning_task.g.dart';

@HiveType(typeId: 0)
class CleaningTask extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  List<String> subtasks;

  @HiveField(2)
  ExecutionType type;

  @HiveField(3)
  List<int>? weekdays;

  @HiveField(4)
  List<int>? monthDays;

  @HiveField(5)
  DateTime? executionTime;

  @HiveField(6)
  bool notificationsEnabled;

  @HiveField(7)
  DateTime createdAt;

  CleaningTask({
    required this.name,
    required this.subtasks,
    required this.type,
    this.weekdays,
    this.monthDays,
    this.executionTime,
    required this.notificationsEnabled,
    required this.createdAt,
  });
}

@HiveType(typeId: 3)
enum ExecutionType {
  @HiveField(0)
  daily,
  @HiveField(1)
  weekly,
  @HiveField(2)
  monthly,
}
