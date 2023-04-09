// // ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationWidget {
  static final _notifications = FlutterLocalNotificationsPlugin();

  static Future init({bool scheduled = false}) async {
    final android = AndroidInitializationSettings('@mipmap/ic_launcher');
    final ios = DarwinInitializationSettings();
    final settings = InitializationSettings(android: android, iOS: ios);

    await _notifications.initialize(settings);
  }

  static Future showNotification({
    var id = 0,
    var title,
    var body,
    var payload,
  }) async =>
      _notifications.show(
        id,
        title,
        body,
        await notificationDetails(),
      );

  static Future showScheduleDailyotificationJamKeluar({
    var id = 0,
    var title,
    var body,
    var payload,
    var jamKeluar,
    var menitKeluar,
  }) async =>
      _notifications.zonedSchedule(
        id,
        title,
        body,
        scheduleDaily(
          Time(
            int.parse(jamKeluar) - 7,
            int.parse(menitKeluar),
          ),
        ),
        await notificationDetails(),
        payload: payload,
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time,
      );
  static Future showScheduleDailyotificationJamMasuk({
    var id = 1,
    var title,
    var body,
    var payload,
    var jamKeluar,
    var menitKeluar,
  }) async =>
      _notifications.zonedSchedule(
        id,
        title,
        body,
        scheduleDaily(
          Time(
            int.parse(jamKeluar) - 7,
            int.parse(menitKeluar),
          ),
        ),
        await notificationDetails(),
        payload: payload,
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time,
      );

  static tz.TZDateTime scheduleDaily(Time time) {
    DateTime x = DateTime.now();
    final now = tz.TZDateTime.now(tz.local);
    // final now =
    //     tz.TZDateTime.utc(x.year, x.month, x.day, x.hour, x.minute, x.second);
    final scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      time.hour,
      time.minute,
      time.second,
    );

    print('now time $now');
    print('schedule time $scheduledDate');
    return scheduledDate.isBefore(now)
        ? scheduledDate.add(
            Duration(days: 1),
          )
        : scheduledDate;
  }

  static notificationDetails() {
    return NotificationDetails(
      android: AndroidNotificationDetails('channel id 9', 'channel name',
          importance: Importance.max),
      iOS: DarwinNotificationDetails(),
    );
  }
}
