// ignore_for_file: prefer_const_constructors

import 'package:aplikasi_presensi/Pages/Izin/menu_izin.dart';
import 'package:aplikasi_presensi/api/dbservices_form_izin.dart';
import 'package:aplikasi_presensi/models/izin.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:aplikasi_presensi/globals.dart' as globals;
import 'package:intl/intl.dart';
import 'package:quickalert/quickalert.dart';

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

  String tahunFilter = "";
  String bulanFilter = "";
  String textTanggal = "";

  void pindahKePilihTipeIzin() {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return const MenuIzin();
    }));
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

  void getDaftarIzin({DateTime? filter}) async {
    setState(() {
      isLoadingAll = true;
      isErrorAll = false;
    });
    try {
      daftarIzin =
          await db.getIzin(nikUser: globals.pegawai.read('nik').toString());
      textTanggal = DateFormat('MMMM yyyy').format(filter!);
      tahunFilter = DateFormat('yyyy').format(filter);
      bulanFilter = DateFormat('MM').format(filter);
      daftarIzin.retainWhere((element) => element.tanggalPengajuan
          .toString()
          .contains('$tahunFilter' + '-' + '$bulanFilter'));
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

  void deleteIzin(String id) async {
    try {
      await db.deleteRequestMateri(id.toString());
      globals.showAlertBerhasil(context: context, message: "Izin dihapus");
      setState(() {
        getDaftarIzin(filter: DateTime.now());
      });
    } catch (e) {
      globals.showAlertError(context: context, message: e.toString());
    }
  }

  @override
  void initState() {
    getDaftarIzin(filter: DateTime.now());
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
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () {
                        getDaftarIzin(filter: DateTime.now());
                        DatePicker.showPicker(context,
                            pickerModel: CustomMonthPicker(
                              currentTime: DateTime.now(),
                              minTime: DateTime(2020, 1, 1),
                              maxTime: DateTime.now(),
                            ), onConfirm: (val) {
                          setState(() {
                            textTanggal = DateFormat('MMMM yyyy').format(val);
                            getDaftarIzin(filter: val);
                          });
                        });
                      },
                      child: Icon(
                        FontAwesomeIcons.calendar,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      'IZIN SAYA',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    InkWell(
                      onTap: pindahKePilihTipeIzin,
                      child: Icon(
                        FontAwesomeIcons.plus,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                Text(
                  '$textTanggal',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                SizedBox(
                  height: 15,
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
          return GestureDetector(
            onTap: () => dialogBoxDetailIzin(daftarIzin[index]),
            child: Container(
              margin: EdgeInsets.only(bottom: 5),
              padding: EdgeInsets.only(left: 8, right: 15, top: 5, bottom: 5),
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
                      ? textPending(daftarIzin[index].id)
                      : daftarIzin[index].status.toString() == '2'
                          ? textDiterima()
                          : textDitolak(),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    daftarIzin[index].jenis,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    'Tanggal Pengajuan : ' +
                        DateFormat('dd MMMM yyyy').format(
                          DateTime.parse(
                            daftarIzin[index].tanggalPengajuan.toString(),
                          ),
                        ),
                  ),
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
                getDaftarIzin();
              });
            },
            child: Text("Tap to refresh"),
          ),
        ],
      ));
    }
  }

  void dialogBoxDetailIzin(Izin daftarIzin) {
    if (daftarIzin.idJenisIzin == '1') {
      print('masuk');
      QuickAlert.show(
        context: context,
        type: QuickAlertType.custom,
        widget: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              daftarIzin.jenis,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 7,
            ),
            Text(DateFormat('dd MMMM yyyy')
                .format(DateTime.parse(daftarIzin.tanggalAwal.toString()))),
            Text('Jam Pulang = ' + daftarIzin.jamAwal.toString()),
            Text("Alasan = " + daftarIzin.alasan.toString()),
            SizedBox(
              height: 10,
            ),
            Text(
              daftarIzin.status.toString() == '1'
                  ? 'Pending'
                  : daftarIzin.status.toString() == '2'
                      ? 'Terima'
                      : 'Tolak',
              style: TextStyle(fontWeight: FontWeight.bold),
            )
          ],
        ),
      );
    } else if (daftarIzin.idJenisIzin == '2') {
      QuickAlert.show(
        context: context,
        type: QuickAlertType.custom,
        widget: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              daftarIzin.jenis,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 7,
            ),
            Text(DateFormat('dd MMMM yyyy')
                .format(DateTime.parse(daftarIzin.tanggalAwal.toString()))),
            Text('Jam Pergi = ' + daftarIzin.jamAwal.toString()),
            Text('Jam Kembali = ' + daftarIzin.jamAkhir.toString()),
            Text("Alasan = " + daftarIzin.alasan.toString()),
            SizedBox(
              height: 10,
            ),
            Text(
              daftarIzin.status.toString() == '1'
                  ? 'Pending'
                  : daftarIzin.status.toString() == '2'
                      ? 'Terima'
                      : 'Tolak',
              style: TextStyle(fontWeight: FontWeight.bold),
            )
          ],
        ),
      );
    } else if (daftarIzin.idJenisIzin == '3') {
      QuickAlert.show(
        context: context,
        type: QuickAlertType.custom,
        widget: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              daftarIzin.jenis,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 7,
            ),
            Text('Tanggal Awal = ' + daftarIzin.tanggalAwal.toString()),
            Text('Tanggal Akhir = ' + daftarIzin.tanggalAkhir.toString()),
            Text("Tugas = " + daftarIzin.uraianTugas.toString()),
            SizedBox(
              height: 10,
            ),
            Text(
              daftarIzin.status.toString() == '1'
                  ? 'Pending'
                  : daftarIzin.status.toString() == '2'
                      ? 'Terima'
                      : 'Tolak',
              style: TextStyle(fontWeight: FontWeight.bold),
            )
          ],
        ),
      );
    } else if (daftarIzin.idJenisIzin == '4') {
      QuickAlert.show(
        context: context,
        type: QuickAlertType.custom,
        widget: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              daftarIzin.jenis,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 7,
            ),
            Text('Tanggal Absen = ' + daftarIzin.tanggalAwal.toString()),
            Text('Jam Masuk = ' + daftarIzin.jamAwal.toString()),
            Text('Jam Pulang = ' + daftarIzin.jamAkhir.toString()),
            Text("Alasan = " + daftarIzin.alasan.toString()),
            SizedBox(
              height: 10,
            ),
            Text(
              daftarIzin.status.toString() == '1'
                  ? 'Pending'
                  : daftarIzin.status.toString() == '2'
                      ? 'Terima'
                      : 'Tolak',
              style: TextStyle(fontWeight: FontWeight.bold),
            )
          ],
        ),
      );
    }
  }

  Widget textPending(String id) {
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
        InkWell(
          onTap: () {
            deleteIzin(id);
          },
          child: Container(
            child: Icon(
              FontAwesomeIcons.trash,
              size: 17,
              color: Colors.red,
            ),
          ),
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
