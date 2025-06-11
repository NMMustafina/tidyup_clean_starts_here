import '../models/cleaning_task.dart';
import '../services/cleaning_record_storage.dart';

enum TaskStatus {
  allDone,
  partiallyDone,
  stillTasks,
}

String taskStatusLabel(TaskStatus status) {
  switch (status) {
    case TaskStatus.allDone:
      return 'All done';
    case TaskStatus.partiallyDone:
      return "It's partially done";
    case TaskStatus.stillTasks:
      return 'There are still tasks';
  }
}

TaskStatus getTaskStatus(CleaningTask task) {
  final taskId = (task.key as int).toString();
  final records = CleaningRecordStorage.getRecordsByTaskId(taskId);
  final total = task.subtasks.length;

  if (total == 0 || records.isEmpty) return TaskStatus.stillTasks;

  bool allDoneEverywhere = true;
  bool hasAnyChecked = false;

  for (final record in records) {
    final completed = record.completedSubtasks;
    final checkedCount = completed.where((b) => b).length;

    if (checkedCount > 0) {
      hasAnyChecked = true;
    }

    if (checkedCount < total) {
      allDoneEverywhere = false;
    }
  }

  if (allDoneEverywhere) return TaskStatus.allDone;
  if (hasAnyChecked) return TaskStatus.partiallyDone;
  return TaskStatus.stillTasks;
}
