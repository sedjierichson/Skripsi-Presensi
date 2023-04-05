// ignore_for_file: prefer_const_constructors

import 'package:aplikasi_presensi/Pages/PIN%20Login/verif_pin.dart';
import 'package:aplikasi_presensi/Pages/bottom_navbar.dart';
import 'package:aplikasi_presensi/api/dbservices_user.dart';
import 'package:aplikasi_presensi/models/pegawai.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_verification_code/flutter_verification_code.dart';
import 'package:quickalert/quickalert.dart';
import 'package:aplikasi_presensi/globals.dart' as globals;

class EnterPin extends StatefulWidget {
  final String nik;
  final String mode;
  const EnterPin({super.key, required this.nik, required this.mode});

  @override
  State<EnterPin> createState() => _EnterPinState();
}

class _EnterPinState extends State<EnterPin> {
  String pin_login = '';
  String pinTerdaftar = '';
  UserService db = UserService();
  List<Pegawai> p = [];

  void getPIN() async {
    try {
      var res = await db.cekNIKSudahTerdaftar(nik: widget.nik.toString());
      pinTerdaftar = res['message']['security_code'].toString();
      print("pin = " + res['message']['security_code'].toString());
    } catch (e) {
      print(e.toString());
    }
  }

  void cekPINLogin() {
    if (pin_login != '') {
      if (pin_login == pinTerdaftar) {
        if (widget.mode.toString() == "sudah_login") {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) {
                return BottomNavBar();
              },
            ),
            (route) => false,
          );
        } else if (widget.mode.toString() == "ganti_pin") {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) {
            return EnterPin(
              nik: globals.currentPegawai.nik.toString(),
              mode: 'ganti_pin2',
            );
          }));
        }
      } else {
        globals.showAlertError(context: context, message: 'PIN salah');
      }
    } else {
      globals.showAlertError(
          context: context, message: 'PIN tidak boleh kosong');
    }
  }

  void pindahkeVerifPINPertamaLogin() {
    if (pin_login != '') {
      Navigator.of(context).push(MaterialPageRoute(builder: (context) {
        return VerifPin(
          pinLogin: pin_login,
          nik: widget.nik,
          mode: widget.mode,
        );
      }));
    } else {
      globals.showAlertError(
          context: context, message: 'PIN tidak boleh kosong');
    }
  }

  @override
  void initState() {
    if (widget.mode.toString() == 'sudah_login' ||
        widget.mode.toString() == 'ganti_pin') {
      getPIN();
    }
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
                    child: widget.mode.toString() == 'sudah_login' ||
                            widget.mode.toString() == 'ganti_pin'
                        ? Text(
                            "Masukkan PIN Login",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                            textAlign: TextAlign.center,
                          )
                        : widget.mode.toString() == 'pertama_login'
                            ? Text(
                                "Daftar PIN Login",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                                textAlign: TextAlign.center,
                              )
                            : Text(
                                "Masukkan PIN Login Baru",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                                textAlign: TextAlign.center,
                              ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height / 15),
                    child: VerificationCode(
                      length: 4,
                      textStyle: TextStyle(fontSize: 20, color: Colors.black),
                      underlineColor: Colors.black,
                      keyboardType: TextInputType.number,
                      underlineUnfocusedColor: Colors.black,
                      onCompleted: (value) {
                        // print("AAAA" + value);
                        setState(() {
                          pin_login = value;
                        });
                      },
                      onEditing: (value) {},
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height / 15),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width / 2,
                      height: MediaQuery.of(context).size.height / 15,
                      child: MaterialButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)),
                        color: Colors.cyan,
                        onPressed: () {
                          if (widget.mode.toString() == "pertama_login" ||
                              widget.mode.toString() == "ganti_pin2") {
                            pindahkeVerifPINPertamaLogin();
                          } else {
                            cekPINLogin();
                          }
                        },
                        child: Text(
                          'LANJUT',
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
