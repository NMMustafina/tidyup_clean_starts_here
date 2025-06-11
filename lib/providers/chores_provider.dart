import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../models/cleaning_record.dart';
import '../models/cleaning_task.dart';
import '../services/notification_service.dart';
import '../utils/task_status_utils.dart';

class ChoresProvider with ChangeNotifier {
  final _taskBox = Hive.box<CleaningTask>('chores');
  final _historyBox = Hive.box<CleaningRecord>('history');

  List<CleaningTask> get tasks {
    final list = _taskBox.values.toList();
    list.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return list;
  }

  Map<int, TaskStatus> get taskStatuses {
    final map = <int, TaskStatus>{};
    for (int i = 0; i < _taskBox.length; i++) {
      final task = _taskBox.getAt(i);
      if (task != null) {
        map[task.key as int] = getTaskStatus(task);
      }
    }
    return map;
  }

  void addTask(CleaningTask task) async {
    final index = await _taskBox.add(task);
    await _handleNotifications(task);
    notifyListeners();
  }

  void updateTask(int index, CleaningTask task) async {
    final oldTask = _taskBox.getAt(index);
    await _cancelNotifications(oldTask);
    await _taskBox.putAt(index, task);
    await _handleNotifications(task);
    notifyListeners();
  }

  void updateTaskByKey(int key, CleaningTask task) async {
    final oldTask = _taskBox.get(key);
    await _cancelNotifications(oldTask);
    await _taskBox.put(key, task);
    await _handleNotifications(task);
    notifyListeners();
  }

  void deleteTaskByKey(int key) async {
    final task = _taskBox.get(key);
    await _cancelNotifications(task);
    await _taskBox.delete(key);
    notifyListeners();
  }

  void addRecord(CleaningRecord record) async {
    await _historyBox.add(record);
    notifyListeners();
  }

  List<CleaningRecord> recordsForTask(String taskId) {
    return _historyBox.values.where((r) => r.taskId == taskId).toList()
      ..sort((a, b) => b.date.compareTo(a.date));
  }

  Future<void> _handleNotifications(CleaningTask? task) async {
    if (task == null ||
        !task.notificationsEnabled ||
        task.executionTime == null) return;

    final time = TimeOfDay(
        hour: task.executionTime!.hour, minute: task.executionTime!.minute);

    switch (task.type) {
      case ExecutionType.daily:
        await NotificationService.scheduleDailyReminder(
          taskName: task.name,
          time: time,
        );
        break;
      case ExecutionType.weekly:
        for (final weekday in task.weekdays ?? []) {
          await NotificationService.scheduleWeeklyReminder(
            taskName: task.name,
            weekday: weekday,
            time: time,
          );
        }
        break;
      case ExecutionType.monthly:
        for (final day in task.monthDays ?? []) {
          await NotificationService.scheduleMonthlyReminder(
            taskName: task.name,
            day: day,
            time: time,
          );
        }
        break;
    }
  }

  Future<void> _cancelNotifications(CleaningTask? task) async {
    if (task == null || !task.notificationsEnabled) return;

    switch (task.type) {
      case ExecutionType.daily:
        await NotificationService.cancelDailyReminder(task.name);
        break;
      case ExecutionType.weekly:
        for (final weekday in task.weekdays ?? []) {
          await NotificationService.cancelWeeklyReminder(task.name, weekday);
        }
        break;
      case ExecutionType.monthly:
        for (final day in task.monthDays ?? []) {
          await NotificationService.cancelMonthlyReminder(task.name, day);
        }
        break;
    }
  }
}
