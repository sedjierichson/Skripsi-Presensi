// ignore_for_file: prefer_const_constructors

import 'package:aplikasi_presensi/Pages/PIN%20Login/enter_pin.dart';
import 'package:aplikasi_presensi/Pages/bottom_navbar.dart';
import 'package:aplikasi_presensi/Pages/home_page.dart';
import 'package:aplikasi_presensi/Pages/login_screen.dart';
import 'package:aplikasi_presensi/api/notification_api.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:aplikasi_presensi/globals.dart' as globals;

void main() async {
  await GetStorage.init();
  WidgetsFlutterBinding.ensureInitialized();
  // NotificationService().initNotification();
  tz.initializeTimeZones();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
