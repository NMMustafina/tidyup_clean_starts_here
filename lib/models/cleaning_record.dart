import 'package:hive/hive.dart';

part 'cleaning_record.g.dart';

@HiveType(typeId: 2)
class CleaningRecord extends HiveObject {
  @HiveField(0)
  late String taskId;

  @HiveField(1)
  late DateTime date;

  @HiveField(2)
  late List<bool> completedSubtasks;

  CleaningRecord({
    required this.taskId,
    required this.date,
    required this.completedSubtasks,
  });
}
