import 'package:aplikasi_presensi/Pages/ambil_foto.dart';
import 'package:aplikasi_presensi/api/dbservices_presensi.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:aplikasi_presensi/globals.dart' as globals;

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

  List<String> uuidScanAdaSama = [
    '32a6d2-4693-8a-4ffaf50af319',
    '32a66425-26d2-4693-859a-4ffaf50af319',
    'aaaa',
    'bbbbbb'
  ];
  List<String> uuidScanTidakAdaSama = [
    '32a65-26d2-4-859a-4ffaf50af319',
    '32a65-26d2-4693-8afa0af319',
    '02129fd8-e302-479c-8450d509'
  ];

  String Caa = "";
  void turn() async {
    List<BluetoothService> s = await device.discoverServices();
    s.forEach((element) async {
      Caa = element.uuid.toString();
    });
  }

  void toggleState() {
    print('scanning nyala');
    // Future.delayed(const Duration(seconds: 3), () {
    //   Navigator.pushReplacement(
    //       context,
    //       MaterialPageRoute(
    //         builder: (context) => super.widget,
    //       ));
    // });
    // isScanning = !isScanning;

    // if (isScanning) {
    flutterBlue.startScan(scanMode: ScanMode(scan_mode), allowDuplicates: true);
    scan();
    turn();
    // }
    Future.delayed(const Duration(seconds: 4), () {
      flutterBlue.stopScan();
      isLoading = false;
      print(scanResultList.length);
      for (int i = 0; i < scanResultList.length; i++) {
        if (scanResultList[i].advertisementData.serviceUuids.toString() !=
            "[]") {
          print(scanResultList[i]
              .advertisementData
              .serviceUuids
              .toString()
              .toLowerCase());
          String temp = scanResultList[i]
              .advertisementData
              .serviceUuids
              .toString()
              .toLowerCase();
          print('x' + temp.substring(1, temp.length - 1) + 'x');

          hasilbeacon.add(temp.substring(1, temp.length - 1));
        }
      }
    });

    setState(() {});
  }

  void scan() async {
    // if (isScanning) {
    flutterBlue.scan();
    // Listen to scan results
    // flutterBlue.startScan(withDevices: g);
    flutterBlue.scanResults.listen((results) {
      // print('masuk');
      // do something with scan results
      scanResultList = results;
      // print(scanResultList.length);

      // update state
      setState(() {});
    });
    // }
  }

  void pindahAmbilFoto() {
    Navigator.of(context, rootNavigator: true)
        .pushReplacement(MaterialPageRoute(builder: (context) {
      return AmbilFoto();
    }));
  }

  void getBeacon() async {
    print(hasilbeacon[0]);
    try {
      beacon = await dbPresensi.getBeaconPresensi();
      // for (int i = 0; i < hasilbeacon.length; i++) {
      //   if (beacon[i].toString() == hasilbeacon[i].toString()) {
      //     print('sama');
      //   } else {
      //     print('tidak sama');
      //   }
      for (int i = 0; i < beacon.length; i++) {
        var hasil = hasilbeacon.contains(beacon[i].toString());
        print(hasil);
        if (hasil == true) {
          pindahAmbilFoto();
          setState(() {
            hasilScanAdaSama = true;
            isLoading = false;
          });
          break;
        } else if (hasil == false) {
          setState(() {
            hasilScanAdaSama = false;
            isLoading = false;
          });
          globals.showAlertError(context: context, message: 'Tidak ada Beacon');
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
          child: isLoading == true ? loadingAnimation() : SizedBox(),
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
        )
      ],
    );
  }
}