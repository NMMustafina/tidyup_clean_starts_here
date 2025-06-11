import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../iuhrwieugtnj/color_ashfuoajfdgb.dart';

class TaskNameInput extends StatelessWidget {
  final TextEditingController controller;

  const TaskNameInput({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Task name',
          style: TextStyle(
            fontSize: 16.sp,
            color: Colorasdf.purple,
          ),
        ),
        SizedBox(height: 8.h),
        Focus(
          child: Builder(
            builder: (context) {
              final hasFocus = Focus.of(context).hasFocus;
              return Container(
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
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: Colorasdf.purple,
                    ),
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(
                          horizontal: 16.w, vertical: 12.h),
                      hintText: 'Name',
                      hintStyle: TextStyle(
                        color: Colorasdf.lightPurple,
                        fontSize: 16.sp,
                      ),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
