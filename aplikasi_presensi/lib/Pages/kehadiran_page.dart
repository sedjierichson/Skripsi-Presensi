// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:aplikasi_presensi/api/dbservices_presensi.dart';
import 'package:aplikasi_presensi/models/presensi.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:aplikasi_presensi/globals.dart' as globals;

class PageKehadiran extends StatefulWidget {
  const PageKehadiran({super.key});

  @override
  State<PageKehadiran> createState() => _PageKehadiranState();
}

class _PageKehadiranState extends State<PageKehadiran> {
  String textTanggal = "";
  PresensiService db = PresensiService();
  List<Presensi> kehadiran = [];
  bool isLoadingAll = true;
  bool isErrorAll = false;

  void getDataPresensi() async {
    try {
      kehadiran = await db.getDataPresensi(
        nik: globals.currentPegawai.nik.toString(),
      );
      setState(() {
        isLoadingAll = false;
      });
    } catch (e) {
      setState(() {
        isLoadingAll = false;
        isErrorAll = true;
      });
      globals.showAlertError(context: context, message: e.toString());
    }
  }

  @override
  void initState() {
    getDataPresensi();
    super.initState();
  }

  // List<Presensi> kehadiran = [
  //   Presensi(
  //       id: 1,
  //       nik: 1,
  //       idKantor: 1,
  //       tanggal: '2023-06-05',
  //       foto: 'a',
  //       status: 1,
  //       jamMasuk: '09:00',
  //       jamKeluar: '15:00')
  // ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              SizedBox(
                height: 20,
              ),
              Text(
                'Kehadiran',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              SizedBox(
                height: 15,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width / 2,
                height: MediaQuery.of(context).size.height / 13,
                child: MaterialButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  color: HexColor('#13542D'),
                  onPressed: () {
                    DatePicker.showPicker(context,
                        pickerModel: CustomMonthPicker(
                          currentTime: DateTime.now(),
                          minTime: DateTime(2020, 1, 1),
                          maxTime: DateTime.now(),
                        ), onConfirm: (val) {
                      setState(() {
                        textTanggal = DateFormat('MMMM yyyy').format(val);
                      });
                      print(val);
                    });
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Pilih Bulan',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      Icon(
                        FontAwesomeIcons.calendar,
                        color: Colors.white,
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Text(
                textTanggal,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              Expanded(
                child: Row(
                  children: [
                    SingleChildScrollView(
                      child: DataTable(
                        columnSpacing: 10,
                        columns: [
                          DataColumn(
                              label: Container(
                            width: 90,
                            child: Text(
                              'Tanggal',
                              textAlign: TextAlign.center,
                            ),
                          )),
                          DataColumn(
                              label: Text(
                            'Status',
                            textAlign: TextAlign.center,
                          )),
                          DataColumn(
                              label: Text(
                            'Jam Masuk',
                            textAlign: TextAlign.center,
                          )),
                          DataColumn(
                              label: Text(
                            'Jam Keluar',
                            textAlign: TextAlign.center,
                          )),
                        ],
                        rows: kehadiran.map((e) {
                          return DataRow(cells: [
                            DataCell(Container(
                              alignment: Alignment.center,
                              child: Text(
                                e.tanggal,
                                textAlign: TextAlign.center,
                              ),
                            )),
                            DataCell(Container(
                              alignment: Alignment.center,
                              child: Text(
                                e.status.toString(),
                                textAlign: TextAlign.center,
                              ),
                            )),
                            DataCell(Container(
                              alignment: Alignment.center,
                              child: Text(
                                e.jamMasuk.toString(),
                                textAlign: TextAlign.center,
                              ),
                            )),
                            DataCell(Container(
                              alignment: Alignment.center,
                              child: Text(
                                e.jamKeluar.toString(),
                                textAlign: TextAlign.center,
                              ),
                            )),
                          ]);
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
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
