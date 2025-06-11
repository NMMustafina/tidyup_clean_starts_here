import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';

import '../iuhrwieugtnj/color_ashfuoajfdgb.dart';
import '../models/cleaning_task.dart';
import '../services/notification_service.dart';
import '../widgets/frequency_selector.dart';
import '../widgets/modals.dart';
import '../widgets/notification_toggle.dart';
import '../widgets/save_button.dart';
import '../widgets/subtasks_input.dart';
import '../widgets/task_name_input.dart';
import '../widgets/time_picker_section.dart';

class AddEditTaskScreen extends StatefulWidget {
  final CleaningTask? initialTask;

  const AddEditTaskScreen({super.key, this.initialTask});

  @override
  State<AddEditTaskScreen> createState() => _AddEditTaskScreenState();
}

class _AddEditTaskScreenState extends State<AddEditTaskScreen> {
  final _nameController = TextEditingController();
  final List<TextEditingController> _subtaskControllers = [
    TextEditingController()
  ];
  ExecutionType? _selectedType;
  Set<int> _selectedWeekdays = {};
  Set<int> _selectedMonthDays = {};
  TimeOfDay? _dailyTime;
  TimeOfDay? _weeklyTime;
  TimeOfDay? _monthlyTime;
  bool _notificationsEnabled = false;
  bool _hasChanged = false;

  @override
  void initState() {
    super.initState();
    final task = widget.initialTask;
    if (task != null) {
      _nameController.text = task.name;
      _subtaskControllers.clear();
      _subtaskControllers.addAll(
        task.subtasks.map(
            (t) => TextEditingController(text: t)..addListener(_checkChanged)),
      );
      _selectedType = task.type;
      _selectedWeekdays = (task.weekdays ?? []).map((i) => i - 1).toSet();
      _selectedMonthDays = (task.monthDays ?? []).toSet();
      final time = task.executionTime;
      if (time != null) {
        final t = TimeOfDay(hour: time.hour, minute: time.minute);
        switch (task.type) {
          case ExecutionType.daily:
            _dailyTime = t;
            break;
          case ExecutionType.weekly:
            _weeklyTime = t;
            break;
          case ExecutionType.monthly:
            _monthlyTime = t;
            break;
        }
      }
      _notificationsEnabled = task.notificationsEnabled;
    }
    _nameController.addListener(_checkChanged);
  }

  bool _canSave() {
    if (_nameController.text.trim().isEmpty) return false;
    if (!_subtaskControllers.any((c) => c.text.trim().isNotEmpty)) return false;
    if (_selectedType == null) return false;
    switch (_selectedType!) {
      case ExecutionType.daily:
        return _dailyTime != null;
      case ExecutionType.weekly:
        return _selectedWeekdays.isNotEmpty && _weeklyTime != null;
      case ExecutionType.monthly:
        return _selectedMonthDays.isNotEmpty && _monthlyTime != null;
    }
  }

  void _checkChanged() {
    final task = widget.initialTask;
    if (task == null) return;

    final newName = _nameController.text.trim();
    final newSubtasks = _subtaskControllers
        .map((c) => c.text.trim())
        .where((t) => t.isNotEmpty)
        .toList();

    final currentTime = switch (_selectedType) {
      ExecutionType.daily => _dailyTime,
      ExecutionType.weekly => _weeklyTime,
      ExecutionType.monthly => _monthlyTime,
      _ => null,
    };

    final oldTime = task.executionTime == null
        ? null
        : TimeOfDay(
            hour: task.executionTime!.hour, minute: task.executionTime!.minute);

    bool isTimeEqual(TimeOfDay? a, TimeOfDay? b) {
      if (a == null || b == null) return a == b;
      return a.hour == b.hour && a.minute == b.minute;
    }

    final currentWeekdays = _selectedWeekdays.map((i) => i + 1).toList()
      ..sort();
    final currentMonthDays = _selectedMonthDays.toList()..sort();
    final oldWeekdays = (task.weekdays ?? []).toList()..sort();
    final oldMonthDays = (task.monthDays ?? []).toList()..sort();

    final changed = newName != task.name ||
        newSubtasks.join(',') != task.subtasks.join(',') ||
        _selectedType != task.type ||
        _notificationsEnabled != task.notificationsEnabled ||
        !isTimeEqual(currentTime, oldTime) ||
        oldWeekdays.toString() != currentWeekdays.toString() ||
        oldMonthDays.toString() != currentMonthDays.toString();

    if (_hasChanged != changed) {
      setState(() => _hasChanged = changed);
    }
  }

  Future<bool> _onWillPop() async {
    final hasContent = _nameController.text.trim().isNotEmpty ||
        _subtaskControllers.any((c) => c.text.trim().isNotEmpty);
    final isEditing = widget.initialTask != null;
    final needsWarning = isEditing ? _hasChanged : hasContent;

    if (!needsWarning) return true;

    final result = await showCupertinoDialog<bool>(
      context: context,
      builder: (_) => CupertinoAlertDialog(
        title: const Text('Coming out?'),
        content: const Text('Your data will be lost on exit'),
        actions: [
          CupertinoDialogAction(
            child: const Text('Stay'),
            onPressed: () => Navigator.of(context).pop(false),
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            child: const Text('Leave'),
            onPressed: () => Navigator.of(context).pop(true),
          ),
        ],
      ),
    );

    return result ?? false;
  }

  @override
  void dispose() {
    _nameController.dispose();
    for (final controller in _subtaskControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _saveTask() async {
    final name = _nameController.text.trim();
    final subtasks = _subtaskControllers
        .map((c) => c.text.trim())
        .where((text) => text.isNotEmpty)
        .toList();
    final type = _selectedType!;
    List<int>? weekdays;
    List<int>? monthDays;
    TimeOfDay? time;
    switch (type) {
      case ExecutionType.daily:
        time = _dailyTime;
        break;
      case ExecutionType.weekly:
        weekdays = _selectedWeekdays.map((i) => i + 1).toList()..sort();
        time = _weeklyTime;
        break;
      case ExecutionType.monthly:
        monthDays = _selectedMonthDays.toList()..sort();
        time = _monthlyTime;
        break;
    }
    final now = DateTime.now();
    final executionTime =
        DateTime(now.year, now.month, now.day, time!.hour, time.minute);
    final task = CleaningTask(
      name: name,
      subtasks: subtasks,
      type: type,
      weekdays: weekdays,
      monthDays: monthDays,
      executionTime: executionTime,
      notificationsEnabled: _notificationsEnabled,
      createdAt: DateTime.now(),
    );
    final box = GetIt.I<Box<CleaningTask>>();
    if (widget.initialTask != null && widget.initialTask!.key != null) {
      await box.put(widget.initialTask!.key, task);
    } else {
      await box.add(task);
    }
    if (_notificationsEnabled) {
      switch (type) {
        case ExecutionType.daily:
          await NotificationService.scheduleDailyReminder(
              taskName: name, time: time);
          break;
        case ExecutionType.weekly:
          for (final weekday in weekdays!) {
            await NotificationService.scheduleWeeklyReminder(
                taskName: name, weekday: weekday, time: time);
          }
          break;
        case ExecutionType.monthly:
          for (final day in monthDays!) {
            await NotificationService.scheduleMonthlyReminder(
                taskName: name, day: day, time: time);
          }
          break;
      }
    }
    if (!context.mounted) return;
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: Colorasdf.background,
        appBar: AppBar(
          surfaceTintColor: Colors.transparent,
          backgroundColor: Colorasdf.background,
          elevation: 0,
          leading: IconButton(
            iconSize: 28.r,
            onPressed: () async {
              final canExit = await _onWillPop();
              if (canExit && context.mounted) Navigator.pop(context);
            },
            icon: SvgPicture.asset(
              'assets/icons/arrow_left_circle.svg',
              width: 28.r,
              height: 28.r,
            ),
          ),
          title: Text(
            widget.initialTask == null ? 'New task' : 'Edit task',
            style: TextStyle(
              fontSize: 20.sp,
              color: Colorasdf.purple,
            ),
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TaskNameInput(controller: _nameController),
                SizedBox(height: 24.h),
                SubtasksInput(
                  controllers: _subtaskControllers,
                  onChanged: () => setState(() {}),
                ),
                SizedBox(height: 24.h),
                FrequencySelector(
                  selectedType: _selectedType,
                  dailyTime: _dailyTime,
                  selectedWeekdays: _selectedWeekdays,
                  selectedMonthDays: _selectedMonthDays,
                  onTypeSelected: (type) async {
                    if (type == ExecutionType.daily) {
                      final pickedTime = await _showCupertinoTimePicker(
                        _dailyTime ?? TimeOfDay.now(),
                      );
                      if (pickedTime != null) {
                        setState(() {
                          _selectedType = ExecutionType.daily;
                          _dailyTime = pickedTime;
                          _checkChanged();
                        });
                      }
                    } else if (type == ExecutionType.weekly) {
                      final picked = await showWeeklyPickerModal(
                          context, _selectedWeekdays);
                      if (picked != null) {
                        setState(() {
                          _selectedType = ExecutionType.weekly;
                          _selectedWeekdays = picked;
                          _checkChanged();
                        });
                      }
                    } else if (type == ExecutionType.monthly) {
                      final picked = await showMonthlyPickerModal(
                          context, _selectedMonthDays);
                      if (picked != null) {
                        setState(() {
                          _selectedType = ExecutionType.monthly;
                          _selectedMonthDays = picked;
                          _checkChanged();
                        });
                      }
                    }
                  },
                  onTypeReset: () => setState(() {
                    switch (_selectedType) {
                      case ExecutionType.daily:
                        _dailyTime = null;
                        break;
                      case ExecutionType.weekly:
                        _weeklyTime = null;
                        _selectedWeekdays.clear();
                        break;
                      case ExecutionType.monthly:
                        _monthlyTime = null;
                        _selectedMonthDays.clear();
                        break;
                      default:
                        break;
                    }
                    _selectedType = null;
                  }),
                ),
                SizedBox(height: 12.h),
                TimePickerSection(
                  selectedType: _selectedType,
                  selectedWeekdays: _selectedWeekdays,
                  selectedMonthDays: _selectedMonthDays,
                  weeklyTime: _weeklyTime,
                  monthlyTime: _monthlyTime,
                  onTimePicked: (time) => setState(() {
                    if (_selectedType == ExecutionType.weekly) {
                      _weeklyTime = time;
                    } else if (_selectedType == ExecutionType.monthly) {
                      _monthlyTime = time;
                    }
                    _checkChanged();
                  }),
                ),
                SizedBox(height: 12.h),
                NotificationToggle(
                  value: _notificationsEnabled,
                  onChanged: (v) => setState(() {
                    _notificationsEnabled = v;
                    _checkChanged();
                  }),
                ),
                SizedBox(height: 24.h),
                SaveButton(
                  canSave:
                      _canSave() && (widget.initialTask == null || _hasChanged),
                  onPressed: _saveTask,
                  isEditing: widget.initialTask != null,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<TimeOfDay?> _showCupertinoTimePicker(TimeOfDay initial) {
    TimeOfDay tempTime = initial;

    return showDialog<TimeOfDay>(
      context: context,
      builder: (context) {
        final initialDateTime =
            DateTime(2023, 1, 1, initial.hour, initial.minute);

        return Center(
          child: Container(
            width: 300.w,
            height: 280.h,
            padding: EdgeInsets.only(top: 12.h),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24.r),
            ),
            child: Column(
              children: [
                Expanded(
                  child: CupertinoDatePicker(
                    mode: CupertinoDatePickerMode.time,
                    initialDateTime: initialDateTime,
                    use24hFormat: false,
                    onDateTimeChanged: (newDateTime) {
                      tempTime = TimeOfDay.fromDateTime(newDateTime);
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Reset',
                            style: TextStyle(color: Colorasdf.lightPurple)),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(context, tempTime),
                        child: const Text('Done',
                            style: TextStyle(color: Colorasdf.lightPurple)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
