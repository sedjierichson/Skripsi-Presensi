// ignore_for_file: prefer_const_constructors

import 'package:aplikasi_presensi/Pages/Izin/menu_izin.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:hexcolor/hexcolor.dart';

class ListIzin extends StatefulWidget {
  const ListIzin({super.key});

  @override
  State<ListIzin> createState() => _ListIzinState();
}

class _ListIzinState extends State<ListIzin> {
  void pindahKePilihTipeIzin() {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return const MenuIzin();
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
                  'IZIN SAYA',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        Container(
                          alignment: Alignment.center,
                          width: MediaQuery.of(context).size.width / 5,
                          height: MediaQuery.of(context).size.width / 5,
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            '05',
                            style: TextStyle(fontSize: 25),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width / 5,
                          child: Text(
                            'Pulang Lebih Awal',
                            textAlign: TextAlign.center,
                          ),
                        )
                      ],
                    ),
                    Column(
                      children: [
                        Container(
                          alignment: Alignment.center,
                          width: MediaQuery.of(context).size.width / 5,
                          height: MediaQuery.of(context).size.width / 5,
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            '05',
                            style: TextStyle(fontSize: 25),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width / 5,
                          child: Text(
                            'Surat Tugas',
                            textAlign: TextAlign.center,
                          ),
                        )
                      ],
                    ),
                    Column(
                      children: [
                        Container(
                          alignment: Alignment.center,
                          width: MediaQuery.of(context).size.width / 5,
                          height: MediaQuery.of(context).size.width / 5,
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            '05',
                            style: TextStyle(fontSize: 25),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width / 5,
                          child: Text(
                            'Meninggalkan Kantor',
                            textAlign: TextAlign.center,
                          ),
                        )
                      ],
                    ),
                    Column(
                      children: [
                        Container(
                          alignment: Alignment.center,
                          width: MediaQuery.of(context).size.width / 5,
                          height: MediaQuery.of(context).size.width / 5,
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            '05',
                            style: TextStyle(fontSize: 25),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width / 5,
                          child: Text(
                            'Tidak Absen',
                            textAlign: TextAlign.center,
                          ),
                        )
                      ],
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height / 25),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width / 2,
                    height: MediaQuery.of(context).size.height / 13,
                    child: MaterialButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                      color: HexColor('#13542D'),
                      onPressed: () {
                        pindahKePilihTipeIzin();
                      },
                      child: Text(
                        'Ajukan Izin Baru',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
