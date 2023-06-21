import 'dart:async';

import 'package:aplikasi_presensi/api/dbservices_log.dart';
import 'package:aplikasi_presensi/api/dbservices_presensi.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:intl/intl.dart';
import 'package:aplikasi_presensi/globals.dart' as globals;

class LogData extends StatefulWidget {
  const LogData({super.key});

  @override
  State<LogData> createState() => _LogDataState();
}

class _LogDataState extends State<LogData> {
  FlutterBluePlus flutterBlue = FlutterBluePlus.instance;
  String tanggalAbsen = DateFormat('yyyy-MM-dd').format(DateTime.now());
  late final BluetoothDevice device;
  bool hasilScanAdaSama = false;
  LogService dbLog = LogService();
  String jamSekarang = '';
  List<String> hasilbeacon = [];
  List<ScanResult> scanResultList = [];
  PresensiService dbPresensi = PresensiService();
  List<String> beacon = [];
  Timer? timer;
  Timer? timer2;
  String idPresensiHistory = '';

  void insertLog(
      {required String jarak,
      required String jam,
      required String keterangan}) async {
    try {
      await dbLog.insertLogBeacon(
          jarak: jarak, jam: jam, keterangan: keterangan);
    } catch (e) {
      print(e.toString());
    }
  }

  void checkBeacon({required String jarak, required String keterangan}) {
    timer = Timer.periodic(Duration(seconds: 5), (timer) {
      // print('scanning bluetooth lagi');
      print(jamSekarang);
      setState(() {
        hasilbeacon = [];
        scanResultList = [];
      });
      toggleState(jarak: jarak, keterangan: keterangan);
    });
    Future.delayed(const Duration(seconds: 70), () {
      timer?.cancel();
    });
  }

  void toggleState({required String jarak, required String keterangan}) async {
    try {
      await for (final state
          in flutterBlue.state.timeout(const Duration(seconds: 5))) {
        if (state == BluetoothState.on) {
          flutterBlue.startScan(allowDuplicates: true);
          scan();
          Future.delayed(const Duration(seconds: 1), () {
            flutterBlue.stopScan();
            for (int i = 0; i < scanResultList.length; i++) {
              if (scanResultList[i].advertisementData.serviceUuids.toString() !=
                  "[]") {
                String temp = scanResultList[i]
                    .advertisementData
                    .serviceUuids
                    .toString()
                    .toLowerCase();

                hasilbeacon.add(temp.substring(1, temp.length - 1));
              }
            }
            compareBeacon(jarak: jarak, keterangan: keterangan);
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
    } catch (e) {
      print(e.toString());
    }
  }

  void compareBeacon(
      {required String jarak, required String keterangan}) async {
    if (hasilbeacon.any((element) => beacon.contains(element))) {
      insertLog(jarak: jarak, jam: jamSekarang, keterangan: keterangan);
    } else {
      print('tidak ada beacon');
    }
  }

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

  void checkKoneksiInternet(bool res) async {
    // globals.pegawai.remove('jam_offline');

    // bool result = await InternetConnectionChecker().hasConnection;
    if (res == true) {
      if (globals.pegawai.read('jam_offline') == null) {
        globals.pegawai.write('jam_offline', DateTime.now().toIso8601String());
      } else {
        DateTime temp = DateTime.parse(globals.pegawai.read('jam_offline'));
        DateTime temp2 = DateTime.now();
        //membandingkan perbedaan waktu terakhir & waktu sekarang
        int diff = temp2.difference(temp).inSeconds;
        print('Jam Online = ' + DateTime.now().toString());
        print('Perbedaan = ' + diff.toString());
        if (diff > 5) {
          //catat sebagai history
          insertHistoryAbsenKeluarOtomatis(
              DateFormat("HH:mm:ss").format(temp).toString(),
              DateFormat("HH:mm:ss").format(temp2).toString());
          globals.pegawai.remove('jam_offline');
        } else {
          // catat jam offline hanya kalau belum tercatat di local storage
          // if (globals.pegawai.read('jam_offline') == null) {
          globals.pegawai.remove('jam_offline');
          globals.pegawai
              .write('jam_offline', DateTime.now().toIso8601String());
          // }
        }
      }
    } else {
      if (globals.pegawai.read('jam_offline') == null) {
        globals.pegawai.remove('jam_offline');
        globals.pegawai.write('jam_offline', DateTime.now().toIso8601String());
      } else {
        print('offline tercatat');
      }
      print('Jam offline = ' + globals.pegawai.read('jam_offline').toString());
    }
  }

  void insertHistoryAbsenKeluarOtomatis(
      String jamKeluar, String jamKembali) async {
    //klik tombol untuk harian (not history keluar masuk)
    try {
      var res = await dbPresensi.insertAbsenMasuk(
          globals.pegawai.read('nik'),
          999,
          tanggalAbsen.toString(),
          jamKeluar,
          "history",
          "history",
          "D",
          1);
      if (res['status'] == 1) {
        setState(() {
          idPresensiHistory = res['message'];
          globals.pegawai.write('idhistory', idPresensiHistory);
        });
      }
    } catch (e) {
      print(e.toString());
    }
    updateHistoryJamKembali(jamKembali);
  }

  void updateHistoryJamKembali(String jam) async {
    try {
      await dbPresensi.updateHistoryJamKembali(
        nik: globals.pegawai.read('nik'),
        jam: jam,
        tanggal: tanggalAbsen.toString(),
      );
    } catch (e) {
      globals.showAlertError(context: context, message: e.toString());
    }
  }

  @override
  void initState() {
    getBeacon();
    Timer.periodic(Duration(seconds: 1), (timer) => getTime());
    // timer2 = Timer.periodic(Duration(seconds: 5), (timer) {
    //   checkKoneksiInternet();
    // });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Tanpa Penghalang'),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          checkBeacon(
                              jarak: "10", keterangan: "tanpa penghalang");
                        },
                        child: Text('10 meter'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          checkBeacon(
                              jarak: "20", keterangan: "tanpa penghalang");
                        },
                        child: Text('20 meter'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          checkBeacon(
                              jarak: "30", keterangan: "tanpa penghalang");
                        },
                        child: Text('30 meter'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          checkBeacon(
                              jarak: "35", keterangan: "tanpa penghalang");
                        },
                        child: Text('35 meter'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          checkBeacon(
                              jarak: "40", keterangan: "tanpa penghalang");
                        },
                        child: Text('40 meter'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          checkBeacon(
                              jarak: "45", keterangan: "tanpa penghalang");
                        },
                        child: Text('45 meter'),
                      ),
                    ],
                  ),
                ),
                Text('Penghalang Pintu Kaca'),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          checkBeacon(
                              jarak: "10", keterangan: "penghalang pintu kaca");
                        },
                        child: Text('10 meter'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          checkBeacon(
                              jarak: "20", keterangan: "penghalang pintu kaca");
                        },
                        child: Text('20 meter'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          checkBeacon(
                              jarak: "30", keterangan: "penghalang pintu kaca");
                        },
                        child: Text('30 meter'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          checkBeacon(
                              jarak: "35", keterangan: "penghalang pintu kaca");
                        },
                        child: Text('35 meter'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          checkBeacon(
                              jarak: "40", keterangan: "penghalang pintu kaca");
                        },
                        child: Text('40 meter'),
                      ),
                    ],
                  ),
                ),
                Text('Penghalang Tembok'),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          checkBeacon(
                              jarak: "10", keterangan: "penghalang tembok");
                        },
                        child: Text('10 meter'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          checkBeacon(
                              jarak: "20", keterangan: "penghalang tembok");
                        },
                        child: Text('20 meter'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          checkBeacon(
                              jarak: "30", keterangan: "penghalang tembok");
                        },
                        child: Text('30 meter'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          checkBeacon(
                              jarak: "35", keterangan: "penghalang tembok");
                        },
                        child: Text('35 meter'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          checkBeacon(
                              jarak: "40", keterangan: "penghalang tembok");
                        },
                        child: Text('40 meter'),
                      ),
                    ],
                  ),
                ),
                Text('Penghalang Badan'),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          checkBeacon(
                              jarak: "10", keterangan: "penghalang badan");
                        },
                        child: Text('10 meter'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          checkBeacon(
                              jarak: "20", keterangan: "penghalang badan");
                        },
                        child: Text('20 meter'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          checkBeacon(
                              jarak: "30", keterangan: "penghalang badan");
                        },
                        child: Text('30 meter'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          checkBeacon(
                              jarak: "35", keterangan: "penghalang badan");
                        },
                        child: Text('35 meter'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          checkBeacon(
                              jarak: "40", keterangan: "penghalang badan");
                        },
                        child: Text('40 meter'),
                      ),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    checkKoneksiInternet(true);
                  },
                  child: Text('check koneksi online'),
                ),
                ElevatedButton(
                  onPressed: () {
                    checkKoneksiInternet(false);
                  },
                  child: Text('check koneksi offline'),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
