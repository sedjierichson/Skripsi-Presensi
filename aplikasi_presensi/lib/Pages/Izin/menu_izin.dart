// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:aplikasi_presensi/Pages/Izin/meninggalkan_sementara.dart';
import 'package:aplikasi_presensi/Pages/Izin/pulang_awal.dart';
import 'package:aplikasi_presensi/Pages/Izin/surat_tugas.dart';
import 'package:aplikasi_presensi/Pages/Izin/tidak_absen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hexcolor/hexcolor.dart';

class MenuIzin extends StatefulWidget {
  const MenuIzin({super.key});

  @override
  State<MenuIzin> createState() => _MenuIzinState();
}

class _MenuIzinState extends State<MenuIzin> {
  void pindahKeFormPulangAwal() {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return const PulangLebihAwal();
    }));
  }

  void pindahKeFormMeninggalkanSementara() {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return const MeninggalkanSementara();
    }));
  }

  void pindahKeSuratTugas() {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return const SuratTugas();
    }));
  }

  void pindahKeLupaAbsen() {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
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
              padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.width / 15,
                  left: MediaQuery.of(context).size.width / 15,
                  right: MediaQuery.of(context).size.width / 15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'PILIH TIPE IZIN',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height / 3,
                    child: Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () => pindahKeFormPulangAwal(),
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: HexColor('#13542D')),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Pulang Lebih Awal',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Icon(
                                    FontAwesomeIcons.houseUser,
                                    size: 50,
                                    color: Colors.white,
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Expanded(
                          child: InkWell(
                            onTap: () => pindahKeFormMeninggalkanSementara(),
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: HexColor('#C3Cf0A')),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Meninggalkan Lokasi Kerja Sementara',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Icon(
                                    FontAwesomeIcons.personWalkingArrowRight,
                                    size: 50,
                                    color: Colors.white,
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height / 3,
                    child: Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () => pindahKeSuratTugas(),
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: HexColor('#FFA133')),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Surat Tugas',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Icon(
                                    FontAwesomeIcons.envelope,
                                    size: 50,
                                    color: Colors.white,
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Expanded(
                          child: InkWell(
                            onTap: () => pindahKeLupaAbsen(),
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: HexColor('#bdbbbb')),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Tidak Melakukan Presensi',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Icon(
                                    FontAwesomeIcons.clipboardQuestion,
                                    size: 50,
                                    color: Colors.white,
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
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
}
