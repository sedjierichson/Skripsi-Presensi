// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, use_build_context_synchronously

import 'package:aplikasi_presensi/Pages/Lainnya/izin_bawahan.dart';
import 'package:aplikasi_presensi/api/dbservices_form_izin.dart';
import 'package:aplikasi_presensi/api/dbservices_presensi.dart';
import 'package:aplikasi_presensi/models/izin.dart';
import 'package:aplikasi_presensi/models/presensi.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:aplikasi_presensi/globals.dart' as globals;
import 'package:quickalert/quickalert.dart';

class detailIzinBawahan extends StatefulWidget {
  final Izin detail;
  const detailIzinBawahan({super.key, required this.detail});

  @override
  State<detailIzinBawahan> createState() => _detailIzinBawahanState();
}

class _detailIzinBawahanState extends State<detailIzinBawahan> {
  FormIzinService db = FormIzinService();
  PresensiService db2 = PresensiService();
  String? bulantahunFilter;
  List<Presensi> kehadiran = [];
  List<Izin> daftarIzin = [];
  int jumlahKategoriA = 0;
  int jumlahKategoriB = 0;
  int jumlahKategoriC = 0;
  int jumlahKategoriD = 0;
  int jumlahPulangLebihAwal = 0;
  bool isLoadingAll = true;
  bool isErrorAll = false;

  void getDataPresensi({DateTime? filter}) async {
    try {
      kehadiran = await db2.getDataPresensi(
        nik: widget.detail.nik.toString(),
      );
      String tahunFilter = DateFormat('yyyy').format(filter!);
      String bulanFilter = DateFormat('MM').format(filter);
      kehadiran.retainWhere((element) => element.tanggal
          .toString()
          .contains('$tahunFilter' + '-' + '$bulanFilter'));
      getJumlahKehadiran();
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

  void getJumlahKehadiran() {
    setState(() {
      jumlahKategoriA = 0;
      jumlahKategoriB = 0;
      jumlahKategoriC = 0;
      jumlahKategoriD = 0;
    });
    for (int i = 0; i < kehadiran.length; i++) {
      if (kehadiran[i].kategori.toString() == 'A') {
        jumlahKategoriA += 1;
      } else if (kehadiran[i].kategori.toString() == 'B') {
        jumlahKategoriB += 1;
      } else if (kehadiran[i].kategori.toString() == 'C') {
        jumlahKategoriC += 1;
      } else {
        jumlahKategoriD += 1;
      }
    }
  }

  void getDaftarIzin({DateTime? filter}) async {
    setState(() {
      isLoadingAll = true;
      isErrorAll = false;
    });
    try {
      daftarIzin = await db.getIzin(nikUser: widget.detail.nik.toString());
      String tahunFilter = DateFormat('yyyy').format(filter!);
      String bulanFilter = DateFormat('MM').format(filter);
      daftarIzin.retainWhere((element) => element.tanggalPengajuan
          .toString()
          .contains('$tahunFilter' + '-' + '$bulanFilter'));
      getJumlahIzin();
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

  void getJumlahIzin() {
    setState(() {
      jumlahPulangLebihAwal = 0;
    });
    for (int i = 0; i < daftarIzin.length; i++) {
      if (daftarIzin[i].idJenisIzin.toString() == '1') {
        jumlahPulangLebihAwal += 1;
      }
    }
  }

  @override
  void initState() {
    bulantahunFilter = DateFormat('MMMM yyyy')
        .format(DateTime.parse(widget.detail.tanggalPengajuan.toString()));
    getDataPresensi(
        filter: DateTime.parse(widget.detail.tanggalPengajuan.toString()));
    getDaftarIzin(
        filter: DateTime.parse(widget.detail.tanggalPengajuan.toString()));
    super.initState();
  }

  void terimaTolakIzin(String id, String tanggal, String mode) async {
    try {
      await db.terimaTolakIzin(id, tanggal, mode);
      Navigator.pop(context);
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (context) {
        return const IzinBawahanPage();
      }));
      globals.showAlertBerhasil(context: context, message: 'Izin di$mode');
    } catch (e) {
      globals.showAlertError(context: context, message: e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.width / 15,
                  left: MediaQuery.of(context).size.width / 15,
                  right: MediaQuery.of(context).size.width / 15),
              child: widget.detail.idJenisIzin == '1'
                  ? cardPulangLebihAwal()
                  : widget.detail.idJenisIzin.toString() == '2'
                      ? cardMeninggalkanKantor()
                      : widget.detail.idJenisIzin.toString() == '3'
                          ? cardSuratTugas()
                          : cardLupaAbsen(),
            ),
          ),
        ),
      ),
    );
  }

  Widget cardPulangLebihAwal() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          alignment: Alignment.center,
          child: Text(
            'Izin Pulang Lebih Awal',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
        ),
        Container(
          alignment: Alignment.center,
          child: Text(
            'Tanggal Pengajuan : ' +
                DateFormat('dd MMMM yyyy').format(
                    DateTime.parse(widget.detail.tanggalPengajuan.toString())),
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Text(
          "Nama Pegawai - NIK",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        SizedBox(
          height: 5,
        ),
        TextField(
          readOnly: true,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.only(
                top: MediaQuery.of(context).size.height / 20,
                left: MediaQuery.of(context).size.width / 20),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            hintText: widget.detail.nama + ' - ' + widget.detail.nik,
            hintStyle: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Text("Jam Pulang", style: TextStyle(fontWeight: FontWeight.bold)),
        SizedBox(
          height: 5,
        ),
        TextField(
          readOnly: true,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.only(
                top: MediaQuery.of(context).size.height / 20,
                left: MediaQuery.of(context).size.width / 20),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            hintText: widget.detail.jamAwal,
            hintStyle: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Text("Alasan", style: TextStyle(fontWeight: FontWeight.bold)),
        SizedBox(
          height: 5,
        ),
        TextField(
          readOnly: true,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.only(
                top: MediaQuery.of(context).size.height / 20,
                left: MediaQuery.of(context).size.width / 20),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            hintText: widget.detail.alasan,
            hintStyle: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(
          height: 20,
        ),
        widget.detail.status == "1" ? cardButtonTerimaTolak() : SizedBox(),
        SizedBox(
          height: 8,
        ),
        Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(color: HexColor('FFA133')),
          child: MaterialButton(
            onPressed: () {
              showCupertinoModalPopup(
                context: context,
                builder: (context) => CupertinoAlertDialog(
                  title: Text(
                      'Riwayat Izin & Rekap Kehadiran Bulan $bulantahunFilter'),
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
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        'Jumlah Izin Pulang Lebih Awal $bulantahunFilter',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                      Text('$jumlahPulangLebihAwal izin'),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        'Kehadiran $bulantahunFilter',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                      Text('Kategori A = $jumlahKategoriA'),
                      Text('Kategori B = $jumlahKategoriB'),
                      Text('Kategori C = $jumlahKategoriC'),
                      Text('Kategori D = $jumlahKategoriD'),
                    ],
                  ),
                ),
              );
            },
            child: Text(
              'Lihat Riwayat & Kehadiran',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget cardMeninggalkanKantor() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          alignment: Alignment.center,
          child: Text(
            'Izin Meninggalkan Lokasi Kerja',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
        ),
        Container(
          alignment: Alignment.center,
          child: Text(
            'Tanggal Pengajuan : ' +
                DateFormat('dd MMMM yyyy').format(
                    DateTime.parse(widget.detail.tanggalPengajuan.toString())),
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Text(
          "Nama Pegawai - NIK",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        SizedBox(
          height: 5,
        ),
        TextField(
          readOnly: true,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.only(
                top: MediaQuery.of(context).size.height / 20,
                left: MediaQuery.of(context).size.width / 20),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            hintText: widget.detail.nama + ' - ' + widget.detail.nik,
            hintStyle: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Text("Jam Pergi - Jam Kembali",
            style: TextStyle(fontWeight: FontWeight.bold)),
        SizedBox(
          height: 5,
        ),
        Row(
          children: [
            Expanded(
              child: TextField(
                readOnly: true,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height / 20,
                      left: MediaQuery.of(context).size.width / 20),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  hintText: widget.detail.jamAwal,
                  hintStyle: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Text(' s/d '),
            Expanded(
              child: TextField(
                readOnly: true,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height / 20,
                      left: MediaQuery.of(context).size.width / 20),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  hintText: widget.detail.jamAwal,
                  hintStyle:
                      TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
        SizedBox(
          height: 10,
        ),
        Text("Alasan", style: TextStyle(fontWeight: FontWeight.bold)),
        SizedBox(
          height: 5,
        ),
        TextField(
          readOnly: true,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.only(
                top: MediaQuery.of(context).size.height / 20,
                left: MediaQuery.of(context).size.width / 20),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            hintText: widget.detail.alasan,
            hintStyle: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(
          height: 30,
        ),
        widget.detail.status == "1" ? cardButtonTerimaTolak() : SizedBox(),
      ],
    );
  }

  Widget cardSuratTugas() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          alignment: Alignment.center,
          child: Text(
            'Surat Tugas',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
        ),
        Container(
          alignment: Alignment.center,
          child: Text(
            'Tanggal Pengajuan : ' +
                DateFormat('dd MMMM yyyy').format(
                    DateTime.parse(widget.detail.tanggalPengajuan.toString())),
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Text(
          "Nama Pegawai - NIK",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        SizedBox(
          height: 5,
        ),
        TextField(
          readOnly: true,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.only(
                top: MediaQuery.of(context).size.height / 20,
                left: MediaQuery.of(context).size.width / 20),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            hintText: widget.detail.nama + ' - ' + widget.detail.nik,
            hintStyle: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Text("Tanggal Awal", style: TextStyle(fontWeight: FontWeight.bold)),
        SizedBox(
          height: 5,
        ),
        TextField(
          readOnly: true,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.only(
                top: MediaQuery.of(context).size.height / 20,
                left: MediaQuery.of(context).size.width / 20),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            hintText: widget.detail.tanggalAwal,
            hintStyle: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Text("Tanggal Akhir", style: TextStyle(fontWeight: FontWeight.bold)),
        SizedBox(
          height: 5,
        ),
        TextField(
          readOnly: true,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.only(
                top: MediaQuery.of(context).size.height / 20,
                left: MediaQuery.of(context).size.width / 20),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            hintText: widget.detail.tanggalAkhir,
            hintStyle: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Text("Uraian Tugas", style: TextStyle(fontWeight: FontWeight.bold)),
        SizedBox(
          height: 5,
        ),
        TextField(
          maxLines: 8,
          minLines: 7,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.only(
                top: MediaQuery.of(context).size.height / 20,
                left: MediaQuery.of(context).size.width / 20),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            hintText: widget.detail.uraianTugas,
            hintStyle: TextStyle(fontSize: 13),
          ),
        ),
        SizedBox(
          height: 30,
        ),
        widget.detail.status == "1" ? cardButtonTerimaTolak() : SizedBox(),
      ],
    );
  }

  Widget cardLupaAbsen() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          alignment: Alignment.center,
          child: Text(
            'Pemberitahuan Tidak Melakukan Presensi',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
        ),
        Container(
          alignment: Alignment.center,
          child: Text(
            'Tanggal Pengajuan : ' +
                DateFormat('dd MMMM yyyy').format(
                    DateTime.parse(widget.detail.tanggalPengajuan.toString())),
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Text(
          "Nama Pegawai - NIK",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        SizedBox(
          height: 5,
        ),
        TextField(
          readOnly: true,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.only(
                top: MediaQuery.of(context).size.height / 20,
                left: MediaQuery.of(context).size.width / 20),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            hintText: widget.detail.nama + ' - ' + widget.detail.nik,
            hintStyle: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Text("Jam Masuk - Jam Pulang",
            style: TextStyle(fontWeight: FontWeight.bold)),
        SizedBox(
          height: 5,
        ),
        Row(
          children: [
            Expanded(
              child: TextField(
                readOnly: true,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height / 20,
                      left: MediaQuery.of(context).size.width / 20),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  hintText: widget.detail.jamAwal,
                  hintStyle: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Text(' s/d '),
            Expanded(
              child: TextField(
                readOnly: true,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height / 20,
                      left: MediaQuery.of(context).size.width / 20),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  hintText: widget.detail.jamAwal,
                  hintStyle:
                      TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
        SizedBox(
          height: 10,
        ),
        Text("Alasan", style: TextStyle(fontWeight: FontWeight.bold)),
        SizedBox(
          height: 5,
        ),
        TextField(
          readOnly: true,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.only(
                top: MediaQuery.of(context).size.height / 20,
                left: MediaQuery.of(context).size.width / 20),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            hintText: widget.detail.alasan,
            hintStyle: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(
          height: 30,
        ),
        widget.detail.status == "1" ? cardButtonTerimaTolak() : SizedBox(),
      ],
    );
  }

  Widget cardButtonTerimaTolak() {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Row(
        children: [
          Expanded(
            child: MaterialButton(
              color: HexColor('#C3CF0A'),
              onPressed: () {
                QuickAlert.show(
                  context: context,
                  type: QuickAlertType.confirm,
                  text: 'Apakah anda yakin ?',
                  confirmBtnText: 'Ya',
                  cancelBtnText: 'Tidak',
                  onConfirmBtnTap: () {
                    terimaTolakIzin(
                        widget.detail.id,
                        DateFormat('yyyy-MM-dd')
                            .format(DateTime.now())
                            .toString(),
                        "terima");
                    Navigator.of(context, rootNavigator: true).pop();
                  },
                  onCancelBtnTap: () =>
                      Navigator.of(context, rootNavigator: true).pop(),
                );
              },
              child: Text(
                'TERIMA',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
          SizedBox(
            width: 20,
          ),
          Expanded(
            child: MaterialButton(
              color: HexColor('#DF2E38'),
              onPressed: () {
                QuickAlert.show(
                  context: context,
                  type: QuickAlertType.confirm,
                  text: 'Apakah anda yakin ?',
                  confirmBtnText: 'Ya',
                  cancelBtnText: 'Tidak',
                  onConfirmBtnTap: () {
                    terimaTolakIzin(
                        widget.detail.id,
                        DateFormat('yyyy-MM-dd')
                            .format(DateTime.now())
                            .toString(),
                        "tolak");
                    Navigator.of(context, rootNavigator: true).pop();
                  },
                  onCancelBtnTap: () =>
                      Navigator.of(context, rootNavigator: true).pop(),
                );
              },
              child: Text(
                'TOLAK',
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          )
        ],
      ),
    );
  }
}
