// // ignore_for_file: prefer_const_constructors

// import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// class NotificationAPI {
//   final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
//       FlutterLocalNotificationsPlugin();

//   final AndroidInitializationSettings _androidInitializationSettings =
//       const AndroidInitializationSettings('rutan');

//   void initializeNotification() async {
//     InitializationSettings initializationSettings =
//         InitializationSettings(android: _androidInitializationSettings);

//     await _flutterLocalNotificationsPlugin.initialize(initializationSettings);
//   }

//   void sendNotification(String title, String body) async {
//     AndroidNotificationDetails androidNotificationDetails =
//         AndroidNotificationDetails(
//       'channelId',
//       'channelName',
//       priority: Priority.high,
//       importance: Importance.max,
//     );
//     NotificationDetails notificationDetails = NotificationDetails(
//       android: androidNotificationDetails
//     );
//     await _flutterLocalNotificationsPlugin.show(
//       0,
//       title,
//       body,
//       notificationDetails,
//     );
//   }
//   // static Future _notificationDetails() async {
//   //   return NotificationDetails(
//   //     android: AndroidNotificationDetails(
//   //       'channel id',
//   //       'channel name',
//   //       importance: Importance.max
//   //     ),
//   //     iOS: DarwinNotificationDetails(),
//   //   );
//   // }

//   // // static Future init({bool initScheduled = false}) async{
//   // //   final android = AndroidInitializationSettings('@mipmap/ic_launcher');
//   // //   final ios = DarwinInitializationSettings();
//   // //   final settings = InitializationSettings(android: android, iOS: ios);

//   // //   await _notif.initialize(settings, on)
//   // // }

//   // static Future showNotification({
//   //   int id = 0,
//   //   String? title,
//   //   String? body,
//   //   String? payload,
//   // }) async =>
//   //     _notif.show(
//   //       id,
//   //       title,
//   //       body,
//   //       await _notificationDetails(),
//   //       payload: payload,
//   //     );
// }

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  final FlutterLocalNotificationsPlugin notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> initNotification() async {
    AndroidInitializationSettings initializationSettingsAndroid =
        const AndroidInitializationSettings('flutter_logo');

    var initializationSettingsIOS = DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
        onDidReceiveLocalNotification:
            (int id, String? title, String? body, String? payload) async {});

    var initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
    await notificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse:
            (NotificationResponse notificationResponse) async {});
  }

  notificationDetails() {
    return const NotificationDetails(
        android: AndroidNotificationDetails('channelId', 'channelName',
            importance: Importance.max),
        iOS: DarwinNotificationDetails());
  }

  Future showNotification(
      {int id = 0, String? title, String? body, String? payLoad}) async {
    return notificationsPlugin.show(
        id, title, body, await notificationDetails());
  }

  Future scheduleNotification(
      {int id = 0,
      String? title,
      String? body,
      String? payLoad,
      required DateTime scheduledNotificationDateTime}) async {
    return notificationsPlugin.zonedSchedule(
        id,
        title,
        body,
        tz.TZDateTime.from(
          scheduledNotificationDateTime,
          tz.local,
        ),
        await notificationDetails(),
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime);
  }
}