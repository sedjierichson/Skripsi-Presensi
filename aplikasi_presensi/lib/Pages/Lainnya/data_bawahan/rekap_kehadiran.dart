// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:aplikasi_presensi/api/dbservices_presensi.dart';
import 'package:aplikasi_presensi/api/dbservices_user.dart';
import 'package:aplikasi_presensi/models/pegawai.dart';
import 'package:aplikasi_presensi/models/rekap.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:aplikasi_presensi/globals.dart' as globals;
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';

class rekapKehadiran extends StatefulWidget {
  const rekapKehadiran({super.key});

  @override
  State<rekapKehadiran> createState() => _rekapKehadiranState();
}

class _rekapKehadiranState extends State<rekapKehadiran> {
  List<apiRutanPegawai> bawahan = [];
  UserService db = UserService();
  PresensiService db2 = PresensiService();
  bool isLoading = true;
  bool isError = false;
  bool isLoadingAll = true;
  bool isErrorAll = false;
  List<Rekap> kehadiran = [];
  String textTanggal = "";

  @override
  void initState() {
    textTanggal = DateFormat('MMMM yyyy').format(DateTime.now());
    getBawahanUser(DateTime.now());
    super.initState();
  }

  void getBawahanUser(DateTime filter) async {
    setState(() {
      isLoading = true;
      isError = false;
    });
    try {
      bawahan = await db.getBawahanUser(
        nik: globals.pegawai.read('nik').toString(),
      );
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        isError = true;
      });
    }
    getDataPresensi(filter: filter);
  }

  void getDataPresensi({required DateTime filter}) async {
    String tahunFilter = DateFormat('yyyy').format(filter);
    String bulanFilter = DateFormat('MM').format(filter);
    try {
      kehadiran = await db2.getDataRekat(
          nik_atasan: '1', bulan: bulanFilter, tahun: tahunFilter);
      // print(kehadiran);
      setState(() {
        isLoadingAll = false;
      });
    } catch (e) {
      print(e.toString());
      setState(() {
        isLoading = false;
        isError = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(15),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      autofocus: true,
                      onTap: () {
                        getDataPresensi(filter: DateTime.now());
                      },
                      child: Icon(Icons.refresh),
                    ),
                    Text(
                      'Rekap Kehadiran',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        DatePicker.showPicker(
                          context,
                          pickerModel: CustomMonthPicker(
                            currentTime: DateTime.now(),
                            minTime: DateTime(2020, 1, 1),
                            maxTime: DateTime.now(),
                          ),
                          onConfirm: (val) {
                            setState(() {
                              kehadiran.clear;
                              textTanggal = DateFormat('MMMM yyyy').format(val);
                              getDataPresensi(filter: val);
                            });
                          },
                        );
                      },
                      child: Icon(FontAwesomeIcons.calendar),
                    ),
                  ],
                ),
                Text(
                  textTanggal,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                cardTeamSaya()
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget cardTeamSaya() {
    if (isLoading == false && isError == false) {
      return Expanded(
        child: SingleChildScrollView(
          child: DataTable(
            columnSpacing: 30,
            columns: [
              DataColumn(
                label: Container(
                  width: 90,
                  child: Text(
                    'NIK',
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              DataColumn(
                  label: Text(
                'Kategori',
                textAlign: TextAlign.center,
              )),
              DataColumn(
                  label: Text(
                'Jumlah',
                textAlign: TextAlign.center,
              )),
            ],
            rows: kehadiran.map((e) {
              return DataRow(cells: [
                DataCell(
                  Container(
                    alignment: Alignment.center,
                    child: Text(
                      e.nik,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                DataCell(
                  Container(
                    alignment: Alignment.center,
                    child: Text(
                      e.kategori.toString(),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                DataCell(
                  Container(
                    alignment: Alignment.center,
                    child: Text(
                      e.jumlah.toString(),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ]);
            }).toList(),
          ),
        ),
      );
    } else if (isLoading == true) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    } else {
      return Center(
        child: Column(
          children: [
            Text("Data Tidak Ditemukan"),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  isError = false;
                  kehadiran.clear;
                  textTanggal = DateFormat('MMMM yyyy').format(DateTime.now());
                  getDataPresensi(filter: DateTime.now());
                });
              },
              child: Text("Tap to refresh"),
            ),
          ],
        ),
      );
    }
  }
}

class CustomMonthPicker extends DatePickerModel {
  CustomMonthPicker(
      {required DateTime currentTime,
      DateTime? minTime,
      DateTime? maxTime,
      LocaleType? locale})
      : super(
            locale: locale,
            minTime: minTime,
            maxTime: maxTime,
            currentTime: currentTime);

  @override
  List<int> layoutProportions() {
    return [1, 1, 0];
  }
}
