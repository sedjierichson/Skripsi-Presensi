import 'package:aplikasi_presensi/api/dbservices_presensi.dart';
import 'package:aplikasi_presensi/models/presensi.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:hexcolor/hexcolor.dart';

class historyKeluarMasuk extends StatefulWidget {
  final String nik;
  final String tanggal;
  final String foto;
  const historyKeluarMasuk(
      {super.key,
      required this.nik,
      required this.tanggal,
      required this.foto});

  @override
  State<historyKeluarMasuk> createState() => _historyKeluarMasukState();
}

class _historyKeluarMasukState extends State<historyKeluarMasuk> {
  List<Presensi> historyKeluarMasuk = [];
  PresensiService db = PresensiService();
  bool isLoadingAll = true;
  bool isErrorAll = false;
  void getDataPresensi() async {
    try {
      historyKeluarMasuk = await db.getHistoryKeluarMasukPresensi(
          nik: widget.nik.toString(), tanggal: widget.tanggal.toString());
      print(historyKeluarMasuk);
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
    getDataPresensi();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Center(
            child: Padding(
              padding: EdgeInsets.all(15),
              child: Column(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width / 1.5,
                    child: Image.network(
                      widget.foto,
                      fit: BoxFit.fill,
                      loadingBuilder: (BuildContext context, Widget child,
                          ImageChunkEvent? loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Center(
                          child: CircularProgressIndicator(
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes!
                                : null,
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Text(
                    'History Keluar Masuk',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  tablePresensi()
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget tablePresensi() {
    if (isLoadingAll == false && isErrorAll == false) {
      return SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            columnSpacing: 30,
            columns: [
              DataColumn(
                  label: Text(
                'Jam Masuk',
                textAlign: TextAlign.center,
              )),
              DataColumn(
                  label: Text(
                'Jam Keluar',
                textAlign: TextAlign.center,
              )),
            ],
            rows: historyKeluarMasuk.map((e) {
              return DataRow(cells: [
                DataCell(Container(
                  alignment: Alignment.center,
                  child: Text(
                    e.jamMasuk.toString(),
                    textAlign: TextAlign.center,
                  ),
                )),
                DataCell(Container(
                  alignment: Alignment.center,
                  child: Text(
                    e.jamKeluar.toString(),
                    textAlign: TextAlign.center,
                  ),
                )),
              ]);
            }).toList(),
          ),
        ),
      );
    } else if (isLoadingAll == false && isErrorAll == true) {
      return Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Data keluar masuk presensi tidak ditemukan',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            MaterialButton(
              color: HexColor('#ffa133'),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => super.widget,
                  ),
                );
              },
              child: Text("REFRESH"),
            ),
          ],
        ),
      );
    } else if (isLoadingAll == true) {
      return Center(
        child: CircularProgressIndicator(),
      );
    } else {
      return Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Data keluar masuk presensi tidak ditemukan',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            MaterialButton(
              color: HexColor('#ffa133'),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => super.widget,
                  ),
                );
              },
              child: Text("REFRESH"),
            ),
          ],
        ),
      );
    }
  }
}
