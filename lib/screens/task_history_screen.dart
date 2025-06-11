import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

import '../iuhrwieugtnj/color_ashfuoajfdgb.dart';
import '../models/cleaning_task.dart';
import '../services/cleaning_record_storage.dart';

class TaskHistoryScreen extends StatefulWidget {
  final CleaningTask task;

  const TaskHistoryScreen({super.key, required this.task});

  @override
  State<TaskHistoryScreen> createState() => _TaskHistoryScreenState();
}

class _TaskHistoryScreenState extends State<TaskHistoryScreen> {
  void _toggleSubtask(int i, record) {
    setState(() {
      record.completedSubtasks[i] = !record.completedSubtasks[i];
      record.save();
    });
  }

  @override
  Widget build(BuildContext context) {
    final task = widget.task;
    final taskId = (task.key as int).toString();
    final records = CleaningRecordStorage.getRecordsByTaskId(taskId);

    return Scaffold(
      backgroundColor: Colorasdf.background,
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        backgroundColor: Colorasdf.background,
        elevation: 0,
        leading: IconButton(
          iconSize: 28.r,
          icon: SvgPicture.asset(
            'assets/icons/arrow_left_circle.svg',
            width: 28.r,
            height: 28.r,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          task.name,
          style: TextStyle(
            fontSize: 20.sp,
            color: Colorasdf.purple,
          ),
        ),
      ),
      body: records.isEmpty
          ? Center(
              child: Padding(
                padding: EdgeInsets.all(32.r),
                child: Text(
                  'No cleaning records yet',
                  style: TextStyle(
                    fontSize: 20.sp,
                    color: Colorasdf.lightPurple,
                  ),
                ),
              ),
            )
          : ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              itemCount: records.length,
              itemBuilder: (_, index) {
                final record = records[index];
                final date = record.date;
                final completed = record.completedSubtasks;

                return Container(
                  margin: EdgeInsets.only(bottom: 12.h),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20.r),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 16.w, vertical: 14.h),
                        child: Text(
                          DateFormat('dd.MM.yyyy, EEEE').format(date.toLocal()),
                          style: TextStyle(
                            fontSize: 16.sp,
                            color: Colorasdf.purple,
                          ),
                        ),
                      ),
                      Container(
                        height: 1,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: Colorasdf.mainGradient.colors
                                .map((c) => c.withOpacity(0.9))
                                .toList(),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(16.r),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              task.name,
                              style: TextStyle(
                                fontSize: 20.sp,
                                color: Colorasdf.purple,
                              ),
                            ),
                            SizedBox(height: 12.h),
                            ...task.subtasks.asMap().entries.map((entry) {
                              final i = entry.key;
                              final s = entry.value;
                              final isChecked = completed[i];

                              return GestureDetector(
                                onTap: () => _toggleSubtask(i, record),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(vertical: 4.h),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(top: 3.h),
                                        child: SvgPicture.asset(
                                          isChecked
                                              ? 'assets/icons/check.svg'
                                              : 'assets/icons/circle.svg',
                                          width: 20.r,
                                          height: 20.r,
                                        ),
                                      ),
                                      SizedBox(width: 6.w),
                                      Expanded(
                                        child: Text(
                                          s,
                                          style: TextStyle(
                                            fontSize: 18.sp,
                                            color: Colorasdf.purple,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }),
                            Divider(
                              color: Colorasdf.lightPurple.withOpacity(0.5),
                              thickness: 1,
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(top: 2.h),
                                  child: SvgPicture.asset(
                                    'assets/icons/calendar.svg',
                                    width: 16.r,
                                    height: 16.r,
                                  ),
                                ),
                                SizedBox(width: 6.w),
                                Expanded(
                                  child: Text(
                                    _formatRepeatText(widget.task),
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      color: Colorasdf.purple,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 6.h),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(top: 2.h),
                                  child: SvgPicture.asset(
                                    'assets/icons/clock.svg',
                                    width: 16.r,
                                    height: 16.r,
                                  ),
                                ),
                                SizedBox(width: 6.w),
                                Expanded(
                                  child: Text(
                                    _formatTime(widget.task),
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      color: Colorasdf.purple,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }

  String _formatRepeatText(CleaningTask task) {
    switch (task.type) {
      case ExecutionType.daily:
        return 'Daily';
      case ExecutionType.weekly:
        final days = task.weekdays?.map(_weekdayLabel).join(', ') ?? '';
        return 'Weekly ($days)';
      case ExecutionType.monthly:
        if (task.monthDays == null || task.monthDays!.isEmpty) {
          return 'Monthly';
        }

        List<String> suffixes(int day) {
          if (day >= 11 && day <= 13) return ['th'];
          switch (day % 10) {
            case 1:
              return ['st'];
            case 2:
              return ['nd'];
            case 3:
              return ['rd'];
            default:
              return ['th'];
          }
        }

        final sorted = task.monthDays!..sort();
        final labels = sorted.map((d) => '$d${suffixes(d).first}').join(', ');
        return 'Every $labels of the month';
    }
  }

  String _formatTime(CleaningTask task) {
    if (task.executionTime == null) return '';
    final time = task.executionTime!;
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  String _weekdayLabel(int weekday) {
    const map = {
      1: 'Mo',
      2: 'Tu',
      3: 'We',
      4: 'Th',
      5: 'Fr',
      6: 'Sa',
      7: 'Su',
    };
    return map[weekday] ?? '';
  }
}
