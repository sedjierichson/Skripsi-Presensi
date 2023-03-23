// ignore_for_file: prefer_const_constructors

import 'package:aplikasi_presensi/Pages/Izin/list_izin.dart';
import 'package:aplikasi_presensi/Pages/Izin/menu_izin.dart';
import 'package:aplikasi_presensi/api/dbservices_form_izin.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:aplikasi_presensi/globals.dart' as globals;

class PemberitahuanTidakAbsen extends StatefulWidget {
  const PemberitahuanTidakAbsen({super.key});

  @override
  State<PemberitahuanTidakAbsen> createState() =>
      _PemberitahuanTidakAbsenState();
}

class _PemberitahuanTidakAbsenState extends State<PemberitahuanTidakAbsen> {
  FormIzinService db = FormIzinService();
  TextEditingController tfTanggalIzin = TextEditingController();
  TextEditingController tfJamMasuk = TextEditingController();
  TextEditingController tfJamKeluar = TextEditingController();
  TextEditingController tfAlasanLainnyaIzin = TextEditingController();
  String tanggal_pengajuan = DateFormat('yyyy-MM-dd').format(DateTime.now());

  String? alasan;
  String? tanggalIzin;

  bool tampilkanTFTugasKe = false;
  bool tampilkanTFLainnya = false;

  void pindahKeMenuIzin() {
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) {
      return const ListIzin();
    }));
  }

  void submitForm() async {
    if (tampilkanTFLainnya == true) {
      alasan = "Lainnya : " + tfAlasanLainnyaIzin.text.toString();
    } else if (tampilkanTFTugasKe == true) {
      alasan = "Tugas Ke : " + tfAlasanLainnyaIzin.text.toString();
    }

    if (tfTanggalIzin.text != "" &&
        tfJamMasuk.text != "" &&
        tfJamKeluar.text != "" &&
        alasan != "") {
      try {
        await db.insertFormLupaAbsen(
          globals.currentPegawai.nik,
          globals.currentPegawai.nik_atasan,
          tanggalIzin!.toString(),
          tfJamMasuk.text.toString(),
          tfJamKeluar.text.toString(),
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
                      'Form Izin Lupa Absen',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                      textAlign: TextAlign.center,
                    ),
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
                    'Jam Masuk - Jam Pulang',
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width / 3,
                        child: TextField(
                          textAlign: TextAlign.center,
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
                                tfJamMasuk.text = formattedTime;
                              });
                            }
                            ;
                          },
                          controller: tfJamMasuk,
                          decoration: InputDecoration(
                            // contentPadding: EdgeInsets.only(
                            //     top: MediaQuery.of(context).size.height / 20,
                            //     left: MediaQuery.of(context).size.width / 20),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            hintText: 'Pilih Jam',
                            hintStyle: TextStyle(fontSize: 13),
                          ),
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width / 6,
                        child: Center(
                            child: Text(
                          's/d',
                          textAlign: TextAlign.center,
                        )),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width / 3,
                        child: TextField(
                          textAlign: TextAlign.center,
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
                                tfJamKeluar.text = formattedTime;
                              });
                            }
                            ;
                          },
                          controller: tfJamKeluar,
                          decoration: InputDecoration(
                            // contentPadding: EdgeInsets.only(
                            //     top: MediaQuery.of(context).size.height / 20,
                            //     left: MediaQuery.of(context).size.width / 20),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            hintText: 'Pilih Jam',
                            hintStyle: TextStyle(fontSize: 13),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    'Saya tidak melakukan absen karena...',
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    child: Column(
                      children: [
                        SizedBox(
                          height: 40,
                          child: RadioListTile(
                            title: Text(
                              "Lupa",
                              style: TextStyle(fontSize: 15),
                            ),
                            value: "Lupa",
                            groupValue: alasan,
                            onChanged: (value) {
                              setState(() {
                                alasan = value.toString();
                                print(alasan);
                                tampilkanTFTugasKe = false;
                                tampilkanTFLainnya = false;
                              });
                            },
                          ),
                        ),
                        SizedBox(
                          height: 40,
                          child: RadioListTile(
                            title: Text(
                              "Tugas ke",
                              style: TextStyle(fontSize: 15),
                            ),
                            value: "Tugas Ke",
                            groupValue: alasan,
                            onChanged: (value) {
                              setState(() {
                                alasan = value.toString();
                                print(alasan);
                                tampilkanTFTugasKe = true;
                                tampilkanTFLainnya = false;
                              });
                            },
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        tampilkanTFTugasKe
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
                                tampilkanTFTugasKe = false;
                                tampilkanTFLainnya = true;
                              });
                            },
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
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
                      ],
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
                          color: HexColor('#13542D'),
                          onPressed: () {
                            if (tfTanggalIzin.text.toString() != "" &&
                                tfJamKeluar.text.toString() != "" &&
                                alasan != "") {
                              submitForm();
                            } else {
                              globals.showAlertError(
                                  context: context,
                                  message:
                                      'Harap mengisi form dengan lengkap!');
                            }
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
