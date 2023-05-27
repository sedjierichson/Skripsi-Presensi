// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, use_build_context_synchronously

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:aplikasi_presensi/Pages/bottom_navbar.dart';
import 'package:aplikasi_presensi/Pages/home_page.dart';
import 'package:aplikasi_presensi/api/dbservices_presensi.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:image_picker/image_picker.dart';
import 'package:aplikasi_presensi/globals.dart' as globals;
import 'package:intl/intl.dart';

class AmbilFoto extends StatefulWidget {
  final String uuid;
  const AmbilFoto({super.key, required this.uuid});

  @override
  State<AmbilFoto> createState() => _AmbilFotoState();
}

class _AmbilFotoState extends State<AmbilFoto> {
  File? image;
  String? base64Image;
  final imagePicker = ImagePicker();
  PresensiService dbPresensi = PresensiService();
  String tanggalAbsen = DateFormat('yyyy-MM-dd').format(DateTime.now());
  String jamSekarang = '';
  String idKantor = '';

  Future getImage() async {
    final imageTmp = await ImagePicker().pickImage(
        source: ImageSource.camera,
        preferredCameraDevice: CameraDevice.front,
        imageQuality: 20);
    if (imageTmp == null) return;
    setState(() {
      image = File(imageTmp.path);
    });
    base64Image = base64Encode(image!.readAsBytesSync());
  }

  void insertAbsenMasuk({required String kategori}) async {
    if (base64Image == null) {
      globals.showAlertError(
          context: context,
          message: "Ambil foto selfie untuk melengkapi presensi");
    } else {
      try {
        var res = await dbPresensi.insertAbsenMasuk(
            globals.pegawai.read('nik').toString(),
            int.parse(idKantor),
            tanggalAbsen.toString(),
            jamSekarang,
            base64Image!,
            getRandomString(10) + "_" + image!.path.split('/').last,
            kategori,
            0); //0 = not history keluar masuk dalam sehari
        if (res['status'] == 1) {
          globals.showAlertBerhasil(
              context: context, message: 'Berhasil absen masuk');
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) {
                return BottomNavBar();
              },
            ),
            (route) => false,
          );
        }
        print(res['status']);
      } catch (e) {
        globals.showAlertError(
          context: context,
          message: e.toString(),
        );
      }
    }
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

  void getLokasiPresensi() async {
    try {
      var res = await dbPresensi.getKantorBeacon(uuid: widget.uuid.toString());
      setState(() {
        idKantor = res['lokasi'].toString();
      });
    } catch (e) {
      globals.showAlertError(context: context, message: e.toString());
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

  static const _chars =
      'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  Random _rnd = Random();

  String getRandomString(int length) => String.fromCharCodes(
        Iterable.generate(
          length,
          (_) => _chars.codeUnitAt(
            _rnd.nextInt(
              _chars.length,
            ),
          ),
        ),
      );

  @override
  void initState() {
    jamSekarang = _format(DateTime.now());
    getLokasiPresensi();
    Timer.periodic(Duration(seconds: 1), (timer) => getTime());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(MediaQuery.of(context).size.width / 15),
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Ambil foto selfie untuk melengkapi presensi masuk',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  alignment: Alignment.center,
                  height: MediaQuery.of(context).size.width / 1.5,
                  width: MediaQuery.of(context).size.width / 1.5,
                  decoration: BoxDecoration(
                      border: Border.all(),
                      borderRadius: BorderRadius.circular(10)),
                  child: image == null
                      ? Text('Belum ambil foto')
                      : Image.file(
                          image!,
                          width: 250,
                          height: 250,
                          fit: BoxFit.cover,
                        ),
                ),
                SizedBox(height: 15),
                GestureDetector(
                  onTap: () => getImage(),
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: HexColor('#13542D'),
                        borderRadius: BorderRadius.circular(10)),
                    width: MediaQuery.of(context).size.width / 2,
                    height: 40,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Buka Kamera',
                          style: TextStyle(color: Colors.white),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Icon(
                          Icons.camera_alt,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: getJamMasukKerja,
                  child: Text('Lanjut'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
