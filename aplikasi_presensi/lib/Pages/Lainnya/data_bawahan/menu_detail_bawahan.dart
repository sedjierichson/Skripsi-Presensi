// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, sort_child_properties_last

import 'package:aplikasi_presensi/api/dbservices_presensi.dart';
import 'package:aplikasi_presensi/models/pegawai.dart';
import 'package:aplikasi_presensi/models/presensi.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:aplikasi_presensi/globals.dart' as globals;

class menuDetailBawahan extends StatefulWidget {
  final apiRutanPegawai bawahan;
  const menuDetailBawahan({super.key, required this.bawahan});

  @override
  State<menuDetailBawahan> createState() => _menuDetailBawahanState();
}

class _menuDetailBawahanState extends State<menuDetailBawahan> {
  PresensiService db = PresensiService();
  List<Presensi> kehadiran = [];
  bool isLoadingAll = true;
  bool isErrorAll = false;

  void getDataPresensi() async {
    try {
      kehadiran = await db.getDataPresensi(
        nik: widget.bawahan.nik.toString(),
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

  @override
  void initState() {
    getDataPresensi();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        body: SafeArea(
          child: Center(
            child: Padding(
              padding: EdgeInsets.all(15),
              child: Column(
                children: [
                  Text(
                    widget.bawahan.nama,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    widget.bawahan.nik + " - " + widget.bawahan.jabatan,
                    style: TextStyle(fontSize: 14),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Container(
                    height: 50,
                    decoration: BoxDecoration(
                      color: HexColor(
                        '#13542D',
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TabBar(
                        indicator: BoxDecoration(
                          borderRadius: BorderRadius.circular(7),
                          color: HexColor('FFA133'),
                        ),
                        tabs: [
                          Tab(text: 'Presensi'),
                          Tab(text: 'Izin'),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: TabBarView(
                      children: [
                        tablePresensi(),
                        Text('Izin'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
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
                DataCell(
                  Container(
                    alignment: Alignment.center,
                    child: Text(
                      e.tanggal,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
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
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => super.widget,
                    ));
              },
              child: Text("Refresh"),
            ),
          ],
        ),
      );
    }
  }
}
