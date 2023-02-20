// ignore_for_file: prefer_const_constructors

import 'package:aplikasi_presensi/Pages/other_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_verification_code/flutter_verification_code.dart';
import 'package:quickalert/quickalert.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

class VerifPin extends StatefulWidget {
  final String pinLogin;
  const VerifPin({super.key, required this.pinLogin});

  @override
  State<VerifPin> createState() => _VerifPinState();
}

class _VerifPinState extends State<VerifPin> {
  String VerifikasiPin = '';

  void successGantiPin() {
    if (VerifikasiPin == widget.pinLogin.toString()) {
      QuickAlert.show(
        context: context,
        type: QuickAlertType.success,
        text: 'PIN berhasil diganti',
        confirmBtnText: 'OK',
        confirmBtnColor: Colors.blueAccent,
        onConfirmBtnTap: () {
          Navigator.pop(context);
          Navigator.of(context)
              .pushReplacement(MaterialPageRoute(builder: (context) {
            return const OtherPage();
          }));
        },
      );
    } else {
      QuickAlert.show(
        context: context,
        type: QuickAlertType.error,
        text: 'PIN tidak sama',
        confirmBtnText: 'OK',
        confirmBtnColor: Colors.blueAccent,
      );
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
                        // print("AAAAB" + value);
                        setState(() {
                          VerifikasiPin = value;
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
                          successGantiPin();
                        },
                        child: Text(
                          'ATUR PIN',
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
