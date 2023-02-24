// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, use_build_context_synchronously, avoid_unnecessary_containers

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:intl/intl.dart';

class PulangLebihAwal extends StatefulWidget {
  const PulangLebihAwal({super.key});

  @override
  State<PulangLebihAwal> createState() => _PulangLebihAwalState();
}

class _PulangLebihAwalState extends State<PulangLebihAwal> {
  TextEditingController tfTanggalIzin = TextEditingController();
  TextEditingController tfJamIzin = TextEditingController();
  String? alasan;
  String jamPulangAwal = '';

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
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    child: Column(
                      children: [
                        SizedBox(
                          height: 40,
                          child: RadioListTile(
                            title: Text("Sakit"),
                            value: "Sakit",
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
                            title: Text("Urusan Keluarga"),
                            value: "Urusan Keluarga",
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
                            title: Text("Panggilan dari Instansi Pemerintah"),
                            value: "Panggilan dari Instansi Pemerintah",
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
                            title: Text("Lainnya"),
                            value: "Lainnya",
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
