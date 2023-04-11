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
  String tahunFilter = "";
  String bulanFilter = "";

  void getDataPresensi() async {
    try {
      kehadiran = await db.getDataPresensi(
        nik: globals.currentPegawai.nik.toString(),
      );
      // print(kehadiran[0].tanggal);
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

  void getDataPresensiFilter() async {
    try {
      kehadiran = await db.getDataPresensi(
        nik: globals.currentPegawai.nik.toString(),
        tahun: tahunFilter,
        bulan: bulanFilter,
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
              Padding(
                padding: const EdgeInsets.only(left: 15, right: 15),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      autofocus: true,
                      onTap: () {
                        setState(() {
                          textTanggal = "";
                          getDataPresensi();
                        });
                      },
                      child: Icon(Icons.refresh),
                    ),
                    Text(
                      'Kehadiran',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        DatePicker.showPicker(context,
                            pickerModel: CustomMonthPicker(
                              currentTime: DateTime.now(),
                              minTime: DateTime(2020, 1, 1),
                              maxTime: DateTime.now(),
                            ), onConfirm: (val) {
                          setState(() {
                            textTanggal = DateFormat('MMMM yyyy').format(val);
                            tahunFilter = DateFormat('yyyy').format(val);
                            bulanFilter = DateFormat('MM').format(val);
                            kehadiran.retainWhere((element) => element.tanggal
                                .contains(
                                    '$tahunFilter' + '-' + '$bulanFilter'));
                          });
                        });
                      },
                      child: Icon(FontAwesomeIcons.calendar),
                    ),
                  ],
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
              SizedBox(
                height: 15,
              ),
              tablePresensi()
            ],
          ),
        ),
      ),
    );
  }

  Widget tablePresensi() {
    if (isLoadingAll == false && isErrorAll == false) {
      return Expanded(
        child: SingleChildScrollView(
          child: DataTable(
            columnSpacing: 30,
            columns: [
              DataColumn(
                  label: Container(
                width: 90,
                child: Text(
                  'Tanggal',
                  textAlign: TextAlign.center,
                ),
              )),
              // DataColumn(
              //     label: Text(
              //   'Status',
              //   textAlign: TextAlign.center,
              // )),
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
                // DataCell(Container(
                //   alignment: Alignment.center,
                //   child: Text(
                //     e.status.toString(),
                //     textAlign: TextAlign.center,
                //   ),
                // )),
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
      );
    } else if (isLoadingAll == false && isErrorAll == true) {
      return Center(
        child: Column(
          children: [
            Text('Error'),
            MaterialButton(
              color: HexColor('#ffa133'),
              onPressed: () {
                getDataPresensi();
              },
              child: Text("REFRESH"),
            ),
          ],
        ),
      );
    } else if (isLoadingAll == true) {
      return Center(
        child: CircularProgressIndicator(),
      );
    } else {
      return Center(
        child: Column(
          children: [
            Text("Unknown Error"),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  getDataPresensi();
                });
              },
              child: Text("Refresh"),
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
