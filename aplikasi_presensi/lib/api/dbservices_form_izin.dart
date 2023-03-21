import 'package:aplikasi_presensi/models/izin.dart';

import 'apidbconfig.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class FormIzinService {
  Future<List<Izin>> getIzin({String? nikUser, String? nikAtasan}) async {
    Map<String, String> requestHeaders = {
      "Accept": "application/json",
      "Access-Control_Allow_Origin": "*"
    };
    String uri;
    if (nikUser != null) {
      uri = "$apiUrl/detail_izin.php?nik_pegawai=$nikUser";
    } else if (nikAtasan != null) {
      uri = "$apiUrl/detail_izin.php?nik_atasan=$nikAtasan";
    } else {
      uri = "$apiUrl/detail_izin.php?";
    }
    print(uri);
    final response = await http.get(
      Uri.parse(uri),
      headers: requestHeaders,
    );

    if (response.statusCode == 200) {
      // print('masuk');
      Map<String, dynamic> map = json.decode(response.body);
      if (map['status'] == 0) {
        throw (map['message']);
      } else {
        List<dynamic> data = map['data'];
        // print(data);
        List<Izin> listIzin = [];
        for (int i = 0; i < data.length; i++) {
          Izin izin = Izin(
            id: data[i]['id'],
            idJenisIzin: data[i]['id_jenis_izin'],
            jenis: data[i]['tipe_izin'],
            nik: data[i]['nik_pegawai'],
            nama: data[i]['nama'],
            nikAtasan: data[i]['nik_atasan'],
            tanggalAwal: data[i]['tanggal_awal'],
            tanggalAkhir: data[i]['tanggal_akhir'],
            jamAwal: data[i]['jam_awal'],
            jamAkhir: data[i]['jam_akhir'],
            alasan: data[i]['alasan'],
            tempatTujuan: data[i]['tempat_tujuan'],
            uraianTugas: data[i]['uraian_tugas'],
            tanggalPengajuan: data[i]['tanggal_pengajuan'],
            tanggalRespon: data[i]['tanggal_respon'],
            status: data[i]['status'],
          );
          listIzin.add(izin);
        }
        return listIzin;
      }
    } else {
      throw ("Gagal mengambil data materi");
    }
  }

  Future<String> insertFormMeninggalkanKantor(
    int nikPegawai,
    int nikAtasan,
    String tanggal,
    String jamAwal,
    String jamAkhir,
    String alasan,
    String tanggal_pengajuan,
  ) async {
    print("aaaa" + tanggal_pengajuan);
    final response =
        await http.post(Uri.parse("$apiUrl/detail_izin.php"), body: {
      'nik_pegawai': nikPegawai.toString(),
      'nik_atasan': nikAtasan.toString(),
      'tanggal_izin': tanggal,
      'jam_awal': jamAwal,
      'jam_akhir': jamAkhir,
      'alasan': alasan,
      'tanggal_pengajuan': tanggal_pengajuan
    });

    if (response.statusCode == 200 || response.statusCode == 201) {
      var jsonResponse = json.decode(response.body);
      if (jsonResponse['status'] == 1) {
        return "Berhasil";
      } else {
        throw jsonResponse['message'];
      }
    } else {
      throw ("Gagal memperbarui data user");
    }
  }

  Future<String> insertFormSuratTugas(
      String nikPegawai,
      String nikAtasan,
      String tanggalAwal,
      String tanggalAkhir,
      String uraianTugas,
      String tempatTujuan,
      String tanggal_pengajuan) async {
    final response = await http.post(
      Uri.parse("$apiUrl/detail_izin.php"),
      body: {
        'nik_pegawai': nikPegawai.toString(),
        'nik_atasan': nikAtasan.toString(),
        'tanggal_awal': tanggalAwal,
        'tanggal_akhir': tanggalAkhir,
        'uraian_tugas': uraianTugas,
        'tempat_tujuan': tempatTujuan,
        'tanggal_pengajuan': tanggal_pengajuan,
      },
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      var jsonResponse = json.decode(response.body);
      if (jsonResponse['status'] == 1) {
        return "Berhasil";
      } else {
        throw jsonResponse['message'];
      }
    } else {
      throw ("Gagal memperbarui data user");
    }
  }

  Future<String> insertFormPulangAwal(
    String nikPegawai,
    String nikAtasan,
    String tanggalIzin,
    String jamIzinPulang,
    String alasan,
    String tanggal_pengajuan,
  ) async {
    print("aaa" + nikPegawai.toString());
    final response = await http.post(
      Uri.parse("$apiUrl/detail_izin.php"),
      body: {
        'nik_pegawai': nikPegawai.toString(),
        'nik_atasan': nikAtasan.toString(),
        'tanggal_izin': tanggalIzin,
        'jam_izin_pulang': jamIzinPulang,
        'alasan': alasan,
        'tanggal_pengajuan': tanggal_pengajuan,
      },
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      var jsonResponse = json.decode(response.body);
      if (jsonResponse['status'] == 1) {
        return "Berhasil";
      } else {
        throw jsonResponse['message'];
      }
    } else {
      throw ("Gagal memperbarui data user");
    }
  }

  Future<String> insertFormLupaAbsen(
    String nikPegawai,
    String nikAtasan,
    String tanggalIzin,
    String jamAwal,
    String jamAkhir,
    String alasan,
    String tanggal_pengajuan,
  ) async {
    final response = await http.post(
      Uri.parse("$apiUrl/detail_izin.php"),
      body: {
        'nik_pegawai': nikPegawai.toString(),
        'nik_atasan': nikAtasan.toString(),
        'tanggal_lupa_absen': tanggalIzin,
        'jam_awal': jamAwal,
        'jam_akhir': jamAkhir,
        'alasan': alasan,
        'tanggal_pengajuan': tanggal_pengajuan,
      },
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      var jsonResponse = json.decode(response.body);
      if (jsonResponse['status'] == 1) {
        return "Berhasil";
      } else {
        throw jsonResponse['message'];
      }
    } else {
      throw ("Gagal memperbarui data user");
    }
  }
}
