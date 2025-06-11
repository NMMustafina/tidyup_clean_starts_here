import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings();

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    tz.initializeTimeZones();
    await _plugin.initialize(initSettings);

    const androidChannel = AndroidNotificationChannel(
      'task_channel',
      'Task Reminders',
      description: 'Reminder notifications for your cleaning tasks',
      importance: Importance.max,
    );

    await _plugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(androidChannel);
  }

  static Future<void> scheduleDailyReminder({
    required String taskName,
    required TimeOfDay time,
  }) async {
    final now = DateTime.now();
    DateTime scheduled =
        DateTime(now.year, now.month, now.day, time.hour, time.minute)
            .subtract(const Duration(hours: 1));
    if (scheduled.isBefore(now)) {
      scheduled = scheduled.add(const Duration(days: 1));
    }
    final tzTime = tz.TZDateTime.from(scheduled, tz.local);

    await _plugin.zonedSchedule(
      _dailyId(taskName),
      'Hey there, hurry up!',
      "In an hour, it's time to start '$taskName'",
      tzTime,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'task_channel',
          'Task Reminders',
          channelDescription: 'Reminder notifications for your cleaning tasks',
          importance: Importance.max,
          priority: Priority.high,
        ),
      ),
      androidAllowWhileIdle: true,
      matchDateTimeComponents: DateTimeComponents.time,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  static Future<void> scheduleWeeklyReminder({
    required String taskName,
    required int weekday,
    required TimeOfDay time,
  }) async {
    final now = DateTime.now();
    final offset = (weekday - now.weekday + 7) % 7;
    DateTime first = now.add(Duration(days: offset));
    DateTime scheduled =
        DateTime(first.year, first.month, first.day, time.hour, time.minute)
            .subtract(const Duration(hours: 1));
    if (scheduled.isBefore(now)) {
      scheduled = scheduled.add(const Duration(days: 7));
    }
    final tzTime = tz.TZDateTime.from(scheduled, tz.local);

    await _plugin.zonedSchedule(
      _weeklyId(taskName, weekday),
      'Hey there, hurry up!',
      "In an hour, it's time to start '$taskName'",
      tzTime,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'task_channel',
          'Task Reminders',
          channelDescription: 'Reminder notifications for your cleaning tasks',
          importance: Importance.max,
          priority: Priority.high,
        ),
      ),
      androidAllowWhileIdle: true,
      matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  static Future<void> scheduleMonthlyReminder({
    required String taskName,
    required int day,
    required TimeOfDay time,
  }) async {
    final now = DateTime.now();
    DateTime scheduled;
    try {
      scheduled = DateTime(now.year, now.month, day, time.hour, time.minute);
    } catch (_) {
      scheduled = DateTime(
          now.year,
          now.month,
          DateUtils.getDaysInMonth(now.year, now.month),
          time.hour,
          time.minute);
    }
    scheduled = scheduled.subtract(const Duration(hours: 1));
    if (scheduled.isBefore(now)) {
      scheduled = scheduled.add(const Duration(days: 30));
    }
    final tzTime = tz.TZDateTime.from(scheduled, tz.local);

    await _plugin.zonedSchedule(
      _monthlyId(taskName, day),
      'Hey there, hurry up!',
      "In an hour, it's time to start '$taskName'",
      tzTime,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'task_channel',
          'Task Reminders',
          channelDescription: 'Reminder notifications for your cleaning tasks',
          importance: Importance.max,
          priority: Priority.high,
        ),
      ),
      androidAllowWhileIdle: true,
      matchDateTimeComponents: DateTimeComponents.dayOfMonthAndTime,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  static Future<void> cancelDailyReminder(String taskName) async {
    await _plugin.cancel(_dailyId(taskName));
  }

  static Future<void> cancelWeeklyReminder(String taskName, int weekday) async {
    await _plugin.cancel(_weeklyId(taskName, weekday));
  }

  static Future<void> cancelMonthlyReminder(String taskName, int day) async {
    await _plugin.cancel(_monthlyId(taskName, day));
  }

  static Future<void> cancelAll() async {
    await _plugin.cancelAll();
  }

  static int _dailyId(String name) => '${name}_daily'.hashCode;
  static int _weeklyId(String name, int weekday) =>
      '${name}_w$weekday'.hashCode;
  static int _monthlyId(String name, int day) => '${name}_m$day'.hashCode;
}
