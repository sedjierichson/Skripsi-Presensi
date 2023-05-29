// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:aplikasi_presensi/Pages/Lainnya/izin_bawahan.dart';
import 'package:aplikasi_presensi/Pages/Lainnya/log_data.dart';
import 'package:aplikasi_presensi/Pages/PIN%20Login/enter_pin.dart';
import 'package:aplikasi_presensi/Pages/custom_clipper.dart';
import 'package:aplikasi_presensi/Pages/login_screen.dart';
import 'package:aplikasi_presensi/api/dbservices_device.dart';
import 'set_reminder.dart';
import 'team_saya.dart';
import 'package:aplikasi_presensi/api/dbservices_user.dart';
import 'package:aplikasi_presensi/models/pegawai.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:aplikasi_presensi/globals.dart' as globals;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class OtherPage extends StatefulWidget {
  const OtherPage({super.key});

  @override
  State<OtherPage> createState() => _OtherPageState();
}

class _OtherPageState extends State<OtherPage> {
  // List<apiRutanPegawai> bawahan = [];
  UserService db = UserService();
  DeviceService dbDevice = DeviceService();
  bool isLoading = true;
  bool isError = false;
  bool adaBawahan = false;

  void getBawahanUser() async {
    setState(() {
      isLoading = true;
      isError = false;
    });
    try {
      await db.getBawahanUser(
        nik: globals.pegawai.read('nik').toString(),
      );
      setState(() {
        isLoading = false;
        adaBawahan = true;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        isError = true;
      });
    }
  }

  @override
  void initState() {
    getBawahanUser();
    super.initState();
  }

  void pindahkeEnterPIN() {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return EnterPin(
        nik: globals.pegawai.read('nik').toString(),
        mode: 'ganti_pin',
      );
    }));
  }

  void pindahkeTeamSaya({required String mode}) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return TeamSaya(
        jabatan: mode.toString(),
      );
    }));
  }

  void pindahkeSetReminder() {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return const SetReminder();
    }));
  }

  void pindahkeLogData() {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return const LogData();
    }));
  }

  void pindahkeIzinBawahan() {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return const IzinBawahanPage();
    }));
  }

  void pindahkeLogin() async {
    try {
      dbDevice.removeDeviceId(
          nik: globals.pegawai.read('nik'),
          token: globals.pegawai.read('deviceId'));
      globals.pegawai.remove('nik');
      globals.pegawai.remove('nama');
      globals.pegawai.remove('jabatan');
      globals.pegawai.remove('nik_atasan');
      globals.pegawai.remove('deviceId');
    } catch (e) {
      print(e.toString());
    }
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
              child: isError == true && isLoading == true
                  ? Text('Error')
                  : Column(
                      children: [
                        Text(
                          globals.pegawai.read('nama') ?? 'x',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        Text('NIK : ' + globals.pegawai.read('nik')),
                        Text(globals.pegawai.read('jabatan')),
                        SizedBox(
                          height: 40,
                        ),
                        MaterialButton(
                          padding: EdgeInsets.all(15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          color: Color.fromARGB(255, 207, 207, 207),
                          onPressed: () {
                            adaBawahan == true
                                ? pindahkeTeamSaya(mode: "manajer")
                                : pindahkeTeamSaya(mode: "other");
                          },
                          child: Row(
                            children: [
                              Icon(Icons.group),
                              SizedBox(
                                width: 20,
                              ),
                              Expanded(
                                child: Text('Team Saya'),
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
                        adaBawahan == true
                            ? MaterialButton(
                                padding: EdgeInsets.all(15),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                color: Color.fromARGB(255, 207, 207, 207),
                                onPressed: () {
                                  pindahkeIzinBawahan();
                                },
                                child: Row(
                                  children: [
                                    Icon(FontAwesomeIcons.listCheck),
                                    SizedBox(
                                      width: 20,
                                    ),
                                    Expanded(
                                      child: Text('Daftar Izin Team Saya'),
                                    ),
                                    Icon(
                                      Icons.arrow_forward_ios,
                                      size: 15,
                                    )
                                  ],
                                ),
                              )
                            : SizedBox(),
                        SizedBox(
                          height: 10,
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
                          onPressed: () {
                            pindahkeLogData();
                          },
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
                                      color: Colors.red,
                                      fontWeight: FontWeight.bold),
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
