import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:tidyup_clean_starts_here_272_a/widgets/task_action_popup.dart';

import '../iuhrwieugtnj/color_ashfuoajfdgb.dart';
import '../models/cleaning_task.dart';
import '../providers/chores_provider.dart';
import '../screens/add_edit_task_screen.dart';
import '../screens/task_history_screen.dart';
import '../services/cleaning_record_storage.dart';
import '../utils/task_status_utils.dart';

class ChoreCard extends StatefulWidget {
  final CleaningTask task;
  final bool showPopup;
  final bool dimmed;
  final VoidCallback? onActivate;
  final VoidCallback? onDeactivate;

  const ChoreCard({
    super.key,
    required this.task,
    required this.showPopup,
    required this.dimmed,
    this.onActivate,
    this.onDeactivate,
  });

  @override
  State<ChoreCard> createState() => _ChoreCardState();
}

class _ChoreCardState extends State<ChoreCard> {
  List<bool> _loadCompletedSubtasks() {
    final taskId = (widget.task.key as int).toString();
    final record =
        CleaningRecordStorage.getRecordForDate(taskId, DateTime.now());
    final total = widget.task.subtasks.length;
    return record?.completedSubtasks ?? List.filled(total, false);
  }

  void _showDeleteConfirmation(BuildContext context, int key) {
    showCupertinoDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: const Text('Delete the task?'),
          content: const Text('Are you sure about deleting the task?'),
          actions: [
            CupertinoDialogAction(
              child: const Text('Cancel'),
              onPressed: () => Navigator.pop(context),
            ),
            CupertinoDialogAction(
              isDestructiveAction: true,
              child: const Text('Delete'),
              onPressed: () {
                context.read<ChoresProvider>().deleteTaskByKey(key);
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => widget.onDeactivate?.call(),
      child: Container(
        decoration: BoxDecoration(
          color: Colorasdf.white,
          borderRadius: BorderRadius.circular(20.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          children: [
            AnimatedOpacity(
              duration: const Duration(milliseconds: 200),
              opacity: widget.dimmed ? 0.4 : 1.0,
              child: _buildCardContent(context),
            ),
            if (widget.showPopup)
              Positioned(
                right: 16.r,
                bottom: 16.r,
                child: TaskActionPopup(
                  onEdit: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            AddEditTaskScreen(initialTask: widget.task),
                      ),
                    );
                    widget.onDeactivate?.call();
                  },
                  onDelete: () {
                    final key = widget.task.key as int;
                    _showDeleteConfirmation(context, key);
                    widget.onDeactivate?.call();
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildCardContent(BuildContext context) {
    final taskId = (widget.task.key as int).toString();
    List<bool> completed = _loadCompletedSubtasks();

    final status =
        context.watch<ChoresProvider>().taskStatuses[widget.task.key as int] ??
            TaskStatus.stillTasks;
    final statusLabel = taskStatusLabel(status);
    final statusColor = switch (status) {
      TaskStatus.allDone => Colorasdf.green,
      TaskStatus.partiallyDone => Colorasdf.lightBlue,
      TaskStatus.stillTasks => Colorasdf.red,
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => TaskHistoryScreen(task: widget.task),
              ),
            ).then((_) {
              if (context.mounted) {
                context.read<ChoresProvider>().notifyListeners();
              }
            });
          },
          behavior: HitTestBehavior.opaque,
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 16.r, vertical: 14.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    SvgPicture.asset('assets/icons/history.svg',
                        width: 18.r, height: 18.r),
                    SizedBox(width: 6.w),
                    Text('View cleaning history',
                        style: TextStyle(
                          fontSize: 16.sp,
                          color: Colorasdf.purple,
                        )),
                  ],
                ),
                Icon(Icons.chevron_right, color: Colorasdf.purple, size: 18.r),
              ],
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
                widget.task.name,
                style: TextStyle(
                  fontSize: 20.sp,
                  color: Colorasdf.purple,
                ),
              ),
              SizedBox(height: 12.h),
              ...widget.task.subtasks.asMap().entries.map((entry) {
                final i = entry.key;
                final s = entry.value;
                final isChecked = completed[i];

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      completed[i] = !completed[i];
                      CleaningRecordStorage.saveOrUpdateRecord(
                          taskId, completed);
                    });
                  },
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 4.h),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
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
                  color: Colorasdf.lightPurple.withOpacity(0.5), thickness: 1),
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
              SizedBox(height: 12.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(statusLabel,
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: statusColor,
                      )),
                  GestureDetector(
                    onTap: () => widget.onActivate?.call(),
                    child: Row(
                      children: [
                        Text(
                          'Editing or deleting',
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: Colorasdf.lightPurple,
                          ),
                        ),
                        Icon(Icons.chevron_right,
                            size: 16.r, color: Colorasdf.lightPurple),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
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
        if (task.monthDays == null || task.monthDays!.isEmpty) return 'Monthly';
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
