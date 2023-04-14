// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:aplikasi_presensi/Pages/Lainnya/detail_izin_bawahan.dart';
import 'package:aplikasi_presensi/api/dbservices_form_izin.dart';
import 'package:aplikasi_presensi/models/izin.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:aplikasi_presensi/globals.dart' as globals;
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:quickalert/quickalert.dart';

class IzinBawahanPage extends StatefulWidget {
  const IzinBawahanPage({super.key});

  @override
  State<IzinBawahanPage> createState() => _IzinBawahanPageState();
}

class _IzinBawahanPageState extends State<IzinBawahanPage> {
  FormIzinService db = FormIzinService();
  List<Izin> daftarIzin = [];
  bool isLoadingAll = true;
  bool isErrorAll = false;
  String tahunFilter = "";
  String bulanFilter = "";
  String textTanggal = "";
  int jumlahPulangLebihAwal = 0;
  int jumlahSuratTugas = 0;
  int julahMeninggalkanKantor = 0;
  int jumlahTidakAbsen = 0;

  void getDaftarIzinBawahan() async {
    setState(() {
      isLoadingAll = true;
      isErrorAll = false;
    });
    try {
      daftarIzin =
          await db.getIzin(nikAtasan: globals.pegawai.read('nik').toString());
      setState(() {
        isLoadingAll = false;
      });
      getJumlah();
    } catch (e) {
      setState(() {
        isLoadingAll = false;
        isErrorAll = true;
      });
      print(e.toString());
    }
  }

  void getJumlah() {
    setState(() {
      jumlahPulangLebihAwal = 0;
      jumlahSuratTugas = 0;
      jumlahTidakAbsen = 0;
      julahMeninggalkanKantor = 0;
    });
    for (int i = 0; i < daftarIzin.length; i++) {
      if (daftarIzin[i].idJenisIzin.toString() == '1') {
        jumlahPulangLebihAwal += 1;
      } else if (daftarIzin[i].idJenisIzin.toString() == '2') {
        julahMeninggalkanKantor += 1;
      } else if (daftarIzin[i].idJenisIzin.toString() == '3') {
        jumlahSuratTugas += 1;
      } else {
        jumlahTidakAbsen += 1;
      }
    }
  }

  void pindahkeDetailIzin(Izin detail) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return detailIzinBawahan(
        detail: detail,
      );
    }));
  }

  @override
  void initState() {
    getDaftarIzinBawahan();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.width / 20,
                left: MediaQuery.of(context).size.width / 15,
                right: MediaQuery.of(context).size.width / 15),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () {
                        setState(() {
                          textTanggal = "";
                          getDaftarIzinBawahan();
                        });
                        DatePicker.showPicker(context,
                            pickerModel: CustomMonthPicker(
                              currentTime: DateTime.now(),
                              minTime: DateTime(2020, 1, 1),
                              maxTime: DateTime.now(),
                            ), onConfirm: (val) {
                          setState(() {
                            textTanggal = DateFormat('MMMM yyyy').format(val);
                            tahunFilter = DateFormat('yyyy').format(val);
                            bulanFilter = DateFormat('MM').format(val);
                            daftarIzin.retainWhere((element) =>
                                element.tanggalPengajuan.toString().contains(
                                    '$tahunFilter' + '-' + '$bulanFilter'));
                            getJumlah();
                          });
                        });
                      },
                      child: Icon(FontAwesomeIcons.calendar),
                    ),
                    Text(
                      'Daftar Izin Team Saya',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        showCupertinoModalPopup(
                          context: context,
                          builder: (context) => CupertinoAlertDialog(
                            title:
                                Text('Jumlah Izin Team Saya Berdasarkan Jenis'),
                            actions: [
                              CupertinoDialogAction(
                                  isDefaultAction: true,
                                  onPressed: () => Navigator.pop(context),
                                  child: Text('OK')),
                            ],
                            content: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                    'Izin Pulang Lebih Awal = $jumlahPulangLebihAwal'),
                                Text(
                                    'Meninggalkan Kantor = $julahMeninggalkanKantor'),
                                Text('Surat Tugas = $jumlahSuratTugas'),
                                Text('Lupa Absen = $jumlahTidakAbsen'),
                              ],
                            ),
                          ),
                        );
                      },
                      child: Icon(FontAwesomeIcons.circleInfo),
                    ),
                  ],
                ),
                Text(
                  '$textTanggal',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Expanded(
                  child: cardIzin(),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget cardIzin() {
    if (isLoadingAll == false && isErrorAll == false) {
      return ListView.builder(
        scrollDirection: Axis.vertical,
        itemCount: daftarIzin.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () => pindahkeDetailIzin(daftarIzin[index]),
            child: Container(
              margin: EdgeInsets.only(
                bottom: 5,
              ),
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                border: Border.all(),
                borderRadius: BorderRadius.circular(10),
              ),
              alignment: Alignment.centerLeft,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 10,
                  ),
                  daftarIzin[index].status == '1'
                      ? Icon(
                          FontAwesomeIcons.clock,
                          color: HexColor('#FFA133'),
                        )
                      : daftarIzin[index].status.toString() == '2'
                          ? Icon(
                              FontAwesomeIcons.check,
                              color: Colors.green,
                            )
                          : Icon(
                              FontAwesomeIcons.xmark,
                              color: HexColor('#DF2E38'),
                            ),
                  SizedBox(
                    width: 15,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${daftarIzin[index].nama} - ${daftarIzin[index].nik}',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                        Text(
                          daftarIzin[index].jenis,
                          style: TextStyle(fontSize: 15),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          daftarIzin[index].tanggalPengajuan.toString(),
                          style: TextStyle(fontSize: 15),
                        ),
                        daftarIzin[index].status == '1'
                            ? Text('Status : Pending')
                            : daftarIzin[index].status.toString() == '2'
                                ? Text('Status : Diterima')
                                : Text('Status : Ditolak')
                      ],
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 15,
                  )
                ],
              ),
            ),
          );
        },
      );
    } else if (isLoadingAll == true) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    } else {
      return Center(
          child: Column(
        children: [
          Text("Unknown Error"),
          ElevatedButton(
            onPressed: () {
              setState(() {
                daftarIzin.clear();
                getDaftarIzinBawahan();
              });
            },
            child: Text("Tap to refresh"),
          ),
        ],
      ));
    }
  }
}

class CustomMonthPicker extends DatePickerModel {
  CustomMonthPicker(
      {required DateTime currentTime,
      DateTime? minTime,
      DateTime? maxTime,
      LocaleType? locale})
      : super(
            locale: locale,
            minTime: minTime,
            maxTime: maxTime,
            currentTime: currentTime);

  @override
  List<int> layoutProportions() {
    return [1, 1, 0];
  }
}
