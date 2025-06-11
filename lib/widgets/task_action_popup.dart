import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../iuhrwieugtnj/color_ashfuoajfdgb.dart';

class TaskActionPopup extends StatelessWidget {
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const TaskActionPopup({
    super.key,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        width: 120.w,
        decoration: BoxDecoration(
          gradient: Colorasdf.mainGradient,
          borderRadius: BorderRadius.circular(16.r),
        ),
        padding: const EdgeInsets.all(1),
        child: Container(
          decoration: BoxDecoration(
            color: Colorasdf.background,
            borderRadius: BorderRadius.circular(16.r),
          ),
          padding: EdgeInsets.symmetric(vertical: 10.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTap: onEdit,
                behavior: HitTestBehavior.opaque,
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 10.h),
                  alignment: Alignment.center,
                  child: Text(
                    'Edit',
                    style: TextStyle(
                      fontSize: 18.sp,
                      color: Colorasdf.red,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.w),
                child:
                    const Divider(color: Colorasdf.lightPurple, thickness: 1),
              ),
              GestureDetector(
                onTap: onDelete,
                behavior: HitTestBehavior.opaque,
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 10.h),
                  alignment: Alignment.center,
                  child: Text(
                    'Delete',
                    style: TextStyle(
                      fontSize: 18.sp,
                      color: Colorasdf.lightBlue,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
