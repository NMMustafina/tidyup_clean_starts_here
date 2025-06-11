import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:tidyup_clean_starts_here_272_a/ifrusdhubh/new_inventory_screen.dart';
import 'package:tidyup_clean_starts_here_272_a/models/inventory_model.dart';

import '../iuhrwieugtnj/color_ashfuoajfdgb.dart';

class Jfg extends StatelessWidget {
  Jfg({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final box = GetIt.I.get<Box<InventoryModel>>();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'House inventory',
          style: TextStyle(
            fontSize: 28.sp,
            color: Colors.deepPurple,
          ),
        ),
      ),
      body: SafeArea(
        child: ValueListenableBuilder<Box<InventoryModel>>(
          valueListenable: box.listenable(),
          builder: (context, box, _) {
            final models = box.values.toList();
            if (models.isEmpty) {
              return Center(
                child: Text(
                  'Add the first invective element',
                  style: TextStyle(color: Colorasdf.purple, fontSize: 20.sp,),
                ),
              );
            }
            return ListView.builder(
              padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.w),
              itemCount: models.length,
              itemBuilder: (context, index) {
                final m = models[index];
                return _InventoryCard(model: m);
              },
            );
          },
        ),
      ),
      floatingActionButton: GestureDetector(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const NewInventoryScreen()),
        ),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30.r),
            gradient: const LinearGradient(
              colors: [
                Color(0xFFFF77FB),
                Color(0xFF8968FF),
              ],
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Add inventory element',
                style: TextStyle(color: Colors.white, fontSize: 18.sp),
              ),
              SizedBox(width: 8.w),
              Icon(Icons.add, color: Colors.white, size: 16.sp),
            ],
          ),
        ),
      ),
    );
  }
}

class _InventoryCard extends StatelessWidget {
  final InventoryModel model;

  const _InventoryCard({Key? key, required this.model}) : super(key: key);

  String get _formattedDate {
    final dt = model.purchaseDate;
    if (dt == null) return '';
    return '${dt.day.toString().padLeft(2, '0')}.'
        '${dt.month.toString().padLeft(2, '0')}.'
        '${dt.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 20.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 24.r,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (model.photoPath != null && model.photoPath!.isNotEmpty)
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
              child: Image.file(
                File(model.photoPath!),
                width: double.infinity,
                height: 180.h,
                fit: BoxFit.cover,
              ),
            )
          else
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
              child: Container(
                width: double.infinity,
                height: 180.h,
                color: Colors.grey[200],
                child: Center(
                  child: SvgPicture.asset(
                    'assets/icons/gallery.svg',
                    width: 48.w,
                    height: 48.h,
                  ),
                ),
              ),
            ),
          Padding(
            padding: EdgeInsets.all(12.r),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  model.name,
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w400,
                    color: Colorasdf.purple,
                  ),
                ),
                SizedBox(height: 4.h),
                if ((model.description ?? '').isNotEmpty)
                  Text(
                    model.description,
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: Colorasdf.purple,
                    ),
                  ),
                SizedBox(height: 8.h),
                Divider(color: const Color(0xFFBF90FF)),
                SizedBox(height: 8.h),
                if ((model.location ?? '').isNotEmpty)
                  Row(
                    children: [
                      SvgPicture.asset('assets/icons/location.svg'),
                      SizedBox(width: 4.w),
                      Expanded(
                        child: Text(
                          model.location!,
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: Colorasdf.purple,
                          ),
                        ),
                      ),
                    ],
                  ),
                if (model.purchaseDate != null) ...[
                  SizedBox(height: 6.h),
                  Row(
                    children: [
                      SvgPicture.asset('assets/icons/calendar.svg'),
                      SizedBox(width: 4.w),
                      Text(
                        _formattedDate,
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: Colorasdf.purple,
                        ),
                      ),
                    ],
                  ),
                ],
                SizedBox(height: 6.h),
                Row(
                  children: [
                    SvgPicture.asset('assets/icons/time.svg'),
                    SizedBox(width: 4.w),
                    Text(
                      '${model.retentionPeriod ?? 0} years',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Colorasdf.purple,
                      ),
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: () => _showContextMenu(context),
                      child: Text(
                        'Editing or deleting ›',
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: const Color(0xFFBF90FF),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showContextMenu(BuildContext context) {
    final renderBox = context.findRenderObject() as RenderBox;
    final offset = renderBox.localToGlobal(Offset.zero);
    final width = renderBox.size.width;
    final height = renderBox.size.height;

    final position = RelativeRect.fromLTRB(
      offset.dx + width - 130.w,
      offset.dy + height - 30.h,
      offset.dx + width,
      offset.dy,
    );

    showMenu<String>(
      context: context,
      position: position,
      color: const Color(0xFFFDF4FF),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.r),
        side: BorderSide(color: Colorasdf.purple, width: 1.5),
      ),
      items: [
        PopupMenuItem(
          value: 'edit',
          child: SizedBox(
            width: 120.w,
            child: Center(
              child: Text(
                'Edit',
                style: TextStyle(fontSize: 18.sp, color: Color(0xFFD80004)),
              ),
            ),
          ),
        ),
        const PopupMenuDivider(height: 1),
        PopupMenuItem(
          value: 'delete',
          child: SizedBox(
            width: 120.w,
            child: Center(
              child: Text(
                'Delete',
                style: TextStyle(
                  fontSize: 18.sp,
                  color: Color(0xFF4F57EA),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
      ],
    ).then((selected) {
      if (selected == 'delete') {
        showCupertinoDialog(
          context: context,
          builder: (ctx) => CupertinoAlertDialog(
            title: Text(
              'Delete the inventory element?',
              style: TextStyle(fontSize: 18.sp),
            ),
            content: Text(
              'Are you sure about deleting the inventory element?',
              style: TextStyle(fontSize: 14.sp),
            ),
            actions: [
              CupertinoDialogAction(
                child: Text('Cancel'),
                onPressed: () => Navigator.of(ctx).pop(),
              ),
              CupertinoDialogAction(
                isDestructiveAction: true,
                child: Text('Delete'),
                onPressed: () {
                  final box = GetIt.I.get<Box<InventoryModel>>();
                  box.delete(model.id);
                  Navigator.of(ctx).pop();
                },
              ),
            ],
          ),
        );
      } else if (selected == 'edit') {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => NewInventoryScreen(
              inventoryModel: model,
            ),
          ),
        );
      }
    });
  }
}
