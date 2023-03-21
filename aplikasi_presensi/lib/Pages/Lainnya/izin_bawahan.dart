// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:aplikasi_presensi/api/dbservices_form_izin.dart';
import 'package:aplikasi_presensi/models/izin.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:aplikasi_presensi/globals.dart' as globals;

class IzinBawahanPage extends StatefulWidget {
  const IzinBawahanPage({super.key});

  @override
  State<IzinBawahanPage> createState() => _IzinBawahanPageState();
}

class _IzinBawahanPageState extends State<IzinBawahanPage> {
  FormIzinService db = FormIzinService();
  List<Izin> daftarIzin = [];
  bool isLoadingAll = true;
  bool isErrorAll = false;

  void getDaftarIzinBawahan() async {
    // print("terpanggil");
    setState(() {
      isLoadingAll = true;
      isErrorAll = false;
    });
    try {
      daftarIzin =
          await db.getIzin(nikAtasan: globals.currentPegawai.nik.toString());
      setState(() {
        isLoadingAll = false;
      });
    } catch (e) {
      setState(() {
        isLoadingAll = false;
        isErrorAll = true;
      });
      print(e.toString());
    }
  }

  @override
  void initState() {
    getDaftarIzinBawahan();
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
              children: [
                Text(
                  'Daftar Izin Karyawan Bawahan',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Expanded(
                  child: cardIzin(),
                )
              ],
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
          return Container(
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
                      daftarIzin[index].nama + " - " + daftarIzin[index].nik,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                    Text(
                      daftarIzin[index].jenis,
                      style: TextStyle(fontSize: 15),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      daftarIzin[index].tanggalPengajuan.toString(),
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
        children: [
          Text("Unknown Error"),
          ElevatedButton(
            onPressed: () {
              setState(() {
                daftarIzin.clear();
                getDaftarIzinBawahan();
              });
            },
            child: Text("Tap to refresh"),
          ),
        ],
      ));
    }
  }
}
