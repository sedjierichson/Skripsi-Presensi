// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:aplikasi_presensi/api/dbservices_user.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:aplikasi_presensi/globals.dart' as globals;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //Fungsi Untuk Get Jam secara Live
  String jamSekarang = '';
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  UserService db = UserService();
  String imeiBaru = "";
  String imeiHP = "";

  @override
  void initState() {
    print("Imei terdaftar " + globals.currentHpPegawai.imei.toString());
    if (globals.currentHpPegawai.imei == null) {
      getImeiBaru();
    } else {
      cocokkanIMEI();
    }
    super.initState();
    jamSekarang = _format(DateTime.now());
    Timer.periodic(Duration(seconds: 1), (timer) => getTime());
  }

  void daftarkanImei(String imeix) async {
    try {
      await db.updateIMEI(
          globals.currentPegawai.nik.toString(), imeix.toString());
    } catch (e) {
      print(e.toString());
    }
  }

  void cocokkanIMEI() async {
    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      setState(() {
        imeiBaru = androidInfo.serialNumber.toString();
      });
      if (globals.currentHpPegawai.imei != imeiBaru) {
        print('LOGOUTTTT');
      } else {
        print('cocok');
      }
      print("imei : " + imeiBaru);
      print("Platform" + androidInfo.device);
    } else if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      setState(() {
        imeiBaru = iosInfo.identifierForVendor!.toString();
      });
      if (globals.currentHpPegawai.imei != imeiBaru) {
        print('LOGOUTTTT');
      } else {
        print('cocok');
      }
      print("imei : " + imeiBaru);
      print(iosInfo.name);
    }
  }

  void getImeiBaru() async {
    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      setState(() {
        imeiBaru = androidInfo.serialNumber.toString();
      });
      daftarkanImei(imeiBaru);
      print("imei : " + imeiBaru);
      print(androidInfo.model);
    } else if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      setState(() {
        imeiBaru = iosInfo.identifierForVendor!.toString();
      });
      daftarkanImei(imeiBaru);
      print("imei : " + imeiBaru);
    }
  }

  void getTime() {
    final DateTime now = DateTime.now();
    final String formatted = _format(now);
    if (this.mounted) {
      setState(() {
        jamSekarang = formatted;
      });
    }
  }

  String _format(DateTime dateTime) {
    return DateFormat("HH:mm").format(dateTime);
  }

  //-----
  //final tanggal = DateTime.now();
  String formatter = DateFormat('d ' + 'MMMM ' + 'y').format(DateTime.now());

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
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Hi, ' + globals.currentPegawai.nama,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                      ),
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width / 3,
                      child: Row(
                        children: [
                          Text(
                            'NIK : ' + globals.currentPegawai.nik,
                            style: TextStyle(
                              fontSize: 12,
                            ),
                          ),
                          Text(' | '),
                          Text(
                            globals.currentPegawai.jabatan,
                            style: TextStyle(
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 20,
                  ),
                  Container(
                    child: Text(
                      jamSekarang,
                      style:
                          TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                    child: Text(
                      formatter,
                      style: TextStyle(fontSize: 15),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 20,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: HexColor('#13542D'),
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                    ),
                    alignment: Alignment.center,
                    width: MediaQuery.of(context).size.height / 3.5,
                    height: MediaQuery.of(context).size.height / 3.5,
                    //color: Colors.greenAccent,
                    child: Text(
                      'Absen Masuk',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 8,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width / 10,
                              child: Image.asset(
                                "assets/images/time_in.png",
                                fit: BoxFit.fitWidth,
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              '09:00',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            Text('Jam Masuk'),
                          ],
                        ),
                        Column(
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width / 10,
                              child: Image.asset(
                                "assets/images/time_out.png",
                                fit: BoxFit.fitWidth,
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              '09:00',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            Text('Jam Keluar'),
                          ],
                        ),
                        Column(
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width / 10,
                              child: Image.asset(
                                "assets/images/working_time.png",
                                fit: BoxFit.fitWidth,
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              '09:00',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            Text('Jam Kerja'),
                          ],
                        ),
                      ],
                    ),
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
