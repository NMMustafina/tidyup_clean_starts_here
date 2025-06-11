import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../iuhrwieugtnj/color_ashfuoajfdgb.dart';

class SaveButton extends StatelessWidget {
  final bool canSave;
  final VoidCallback onPressed;
  final bool isEditing;

  const SaveButton({
    super.key,
    required this.canSave,
    required this.onPressed,
    required this.isEditing,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: canSave ? onPressed : null,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 14.h),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.r),
          gradient: canSave
              ? Colorasdf.mainGradient
              : LinearGradient(
                  colors: Colorasdf.mainGradient.colors
                      .map((c) => c.withOpacity(0.4))
                      .toList(),
                ),
        ),
        child: Text(
          isEditing ? 'Save' : 'Add',
          style: TextStyle(
            fontSize: 18.sp,
            color: Colorasdf.white,
          ),
        ),
      ),
    );
  }
}
