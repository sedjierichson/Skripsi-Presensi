// ignore_for_file: prefer_const_constructors, use_build_context_synchronously, avoid_single_cascade_in_expression_statements

import 'dart:io';

import 'package:aplikasi_presensi/Pages/Lainnya/other_page.dart';
import 'package:aplikasi_presensi/Pages/bottom_navbar.dart';
import 'package:aplikasi_presensi/Pages/login_screen.dart';
import 'package:aplikasi_presensi/api/dbservices_user.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:pinput/pinput.dart';
import 'package:quickalert/quickalert.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:aplikasi_presensi/globals.dart' as globals;

class VerifPin extends StatefulWidget {
  final String pinLogin;
  final String nik;
  final String mode;
  const VerifPin(
      {super.key,
      required this.pinLogin,
      required this.nik,
      required this.mode});

  @override
  State<VerifPin> createState() => _VerifPinState();
}

class _VerifPinState extends State<VerifPin> {
  String VerifikasiPin = '';
  UserService db = UserService();
  String imeiBaru = "";
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

  void pindahkeHomePage() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) {
          return BottomNavBar();
        },
      ),
      (route) => false,
    );
  }

  void tambahkanUser() async {
    try {
      var res = await db.insertDataPertamaLogin(
          widget.nik.toString(),
          globals.pegawai.read('nama'),
          VerifikasiPin.toString(),
          imeiBaru.toString());
      if (res['message'] == -1) {
        globals.pegawai.erase();

        QuickAlert.show(
            context: context,
            type: QuickAlertType.error,
            text: 'IMEI sudah terdaftar',
            confirmBtnText: 'OK',
            confirmBtnColor: Colors.blueAccent,
            autoCloseDuration: Duration(seconds: 5));
        Future.delayed(const Duration(seconds: 5), () {
          Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => LoginScreen()),
              (Route<dynamic> route) => false);
        });
      } else {
        pindahkeHomePage();
      }
    } catch (e) {
      print(e.toString());
    }
  }

  void getImeiBaru() async {
    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      setState(() {
        imeiBaru = androidInfo.serialNumber.toString();
      });
    } else if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      setState(() {
        imeiBaru = iosInfo.identifierForVendor!.toString();
      });
    }
  }

  void successGantiPin() async {
    if (VerifikasiPin == widget.pinLogin) {
      try {
        await db.updateSecurityCodeLogin(widget.nik, VerifikasiPin);
        QuickAlert.show(
            context: context,
            type: QuickAlertType.success,
            text: 'PIN berhasil diganti',
            confirmBtnText: 'OK',
            confirmBtnColor: Colors.blueAccent,
            autoCloseDuration: Duration(seconds: 5));
        Navigator.of(context)
          ..pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => OtherPage()),
              (Route<dynamic> route) => false);
      } catch (e) {
        print(e.toString());
      }
    } else {
      QuickAlert.show(
        context: context,
        type: QuickAlertType.error,
        text: 'PIN tidak sama',
        confirmBtnText: 'Coba Lagi',
        confirmBtnColor: Colors.blueAccent,
      );
    }
  }

  @override
  void initState() {
    getImeiBaru();
    super.initState();
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
                  Container(
                    padding: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height / 30),
                    alignment: Alignment.center,
                    child: Text(
                      "Verifikasi PIN Login",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    child: Pinput(
                      length: 4,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      onCompleted: (value) {
                        setState(() {
                          VerifikasiPin = value;
                        });
                      },
                    ),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  InkWell(
                    onTap: () {
                      if (widget.mode == 'pertama_login') {
                        tambahkanUser();
                      } else if (widget.mode == 'ganti_pin2') {
                        successGantiPin();
                      }
                    },
                    child: Container(
                      alignment: Alignment.center,
                      height: 50,
                      width: MediaQuery.of(context).size.width / 2,
                      decoration: BoxDecoration(
                        color: HexColor('#13542D'),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        'ATUR PIN',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 17),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
