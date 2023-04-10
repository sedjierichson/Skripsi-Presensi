// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, sort_child_properties_last

import 'package:aplikasi_presensi/Pages/Lainnya/detail_izin_bawahan.dart';
import 'package:aplikasi_presensi/api/dbservices_form_izin.dart';
import 'package:aplikasi_presensi/api/dbservices_presensi.dart';
import 'package:aplikasi_presensi/models/izin.dart';
import 'package:aplikasi_presensi/models/pegawai.dart';
import 'package:aplikasi_presensi/models/presensi.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:aplikasi_presensi/globals.dart' as globals;
import 'package:intl/intl.dart';

class menuDetailBawahan extends StatefulWidget {
  final apiRutanPegawai bawahan;
  const menuDetailBawahan({super.key, required this.bawahan});

  @override
  State<menuDetailBawahan> createState() => _menuDetailBawahanState();
}

class _menuDetailBawahanState extends State<menuDetailBawahan> {
  PresensiService db = PresensiService();
  FormIzinService db2 = FormIzinService();
  List<Presensi> kehadiran = [];
  List<Izin> daftarIzin = [];
  bool isLoadingAll = true;
  bool isErrorAll = false;

  void pindahkeDetailIzin(Izin detail) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return detailIzinBawahan(
        detail: detail,
      );
    }));
  }

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
      // globals.showAlertError(context: context, message: e.toString());
    }
  }

  void getDaftarIzin() async {
    // print("terpanggil");
    setState(() {
      isLoadingAll = true;
      isErrorAll = false;
    });
    try {
      daftarIzin = await db2.getIzin(nikUser: widget.bawahan.nik.toString());
      // getJumlah();
      setState(() {
        isLoadingAll = false;
      });
    } catch (e) {
      setState(() {
        isLoadingAll = false;
        isErrorAll = true;
      });
    }
  }

  @override
  void initState() {
    getDataPresensi();
    getDaftarIzin();
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
                  SizedBox(
                    height: 10,
                  ),
                  Expanded(
                    child: TabBarView(
                      children: [
                        tablePresensi(),
                        cardIzin(),
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

  Widget cardIzin() {
    if (isLoadingAll == false && isErrorAll == false) {
      return ListView.builder(
        scrollDirection: Axis.vertical,
        itemCount: daftarIzin.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () => pindahkeDetailIzin(daftarIzin[index]),
            child: Container(
              margin: EdgeInsets.only(
                bottom: 5,
              ),
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                border: Border.all(width: 1),
                borderRadius: BorderRadius.circular(10),
              ),
              alignment: Alignment.centerLeft,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        daftarIzin[index].jenis,
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        daftarIzin[index].tanggalPengajuan.toString(),
                        style: TextStyle(fontSize: 15),
                      ),
                      daftarIzin[index].status == '1'
                          ? Text('Status : Pending')
                          : daftarIzin[index].status.toString() == '2'
                              ? Text('Status : Diterima')
                              : Text('Status : Ditolak')
                    ],
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 15,
                  )
                ],
              ),
            ),
          );
        },
      );
    } else if (isLoadingAll == true) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    } else {
      return Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Data izin tidak ditemukan',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            MaterialButton(
              color: HexColor('#ffa133'),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => super.widget,
                  ),
                );
              },
              child: Text("REFRESH"),
            ),
          ],
        ),
      );
    }
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
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Data presensi tidak ditemukan',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            MaterialButton(
              color: HexColor('#ffa133'),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => super.widget,
                  ),
                );
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
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Data presensi tidak ditemukan',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            MaterialButton(
              color: HexColor('#ffa133'),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => super.widget,
                  ),
                );
              },
              child: Text("REFRESH"),
            ),
          ],
        ),
      );
    }
  }
}
