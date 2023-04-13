// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, use_build_context_synchronously

import 'package:aplikasi_presensi/Pages/Lainnya/izin_bawahan.dart';
import 'package:aplikasi_presensi/api/dbservices_form_izin.dart';
import 'package:aplikasi_presensi/models/izin.dart';
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
          height: 30,
        ),
        widget.detail.status == "1" ? cardButtonTerimaTolak() : SizedBox(),
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
