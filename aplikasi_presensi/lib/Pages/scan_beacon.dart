import 'package:aplikasi_presensi/Pages/ambil_foto.dart';
import 'package:aplikasi_presensi/api/dbservices_presensi.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:aplikasi_presensi/globals.dart' as globals;

class scanBeaconPage extends StatefulWidget {
  const scanBeaconPage({super.key});

  @override
  State<scanBeaconPage> createState() => _scanBeaconPageState();
}

class _scanBeaconPageState extends State<scanBeaconPage> {
  PresensiService dbPresensi = PresensiService();
  bool hasilScanAdaSama = false;
  bool isLoading = true;
  List<String> beacon = [];
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

  void pindahAmbilFoto() {
    Navigator.of(context, rootNavigator: true)
        .pushReplacement(MaterialPageRoute(builder: (context) {
      return AmbilFoto();
    }));
  }

  void getBeacon() async {
    try {
      beacon = await dbPresensi.getBeaconPresensi();
      for (int i = 0; i < uuidScanAdaSama.length; i++) {
        var hasil = uuidScanAdaSama.contains(beacon[i]);
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
    Future.delayed(const Duration(seconds: 1), () {
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
