// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:aplikasi_presensi/api/dbservices_presensi.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:image_picker/image_picker.dart';
import 'package:aplikasi_presensi/globals.dart' as globals;
import 'package:intl/intl.dart';

class AmbilFoto extends StatefulWidget {
  const AmbilFoto({super.key});

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

  Future getImage() async {
    final imageTmp = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (imageTmp == null) return;
    setState(() {
      image = File(imageTmp.path);
    });
    base64Image = base64Encode(image!.readAsBytesSync());
  }

  void insertAbsenMasuk() async {
    try {
      var res = await dbPresensi.insertAbsenMasuk(
        globals.currentPegawai.nik.toString(),
        1,
        tanggalAbsen.toString(),
        jamSekarang,
        base64Image.toString(),
      );
      if (res['status'] == 1) {
        globals.showAlertBerhasil(
            context: context, message: 'Berhasil absen masuk');
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (BuildContext context) => super.widget));
      }
      print(res['status']);
    } catch (e) {
      globals.showAlertError(
        context: context,
        message: e.toString(),
      );
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
    return DateFormat("HH:mm").format(dateTime);
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
                  height: MediaQuery.of(context).size.width / 1.5,
                  width: MediaQuery.of(context).size.width / 1.5,
                  color: Colors.red,
                  child: image == null
                      ? Text('Belum ambil foto')
                      : Image.file(
                          image!,
                          width: 250,
                          height: 250,
                          fit: BoxFit.cover,
                        ),
                ),
                ElevatedButton(
                  onPressed: getImage,
                  child: Icon(Icons.camera_alt),
                ),
                ElevatedButton(
                  onPressed: insertAbsenMasuk,
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
