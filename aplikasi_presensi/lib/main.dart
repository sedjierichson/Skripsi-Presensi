// ignore_for_file: prefer_const_constructors

import 'package:aplikasi_presensi/Pages/PIN%20Login/enter_pin.dart';
import 'package:aplikasi_presensi/Pages/bottom_navbar.dart';
import 'package:aplikasi_presensi/Pages/home_page.dart';
import 'package:aplikasi_presensi/Pages/login_screen.dart';
import 'package:aplikasi_presensi/api/notification_api.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:aplikasi_presensi/globals.dart' as globals;

void main() async {
  await GetStorage.init();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );
  // print('User granted permission: ${settings.authorizationStatus}');
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    // print('Got a message whilst in the foreground!');
    // print('Message data: ${message.data}');

    if (message.notification != null) {
      // print("Message also contained a notification: ${message.notification}");
    }
  });
  // NotificationService().initNotification();
  await Permission.notification.isDenied.then((value) {
    if (value) {
      Permission.notification.request();
    }
  });
  await Permission.bluetoothScan.isDenied.then((value) {
    if (value) {
      Permission.bluetoothScan.request();
    }
  });
  tz.initializeTimeZones();

  runApp(const MyApp());
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          pageTransitionsTheme: PageTransitionsTheme(builders: {
        TargetPlatform.android: CupertinoPageTransitionsBuilder(),
        TargetPlatform.iOS: CupertinoPageTransitionsBuilder()
      })),
      debugShowCheckedModeBanner: false,
      title: 'PRESENSI',
      // builder: (context, child) => MediaQuery(data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),child: child,),
      home: globals.pegawai.read('nik') != null
          ? EnterPin(
              nik: globals.pegawai.read('nik'),
              mode: 'sudah_login',
            )
          : LoginScreen(),
      // home: LoginScreen(),
    );
  }
}
