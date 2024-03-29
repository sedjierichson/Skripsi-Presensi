// ignore_for_file: prefer_const_constructors, use_build_context_synchronously, avoid_single_cascade_in_expression_statements

import 'dart:io';

import 'package:aplikasi_presensi/Pages/Lainnya/other_page.dart';
import 'package:aplikasi_presensi/Pages/bottom_navbar.dart';
import 'package:aplikasi_presensi/Pages/login_screen.dart';
import 'package:aplikasi_presensi/api/dbservices_device.dart';
import 'package:aplikasi_presensi/api/dbservices_user.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:pinput/pinput.dart';
import 'package:quickalert/quickalert.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:aplikasi_presensi/globals.dart' as globals;
import 'package:uuid/uuid.dart';

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
  DeviceService dbDevice = DeviceService();
  String imeiBaru = "";
  var uuid = Uuid();

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
    if (VerifikasiPin == widget.pinLogin) {
      try {
        var res = await db.insertDataPertamaLogin(
            widget.nik.toString(),
            globals.pegawai.read('nama'),
            VerifikasiPin.toString(),
            imeiBaru.toString());

        if (res['message'] == -1) {
          globals.pegawai.remove('nik');
          globals.pegawai.remove('nama');
          globals.pegawai.remove('jabatan');
          globals.pegawai.remove('nik_atasan');

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
          getFcmToken();
          // pindahkeHomePage();
        }
      } catch (e) {
        print(e.toString());
      }
    } else {
      globals.showAlertError(context: context, message: 'PIN Tidak Sama');
    }
  }

  void getUUIDAplikasiBaru() async {
    if (globals.pegawai.read('uuidapp') != null) {
      setState(() {
        imeiBaru = globals.pegawai.read('uuidapp');
      });
    } else {
      setState(() {
        imeiBaru = uuid.v4();
        globals.pegawai.write('uuidapp', imeiBaru);
      });
    }
  }

  void getFcmToken() async {
    try {
      // if (await InternetConnectionChecker().hasConnection == true) {
      FirebaseMessaging.instance.getToken().then((newToken) {
        dbDevice.insertFCMToken(nik: widget.nik, token: newToken.toString());
        globals.pegawai.write('deviceId', newToken.toString());
        // getCurrentUser();
      }).catchError((e) {
        globals.showAlertBerhasil(context: context, message: e);
      });
      pindahkeHomePage();
      // } else {
      // globals.showToast(message: "Tidak ada koneksi internet");
      // }
    } catch (_) {
      globals.showAlertError(context: context, message: _.toString());
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
    getUUIDAplikasiBaru();
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
