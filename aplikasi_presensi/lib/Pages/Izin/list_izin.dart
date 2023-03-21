// ignore_for_file: prefer_const_constructors

import 'package:aplikasi_presensi/Pages/Izin/menu_izin.dart';
import 'package:aplikasi_presensi/api/dbservices_form_izin.dart';
import 'package:aplikasi_presensi/models/izin.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:aplikasi_presensi/globals.dart' as globals;
import 'package:intl/intl.dart';

class ListIzin extends StatefulWidget {
  const ListIzin({super.key});

  @override
  State<ListIzin> createState() => _ListIzinState();
}

class _ListIzinState extends State<ListIzin> {
  FormIzinService db = FormIzinService();
  List<Izin> daftarIzin = [];
  bool isLoadingAll = true;
  bool isErrorAll = false;
  int jumlahPulangLebihAwal = 0;
  int jumlahSuratTugas = 0;
  int julahMeninggalkanKantor = 0;
  int jumlahTidakAbsen = 0;

  void pindahKePilihTipeIzin() {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return const MenuIzin();
    }));
  }

  void getJumlah() {
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

  void getDaftarIzin() async {
    // print("terpanggil");
    setState(() {
      isLoadingAll = true;
      isErrorAll = false;
    });
    try {
      daftarIzin =
          await db.getIzin(nikUser: globals.currentPegawai.nik.toString());
      getJumlah();
      setState(() {
        isLoadingAll = false;
      });
    } catch (e) {
      setState(() {
        isLoadingAll = false;
        isErrorAll = true;
      });
    }
  }

  @override
  void initState() {
    getDaftarIzin();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(MediaQuery.of(context).size.width / 15),
            child: Column(
              children: [
                Text(
                  'IZIN SAYA',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        Container(
                          alignment: Alignment.center,
                          width: MediaQuery.of(context).size.width / 5,
                          height: MediaQuery.of(context).size.width / 5,
                          decoration: BoxDecoration(
                            border: Border.all(width: 2),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            jumlahPulangLebihAwal.toString(),
                            style: TextStyle(fontSize: 25),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width / 5,
                          child: Text(
                            'Pulang Lebih Awal',
                            textAlign: TextAlign.center,
                          ),
                        )
                      ],
                    ),
                    Column(
                      children: [
                        Container(
                          alignment: Alignment.center,
                          width: MediaQuery.of(context).size.width / 5,
                          height: MediaQuery.of(context).size.width / 5,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(width: 2),
                          ),
                          child: Text(
                            jumlahSuratTugas.toString(),
                            style: TextStyle(fontSize: 25),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width / 5,
                          child: Text(
                            'Surat Tugas',
                            textAlign: TextAlign.center,
                          ),
                        )
                      ],
                    ),
                    Column(
                      children: [
                        Container(
                          alignment: Alignment.center,
                          width: MediaQuery.of(context).size.width / 5,
                          height: MediaQuery.of(context).size.width / 5,
                          decoration: BoxDecoration(
                            border: Border.all(width: 2),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            julahMeninggalkanKantor.toString(),
                            style: TextStyle(fontSize: 25),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width / 5,
                          child: Text(
                            'Meninggalkan Kantor',
                            textAlign: TextAlign.center,
                          ),
                        )
                      ],
                    ),
                    Column(
                      children: [
                        Container(
                          alignment: Alignment.center,
                          width: MediaQuery.of(context).size.width / 5,
                          height: MediaQuery.of(context).size.width / 5,
                          decoration: BoxDecoration(
                            border: Border.all(width: 2),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            jumlahTidakAbsen.toString(),
                            style: TextStyle(fontSize: 25),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width / 5,
                          child: Text(
                            'Tidak Absen',
                            textAlign: TextAlign.center,
                          ),
                        )
                      ],
                    ),
                  ],
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
                      color: HexColor('#13542D'),
                      onPressed: () {
                        pindahKePilihTipeIzin();
                      },
                      child: Text(
                        'Ajukan Izin Baru',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Expanded(child: cardIzin())
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
          return Container(
            margin: EdgeInsets.only(bottom: 5),
            padding: EdgeInsets.all(5),
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              border: Border.all(),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                daftarIzin[index].status.toString() == '1'
                    ? textPending()
                    : daftarIzin[index].status.toString() == '2'
                        ? textDiterima()
                        : textDitolak(),
                SizedBox(
                  height: 5,
                ),
                Text(
                  daftarIzin[index].jenis,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  DateFormat('dd MMMM yyyy').format(
                    DateTime.parse(
                      daftarIzin[index].tanggalPengajuan.toString(),
                    ),
                  ),
                ),
              ],
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
                getDaftarIzin();
              });
            },
            child: Text("Tap to refresh"),
          ),
        ],
      ));
    }
  }

  Widget textPending() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          alignment: Alignment.center,
          height: 30,
          width: 90,
          decoration: BoxDecoration(
            color: Colors.orange,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            'PENDING',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        IconButton(
          onPressed: () {
            print("Dihapus");
          },
          icon: Icon(
            FontAwesomeIcons.trash,
            size: 17,
          ),
          color: Colors.red,
        )
      ],
    );
  }

  Widget textDiterima() {
    return Container(
      alignment: Alignment.center,
      height: 30,
      width: 90,
      decoration: BoxDecoration(
        color: HexColor('#C3CF0A'),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        'DITERIMA',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget textDitolak() {
    return Container(
      alignment: Alignment.center,
      height: 30,
      width: 90,
      decoration: BoxDecoration(
        color: HexColor('#DF2E38'),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        'DITOLAK',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }
}
