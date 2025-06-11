import 'package:collection/collection.dart';
import 'package:hive/hive.dart';

import '../models/cleaning_record.dart';

class CleaningRecordStorage {
  static final _box = Hive.box<CleaningRecord>('history');

  static DateTime _normalizeDate(DateTime date) =>
      DateTime(date.year, date.month, date.day);

  static Future<void> saveOrUpdateRecord(
      String taskId, List<bool> updatedSubtasks) async {
    final today = _normalizeDate(DateTime.now());

    final existing = _box.values.firstWhereOrNull(
      (r) => r.taskId == taskId && _normalizeDate(r.date) == today,
    );

    if (existing != null) {
      final updated = List<bool>.from(existing.completedSubtasks);
      for (int i = 0; i < updated.length && i < updatedSubtasks.length; i++) {
        if (updatedSubtasks[i]) updated[i] = true;
      }
      existing.completedSubtasks = updated;
      existing.date = DateTime.now();
      await existing.save();
    } else {
      await _box.add(CleaningRecord(
        taskId: taskId,
        date: DateTime.now(),
        completedSubtasks: updatedSubtasks,
      ));
    }
  }

  static List<CleaningRecord> getRecordsByTaskId(String taskId) {
    return _box.values.where((r) => r.taskId == taskId).toList()
      ..sort((a, b) => b.date.compareTo(a.date));
  }

  static CleaningRecord? getRecordForDate(String taskId, DateTime date) {
    final target = _normalizeDate(date);
    return _box.values.firstWhereOrNull(
      (r) => r.taskId == taskId && _normalizeDate(r.date) == target,
    );
  }

  static bool isTaskFullyDone(String taskId, DateTime date, int totalSubtasks) {
    final record = getRecordForDate(taskId, date);
    if (record == null) return false;
    return record.completedSubtasks.where((b) => b).length == totalSubtasks &&
        totalSubtasks > 0;
  }

  static bool isTaskPartiallyDone(
      String taskId, DateTime date, int totalSubtasks) {
    final record = getRecordForDate(taskId, date);
    if (record == null) return false;
    final done = record.completedSubtasks.where((b) => b).length;
    return done > 0 && done < totalSubtasks;
  }

  static bool isTaskEmpty(String taskId, DateTime date) {
    final record = getRecordForDate(taskId, date);
    if (record == null) return true;
    return record.completedSubtasks.every((b) => !b);
  }
}
