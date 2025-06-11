import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';

import '../iuhrwieugtnj/color_ashfuoajfdgb.dart';
import 'package:tidyup_clean_starts_here_272_a/models/inventory_model.dart';

class NewInventoryScreen extends StatefulWidget {
  const NewInventoryScreen({Key? key, this.inventoryModel}) : super(key: key);

  final InventoryModel? inventoryModel;

  @override
  _NewInventoryScreenState createState() => _NewInventoryScreenState();
}

class _NewInventoryScreenState extends State<NewInventoryScreen> {
  final _nameController = TextEditingController();
  final _descController = TextEditingController();
  final _locationController = TextEditingController();
  DateTime? _purchaseDate;
  final _retentionController = TextEditingController();
  File? _pickedImage;
  final _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    if (widget.inventoryModel != null) {
      final m = widget.inventoryModel!;
      _nameController.text = m.name;
      _descController.text = m.description ?? '';
      _locationController.text = m.location ?? '';
      _purchaseDate = m.purchaseDate;
      _retentionController.text = m.retentionPeriod?.toString() ?? '';
      if (m.photoPath != null && m.photoPath!.isNotEmpty) {
        _pickedImage = File(m.photoPath!);
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    _locationController.dispose();
    _retentionController.dispose();
    super.dispose();
  }

  bool get _isFormValid {
    return _nameController.text.isNotEmpty && _pickedImage != null;
  }

  Future<void> _pickImage() async {
    final XFile? img = await _picker.pickImage(source: ImageSource.gallery);
    if (img != null) {
      setState(() => _pickedImage = File(img.path));
    }
  }

  Future<void> _pickDate() async {
    DateTime temp = _purchaseDate ?? DateTime.now();
    final picked = await showCupertinoModalPopup<DateTime>(
      context: context,
      builder: (ctx) => Container(
        height: 260.h,
        decoration: BoxDecoration(
          color: const Color(0xFFFDF4FF),
          borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
        ),
        child: Column(
          children: [
            SizedBox(
              height: 44.h,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Row(
                  children: [
                    CupertinoButton(
                      padding: EdgeInsets.zero,
                      onPressed: () => Navigator.pop(ctx, null),
                      child: const Text('Cancel'),
                    ),
                    const Spacer(),
                    CupertinoButton(
                      padding: EdgeInsets.zero,
                      onPressed: () => Navigator.pop(ctx, temp),
                      child: const Text('Done'),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: CupertinoTheme(
                data: CupertinoTheme.of(ctx).copyWith(
                  brightness: Brightness.dark,
                  textTheme: CupertinoTextThemeData(
                    dateTimePickerTextStyle:
                        TextStyle(color: Colorasdf.purple, fontSize: 20.sp),
                  ),
                ),
                child: CupertinoDatePicker(
                  backgroundColor: const Color(0xFFFDF4FF),
                  mode: CupertinoDatePickerMode.date,
                  initialDateTime: temp,
                  minimumDate: DateTime(2000),
                  maximumDate: DateTime.now(),
                  onDateTimeChanged: (d) => temp = d,
                ),
              ),
            ),
          ],
        ),
      ),
    );
    if (picked != null) setState(() => _purchaseDate = picked);
  }

  Future<void> _onSave() async {
    final box = GetIt.I.get<Box<InventoryModel>>();
    final id = widget.inventoryModel?.id ?? DateTime.now().toIso8601String();

    final model = InventoryModel(
      id: id,
      name: _nameController.text.trim(),
      description: _descController.text.trim(),
      location: _locationController.text.trim(),
      purchaseDate: _purchaseDate,
      retentionPeriod: int.tryParse(_retentionController.text.trim()) ?? 0,
      photoPath: _pickedImage?.path,
    );

    await box.put(id, model);
    Navigator.pop(context, model);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Text(
          'New inventory element',
          style: TextStyle(
            fontSize: 28.sp,
            color: Colors.deepPurple,
          ),
        ),
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: SvgPicture.asset('assets/icons/back.svg'),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20.h),
                Text('Photo of inventory element',
                    style: TextStyle(fontSize: 18.sp, color: Colorasdf.purple)),
                SizedBox(height: 8.h),
                GestureDetector(
                  onTap: _pickImage,
                  child: Container(
                    width: double.infinity,
                    height: 158.h,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16.r),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.15),
                          blurRadius: 24,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: _pickedImage == null
                        ? Center(
                            child: SvgPicture.asset('assets/icons/gallery.svg'))
                        : Stack(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(16.r),
                                child: Image.file(_pickedImage!,
                                    fit: BoxFit.cover, width: double.infinity),
                              ),
                              Positioned(
                                bottom: 8.h,
                                right: 8.w,
                                child: GestureDetector(
                                  onTap: _pickImage,
                                  child: SvgPicture.asset(
                                      'assets/icons/replace.svg'),
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
                SizedBox(height: 16.h),
                Text('Name of element *',
                    style: TextStyle(fontSize: 18.sp, color: Colorasdf.purple)),
                SizedBox(height: 8.h),
                _buildField(_nameController, 'Name'),
                SizedBox(height: 16.h),
                Text('Element description (optional)',
                    style: TextStyle(fontSize: 18.sp, color: Colorasdf.purple)),
                SizedBox(height: 8.h),
                _buildField(_descController, 'Description'),
                SizedBox(height: 16.h),
                Text('Storage location (optional)',
                    style: TextStyle(fontSize: 18.sp, color: Colorasdf.purple)),
                SizedBox(height: 8.h),
                _buildField(_locationController, 'Location'),
                SizedBox(height: 16.h),
                Text('Date of purchase (optional)',
                    style: TextStyle(fontSize: 18.sp, color: Colorasdf.purple)),
                SizedBox(height: 8.h),
                GestureDetector(
                  onTap: _pickDate,
                  child: Container(
                    height: 48.h,
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.72),
                      borderRadius: BorderRadius.circular(20.r),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.15),
                          blurRadius: 24,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _purchaseDate == null
                              ? 'Select date'
                              : DateFormat('dd.MM.yyyy').format(_purchaseDate!),
                          style: TextStyle(
                              color: Colorasdf.purple, fontSize: 16.sp),
                        ),
                        Icon(CupertinoIcons.arrow_right,
                            color: Colorasdf.purple),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 16.h),
                Text('Retention period (optional, years)',
                    style: TextStyle(fontSize: 18.sp, color: Colorasdf.purple)),
                SizedBox(height: 8.h),
                _buildField(_retentionController, '0',
                    keyboardType: TextInputType.number),
                SizedBox(height: 32.h),
                GestureDetector(
                  onTap: _isFormValid ? _onSave : null,
                  child: Stack(
                    children: [
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(vertical: 14.h),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [
                              Color(0xFFFF77FB),
                              Color(0xFF8968FF),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(30.r),
                        ),
                        child: Center(
                          child: Text(
                            'Add',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w700),
                          ),
                        ),
                      ),
                      _isFormValid
                          ? Container()
                          : Positioned.fill(
                              child: Container(
                                color: Colors.white.withOpacity(0.5),
                              ),
                            ),
                    ],
                  ),
                ),
                SizedBox(height: 40.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildField(TextEditingController controller, String hint,
      {TextInputType keyboardType = TextInputType.text}) {
    return Container(
      height: 48.h,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.72),
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 24,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Center(
        child: TextField(
          controller: controller,
          keyboardType: keyboardType,
          style: TextStyle(
            fontSize: 18.sp,
            color: Colorasdf.purple,
          ),
          decoration: InputDecoration(
            hintStyle: TextStyle(
              fontSize: 18.sp,
              color: Colorasdf.purple,
            ),
            border: InputBorder.none,
            hintText: hint,
          ),
        ),
      ),
    );
  }
}
