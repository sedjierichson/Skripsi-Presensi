// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:aplikasi_presensi/api/notification_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
DateTime scheduleTime = DateTime.now();

class SetReminder extends StatefulWidget {
  const SetReminder({super.key});

  @override
  State<SetReminder> createState() => _SetReminderState();
}

class _SetReminderState extends State<SetReminder> {
  String? jamKeluar;
  // NotificationAPI notificationAPI = NotificationAPI();

  @override
  void initState() {
    super.initState();
    // notificationAPI.initializeNotification();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
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
                  Container(
                    color: Colors.green[200],
                    alignment: Alignment.centerLeft,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Presensi Masuk',
                          textAlign: TextAlign.left,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          '09:00',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Container(
                    color: Colors.red[200],
                    alignment: Alignment.centerLeft,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Presensi Keluar',
                              textAlign: TextAlign.left,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              '$jamKeluar',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        MaterialButton(
                          onPressed: () async {
                            // TimeOfDay? newTime = await showTimePicker(
                            //   context: context,
                            //   initialTime: TimeOfDay.now(),
                            // );
                            

                            // if (newTime != null) {
                            //   setState(() {
                            //     jamKeluar =
                            //         newTime.toString().substring(10, 15);
                            //     print(jamKeluar);
                            //   });
                            // }
                            DatePicker.showDateTimePicker(
                              context,
                              showTitleActions: true,
                              onChanged: (date) => scheduleTime = date,
                              onConfirm: (date) => print(date),
                            );
                          },
                          child: Icon(Icons.edit),
                        )
                      ],
                    ),
                  ),
                  MaterialButton(
                    onPressed: () {
                      // notificationAPI.sendNotification('Halo', "halo lagi");
                      NotificationService().scheduleNotification(
                          title: 'HALO',
                          scheduledNotificationDateTime: scheduleTime);
                    },
                    child: Text("NOTIF"),
                    color: Colors.amberAccent,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
