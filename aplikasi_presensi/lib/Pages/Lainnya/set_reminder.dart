// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:aplikasi_presensi/api/notification_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:timezone/data/latest.dart' as tz;

// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
DateTime scheduleTime = DateTime.now();

class SetReminder extends StatefulWidget {
  const SetReminder({super.key});

  @override
  State<SetReminder> createState() => _SetReminderState();
}

class _SetReminderState extends State<SetReminder> {
  String? jamKeluar;
  String? jamMasuk;
  // NotificationAPI notificationAPI = NotificationAPI();

  void initState() {
    super.initState();
    NotificationWidget.init();
    tz.initializeTimeZones();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(MediaQuery.of(context).size.width / 15),
            child: Column(
              children: [
                Text(
                  'Atur Jam Pengingat Presensi',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                SizedBox(
                  height: 20,
                ),
                Expanded(
                  child: cardJamMasuk(),
                ),
                SizedBox(
                  height: 15,
                ),
                Expanded(
                  child: cardJamKeluar(),
                ),
                MaterialButton(
                  onPressed: () {
                    // notificationAPI.sendNotification('Halo', "halo lagi");
                    // NotificationService().scheduleNotification(
                    //     title: 'Test Notifikasi',
                    //     body: 'Test Notifikasi',
                    //     scheduledNotificationDateTime: scheduleTime);
                    NotificationWidget.showScheduleDailyotificationJamKeluar(
                      title: "Notifications",
                      body: 'Test Notif',
                      jamKeluar: jamKeluar.toString().substring(0, 2),
                      menitKeluar: jamKeluar.toString().substring(3, 5),
                    );
                  },
                  child: Text("NOTIF Schedule"),
                  color: Colors.amberAccent,
                ),
                MaterialButton(
                  onPressed: () {
                    NotificationWidget.showNotification(
                      title: "Notifications",
                      body: 'Test Notif',
                    );
                  },
                  child: Text("NOTIF"),
                  color: Colors.amberAccent,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget cardJamMasuk() {
    return Container(
      padding: EdgeInsets.only(top: 20, left: 20, bottom: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.green[300],
      ),
      alignment: Alignment.centerLeft,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    'Presensi Masuk',
                    textAlign: TextAlign.left,
                    style: TextStyle(fontSize: 15, color: Colors.black),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  FaIcon(
                    FontAwesomeIcons.rightToBracket,
                    size: 15,
                    color: Colors.black,
                  )
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                '$jamKeluar',
                textAlign: TextAlign.left,
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          MaterialButton(
            onPressed: () async {
              TimeOfDay? newTime = await showTimePicker(
                context: context,
                initialTime: TimeOfDay.now(),
              );

              if (newTime != null) {
                setState(() {
                  jamMasuk = newTime.toString().substring(10, 15);
                  print(jamMasuk);
                  print(jamMasuk.toString().substring(0, 2));
                  print(jamMasuk.toString().substring(3, 5));
                });
              }
            },
            child: FaIcon(FontAwesomeIcons.solidClock),
          )
        ],
      ),
    );
  }

  Widget cardJamKeluar() {
    return Container(
      padding: EdgeInsets.only(top: 20, left: 20, bottom: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.red[300],
      ),
      alignment: Alignment.centerLeft,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    'Presensi Keluar',
                    textAlign: TextAlign.left,
                    style: TextStyle(fontSize: 15, color: Colors.white),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  FaIcon(
                    FontAwesomeIcons.rightFromBracket,
                    size: 15,
                    color: Colors.white,
                  )
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                '$jamKeluar',
                textAlign: TextAlign.left,
                style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ],
          ),
          MaterialButton(
            onPressed: () async {
              TimeOfDay? newTime = await showTimePicker(
                context: context,
                initialTime: TimeOfDay.now(),
              );

              if (newTime != null) {
                setState(() {
                  jamKeluar = newTime.toString().substring(10, 15);
                  print(jamKeluar);
                  print(jamKeluar.toString().substring(0, 2));
                  print(jamKeluar.toString().substring(3, 5));
                });
              }
              // var tempJamKeluar = await showTimePicker(
              //   context,
              //   showTitleActions: true,
              //   onChanged: (date) => scheduleTime = date,
              //   onConfirm: (date) => print(date),
              // );
            },
            child: FaIcon(
              FontAwesomeIcons.solidClock,
              color: Colors.white,
            ),
          )
        ],
      ),
    );
  }
}