import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../iuhrwieugtnj/color_ashfuoajfdgb.dart';

class SubtasksInput extends StatelessWidget {
  final List<TextEditingController> controllers;
  final void Function() onChanged;

  const SubtasksInput({
    super.key,
    required this.controllers,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            SvgPicture.asset(
              'assets/icons/circle.svg',
              width: 16,
              height: 16,
            ),
            SizedBox(width: 8.w),
            Text(
              'Tasks',
              style: TextStyle(
                fontSize: 16.sp,
                color: Colorasdf.purple,
              ),
            ),
          ],
        ),
        SizedBox(height: 8.h),
        ...controllers.asMap().entries.map((entry) {
          final index = entry.key;
          final controller = entry.value;
          return Focus(
            child: Builder(
              builder: (context) {
                final hasFocus = Focus.of(context).hasFocus;
                return Padding(
                  padding: EdgeInsets.only(bottom: 8.h),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(32.r),
                      gradient: hasFocus ? Colorasdf.mainGradient : null,
                    ),
                    padding: const EdgeInsets.all(1.5),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(32.r),
                      ),
                      child: TextField(
                        controller: controller,
                        onChanged: (value) {
                          if (index == controllers.length - 1 &&
                              value.isNotEmpty) {
                            controllers.add(TextEditingController());
                          } else if (value.isEmpty &&
                              index != controllers.length - 1) {
                            controllers.removeAt(index);
                          }
                          onChanged();
                        },
                        style: TextStyle(
                          fontSize: 16.sp,
                          color: Colorasdf.purple,
                        ),
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 16.w, vertical: 12.h),
                          hintText: 'Enter your task',
                          hintStyle: TextStyle(
                            color: Colorasdf.lightPurple,
                            fontSize: 16.sp,
                          ),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        })
      ],
    );
  }
}
