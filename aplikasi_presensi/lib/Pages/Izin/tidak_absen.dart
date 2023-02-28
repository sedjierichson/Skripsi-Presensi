import 'package:aplikasi_presensi/Pages/Izin/menu_izin.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:intl/intl.dart';

class PemberitahuanTidakAbsen extends StatefulWidget {
  const PemberitahuanTidakAbsen({super.key});

  @override
  State<PemberitahuanTidakAbsen> createState() =>
      _PemberitahuanTidakAbsenState();
}

class _PemberitahuanTidakAbsenState extends State<PemberitahuanTidakAbsen> {
  TextEditingController tfTanggalIzin = TextEditingController();
  TextEditingController tfJamIzinPergi = TextEditingController();
  TextEditingController tfJamIzinPulang = TextEditingController();
  TextEditingController tfAlasanLainnyaIzin = TextEditingController();
  
  String? alasan;

  bool tampilkanTFTugasKe = false;
  bool tampilkanTFLainnya = false;

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
                                tfJamIzinPergi.text = formattedTime;
                              });
                            }
                            ;
                          },
                          controller: tfJamIzinPergi,
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
                                tfJamIzinPulang.text = formattedTime;
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
                          color: Colors.cyan,
                          onPressed: () {
                            pindahKeMenuIzin();
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
