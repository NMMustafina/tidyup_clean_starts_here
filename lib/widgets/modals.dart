import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../iuhrwieugtnj/color_ashfuoajfdgb.dart';

Future<Set<int>?> showWeeklyPickerModal(
    BuildContext context, Set<int> initialDays) async {
  Set<int> selected = {...initialDays};

  return showDialog<Set<int>>(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return Dialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.r)),
        child: Container(
          padding: EdgeInsets.all(20.w),
          decoration: BoxDecoration(
            color: Colorasdf.background,
            borderRadius: BorderRadius.circular(24.r),
          ),
          child: StatefulBuilder(
            builder: (context, setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Center(
                          child: Text(
                            'Select days',
                            style: TextStyle(
                                fontSize: 18.sp, color: Colorasdf.purple),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: SvgPicture.asset('assets/icons/close_circle.svg',
                            width: 24.w, height: 24.w),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.h),
                  Wrap(
                    spacing: 10.w,
                    runSpacing: 10.h,
                    alignment: WrapAlignment.center,
                    children: List.generate(7, (index) {
                      final isSelected = selected.contains(index);
                      final label =
                          ['Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa', 'Su'][index];
                      return GestureDetector(
                        onTap: () {
                          setState(() => isSelected
                              ? selected.remove(index)
                              : selected.add(index));
                        },
                        child: Container(
                          width: 44.w,
                          height: 44.w,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient:
                                isSelected ? Colorasdf.mainGradient : null,
                            color: isSelected ? null : Colors.white,
                          ),
                          child: Text(
                            label,
                            style: TextStyle(
                              fontSize: 14.sp,
                              color:
                                  isSelected ? Colors.white : Colorasdf.purple,
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                  SizedBox(height: 20.h),
                  GestureDetector(
                    onTap: selected.isNotEmpty
                        ? () => Navigator.pop(context, selected)
                        : null,
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(vertical: 14.h),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(32.r),
                        gradient: LinearGradient(
                          colors: selected.isNotEmpty
                              ? Colorasdf.mainGradient.colors
                              : Colorasdf.mainGradient.colors
                                  .map((c) => c.withOpacity(0.4))
                                  .toList(),
                        ),
                      ),
                      child: Text(
                        'Select',
                        style: TextStyle(fontSize: 16.sp, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      );
    },
  );
}

Future<Set<int>?> showMonthlyPickerModal(
    BuildContext context, Set<int> initialDays) async {
  Set<int> selected = {...initialDays};
  final now = DateTime.now();
  final daysInMonth = DateUtils.getDaysInMonth(now.year, now.month);
  if (selected.isEmpty) selected.add(now.day);

  return showDialog<Set<int>>(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return Dialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.r)),
        child: Container(
          padding: EdgeInsets.all(20.w),
          decoration: BoxDecoration(
            color: Colorasdf.background,
            borderRadius: BorderRadius.circular(24.r),
          ),
          child: StatefulBuilder(
            builder: (context, setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Center(
                          child: Text(
                            'Select month days',
                            style: TextStyle(
                                fontSize: 18.sp, color: Colorasdf.purple),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: SvgPicture.asset('assets/icons/close_circle.svg',
                            width: 24.w, height: 24.w),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: ['Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa', 'Su']
                        .map((label) => Expanded(
                              child: Center(
                                child: Text(
                                  label,
                                  style: TextStyle(
                                      fontSize: 14.sp,
                                      color: Colorasdf.lightPurple),
                                ),
                              ),
                            ))
                        .toList(),
                  ),
                  SizedBox(height: 12.h),
                  GridView.count(
                    shrinkWrap: true,
                    crossAxisCount: 7,
                    crossAxisSpacing: 6.w,
                    mainAxisSpacing: 6.h,
                    physics: const NeverScrollableScrollPhysics(),
                    children: List.generate(daysInMonth, (i) {
                      final day = i + 1;
                      final isSelected = selected.contains(day);
                      return GestureDetector(
                        onTap: () {
                          setState(() => isSelected
                              ? selected.remove(day)
                              : selected.add(day));
                        },
                        child: Container(
                          alignment: Alignment.center,
                          decoration: isSelected
                              ? const BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: Colorasdf.mainGradient)
                              : null,
                          child: Text(
                            day.toString(),
                            style: TextStyle(
                              fontSize: 14.sp,
                              color:
                                  isSelected ? Colors.white : Colorasdf.purple,
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                  SizedBox(height: 20.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: () => setState(() => selected.clear()),
                        child: const Text('Reset',
                            style: TextStyle(color: Colorasdf.purple)),
                      ),
                      GestureDetector(
                        onTap: selected.isNotEmpty
                            ? () => Navigator.pop(context, selected)
                            : null,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 24.w, vertical: 10.h),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(32.r),
                            gradient: LinearGradient(
                              colors: selected.isNotEmpty
                                  ? Colorasdf.mainGradient.colors
                                  : Colorasdf.mainGradient.colors
                                      .map((c) => c.withOpacity(0.4))
                                      .toList(),
                            ),
                          ),
                          child: Text(
                            'Done',
                            style:
                                TextStyle(fontSize: 16.sp, color: Colors.white),
                          ),
                        ),
                      )
                    ],
                  )
                ],
              );
            },
          ),
        ),
      );
    },
  );
}
