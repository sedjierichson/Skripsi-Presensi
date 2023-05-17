// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:aplikasi_presensi/Pages/Izin/list_izin.dart';
import 'package:aplikasi_presensi/Pages/Izin/menu_izin.dart';
import 'package:aplikasi_presensi/api/dbservices_form_izin.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:aplikasi_presensi/globals.dart' as globals;

class MeninggalkanSementara extends StatefulWidget {
  const MeninggalkanSementara({super.key});

  @override
  State<MeninggalkanSementara> createState() => _MeninggalkanSementaraState();
}

class _MeninggalkanSementaraState extends State<MeninggalkanSementara> {
  TextEditingController tfTanggalIzin = TextEditingController();
  TextEditingController tfJamIzinPergi = TextEditingController();
  TextEditingController tfJamIzinPulang = TextEditingController();
  String? alasan;
  String? tanggal_izin;
  String? jamPergi;
  String? jamPulang;
  String tanggal_pengajuan = DateFormat('yyyy-MM-dd').format(DateTime.now());
  FormIzinService db = FormIzinService();

  void pindahKeMenuIzin() {
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) {
      return const ListIzin();
    }));
  }

  void submitForm() async {
    if (tfTanggalIzin.text != "" &&
        tfJamIzinPergi.text != "" &&
        tfJamIzinPulang.text != "") {
      try {
        // print('aaaaa' + globals.currentPegawai.nik_atasan);
        await db.insertFormMeninggalkanKantor(
          int.parse(globals.pegawai.read('nik')),
          int.parse(globals.pegawai.read('nik_atasan')),
          tanggal_izin!.toString(),
          jamPergi!.toString(),
          jamPulang!.toString(),
          alasan!.toString(),
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
                  Text(
                    'Form Izin Meninggalkan Kantor Sementara',
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
                            tanggal_izin =
                                DateFormat('yyyy-MM-dd').format(tanggal);
                            print(tanggal_izin);
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
                    'Pukul',
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
                              DateTime parsedTime = DateFormat('hh:mm')
                                  .parse(pickedTime.format(context).toString());
                              String formattedTime =
                                  DateFormat('HH:mm').format(parsedTime);

                              setState(() {
                                tfJamIzinPergi.text = formattedTime;
                                jamPergi = formattedTime;
                              });
                            }
                            ;
                          },
                          controller: tfJamIzinPergi,
                          decoration: InputDecoration(
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
                              DateTime parsedTime = DateFormat('hh:mm')
                                  .parse(pickedTime.format(context).toString());
                              String formattedTime =
                                  DateFormat('HH:mm').format(parsedTime);

                              setState(() {
                                tfJamIzinPulang.text = formattedTime;
                                jamPulang = formattedTime;
                              });
                            }
                            ;
                          },
                          controller: tfJamIzinPulang,
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
                    'Keperluan',
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
                              "Dinas",
                              style: TextStyle(fontSize: 15),
                            ),
                            value: "Dinas",
                            groupValue: alasan,
                            onChanged: (value) {
                              setState(() {
                                alasan = value.toString();
                                print(alasan);
                              });
                            },
                          ),
                        ),
                        SizedBox(
                          height: 40,
                          child: RadioListTile(
                            title: Text(
                              "Pribadi",
                              style: TextStyle(fontSize: 15),
                            ),
                            value: "Pribadi",
                            groupValue: alasan,
                            onChanged: (value) {
                              setState(() {
                                alasan = value.toString();
                                print(alasan);
                              });
                            },
                          ),
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
                            if (tfJamIzinPergi.text.toString() != "" &&
                                tfJamIzinPulang.text.toString() != "" &&
                                tfTanggalIzin.text.toString() != "" &&
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
