import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:permission_handler/permission_handler.dart';

import '../iuhrwieugtnj/color_ashfuoajfdgb.dart';

class NotificationToggle extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  const NotificationToggle({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32.r),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              SvgPicture.asset(
                value ? 'assets/icons/bell_fill.svg' : 'assets/icons/bell.svg',
                width: 24.r,
                height: 24.r,
              ),
              SizedBox(width: 12.w),
              Text(
                'Notifications',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                  color: Colorasdf.purple,
                ),
              ),
            ],
          ),
          SwitchTheme(
            data: SwitchThemeData(
              thumbColor: MaterialStateProperty.all(Colors.white),
              trackColor: MaterialStateProperty.resolveWith((states) {
                if (states.contains(MaterialState.selected)) {
                  return Colorasdf.lightPurple;
                }
                return Colorasdf.lightPurple.withOpacity(0.3);
              }),
              overlayColor: MaterialStateProperty.all(Colors.transparent),
              trackOutlineColor: MaterialStateProperty.all(Colors.transparent),
            ),
            child: Switch(
              value: value,
              onChanged: (v) async {
                if (v) {
                  final status = await Permission.notification.request();
                  if (status.isGranted) {
                    onChanged(true);
                  } else {
                    if (!context.mounted) return;
                    showCupertinoDialog(
                      context: context,
                      builder: (_) => CupertinoAlertDialog(
                        title: const Text(
                            'Access to notifications has been denied'),
                        content: const Text(
                          "Allow access in settings so you don't forget to clean up and replace worn out elements",
                        ),
                        actions: [
                          CupertinoDialogAction(
                            child: const Text('Cancel'),
                            onPressed: () => Navigator.pop(context),
                          ),
                          CupertinoDialogAction(
                            isDefaultAction: true,
                            child: const Text('Settings'),
                            onPressed: () async {
                              Navigator.pop(context);
                              await openAppSettings();
                            },
                          ),
                        ],
                      ),
                    );
                  }
                } else {
                  onChanged(false);
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
