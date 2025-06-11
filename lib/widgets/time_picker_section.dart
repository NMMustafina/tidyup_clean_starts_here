import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../iuhrwieugtnj/color_ashfuoajfdgb.dart';
import '../models/cleaning_task.dart';

class TimePickerSection extends StatelessWidget {
  final ExecutionType? selectedType;
  final Set<int> selectedWeekdays;
  final Set<int> selectedMonthDays;
  final TimeOfDay? weeklyTime;
  final TimeOfDay? monthlyTime;
  final void Function(TimeOfDay time) onTimePicked;

  const TimePickerSection({
    super.key,
    required this.selectedType,
    required this.selectedWeekdays,
    required this.selectedMonthDays,
    required this.weeklyTime,
    required this.monthlyTime,
    required this.onTimePicked,
  });

  @override
  Widget build(BuildContext context) {
    final isEnabled = selectedType == ExecutionType.weekly ||
        selectedType == ExecutionType.monthly;

    final isActiveTitle = (selectedType == ExecutionType.weekly &&
            selectedWeekdays.isNotEmpty) ||
        (selectedType == ExecutionType.monthly && selectedMonthDays.isNotEmpty);

    TimeOfDay? selectedTime = selectedType == ExecutionType.weekly
        ? weeklyTime
        : selectedType == ExecutionType.monthly
            ? monthlyTime
            : null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Opacity(
          opacity: isActiveTitle ? 1.0 : 0.4,
          child: Text(
            'Execution time',
            style: TextStyle(
              fontSize: 16.sp,
              color: Colorasdf.purple,
            ),
          ),
        ),
        SizedBox(height: 8.h),
        Opacity(
          opacity: isEnabled ? 1.0 : 0.4,
          child: GestureDetector(
            onTap: isEnabled
                ? () async {
                    final now = TimeOfDay.now();
                    final initial = selectedTime ?? now;
                    final picked = await _showCupertinoTimePicker(
                      context,
                      initial,
                    );
                    if (picked != null) {
                      onTimePicked(picked);
                    }
                  }
                : null,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(32.r),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    selectedTime != null
                        ? '${selectedTime.hour.toString().padLeft(2, '0')}:${selectedTime.minute.toString().padLeft(2, '0')}'
                        : 'Select time',
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: Colorasdf.purple,
                    ),
                  ),
                  Icon(Icons.arrow_forward,
                      color: Colorasdf.purple, size: 16.sp),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<TimeOfDay?> _showCupertinoTimePicker(
      BuildContext context, TimeOfDay initial) {
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
