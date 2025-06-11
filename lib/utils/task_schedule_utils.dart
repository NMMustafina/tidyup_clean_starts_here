import 'package:flutter/material.dart';

import '../models/cleaning_task.dart';

List<DateTime> buildPlannedDates(CleaningTask task, int count) {
  final List<DateTime> result = [];
  DateTime current = DateTime(
    task.executionTime!.year,
    task.executionTime!.month,
    task.executionTime!.day,
  );

  switch (task.type) {
    case ExecutionType.daily:
      for (int i = 0; i < count; i++) {
        result.add(current);
        current = current.add(const Duration(days: 1));
      }
      break;

    case ExecutionType.weekly:
      if (task.weekdays == null || task.weekdays!.isEmpty) return result;
      final sortedWeekdays = [...task.weekdays!]..sort();
      while (result.length < count) {
        for (final weekday in sortedWeekdays) {
          final diff = (weekday - current.weekday + 7) % 7;
          final nextDate = current.add(Duration(days: diff));
          if (!result.contains(nextDate)) {
            result.add(nextDate);
          }
          if (result.length == count) break;
        }
        current = current.add(const Duration(days: 7));
      }
      result.sort();
      break;

    case ExecutionType.monthly:
      if (task.monthDays == null || task.monthDays!.isEmpty) return result;
      final sortedDays = [...task.monthDays!]..sort();
      int monthOffset = 0;
      while (result.length < count) {
        final month = DateTime(current.year, current.month + monthOffset);
        final daysInMonth = DateUtils.getDaysInMonth(month.year, month.month);
        for (final day in sortedDays) {
          final d = day <= daysInMonth ? day : daysInMonth;
          final date = DateTime(month.year, month.month, d);
          if (date.isAfter(current.subtract(const Duration(days: 1)))) {
            result.add(date);
          }
          if (result.length == count) break;
        }
        monthOffset++;
      }
      result.sort();
      break;
  }

  return result;
}
