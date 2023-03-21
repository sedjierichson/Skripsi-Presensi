// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:aplikasi_presensi/models/izin.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';

class detailIzinBawahan extends StatefulWidget {
  final Izin detail;
  const detailIzinBawahan({super.key, required this.detail});

  @override
  State<detailIzinBawahan> createState() => _detailIzinBawahanState();
}

class _detailIzinBawahanState extends State<detailIzinBawahan> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: EdgeInsets.all(MediaQuery.of(context).size.width / 15),
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
              onPressed: () {},
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
              onPressed: () {},
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
