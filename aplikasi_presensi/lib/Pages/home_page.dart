// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:aplikasi_presensi/Pages/ambil_foto.dart';
import 'package:aplikasi_presensi/Pages/scan_beacon.dart';
import 'package:aplikasi_presensi/api/dbservices_presensi.dart';
import 'package:aplikasi_presensi/api/dbservices_user.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:aplikasi_presensi/globals.dart' as globals;
// import 'package:modal_bottom_sheet/src/bottom_sheet_route.dart' as mymodal;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String formatter = DateFormat('d ' + 'MMMM ' + 'y').format(DateTime.now());
  String jamSekarang = '';
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  UserService db = UserService();
  PresensiService dbPresensi = PresensiService();
  String imeiBaru = "";
  String imeiHP = "";
  String tanggalAbsen = DateFormat('yyyy-MM-dd').format(DateTime.now());
  bool sudahAbsenMasuk = true;
  String? idPresensi;
  String jamMasuk = "--:--";
  String jamKeluar = "--:--";

  // List<String> beacon = [];
  // List<String> uuidScanAdaSama = [
  //   '32a66425-26d2-4693-859a-4ffaf50af319',
  //   '32a66425-26d2-4693-8a-4ffaf50af319'
  // ];
  // List<String> uuidScanTidakAdaSama = [
  //   '32a65-26d2-4693-859a-4ffaf50af319',
  //   '32a65-26d2-4693-8a-4ffaf50af319',
  //   '02129fd8-e302-479c-84e1-6255f610d509'
  // ];

  void pindahAmbilFoto() {
    Navigator.of(context, rootNavigator: true)
        .push(MaterialPageRoute(builder: (context) {
      return AmbilFoto();
    }));
  }

  void pindahScanBeacon() {
    Navigator.of(context, rootNavigator: true)
        .push(MaterialPageRoute(builder: (context) {
      return scanBeaconPage();
    }));
  }

  // void getBeacon() async {
  //   try {
  //     beacon = await dbPresensi.getBeaconPresensi();
  //     // Function eq = const ListEquality().equals;
  //     // print(beacon);
  //     // print(eq(beacon, uuidScanTidakAdaSama));
  //     for (int i = 0; i < uuidScanAdaSama.length; i++) {
  //       if (uuidScanAdaSama[i] == beacon[i]) {
  //         print('ada sama');
  //         break;
  //       } else {
  //         print('Tidak ada sama');
  //       }
  //     }
  //   } catch (e) {
  //     print(e.toString());
  //   }
  // }

  @override
  void initState() {
    setState(() {
      sudahAbsenMasuk = false;
    });
    // getBeacon();
    cekSudahAbsen();
    // print(sudahAbsenMasuk);
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
      // print("imei : " + imeiBaru);
      print("Platform" + androidInfo.device);
      // } else if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      setState(() {
        imeiBaru = iosInfo.identifierForVendor!.toString();
      });
      if (globals.currentHpPegawai.imei != imeiBaru) {
        print('LOGOUTTTT');
      } else {
        print('cocok');
      }
      // print("imei : " + imeiBaru);
      // print(iosInfo.name);
    }
  }

  void cekSudahAbsen() async {
    try {
      var res = await dbPresensi.cekSudahAbsen(
          nik: globals.currentPegawai.nik, tanggal: tanggalAbsen);
      if (res['jam_keluar'] == null) {
        print('absen belum lengkap');
        if (res['status'] == 1) {
          // print('sudah absen');
          // print(res['message']);
          setState(() {
            sudahAbsenMasuk = true;
            idPresensi = res['id']?.toString();
            jamMasuk = res['jam_masuk'].toString();
            jamKeluar = res['jam_keluar'].toString();
          });
        } else {
          // print('belum absen');
          setState(() {
            sudahAbsenMasuk = false;
          });
        }
      } else {
        print('absen ulang');
        if (res['status'] == 1) {
          // print('sudah absen');
          // print(res['message']);
          setState(() {
            sudahAbsenMasuk = false;
            idPresensi = res['message'];
          });
        } else {
          print('belum absen');
          setState(() {
            sudahAbsenMasuk = true;
          });
        }
      }
    } catch (e) {
      globals.showAlertError(context: context, message: e.toString());
    }
  }

  void getImeiBaru() async {
    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      setState(() {
        imeiBaru = androidInfo.serialNumber.toString();
      });
      daftarkanImei(imeiBaru);
      // print("imei : " + imeiBaru);
      // print(androidInfo.model);
    } else if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      setState(() {
        imeiBaru = iosInfo.identifierForVendor!.toString();
      });
      daftarkanImei(imeiBaru);
      // print("imei : " + imeiBaru);
    }
  }

  // void insertAbsenMasuk() async {
  //   try {
  //     var res = await dbPresensi.insertAbsenMasuk(
  //       globals.currentPegawai.nik.toString(),
  //       1,
  //       tanggalAbsen.toString(),
  //       jamSekarang,
  //       "a",
  //     );
  //     if (res['status'] == 1) {
  //       globals.showAlertBerhasil(
  //           context: context, message: 'Berhasil absen masuk');
  //       Navigator.pushReplacement(context,
  //           MaterialPageRoute(builder: (BuildContext context) => super.widget));
  //     }
  //     print(res['status']);
  //   } catch (e) {
  //     globals.showAlertError(
  //       context: context,
  //       message: e.toString(),
  //     );
  //   }
  // }

  void updateJamKeluar() async {
    try {
      await dbPresensi.updateJamKeluar(idPresensi.toString(), jamSekarang);
      globals.showAlertBerhasil(
          context: context, message: 'Absen keluar berhasil');
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (BuildContext context) => super.widget));
    } catch (e) {
      globals.showAlertError(context: context, message: e.toString());
    }
  }

  //Fungsi Untuk Get Jam secara Live
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
                  sudahAbsenMasuk == false
                      ? buttonCardAbsenMasuk()
                      : buttonCardAbsenKeluar(),
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
                              jamMasuk,
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
                              jamKeluar,
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

  Widget buttonCardAbsenMasuk() {
    return GestureDetector(
      onTap: () {
        // insertAbsenMasuk();
        // pindahAmbilFoto();
        pindahScanBeacon();
      },
      child: Container(
        decoration: BoxDecoration(
          color: HexColor('#13542D'),
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
        ),
        alignment: Alignment.center,
        width: MediaQuery.of(context).size.height / 3.5,
        height: MediaQuery.of(context).size.height / 3.5,
        child: Text(
          'Absen Masuk',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
    );
  }

  Widget buttonCardAbsenKeluar() {
    return GestureDetector(
      onTap: () {
        updateJamKeluar();
      },
      child: Container(
        decoration: BoxDecoration(
          color: HexColor('#DF2E38'),
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
        ),
        alignment: Alignment.center,
        width: MediaQuery.of(context).size.height / 3.5,
        height: MediaQuery.of(context).size.height / 3.5,
        child: Text(
          'Absen Keluar',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
    );
  }
}
