import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/adapters.dart';

import '../iuhrwieugtnj/color_ashfuoajfdgb.dart';
import '../models/cleaning_task.dart';
import '../widgets/chore_card.dart';
import 'add_edit_task_screen.dart';

class ChoresMainScreen extends StatefulWidget {
  const ChoresMainScreen({super.key});

  @override
  State<ChoresMainScreen> createState() => _ChoresMainScreenState();
}

class _ChoresMainScreenState extends State<ChoresMainScreen> {
  int? activeKey;

  void _activate(int key) => setState(() => activeKey = key);
  void _deactivate() => setState(() => activeKey = null);

  @override
  Widget build(BuildContext context) {
    final box = GetIt.I<Box<CleaningTask>>();

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: _deactivate,
      child: Scaffold(
        backgroundColor: Colorasdf.background,
        appBar: AppBar(
          surfaceTintColor: Colors.transparent,
          backgroundColor: Colorasdf.background,
          elevation: 0,
          centerTitle: true,
          title: Text(
            'My household chores',
            style: TextStyle(
              fontSize: 28.sp,
              color: Colorasdf.purple,
            ),
          ),
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.h),
          child: ValueListenableBuilder(
            valueListenable: box.listenable(),
            builder: (_, Box<CleaningTask> box, __) {
              final tasks = box.values.toList()
                ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
              if (tasks.isEmpty) return const _EmptyState();

              return ListView.separated(
                itemCount: tasks.length,
                separatorBuilder: (_, __) => SizedBox(height: 16.h),
                padding: EdgeInsets.only(bottom: 90.h),
                itemBuilder: (_, index) {
                  final task = tasks[index];
                  final key = task.key as int;
                  return ChoreCard(
                    key: ValueKey(key),
                    task: task,
                    showPopup: activeKey == key,
                    dimmed: activeKey != null && activeKey != key,
                    onActivate: () => _activate(key),
                    onDeactivate: _deactivate,
                  );
                },
              );
            },
          ),
        ),
        floatingActionButton: const _AddTaskButton(),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        "It’s time to start cleaning up",
        style: TextStyle(
          fontSize: 20.sp,
          color: Colorasdf.lightPurple,
        ),
      ),
    );
  }
}

class _AddTaskButton extends StatelessWidget {
  const _AddTaskButton();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: Colorasdf.mainGradient,
        borderRadius: BorderRadius.circular(30.r),
      ),
      child: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddEditTaskScreen()),
          );
        },
        backgroundColor: Colors.transparent,
        elevation: 0,
        label: Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          child: Text(
            'Add a task +',
            style: TextStyle(
              fontSize: 18.sp,
              color: Colorasdf.white,
            ),
          ),
        ),
      ),
    );
  }
}
