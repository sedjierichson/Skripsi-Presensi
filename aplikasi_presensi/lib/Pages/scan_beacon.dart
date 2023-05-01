// ignore_for_file: use_build_context_synchronously, prefer_const_constructors

import 'package:aplikasi_presensi/Pages/ambil_foto.dart';
import 'package:aplikasi_presensi/Pages/bottom_navbar.dart';
import 'package:aplikasi_presensi/api/dbservices_presensi.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:aplikasi_presensi/globals.dart' as globals;
import 'package:quickalert/quickalert.dart';

class scanBeaconPage extends StatefulWidget {
  const scanBeaconPage({super.key});

  @override
  State<scanBeaconPage> createState() => _scanBeaconPageState();
}

class _scanBeaconPageState extends State<scanBeaconPage> {
  FlutterBluePlus flutterBlue = FlutterBluePlus.instance;
  late final BluetoothDevice device;
  PresensiService dbPresensi = PresensiService();
  bool hasilScanAdaSama = false;
  bool isLoading = true;
  List<String> beacon = [];
  String? uuiddd;

  List<ScanResult> scanResultList = [];
  var scan_mode = 0;
  bool isScanning = false;
  List<String> hasilbeacon = [];

  // List<String> uuidScanAdaSama = [
  //   '32a6d2-4693-8a-4ffaf50af319',
  //   '32a66425-26d2-4693-859a-4ffaf50af319',
  //   'aaaa',
  //   'bbbbbb'
  // ];
  // List<String> uuidScanTidakAdaSama = [
  //   '32a65-26d2-4-859a-4ffaf50af319',
  //   '32a65-26d2-4693-8afa0af319',
  //   '02129fd8-e302-479c-8450d509'
  // ];

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

  void pindahAmbilFoto(String uuid) {
    Navigator.of(context, rootNavigator: true)
        .pushReplacement(MaterialPageRoute(builder: (context) {
      return AmbilFoto(
        uuid: uuid,
      );
    }));
  }

  void getBeacon() async {
    print(hasilbeacon[0]);
    try {
      beacon = await dbPresensi.getBeaconPresensi();
      for (int i = 0; i < beacon.length; i++) {
        var hasil = hasilbeacon.contains(beacon[i].toString());
        print("Beacon yang sama adalah : " + beacon[i]);
        if (hasil == true) {
          pindahAmbilFoto(beacon[i]);
          setState(() {
            hasilScanAdaSama = true;
            isLoading = false;
          });
          break;
        } else {
          setState(() {
            hasilScanAdaSama = false;
            isLoading = false;
          });
          globals.showAlertError(
              context: context,
              message:
                  'Beacon tidak terdeteksi. Kembali ke halaman beranda...');
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) {
                return BottomNavBar();
              },
            ),
            (route) => false,
          );
          // Future.delayed(const Duration(seconds: 3), () {
          //   Navigator.pop(context);
          // });

          break;
        }
      }
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  void initState() {
    setState(() {
      isLoading = true;
    });
    toggleState();
    Future.delayed(const Duration(seconds: 5), () {
      getBeacon();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              isLoading == true ? loadingAnimation() : SizedBox(),
              // hasilScanAdaSama == true ? SizedBox() : errorTidakAdaBeacon()
            ],
          ),
        ),
      ),
    );
  }

  Widget loadingAnimation() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        LoadingAnimationWidget.discreteCircle(
          color: HexColor('#13542D'),
          secondRingColor: HexColor('#C3CF0A'),
          thirdRingColor: HexColor('FFA133'),
          size: 70,
        ),
        SizedBox(
          height: 50,
        ),
        Text(
          'Mendeteksi beacon presensi...',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(
          height: 20,
        ),
        Text(
          'Pastikan anda berada didalam area kantor',
          style: TextStyle(
            fontSize: 15,
          ),
          textAlign: TextAlign.center,
        )
      ],
    );
  }

  Widget errorTidakAdaBeacon() {
    return Column(
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width / 4,
          child: Image.asset(
            "assets/images/cross.png",
            fit: BoxFit.contain,
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Text(
          'BEACON TIDAK TERDETEKSI',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(
          height: 20,
        ),
        InkWell(
          onTap: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) {
                  return BottomNavBar();
                },
              ),
              (route) => false,
            );
          },
          child: Container(
            alignment: Alignment.center,
            height: 40,
            width: MediaQuery.of(context).size.width / 2,
            decoration: BoxDecoration(
              color: HexColor('#13542D'),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              'Kembali ke Beranda',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        )
      ],
    );
  }
}
