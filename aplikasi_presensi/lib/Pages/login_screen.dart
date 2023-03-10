// ignore_for_file: prefer_const_constructors

import 'package:aplikasi_presensi/Pages/PIN%20Login/enter_pin.dart';
import 'package:aplikasi_presensi/Pages/bottom_navbar.dart';
import 'package:aplikasi_presensi/Pages/home_page.dart';
import 'package:aplikasi_presensi/api/dbservices_user.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:quickalert/quickalert.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController tfLoginNIK = TextEditingController();
  TextEditingController tfLoginPassword = TextEditingController();
  UserService db = UserService();

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

  void pertamaLogin() {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return EnterPin(
        nik: tfLoginNIK.text.toString(),
        mode: 'pertama_login',
      );
    }));
  }

  void checkData() async {
    if (tfLoginNIK.text.toString() == "" ||
        tfLoginPassword.text.toString() == "") {
      QuickAlert.show(
          context: context,
          type: QuickAlertType.warning,
          title: 'Oops...',
          text: 'NIK dan Password tidak boleh kosong',
          confirmBtnText: 'OK',
          confirmBtnColor: Colors.blueAccent);
    } else {
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
          pindahkeHomePage();
          print('pernah login');
          // pindahkeHomePage();
        } else if (res['status'] == 1 && res2['status'] == 0) {
          //password benar & belum pernah login
          pertamaLogin();
          print('belum pernah login');
        } else {
          //password salah
          QuickAlert.show(
              context: context,
              type: QuickAlertType.error,
              title: 'Oops...',
              text: 'NIK atau Password salah',
              confirmBtnText: 'OK',
              confirmBtnColor: Colors.blueAccent);
        }
      } catch (e) {
        print(e.toString());
      }
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
                    margin: EdgeInsets.only(top: 10),
                    child: TextField(
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
                          checkData();
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
