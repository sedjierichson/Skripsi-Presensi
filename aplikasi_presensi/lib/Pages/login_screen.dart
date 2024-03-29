// ignore_for_file: prefer_const_constructors

import 'dart:io';

import 'package:aplikasi_presensi/Pages/PIN%20Login/enter_pin.dart';
import 'package:aplikasi_presensi/Pages/bottom_navbar.dart';
import 'package:aplikasi_presensi/Pages/home_page.dart';
import 'package:aplikasi_presensi/api/apidbconfig.dart';
import 'package:aplikasi_presensi/api/dbservices_user.dart';
import 'package:aplikasi_presensi/models/pegawai.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:quickalert/quickalert.dart';
import 'package:aplikasi_presensi/globals.dart' as globals;

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController tfLoginNIK = TextEditingController();
  TextEditingController tfLoginPassword = TextEditingController();
  String imeiHPSekarang = '';
  UserService db = UserService();
  late Pegawai p;

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

  void pertamaLogin() async {
    try {
      globals.currentPegawai =
          await db.getCurrentUser(nik: tfLoginNIK.text.toString());
      globals.pegawai.write('nik', globals.currentPegawai.nik);
      globals.pegawai.write('nama', globals.currentPegawai.nama);
      globals.pegawai.write('jabatan', globals.currentPegawai.jabatan);
      globals.pegawai.write('nik_atasan', globals.currentPegawai.nik_atasan);

      Navigator.of(context).push(MaterialPageRoute(builder: (context) {
        return EnterPin(
          nik: tfLoginNIK.text.toString(),
          mode: 'pertama_login',
        );
      }));
    } catch (e) {
      print(e);
    }
  }

  void getCurrentUser() async {
    try {
      globals.currentPegawai =
          await db.getCurrentUser(nik: tfLoginNIK.text.toString());
      globals.currentHpPegawai =
          await db.getDataHPPegawai(nik: tfLoginNIK.text.toString());
      globals.pegawai.write('nik', globals.currentPegawai.nik);
      globals.pegawai.write('nama', globals.currentPegawai.nama);
      globals.pegawai.write('jabatan', globals.currentPegawai.jabatan);
      globals.pegawai.write('nik_atasan', globals.currentPegawai.nik_atasan);
      globals.pegawai.write('imei', globals.currentHpPegawai.imei);

      cocokkanUUIDAplikasi();
    } catch (e) {
      print(e);
    }
  }

  void checkData() async {
    try {
      var res = await db.loginAPI(
        nik: tfLoginNIK.text.toString(),
        password: tfLoginPassword.text.toString(),
      );
      var res2 = await db.cekNIKSudahTerdaftar(
        nik: tfLoginNIK.text.toString(),
      );
      if (res['status'] == 1 && res2['status'] == 1) {
        //password benar & sudah pernah login

        getCurrentUser();
        print('pernah login');
      } else if (res['status'] == 1 && res2['status'] == 0) {
        //password benar & belum pernah login
        pertamaLogin();
        print('belum pernah login');
      } else {
        //password salah
        globals.showAlertError(
            context: context, message: 'NIK atau Password Salah');
      }
    } catch (e) {
      globals.showAlertError(context: context, message: e.toString());
    }
  }

  void cocokkanUUIDAplikasi() async {
    print(globals.pegawai.read('uuidapp'));
    setState(() {
      imeiHPSekarang = globals.pegawai.read('uuidapp');
    });
    // if (Platform.isAndroid) {
    //   AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    //   setState(() {
    //     imeiHPSekarang = androidInfo.serialNumber.toString();
    //   });
    // } else if (Platform.isIOS) {
    //   IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
    //   setState(() {
    //     imeiHPSekarang = iosInfo.identifierForVendor!.toString();
    //   });
    // }

    if (globals.currentHpPegawai.imei != imeiHPSekarang) {
      globals.showAlertError(
          context: context,
          message:
              'IMEI perangkat tidak sama. Silahkan login menggunakan perangkat yang sudah terdaftar sebelumnya.');
    } else {
      Navigator.of(context).push(MaterialPageRoute(builder: (context) {
        return EnterPin(
          nik: tfLoginNIK.text.toString(),
          mode: 'sudah_login',
        );
      }));
    }
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
                        top: MediaQuery.of(context).size.height / 35),
                    alignment: Alignment.center,
                    child: Text(
                      "SELAMAT DATANG",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 23,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 4,
                    width: MediaQuery.of(context).size.width / 2,
                    child: Image.asset(
                      "assets/images/attendance.png",
                      fit: BoxFit.contain,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    alignment: Alignment.center,
                    child: Text(
                      "Aplikasi Presensi",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 23,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height / 15),
                    child: TextField(
                      keyboardType: TextInputType.number,
                      controller: tfLoginNIK,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.only(
                            top: MediaQuery.of(context).size.height / 20,
                            left: MediaQuery.of(context).size.width / 20),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15)),
                        hintText: 'Masukkan NIK',
                        hintStyle: TextStyle(fontSize: 13),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 5),
                    child: TextField(
                      obscureText: true,
                      keyboardType: TextInputType.number,
                      controller: tfLoginPassword,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.only(
                            top: MediaQuery.of(context).size.height / 20,
                            left: MediaQuery.of(context).size.width / 20),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15)),
                        hintText: 'Masukkan kata sandi',
                        hintStyle: TextStyle(fontSize: 13),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height / 25),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width / 1.1,
                      height: MediaQuery.of(context).size.height / 13,
                      child: MaterialButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)),
                        color: Colors.cyan,
                        onPressed: () {
                          if (tfLoginNIK.text.toString() == "" ||
                              tfLoginPassword.text.toString() == "") {
                            globals.showAlertWarning(
                                context: context,
                                message: 'NIK dan Password tidak boleh kosong');
                          } else {
                            checkData();
                          }
                        },
                        child: Text(
                          'LOGIN',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.white),
                        ),
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
