// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, use_build_context_synchronously, avoid_unnecessary_containers

import 'package:aplikasi_presensi/Pages/Izin/list_izin.dart';
import 'package:aplikasi_presensi/Pages/Izin/menu_izin.dart';
import 'package:aplikasi_presensi/api/dbservices_form_izin.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:intl/intl.dart';
import 'package:aplikasi_presensi/globals.dart' as globals;

class PulangLebihAwal extends StatefulWidget {
  const PulangLebihAwal({super.key});

  @override
  State<PulangLebihAwal> createState() => _PulangLebihAwalState();
}

class _PulangLebihAwalState extends State<PulangLebihAwal> {
  FormIzinService db = FormIzinService();
  TextEditingController tfTanggalIzin = TextEditingController();
  TextEditingController tfJamIzin = TextEditingController();
  TextEditingController tfAlasanLainnyaIzin = TextEditingController();
  bool tampilkanTFLainnya = false;
  String? alasan;
  String? tanggalIzin;
  String tanggal_pengajuan = DateFormat('yyyy-MM-dd').format(DateTime.now());
  void submitForm() async {
    if (tfAlasanLainnyaIzin.text != "") {
      alasan = tfAlasanLainnyaIzin.text.toString();
    }
    if (tfTanggalIzin.text != "" && tfJamIzin.text != "" && alasan != "") {
      // print(globals.currentPegawai.nik);
      try {
        await db.insertFormPulangAwal(
          globals.currentPegawai.nik,
          globals.currentPegawai.nik_atasan,
          tanggalIzin.toString(),
          tfJamIzin.text.toString(),
          alasan!,
          tanggal_pengajuan.toString(),
        );
        pindahKeMenuIzin();
      } catch (e) {
        print(e.toString());
      }
    } else {
      print("IZIN FORM LENGKAP");
    }
  }

  void pindahKeMenuIzin() {
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) {
      return const ListIzin();
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Center(
            child: Padding(
              padding: EdgeInsets.all(
                MediaQuery.of(context).size.width / 15,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Form Izin Pemberitahuan Pulang Lebih Awal',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 20,
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
                        var tanggal = await showDatePicker(
                            initialDate: DateTime.now(),
                            context: context,
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2030));
                        if (tanggal != null) {
                          String formattedDate =
                              DateFormat('EEEE, dd MMMM yyyy').format(tanggal);
                          setState(() {
                            tfTanggalIzin.text = formattedDate;
                            tanggalIzin =
                                DateFormat('yyyy-MM-dd').format(tanggal);
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
                  Text(
                    'Jam Pulang',
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    child: TextField(
                      readOnly: true,
                      onTap: () async {
                        TimeOfDay? pickedTime = await showTimePicker(
                          initialTime: TimeOfDay.now(),
                          context: context,
                        );

                        if (pickedTime != null) {
                          DateTime parsedTime = DateFormat.jm()
                              .parse(pickedTime.format(context).toString());
                          String formattedTime =
                              DateFormat('HH:mm').format(parsedTime);

                          setState(() {
                            tfJamIzin.text = formattedTime;
                          });
                        }
                        ;
                      },
                      controller: tfJamIzin,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.only(
                            top: MediaQuery.of(context).size.height / 20,
                            left: MediaQuery.of(context).size.width / 20),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        hintText: 'Pilih Jam',
                        hintStyle: TextStyle(fontSize: 13),
                        suffixIcon: Icon(Icons.timer),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    'Alasan',
                  ),
                  Container(
                    child: Column(
                      children: [
                        SizedBox(
                          height: 40,
                          child: RadioListTile(
                            title: Text(
                              "Sakit",
                              style: TextStyle(fontSize: 15),
                            ),
                            value: "Sakit",
                            groupValue: alasan,
                            onChanged: (value) {
                              setState(() {
                                alasan = value.toString();
                                print(alasan);
                                tampilkanTFLainnya = false;
                              });
                            },
                          ),
                        ),
                        SizedBox(
                          height: 40,
                          child: RadioListTile(
                            title: Text(
                              "Urusan Keluarga",
                              style: TextStyle(fontSize: 15),
                            ),
                            value: "Urusan Keluarga",
                            groupValue: alasan,
                            onChanged: (value) {
                              setState(() {
                                alasan = value.toString();
                                print(alasan);
                                tampilkanTFLainnya = false;
                              });
                            },
                          ),
                        ),
                        SizedBox(
                          height: 40,
                          child: RadioListTile(
                            title: Text(
                              "Panggilan dari Instansi Pemerintah",
                              style: TextStyle(fontSize: 15),
                            ),
                            value: "Panggilan dari Instansi Pemerintah",
                            groupValue: alasan,
                            onChanged: (value) {
                              setState(() {
                                alasan = value.toString();
                                print(alasan);
                                tampilkanTFLainnya = false;
                              });
                            },
                          ),
                        ),
                        SizedBox(
                          height: 40,
                          child: RadioListTile(
                            title: Text(
                              "Lainnya",
                              style: TextStyle(fontSize: 15),
                            ),
                            value: "Lainnya",
                            groupValue: alasan,
                            onChanged: (value) {
                              setState(() {
                                alasan = value.toString();
                                print(alasan);
                                tampilkanTFLainnya = true;
                              });
                            },
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        // if (tampilkanTFLainnya == true)
                        tampilkanTFLainnya
                            ? TextField(
                                controller: tfAlasanLainnyaIzin,
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.only(
                                      top: MediaQuery.of(context).size.height /
                                          20,
                                      left: MediaQuery.of(context).size.width /
                                          20),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  hintText: 'Isi Alasan',
                                  hintStyle: TextStyle(fontSize: 13),
                                ),
                              )
                            : SizedBox(
                                height: 0,
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
                              color: Colors.cyan,
                              onPressed: () {
                                submitForm();
                              },
                              child: Text(
                                'Ajukan',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
