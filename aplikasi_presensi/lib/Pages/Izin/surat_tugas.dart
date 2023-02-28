// ignore_for_file: prefer_const_constructors

import 'package:aplikasi_presensi/Pages/Izin/menu_izin.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:intl/intl.dart';

class SuratTugas extends StatefulWidget {
  const SuratTugas({super.key});

  @override
  State<SuratTugas> createState() => _SuratTugasState();
}

class _SuratTugasState extends State<SuratTugas> {
  TextEditingController tfTanggalIzin = TextEditingController();
  TextEditingController tfTempatTujuan = TextEditingController();
  TextEditingController tfUraianTugas = TextEditingController();
  TextEditingController tfBonSementara = TextEditingController();

  void pindahKeMenuIzin() {
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) {
      return const MenuIzin();
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    alignment: Alignment.center,
                    child: Text(
                      'SURAT TUGAS',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Text(
                    'Pilih Tanggal Izin',
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    child: TextField(
                      readOnly: true,
                      controller: tfTanggalIzin,
                      onTap: () async {
                        var tanggal = await showDateRangePicker(
                            context: context,
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2030));
                        if (tanggal != null && tanggal!= null) {
                          print(tanggal.start);
                          print(tanggal.end);
                          String formattedDate =
                              DateFormat('dd MMMM yyyy').format(tanggal.start);
                              String formattedDate2 =
                              DateFormat('dd MMMM yyyy').format(tanggal.end);

                          setState(() {
                            tfTanggalIzin.text = '$formattedDate - $formattedDate2';
                          });
                        }
                      },
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.only(
                            top: MediaQuery.of(context).size.height / 20,
                            left: MediaQuery.of(context).size.width / 20),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        hintText: 'Pilih Tanggal',
                        hintStyle: TextStyle(fontSize: 13),
                        suffixIcon: Icon(Icons.calendar_month),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text('Tempat Tujuan'),
                  SizedBox(height:10),
                  TextField(
                    controller: tfTempatTujuan,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height / 20,
                          left: MediaQuery.of(context).size.width / 20),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      hintText: 'Masukkan Kantor Tujuan',
                      hintStyle: TextStyle(fontSize: 13),
                    ),
                  ),
                   SizedBox(
                    height: 20,
                  ),
                  Text('Uraian Tugas'),
                  SizedBox(height:10),
                  TextField(
                    controller: tfUraianTugas,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height / 20,
                          left: MediaQuery.of(context).size.width / 20),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      hintText: 'Masukkan Uraian Tugas',
                      hintStyle: TextStyle(fontSize: 13),
                    ),
                  ),
                   SizedBox(
                    height: 20,
                  ),
                  Text('Bon Sementara'),
                  SizedBox(height:10),
                  TextField(
                    controller: tfBonSementara,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height / 20,
                          left: MediaQuery.of(context).size.width / 20),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      hintText: 'Masukkan Bon Sementara',
                      hintStyle: TextStyle(fontSize: 13),
                    ),
                  ),
                  Container(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height / 25),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width / 2,
                        height: MediaQuery.of(context).size.height / 13,
                        child: MaterialButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)),
                          color: Colors.cyan,
                          onPressed: () {
                            pindahKeMenuIzin();
                          },
                          child: Text(
                            'Ajukan',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                        ),
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
