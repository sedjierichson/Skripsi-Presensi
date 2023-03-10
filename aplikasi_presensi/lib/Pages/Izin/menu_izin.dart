// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:aplikasi_presensi/Pages/Izin/meninggalkan_sementara.dart';
import 'package:aplikasi_presensi/Pages/Izin/pulang_awal.dart';
import 'package:aplikasi_presensi/Pages/Izin/surat_tugas.dart';
import 'package:aplikasi_presensi/Pages/Izin/tidak_absen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class MenuIzin extends StatefulWidget {
  const MenuIzin({super.key});

  @override
  State<MenuIzin> createState() => _MenuIzinState();
}

class _MenuIzinState extends State<MenuIzin> {

  void pindahKeFormPulangAwal(){
    Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) {
        return const PulangLebihAwal();
      }));
  }

  void pindahKeFormMeninggalkanSementara(){
    Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) {
        return const MeninggalkanSementara();
      }));
  }
  void pindahKeSuratTugas(){
    Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) {
        return const SuratTugas();
      }));
  }

  void pindahKeLupaAbsen(){
    Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) {
        return const PemberitahuanTidakAbsen();
      }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Center(
            child: Padding(
              padding: EdgeInsets.all(MediaQuery.of(context).size.width / 15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'MENU IZIN',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  InkWell(
                    onTap: () => pindahKeFormPulangAwal(),
                    child: Container(
                      
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Colors.greenAccent),
                      height: MediaQuery.of(context).size.height / 6,
                      width: MediaQuery.of(context).size.width / 1.1,
                      child: Align(
                        alignment: Alignment.center,
                        child: Text('PULANG LEBIH AWAL'),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  InkWell(
                    onTap: () => pindahKeFormMeninggalkanSementara(),
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Colors.greenAccent),
                      height: MediaQuery.of(context).size.height / 6,
                      width: MediaQuery.of(context).size.width / 1.1,
                      child: Align(
                        alignment: Alignment.center,
                        child: Text('MENINGGALKAN KANTOR SEMENTARA'),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  InkWell(
                    onTap: () => pindahKeSuratTugas(),
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Colors.greenAccent),
                      height: MediaQuery.of(context).size.height / 6,
                      width: MediaQuery.of(context).size.width / 1.1,
                      child: Align(
                        alignment: Alignment.center,
                        child: Text('SURAT TUGAS'),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  InkWell(
                    onTap: () => pindahKeLupaAbsen(),
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Colors.greenAccent),
                      height: MediaQuery.of(context).size.height / 6,
                      width: MediaQuery.of(context).size.width / 1.1,
                      child: Align(
                        alignment: Alignment.center,
                        child: Text('PEMBERITAHUAN TIDAK \n MELAKUKAN PRESENSI'),
                      ),
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
}