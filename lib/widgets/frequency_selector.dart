import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../iuhrwieugtnj/color_ashfuoajfdgb.dart';
import '../models/cleaning_task.dart';

class FrequencySelector extends StatelessWidget {
  final ExecutionType? selectedType;
  final TimeOfDay? dailyTime;
  final Set<int> selectedWeekdays;
  final Set<int> selectedMonthDays;
  final void Function(ExecutionType type) onTypeSelected;
  final void Function() onTypeReset;

  const FrequencySelector({
    super.key,
    required this.selectedType,
    required this.dailyTime,
    required this.selectedWeekdays,
    required this.selectedMonthDays,
    required this.onTypeSelected,
    required this.onTypeReset,
  });

  @override
  Widget build(BuildContext context) {
    Widget buildButton(String label, ExecutionType type) {
      final isSelected = selectedType == type;
      final isDisabled = selectedType != null && !isSelected;

      String displayLabel = label;

      if (type == ExecutionType.daily && dailyTime != null) {
        displayLabel =
            'Daily, ${dailyTime!.hour.toString().padLeft(2, '0')}:${dailyTime!.minute.toString().padLeft(2, '0')}';
      } else if (type == ExecutionType.weekly && selectedWeekdays.isNotEmpty) {
        final dayNames = ['Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa', 'Su'];
        final sortedDays = List.generate(7, (i) => i)
            .where((i) => selectedWeekdays.contains(i))
            .map((i) => dayNames[i])
            .join(', ');
        displayLabel = 'Weekly ($sortedDays)';
      } else if (type == ExecutionType.monthly &&
          selectedMonthDays.isNotEmpty) {
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

        final sorted = selectedMonthDays.toList()..sort();
        final labels = sorted.map((d) => '$d${suffixes(d).first}').join(', ');
        displayLabel = 'Every $labels of the month';
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: isDisabled ? null : () => onTypeSelected(type),
            child: Opacity(
              opacity: isDisabled ? 0.4 : 1.0,
              child: Container(
                margin: EdgeInsets.only(bottom: 8.h),
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(32.r),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        displayLabel,
                        style: TextStyle(
                          fontSize: 16.sp,
                          color: Colorasdf.purple,
                        ),
                        overflow: TextOverflow.visible,
                        softWrap: true,
                      ),
                    ),
                    Icon(Icons.arrow_forward,
                        size: 16.sp, color: Colorasdf.purple),
                  ],
                ),
              ),
            ),
          ),
          if (selectedType == type && _shouldShowDeleteButtonFor(type))
            Padding(
              padding: EdgeInsets.only(top: 6.h, bottom: 12.h),
              child: GestureDetector(
                onTap: onTypeReset,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(32.r),
                    gradient: Colorasdf.mainGradient,
                  ),
                  padding: const EdgeInsets.all(1),
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(31.r),
                    ),
                    child: Text(
                      'Delete and change type',
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: Colorasdf.purple,
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Type of execution frequency',
          style: TextStyle(
            fontSize: 16.sp,
            color: Colorasdf.purple,
          ),
        ),
        SizedBox(height: 12.h),
        buildButton('Select daily', ExecutionType.daily),
        buildButton('Select weekly', ExecutionType.weekly),
        buildButton('Select monthly', ExecutionType.monthly),
      ],
    );
  }

  bool _shouldShowDeleteButtonFor(ExecutionType type) {
    switch (type) {
      case ExecutionType.daily:
        return dailyTime != null;
      case ExecutionType.weekly:
        return selectedWeekdays.isNotEmpty;
      case ExecutionType.monthly:
        return selectedMonthDays.isNotEmpty;
    }
  }
}
