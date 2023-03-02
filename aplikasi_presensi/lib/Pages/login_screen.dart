// ignore_for_file: prefer_const_constructors

import 'package:aplikasi_presensi/Pages/bottom_navbar.dart';
import 'package:aplikasi_presensi/Pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController tfLoginNIK = TextEditingController();
  TextEditingController tfLoginPassword = TextEditingController();

  void pindahkeHomePage() {
    // Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) {
    //   return const HomePage();
    // }));
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
                  SizedBox(height: 20,),
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 4,
                    width: MediaQuery.of(context).size.width / 2,
                    child: Image.asset(
                      "assets/images/attendance.png",
                      fit: BoxFit.contain,
                    ),
                  ),
                  SizedBox(height: 20,),
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
                    margin: EdgeInsets.only(top: MediaQuery.of(context).size.height/15),
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
                          pindahkeHomePage();
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
