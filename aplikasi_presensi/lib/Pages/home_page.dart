// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_interpolation_to_compose_strings, avoid_print, use_build_context_synchronously

import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:aplikasi_presensi/Pages/ambil_foto.dart';
import 'package:aplikasi_presensi/Pages/scan_beacon.dart';
import 'package:aplikasi_presensi/api/dbservices_presensi.dart';
import 'package:aplikasi_presensi/api/dbservices_user.dart';
import 'package:aplikasi_presensi/api/notification_api.dart';
import 'package:aplikasi_presensi/models/presensi.dart';
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
  PresensiService dbPresensi2 = PresensiService();
  String tanggalAbsen = DateFormat('yyyy-MM-dd').format(DateTime.now());
  bool sudahAbsenMasuk = false;
  bool absenHistory = false;
  String? idPresensi;
  String jamMasuk = "--:--";
  String jamKeluar = "--:--";
  String jamKerja = "--:--";
  String tempKategori = "";
  String jamBeaconTidakTerdeteksi = '';
  // late final BluetoothDevice device;
  FlutterBluePlus flutterBlue = FlutterBluePlus.instance;
  Timer? timer;
  bool isLoading = true;
  List<ScanResult> scanResultList = [];
  List<String> hasilbeacon = [];
  List<String> beacon = [];
  bool hasilScanAdaSama = false;
  String idPresensiHistory = '';
  Presensi? presensiHistory;

  void pindahScanBeacon() {
    Navigator.of(context, rootNavigator: true)
        .push(MaterialPageRoute(builder: (context) {
      return scanBeaconPage();
    }));
  }

  void pindahAmbilFoto(String uuid) {
    Navigator.of(context, rootNavigator: true)
        .pushReplacement(MaterialPageRoute(builder: (context) {
      return AmbilFoto(
        uuid: '1',
      );
    }));
  }

  void getJamMasukKerja({required int isHistory}) async {
    String hari = DateFormat('EEEE').format(DateTime.now());
    // print(hari);
    try {
      var jam = "09:00:00";
      var res = await dbPresensi.getJamKerja(hari: hari);
      var temp = jamSekarang.compareTo(res['jam_masuk'].toString());
      if (temp < 0) {
        insertAbsenMasukKlikTombol(kategori: "A", isHistory: isHistory);
      } else if (temp > 0) {
        insertAbsenMasukKlikTombol(kategori: "B", isHistory: isHistory);
      } else {
        insertAbsenMasukKlikTombol(kategori: "A", isHistory: isHistory);
      }
    } catch (e) {
      print(e.toString());
    }
  }

  void getJamKeluarIsHistory() async {
    String hari = DateFormat('EEEE').format(DateTime.now());
    // print(hari);
    try {
      var res = await dbPresensi.getJamKerja(hari: hari);
      var temp = jamSekarang.compareTo(res['jam_masuk'].toString());
      if (temp < 0) {
        insertAbsenMasukKlikTombol(kategori: "A", isHistory: 1);
      } else if (temp > 0) {
        insertAbsenMasukKlikTombol(kategori: "B", isHistory: 1);
      } else {
        insertAbsenMasukKlikTombol(kategori: "A", isHistory: 1);
      }
      setState(() {
        absenHistory = true;
      });
    } catch (e) {
      print(e.toString());
    }
  }

  void insertAbsenMasukKlikTombol(
      {required String kategori, required int isHistory}) async {
    //klik tombol untuk harian (not history keluar masuk)
    setState(() {
      absenHistory = true;
    });
    try {
      var res = await dbPresensi.insertAbsenMasuk(
          globals.pegawai.read('nik'),
          1,
          tanggalAbsen.toString(),
          jamSekarang,
          "tempImage",
          "tempImage",
          kategori,
          isHistory);
      if (res['status'] == 1) {
        // globals.showAlertBerhasil(
        //     context: context, message: 'Berhasil absen masuk');
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (BuildContext context) => super.widget));
      }
      // print(res['status']);
    } catch (e) {
      print(e.toString());
    }
  }

  void insertHistoryAbsenKeluarOtomatis() async {
    //klik tombol untuk harian (not history keluar masuk)
    setState(() {
      absenHistory = true;
    });
    try {
      var res = await dbPresensi.insertAbsenMasuk(
          globals.pegawai.read('nik'),
          999,
          tanggalAbsen.toString(),
          jamSekarang,
          "history",
          "history",
          "D",
          1);
      if (res['status'] == 1) {
        setState(() {
          idPresensiHistory = res['message'];
          print("id presensi history = " + idPresensiHistory);
          globals.pegawai.write('idhistory', idPresensiHistory);
        });
        // globals.showAlertBerhasil(
        //     context: context, message: 'Berhasil absen masuk');
        // Navigator.pushReplacement(context,
        //     MaterialPageRoute(builder: (BuildContext context) => super.widget));
      }
      // print(res['status']);
    } catch (e) {
      print(e.toString());
    }
  }

  void cekSudahAbsen() async {
    try {
      var res = await dbPresensi.cekSudahAbsen(
          nik: globals.pegawai.read('nik'), tanggal: tanggalAbsen);
      // if (res['jam_keluar'] == null) {
      // print('absen belum lengkap');
      if (res['status'] == 1) {
        if (res['jam_keluar'] != null && res['jam_masuk'] != null) {
          setState(() {
            sudahAbsenMasuk = false;
            jamMasuk = res['jam_masuk'].toString();
            jamKeluar = res['jam_keluar'].toString();
            jamKerja = res['jam_kerja'].toString();
          });
        } else {
          setState(() {
            sudahAbsenMasuk = true;
            idPresensi = res['id']?.toString();
            jamMasuk = res['jam_masuk'].toString();
            jamKeluar = res['jam_keluar'].toString();
            tempKategori = res['kategori'].toString();
          });
        }
      } else {
        setState(() {
          sudahAbsenMasuk = false;
        });
      }
      // } else {
      // print('absen ulang');
      // if (res['status'] == 1) {
      //   setState(() {
      //     sudahAbsenMasuk = false;
      //     idPresensi = res['message'];
      //   });
      // } else {
      //   // print('belum absen');
      //   setState(() {
      //     sudahAbsenMasuk = true;
      //   });
      // }
      // }
    } catch (e) {
      print(e.toString());
    }
    print('state = ' + sudahAbsenMasuk.toString());
  }

  void checkBeacon() {
    // if (sudahAbsenMasuk == true) {
    //Scanning bluetooth
    timer = Timer.periodic(Duration(seconds: 6), (timer) {
      print('scanning bluetooth lagi');
      setState(() {
        hasilbeacon = [];
        scanResultList = [];
        beacon = [];
      });
      toggleState();

      Future.delayed(const Duration(seconds: 5), () {
        getBeacon();
      });
    });
    // }
  }

  void toggleState() async {
    try {
      await for (final state
          in flutterBlue.state.timeout(const Duration(seconds: 5))) {
        if (state == BluetoothState.on) {
          flutterBlue.startScan(allowDuplicates: true);
          scan();
          Future.delayed(const Duration(seconds: 4), () {
            flutterBlue.stopScan();
            isLoading = false;
            for (int i = 0; i < scanResultList.length; i++) {
              if (scanResultList[i].advertisementData.serviceUuids.toString() !=
                  "[]") {
                // print(scanResultList[i]
                //     .advertisementData
                //     .serviceUuids
                //     .toString()
                //     .toLowerCase());
                String temp = scanResultList[i]
                    .advertisementData
                    .serviceUuids
                    .toString()
                    .toLowerCase();

                hasilbeacon.add(temp.substring(1, temp.length - 1));
              }
            }
          });
        }
      }
    } catch (e) {
      print(e.toString());
    }
  }

  void scan() async {
    flutterBlue.scanResults.listen((results) {
      scanResultList = results;
    });
  }

  void getBeacon() async {
    try {
      beacon = await dbPresensi.getBeaconPresensi();
      for (int i = 0; i < beacon.length; i++) {
        var hasil = hasilbeacon.contains(beacon[i].toString());

        if (hasil == false) {
          //simpan jam beacon tidak terdeteksi
          setState(() {
            jamBeaconTidakTerdeteksi = jamSekarang;
          });

          //Kalau sudah absen masuk & beacon tidak ada
          // if (sudahAbsenMasuk == true) {
          //   NotificationWidget.showNotification(
          //     title: "Presensi PT X",
          //     body: 'Beacon tidak terdeteksi!',
          //   );
          // }
          //kalau sudah absen masuk, tapi belum meninggalkan kantor
          if (absenHistory == false && sudahAbsenMasuk == true) {
            //kalau sudah absen masuk harian & tidak ada beacon
            print('absen keluar is history');
            //catat jam keluar
            insertHistoryAbsenKeluarOtomatis();
          }
          // getJamPulangKerja();
          // timer?.cancel();
          setState(() {
            hasilScanAdaSama = false;
            isLoading = false;
          });
          break;
        } else {
          //ada beacon
          // Keluar kantor -> Kembali ke kantor & beacon terdeteksi
          if (absenHistory == true && sudahAbsenMasuk == true) {
            //Update jam kembali setelah meninggalkan kantor
            print('update history kembali is history');
            updateHistoryJamKembali();
            // setState(() {
            //   absenHistory = false;
            // });
          }
          // Ada beacon & belum absen masuk harian
          else if (sudahAbsenMasuk == false) {
            // Berada di kantor tapi belum absen masuk harian
            print('baru datang kantor, belum absen');
            NotificationWidget.showNotification(
              title: "Presensi PT X",
              body:
                  'Beacon presensi terdeteksi ! Silahkan lakukan presensi masuk !',
            );
          }
          setState(() {
            hasilScanAdaSama = true;
            isLoading = false;
          });
          break;
        }
      }
    } catch (e) {
      print(e.toString());
    }
  }

  void updateKategori(String kategori) async {
    // cekSudahAbsen();
    try {
      await dbPresensi.updateKategori(idPresensi.toString(), kategori);
    } catch (e) {
      print(e.toString());
    }
  }

  void updateJamKeluar({required String jam}) async {
    try {
      await dbPresensi.updateJamKeluar(
          globals.pegawai.read('nik'), idPresensi.toString(), jam);
      globals.showAlertBerhasil(
          context: context, message: 'Absen keluar berhasil');
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (BuildContext context) => super.widget));
    } catch (e) {
      globals.showAlertError(context: context, message: e.toString());
    }
    // timer?.cancel();
  }

  void updateHistoryJamKembali() async {
    try {
      await dbPresensi.updateHistoryJamKembali(
        nik: globals.pegawai.read('nik'),
        jam: jamSekarang,
        tanggal: tanggalAbsen.toString(),
      );
      setState(() {
        absenHistory = false;
      });
    } catch (e) {
      globals.showAlertError(context: context, message: e.toString());
    }
  }

  void checkoutMasihAdaBeacon() async {
    String hari = DateFormat('EEEE').format(DateTime.now());
    try {
      var res = await dbPresensi.getJamKerja(hari: hari);
      var temp = jamSekarang.compareTo(res['jam_pulang'].toString());
      //Masuk (A atau C) Pulang ok
      //Masuk (B dan D) & pulang ok
      //Masuk (A atau C) pulang not ok
      //Masuk (B atau D) pulang not ok
      if (temp < 0) {
        // print('Lebih Cepat not ok');
        if (tempKategori == "A") {
          //Kategori C
          updateKategori('C');
        } else if (tempKategori == "B") {
          //Kategori D
          updateKategori('D');
        }
      } else if (temp == 0) {
        if (tempKategori == "B") {
          //Kategori B
          updateKategori('B');
        }
      }
    } catch (e) {
      print(e.toString());
    }
    updateJamKeluar(jam: jamSekarang);
  }

  void checkoutTidakAdaBeacon() async {
    String hari = DateFormat('EEEE').format(DateTime.now());
    try {
      var res = await dbPresensi.getJamKerja(hari: hari);
      presensiHistory = await dbPresensi.gethistoryPresensi(
          id: globals.pegawai.read('idhistory'));
      print("aaa" + presensiHistory!.jamKeluar.toString());
      var temp = presensiHistory!.jamKeluar
          .toString()
          .compareTo(res['jam_pulang'].toString());
      //Masuk (A atau C) Pulang ok
      //Masuk (B dan D) & pulang ok
      //Masuk (A atau C) pulang not ok
      //Masuk (B atau D) pulang not ok
      if (temp < 0) {
        // print('Lebih Cepat not ok');
        if (tempKategori == "A") {
          //Kategori C
          updateKategori('C');
        } else if (tempKategori == "B") {
          //Kategori D
          updateKategori('D');
        }
      } else if (temp > 0) {
        // print('Lewat jam pulang ok');
        if (tempKategori == "A") {
          //Kategori A
          // updateKategori('A');
        } else if (tempKategori == "B") {
          //Kategori B
          // updateKategori('B');
        }
        // insertAbsenMasuk(kategori: "B");
      } else {
        // print('Jam pulang ok');
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
    updateJamKeluar(jam: presensiHistory!.jamKeluar.toString());
    // updateJamKeluar(jam: jamSekarang.toString());
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

  @override
  void initState() {
    NotificationWidget.init();
    cekSudahAbsen();
    Future.delayed(const Duration(seconds: 5), () {
      checkBeacon();
    });
    jamSekarang = _format(DateTime.now());
    Timer.periodic(Duration(seconds: 1), (timer) => getTime());
    super.initState();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
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
                    height: 50,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        //Kembali dari pergi
                        // ElevatedButton(
                        //   onPressed: () {
                        //     updateHistoryJamKembali();
                        //   },
                        //   child: Text('Presensi Kembali History otomatis'),
                        // ),

                        // ElevatedButton(
                        //   onPressed: () {
                        //     insertHistoryAbsenKeluarOtomatis();
                        //   },
                        //   child: Text('Presensi Keluar Otomatis History'),
                        // ),
                        // ElevatedButton(
                        //   onPressed: () {
                        //     checkoutTidakAdaBeacon();
                        //   },
                        //   child:
                        //       Text('Presensi Keluar Manual tidak ada beacon'),
                        // ),

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
                              jamMasuk == 'null' ? '--:--' : jamMasuk,
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
                              jamKeluar == 'null' ? '--:--' : jamKeluar,
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
                              jamKerja.isNotEmpty ? jamKerja : '--:--',
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
        // getJamMasukKerja(isHistory: 0);
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
        width: MediaQuery.of(context).size.height / 3,
        height: MediaQuery.of(context).size.height / 3,
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
        if (hasilScanAdaSama == false) {
          //absen pulang tapi sudah tidak ada beacon
          checkoutTidakAdaBeacon();
        } else {
          //absen pulang tapi masih ada beacon
          checkoutMasihAdaBeacon();
        }
        // checkoutMasihAdaBeacon();
      },
      child: Container(
        decoration: BoxDecoration(
          color: HexColor('#DF2E38'),
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
        ),
        alignment: Alignment.center,
        width: MediaQuery.of(context).size.height / 3,
        height: MediaQuery.of(context).size.height / 3,
        child: Text(
          'Absen Keluar',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
    );
  }
}
