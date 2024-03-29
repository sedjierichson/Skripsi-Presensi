// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:collection';

import 'package:aplikasi_presensi/Pages/Lainnya/data_bawahan/menu_detail_bawahan.dart';
import 'package:aplikasi_presensi/Pages/Lainnya/data_bawahan/rekap_kehadiran.dart';
import 'package:aplikasi_presensi/api/dbservices_presensi.dart';
import 'package:aplikasi_presensi/api/dbservices_user.dart';
import 'package:aplikasi_presensi/models/pegawai.dart';
import 'package:aplikasi_presensi/models/presensi.dart';
import 'package:aplikasi_presensi/models/rekap.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:aplikasi_presensi/globals.dart' as globals;
import 'package:hexcolor/hexcolor.dart';

class TeamSaya extends StatefulWidget {
  final String jabatan;
  const TeamSaya({super.key, required this.jabatan});

  @override
  State<TeamSaya> createState() => _TeamSayaState();
}

class _TeamSayaState extends State<TeamSaya> {
  List<apiRutanPegawai> bawahan = [];
  UserService db = UserService();
  PresensiService db2 = PresensiService();
  bool isLoading = true;
  bool isError = false;
  bool adaBawahan = false;
  bool isLoadingAll = true;
  bool isErrorAll = false;
  List<Rekap> kehadiran = [];
  List<Rekap> kehadiran2 = [];
  List listx = [];

  @override
  void initState() {
    getBawahanUser();
    // baru();
    // getDataPresensi();
    super.initState();
  }

  void getDataPresensi(String nik) async {
    try {
      kehadiran = await db2.getDataRekat(
        nik_atasan: nik,
      );
      kehadiran2.addAll(kehadiran);
      setState(() {
        isLoadingAll = false;
      });
    } catch (e) {
      setState(() {
        isLoadingAll = false;
        isErrorAll = true;
      });
    }
    print(kehadiran2[4].nik);
  }

  void baru() async {
    // Map<int, String> rekap = HashMap();
    for (int i = 0; i < bawahan.length; i++) {
      getDataPresensi(bawahan[i].nik);
    }
    // print(rekap);
  }

  void getBawahanUser() async {
    setState(() {
      isLoading = true;
      isError = false;
    });
    try {
      if (widget.jabatan == "manajer") {
        bawahan = await db.getBawahanUser(
          nik: globals.pegawai.read('nik').toString(),
        );
      } else {
        bawahan = await db.getBawahanUser(
          nik: globals.pegawai.read('nik_atasan').toString(),
        );
      }
      setState(() {
        isLoading = false;
        adaBawahan = true;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        isError = true;
      });
    }
    baru();
  }

  void pindahkeMenuDetail(
      {required apiRutanPegawai detail, required String jabatan}) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return menuDetailBawahan(
        bawahan: detail,
        jabatan: jabatan,
      );
    }));
  }

  void pindahHalamanRekap() {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return rekapKehadiran();
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(MediaQuery.of(context).size.width / 15),
            child: Column(
              children: [
                Text(
                  'Team Saya',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Expanded(
                  child: cardTeamSaya(),
                ),
                widget.jabatan == "manajer"
                    ? InkWell(
                        onTap: () {
                          pindahHalamanRekap();
                        },
                        child: Container(
                          alignment: Alignment.center,
                          width: MediaQuery.of(context).size.width / 2,
                          height: 40,
                          decoration: BoxDecoration(
                              color: Colors.lightGreen,
                              borderRadius: BorderRadius.circular(10)),
                          child: Text(
                            'Rekap Kehadiran',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      )
                    : SizedBox()
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
        itemCount: bawahan.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              pindahkeMenuDetail(
                  detail: bawahan[index], jabatan: widget.jabatan);
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
                      Text(
                        bawahan[index].nama.toString(),
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                      Text(
                        'NIK : ' + bawahan[index].nik.toString(),
                        style: TextStyle(fontSize: 15),
                      ),
                      Text(
                        'Posisi : ' + bawahan[index].jabatan.toString(),
                        style: TextStyle(fontSize: 15),
                      ),
                      Text(
                        'Kategori : ' + bawahan[index].jabatan.toString(),
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
