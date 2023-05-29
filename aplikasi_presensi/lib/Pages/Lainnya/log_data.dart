import 'dart:async';

import 'package:aplikasi_presensi/api/dbservices_log.dart';
import 'package:aplikasi_presensi/api/dbservices_presensi.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:intl/intl.dart';

class LogData extends StatefulWidget {
  const LogData({super.key});

  @override
  State<LogData> createState() => _LogDataState();
}

class _LogDataState extends State<LogData> {
  FlutterBluePlus flutterBlue = FlutterBluePlus.instance;
  late final BluetoothDevice device;
  bool hasilScanAdaSama = false;
  LogService dbLog = LogService();
  String jamSekarang = '';
  List<String> hasilbeacon = [];
  List<ScanResult> scanResultList = [];
  PresensiService dbPresensi = PresensiService();
  List<String> beacon = [];
  Timer? timer;

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

  @override
  void initState() {
    getBeacon();
    Timer.periodic(Duration(seconds: 1), (timer) => getTime());
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
                              jarak: "5", keterangan: "tanpa penghalang");
                        },
                        child: Text('5 meter'),
                      ),
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
                              jarak: "15", keterangan: "tanpa penghalang");
                        },
                        child: Text('15 meter'),
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
                              jarak: "25", keterangan: "tanpa penghalang");
                        },
                        child: Text('25 meter'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          checkBeacon(
                              jarak: "30", keterangan: "tanpa penghalang");
                        },
                        child: Text('30 meter'),
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
                              jarak: "5", keterangan: "penghalang pintu kaca");
                        },
                        child: Text('5 meter'),
                      ),
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
                              jarak: "15", keterangan: "penghalang pintu kaca");
                        },
                        child: Text('15 meter'),
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
                              jarak: "25", keterangan: "penghalang pintu kaca");
                        },
                        child: Text('25 meter'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          checkBeacon(
                              jarak: "30", keterangan: "penghalang pintu kaca");
                        },
                        child: Text('30 meter'),
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
                              jarak: "5", keterangan: "penghalang tembok");
                        },
                        child: Text('5 meter'),
                      ),
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
                              jarak: "15", keterangan: "penghalang tembok");
                        },
                        child: Text('15 meter'),
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
                              jarak: "25", keterangan: "penghalang tembok");
                        },
                        child: Text('25 meter'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          checkBeacon(
                              jarak: "30", keterangan: "penghalang tembok");
                        },
                        child: Text('30 meter'),
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
                              jarak: "5", keterangan: "penghalang badan");
                        },
                        child: Text('5 meter'),
                      ),
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
                              jarak: "15", keterangan: "penghalang badan");
                        },
                        child: Text('15 meter'),
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
                              jarak: "25", keterangan: "penghalang badan");
                        },
                        child: Text('25 meter'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          checkBeacon(
                              jarak: "30", keterangan: "penghalang badan");
                        },
                        child: Text('30 meter'),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
