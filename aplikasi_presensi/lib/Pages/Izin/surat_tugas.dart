// ignore_for_file: prefer_const_constructors, non_constant_identifier_names

import 'package:aplikasi_presensi/Pages/Izin/list_izin.dart';
import 'package:aplikasi_presensi/Pages/Izin/menu_izin.dart';
import 'package:aplikasi_presensi/api/dbservices_form_izin.dart';
import 'package:aplikasi_presensi/api/dbservices_kantor.dart';
import 'package:aplikasi_presensi/models/kantor.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:aplikasi_presensi/globals.dart' as globals;

class SuratTugas extends StatefulWidget {
  const SuratTugas({super.key});

  @override
  State<SuratTugas> createState() => _SuratTugasState();
}

class _SuratTugasState extends State<SuratTugas> {
  FormIzinService db = FormIzinService();
  KantorServices dbKantor = KantorServices();
  TextEditingController tfTanggalIzin = TextEditingController();
  TextEditingController tfTempatTujuan = TextEditingController();
  TextEditingController tfUraianTugas = TextEditingController();
  TextEditingController tfBonSementara = TextEditingController();
  String? tanggal_awal;
  String? tanggal_akhir;
  String? valueChoose;
  late List<Kantor> listKantor;
  bool isLoading = true;
  String tanggal_pengajuan = DateFormat('yyyy-MM-dd').format(DateTime.now());

  void pindahKeMenuIzin() {
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) {
      return const ListIzin();
    }));
  }

  void getListKantor() async {
    try {
      listKantor = await dbKantor.getDataKantor();
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print(e.toString());
    }
  }

  void submitForm() async {
    if (tfTanggalIzin.text != "" &&
        tfTempatTujuan != "" &&
        tfUraianTugas.text != "") {
      try {
        await db.insertFormSuratTugas(
          globals.pegawai.read('nik'),
          globals.pegawai.read('nik_atasan'),
          tanggal_awal!.toString(),
          tanggal_akhir!.toString(),
          tfUraianTugas.text.toString(),
          tfTempatTujuan.text.toString()!,
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
  void initState() {
    getListKantor();
    super.initState();
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
                        if (tanggal != null && tanggal != null) {
                          print(tanggal.start);
                          print(tanggal.end);
                          String formattedDate =
                              DateFormat('dd MMMM yyyy').format(tanggal.start);
                          String formattedDate2 =
                              DateFormat('dd MMMM yyyy').format(tanggal.end);

                          setState(() {
                            tanggal_awal =
                                DateFormat('yyyy-MM-dd').format(tanggal.start);
                            tanggal_akhir =
                                DateFormat('yyyy-MM-dd').format(tanggal.end);
                            tfTanggalIzin.text =
                                '$formattedDate - $formattedDate2';
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
                  SizedBox(height: 10),
                  TextField(
                    controller: tfTempatTujuan,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height / 20,
                          left: MediaQuery.of(context).size.width / 20),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      hintText: 'Masukkan Tempat Tujuan Tugas',
                      hintStyle: TextStyle(fontSize: 13),
                    ),
                  ),
                  // Container(
                  //   padding: EdgeInsets.all(4),
                  //   // height: 50,
                  //   decoration: BoxDecoration(
                  //       borderRadius: BorderRadius.circular(15),
                  //       border: Border.all(color: Colors.grey)),
                  //   child: dropdownListKantor(),
                  // ),
                  SizedBox(
                    height: 20,
                  ),
                  Text('Uraian Tugas'),
                  SizedBox(height: 10),
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
                    height: 15,
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
                          color: HexColor("#13542D"),
                          onPressed: () {
                            print(tfTanggalIzin.text);
                            print(tfTempatTujuan.text);
                            print(tfUraianTugas.text);
                            if (tfTanggalIzin.text.toString() != "" &&
                                tfTempatTujuan.text.toString() != "" &&
                                tfUraianTugas.text.toString() != "") {
                              submitForm();
                            } else {
                              globals.showAlertError(
                                  context: context,
                                  message:
                                      'Harap mengisi form dengan lengkap!');
                            }
                          },
                          child: Text(
                            'AJUKAN',
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

  Widget dropdownListKantor() {
    if (isLoading == false) {
      return DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true,
          hint: Text('Pilih Kantor Tujuan'),
          value: valueChoose,
          icon: const Icon(Icons.arrow_downward),
          elevation: 16,
          style: const TextStyle(color: Colors.black),
          onChanged: (String? value) {
            // This is called when the user selects an item.
            setState(() {
              valueChoose = value!;
              print(valueChoose);
            });
          },
          items: listKantor.map((value) {
            return DropdownMenuItem(
              value: value.id.toString(),
              child: Text(value.nama.toString()),
            );
          }).toList(),
        ),
      );
    } else {
      return SizedBox();
    }
  }
}
