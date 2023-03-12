// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:aplikasi_presensi/Pages/PIN%20Login/enter_pin.dart';
import 'package:aplikasi_presensi/Pages/login_screen.dart';
import 'package:aplikasi_presensi/Pages/set_reminder.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:aplikasi_presensi/globals.dart' as globals;

class OtherPage extends StatefulWidget {
  const OtherPage({super.key});

  @override
  State<OtherPage> createState() => _OtherPageState();
}

class _OtherPageState extends State<OtherPage> {
  void pindahkeEnterPIN() {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return const EnterPin(
        nik: "1",
        mode: 'ganti_pin',
      );
    }));
  }

  void pindahkeSetReminder() {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return const SetReminder();
    }));
  }

  void pindahkeLogin() {
    Navigator.of(context, rootNavigator: true)
        .pushReplacement(MaterialPageRoute(builder: (context) {
      return const LoginScreen();
    }));
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
                    globals.currentPegawai.nama,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Text('NIK : ' + globals.currentPegawai.nik),
                  Text(globals.currentPegawai.jabatan),
                  SizedBox(
                    height: 50,
                  ),
                  MaterialButton(
                    padding: EdgeInsets.all(15),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    color: Color.fromARGB(255, 207, 207, 207),
                    onPressed: () {
                      pindahkeEnterPIN();
                    },
                    child: Row(
                      children: [
                        Icon(Icons.lock),
                        SizedBox(
                          width: 20,
                        ),
                        Expanded(
                          child: Text('Atur PIN Login'),
                        ),
                        Icon(
                          Icons.arrow_forward_ios,
                          size: 15,
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  MaterialButton(
                    padding: EdgeInsets.all(15),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    color: Color.fromARGB(255, 207, 207, 207),
                    onPressed: () {
                      pindahkeSetReminder();
                    },
                    child: Row(
                      children: [
                        Icon(Icons.timer),
                        SizedBox(
                          width: 20,
                        ),
                        Expanded(
                          child: Text('Atur Jam Pengingat Presensi'),
                        ),
                        Icon(
                          Icons.arrow_forward_ios,
                          size: 15,
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  MaterialButton(
                    padding: EdgeInsets.all(15),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    color: Color.fromARGB(255, 207, 207, 207),
                    onPressed: () {},
                    child: Row(
                      children: [
                        Icon(Icons.assignment_rounded),
                        SizedBox(
                          width: 20,
                        ),
                        Expanded(
                          child: Text('Syarat dan Ketentuan'),
                        ),
                        Icon(
                          Icons.arrow_forward_ios,
                          size: 15,
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  MaterialButton(
                    padding: EdgeInsets.all(15),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    color: Color.fromARGB(255, 207, 207, 207),
                    onPressed: () {
                      pindahkeLogin();
                    },
                    child: Row(
                      children: [
                        Icon(
                          Icons.logout,
                          color: Colors.red,
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Expanded(
                          child: Text(
                            'Keluar',
                            style: TextStyle(
                                color: Colors.red, fontWeight: FontWeight.bold),
                          ),
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
