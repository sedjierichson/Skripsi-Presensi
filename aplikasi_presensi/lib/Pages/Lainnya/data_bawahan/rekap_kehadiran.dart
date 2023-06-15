// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:aplikasi_presensi/api/dbservices_presensi.dart';
import 'package:aplikasi_presensi/api/dbservices_user.dart';
import 'package:aplikasi_presensi/models/pegawai.dart';
import 'package:aplikasi_presensi/models/rekap.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:aplikasi_presensi/globals.dart' as globals;
import 'package:hexcolor/hexcolor.dart';

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

  @override
  void initState() {
    getBawahanUser();
    super.initState();
  }

  void getBawahanUser() async {
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
    getDataPresensi();
  }

  void getDataPresensi() async {
    try {
      kehadiran = await db2.getDataRekat(
        nik_atasan: '1',
      );
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
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(15),
            child: Column(
              children: [
                Text(
                  'Rekap Kehadiran',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                Expanded(child: cardTeamSaya())
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget cardTeamSaya() {
    if (isLoading == false && isError == false) {
      return ListView.builder(
        scrollDirection: Axis.vertical,
        itemCount: kehadiran.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              // pindahkeMenuDetail(
              //     detail: bawahan[index], jabatan: widget.jabatan);
            },
            child: Container(
              margin: EdgeInsets.only(bottom: 5),
              padding:
                  EdgeInsets.only(top: 10, left: 20, bottom: 10, right: 10),
              alignment: Alignment.centerLeft,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: index % 2 == 0
                      ? HexColor('#FFA133')
                      : HexColor('#C3CF0A')),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Text(
                      //   bawahan[index].nama.toString(),
                      //   style: TextStyle(
                      //       fontWeight: FontWeight.bold, fontSize: 15),
                      // ),
                      Text(
                        'NIK : ' + kehadiran[index].nik.toString(),
                        style: TextStyle(fontSize: 15),
                      ),
                      Text(
                        'Posisi : ' + kehadiran[index].kategori.toString(),
                        style: TextStyle(fontSize: 15),
                      ),
                      Text(
                        'Kategori : ' + kehadiran[index].jumlah.toString(),
                        style: TextStyle(fontSize: 15),
                      ),
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
    } else if (isLoading == true) {
      return const Center(
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
                  // daftarIzin.clear();
                  // getSemuaMateri();
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
