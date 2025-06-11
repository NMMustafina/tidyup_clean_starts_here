import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:provider/provider.dart';
import 'package:tidyup_clean_starts_here_272_a/iuhrwieugtnj/color_ashfuoajfdgb.dart';
import 'package:tidyup_clean_starts_here_272_a/iuhrwieugtnj/onb_ashfihojfn%20gjk.dart';
import 'package:tidyup_clean_starts_here_272_a/models/inventory_model.dart';
import 'package:tidyup_clean_starts_here_272_a/providers/chores_provider.dart';
import 'package:tidyup_clean_starts_here_272_a/services/notification_service.dart';

import 'models/cleaning_record.dart';
import 'models/cleaning_task.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  await NotificationService.init();

  Hive.registerAdapter(InventoryModelAdapter());
  Hive.registerAdapter(ExecutionTypeAdapter());
  Hive.registerAdapter(CleaningTaskAdapter());
  Hive.registerAdapter(CleaningRecordAdapter());

  final inventBoxdfgr = await Hive.openBox<InventoryModel>('inventBoxdfgr');
  final choresBox = await Hive.openBox<CleaningTask>('chores');
  final historyBox = await Hive.openBox<CleaningRecord>('history');

  GetIt.I.registerSingleton<Box<InventoryModel>>(inventBoxdfgr);
  GetIt.I.registerSingleton<Box<CleaningTask>>(choresBox);
  GetIt.I.registerSingleton<Box<CleaningRecord>>(historyBox);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      builder: (_, __) => ChangeNotifierProvider(
        create: (_) => ChoresProvider(),
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'TidyUp',
          theme: ThemeData(
            appBarTheme: const AppBarTheme(
              backgroundColor: Colorasdf.background,
            ),
            scaffoldBackgroundColor: Colorasdf.background,
            // fontFamily: '-_- ??',
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent,
            splashFactory: NoSplash.splashFactory,
          ),
          home: const OnBoDiasdf(),
        ),
      ),
    );
  }
}
