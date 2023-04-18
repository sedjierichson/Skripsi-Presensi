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
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
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
  String tempKategori = "";
  late final BluetoothDevice device;
  FlutterBluePlus flutterBlue = FlutterBluePlus.instance;

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

  @override
  void initState() {
    setState(() {
      sudahAbsenMasuk = false;
    });
    cekSudahAbsen();
    // toggleState();
    super.initState();
    jamSekarang = _format(DateTime.now());
    Timer.periodic(Duration(seconds: 1), (timer) => getTime());
  }

  void getJamMasukKerja() async {
    String hari = DateFormat('EEEE').format(DateTime.now());
    try {
      var jam = "09:00:00";
      var res = await dbPresensi.getJamKerja(hari: hari);
      print(res['jam_masuk']);
      // print(jamSekarang);
      var temp = jamSekarang.compareTo(res['jam_masuk'].toString());
      if (temp < 0) {
        insertAbsenMasuk(kategori: "A");
      } else if (temp > 0) {
        insertAbsenMasuk(kategori: "B");
      } else {
        insertAbsenMasuk(kategori: "A");
      }
    } catch (e) {
      print(e.toString());
    }
  }

  void insertAbsenMasuk({required String kategori}) async {
    try {
      var res = await dbPresensi.insertAbsenMasuk(
          globals.pegawai.read('nik'),
          1,
          tanggalAbsen.toString(),
          jamSekarang,
          "tempImage",
          "tempImage",
          kategori);
      if (res['status'] == 1) {
        globals.showAlertBerhasil(
            context: context, message: 'Berhasil absen masuk');
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (BuildContext context) => super.widget));
      }
      print(res['status']);
    } catch (e) {
      print(e.toString());
    }
  }

  void daftarkanImei(String imeix) async {
    try {
      await db.updateIMEI(globals.pegawai.read('nik'), imeix.toString());
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
      if (globals.pegawai.read('imei') != imeiBaru) {
        print('LOGOUTTTT');
      } else {
        print('cocok');
      }
    } else if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      setState(() {
        imeiBaru = iosInfo.identifierForVendor!.toString();
      });
      if (globals.pegawai.read('imei') != imeiBaru) {
        print('LOGOUTTTT');
      } else {
        print('cocok');
      }
    }
  }

  void cekSudahAbsen() async {
    try {
      var res = await dbPresensi.cekSudahAbsen(
          nik: globals.pegawai.read('nik'), tanggal: tanggalAbsen);
      if (res['jam_keluar'] == null) {
        print('absen belum lengkap');
        if (res['status'] == 1) {
          setState(() {
            sudahAbsenMasuk = true;
            idPresensi = res['id']?.toString();
            jamMasuk = res['jam_masuk'].toString();
            jamKeluar = res['jam_keluar'].toString();
            tempKategori = res['kategori'].toString();
          });
        } else {
          setState(() {
            sudahAbsenMasuk = false;
          });
        }
      } else {
        print('absen ulang');
        if (res['status'] == 1) {
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
      print(e.toString());
      // globals.showAlertError(context: context, message: e.toString());
    }
  }

  void getImeiBaru() async {
    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      setState(() {
        imeiBaru = androidInfo.serialNumber.toString();
      });
      daftarkanImei(imeiBaru);
    } else if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      setState(() {
        imeiBaru = iosInfo.identifierForVendor!.toString();
      });
      daftarkanImei(imeiBaru);
    }
  }

  void updateKategori(String kategori) async {
    // cekSudahAbsen();
    try {
      await dbPresensi.updateKategori(idPresensi.toString(), kategori);
      // globals.showAlertBerhasil(
      //     context: context, message: 'Absen keluar berhasil');
      // Navigator.pushReplacement(context,
      //     MaterialPageRoute(builder: (BuildContext context) => super.widget));
    } catch (e) {
      print(e.toString());
      // globals.showAlertError(context: context, message: e.toString());
    }
  }

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

  void getJamPulangKerja() async {
    String hari = DateFormat('EEEE').format(DateTime.now());
    try {
      var jam = "17:00:00";
      var res = await dbPresensi.getJamKerja(hari: hari);
      print(res['jam_pulang']);
      // print(jamSekarang)
      var temp = jamSekarang.compareTo(res['jam_pulang'].toString());
      //Masuk (A atau C) Pulang ok
      //Masuk (B dan D) & pulang ok
      //Masuk (A atau C) pulang not ok
      //Masuk (B atau D) pulang not ok
      if (temp < 0) {
        print('Lebih Cepat not ok');
        if (tempKategori == "A") {
          //Kategori C
          updateKategori('C');
        } else if (tempKategori == "B") {
          //Kategori D
          updateKategori('D');
        }
      } else if (temp > 0) {
        print('Lewat jam pulang ok');
        if (tempKategori == "A") {
          //Kategori A
          // updateKategori('A');
        } else if (tempKategori == "B") {
          //Kategori B
          updateKategori('B');
        }
        // insertAbsenMasuk(kategori: "B");
      } else {
        print('Jam pulang ok');
        if (tempKategori == "A") {
          //Kategori A
          // updateKategori('C');
        } else if (tempKategori == "B") {
          //Kategori B
          updateKategori('B');
        }
      }
    } catch (e) {
      print(e.toString());
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
    return DateFormat("HH:mm:ss").format(dateTime);
  }

  //-----
  //final tanggal = DateTime.now();

  //BEACON
  String Caa = "";
  void turn() async {
    List<BluetoothService> s = await device.discoverServices();
    s.forEach((element) async {
      Caa = element.uuid.toString();
    });
  }

  void toggleState() {
    print('scanning nyala');

    // if (isScanning) {
    flutterBlue.startScan(scanMode: ScanMode(0), allowDuplicates: true);
    scan();
    turn();
    // }
    Future.delayed(const Duration(seconds: 4), () {
      flutterBlue.stopScan();
      // isLoading = false;
      // print(scanResultList.length);
    });

    setState(() {});
  }

  void scan() async {
    // if (isScanning) {
    flutterBlue.scan();
    // Listen to scan results
    // flutterBlue.startScan(withDevices: g);
    // flutterBlue.scanResults.listen((results) {
    //   // print('masuk');
    //   // do something with scan results
    //   scanResultList = results;
    //   // print(scanResultList.length);

    //   // update state
    //   setState(() {});
    // });
    // }
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
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Hi, ' + globals.pegawai.read('nama'),
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
                            'NIK : ' + globals.pegawai.read('nik'),
                            style: TextStyle(
                              fontSize: 12,
                            ),
                          ),
                          Text(' | '),
                          Text(
                            globals.pegawai.read('jabatan'),
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
        // getJamMasukKerja();
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
        getJamPulangKerja();
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
