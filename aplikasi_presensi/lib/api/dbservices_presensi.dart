import 'package:aplikasi_presensi/models/presensi.dart';
import 'package:aplikasi_presensi/models/rekap.dart';

import 'apidbconfig.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class PresensiService {
  Future<List<String>> getBeaconPresensi() async {
    Map<String, String> requestHeaders = {
      "Accept": "application/json",
      "Access-Control_Allow_Origin": "*"
    };
    final response = await http.get(
      Uri.parse('$apiUrl/beacon.php'),
      headers: requestHeaders,
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> map = json.decode(response.body);
      if (map['status'] == 0) {
        throw (map['message']);
      } else {
        List<dynamic> data = map['data'];
        List<String> listBeacon = [];
        for (int i = 0; i < data.length; i++) {
          listBeacon.add(data[i]['uuid']);
        }
        // print(listBeacon);
        return listBeacon;
      }
    } else {
      throw ("Gagal mengambil data sub-materi");
    }
  }

  Future<Map<String, dynamic>> getKantorBeacon({required String uuid}) async {
    Map<String, String> requestHeaders = {
      "Accept": "application/json",
      "Access-Control_Allow_Origin": "*"
    };

    String uri = "$apiUrl/beacon.php?uuid=$uuid";
    final response = await http.get(Uri.parse(uri), headers: requestHeaders);

    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      return {
        'lokasi': jsonResponse['data']['id_kantor'],
      };
    } else {
      throw ("Gagal melakukan cek data api user");
    }
  }

  Future<List<Presensi>> getDataPresensi(
      {String nik = "",
      String bulan = "",
      String tahun = "",
      String id = "",
      String nik_atasan = ""}) async {
    Map<String, String> requestHeaders = {
      "Accept": "application/json",
      "Access-Control_Allow_Origin": "*"
    };
    String uri;
    if (nik != '') {
      uri = "$apiUrl/presensi.php?nik=$nik";
    } else if (nik != '' && bulan != '' && tahun != '') {
      uri = "$apiUrl/presensi.php?nikk=$nik&tahun=$tahun&bulan=$bulan";
    } else if (id != '') {
      uri = "$apiUrl/presensi.php?id=$id";
    } else if (nik_atasan != '') {
      uri = "$apiUrl/presensi.php?nik_atasan=$nik_atasan";
    } else {
      uri = "$apiUrl/presensi.php";
    }
    final response = await http.get(
      Uri.parse(uri),
      headers: requestHeaders,
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> map = json.decode(response.body);
      if (map['status'] == 0) {
        throw (map['message']);
      } else {
        List<dynamic> data = map['data'];
        List<Presensi> listPresensi = [];
        for (int i = 0; i < data.length; i++) {
          Presensi presensi = Presensi(
              id: data[i]['id'].toString(),
              nik: data[i]['nik'].toString(),
              idKantor: data[i]['id_kantor'].toString(),
              lokasi: data[i]['lokasi'].toString(),
              tanggal: data[i]['tanggal'].toString(),
              jamMasuk: data[i]['jam_masuk'].toString(),
              jamKeluar: data[i]['jam_keluar'].toString(),
              foto: data[i]['foto'].toString(),
              kategori: data[i]['kategori'].toString(),
              status: data[i]['status'].toString());
          listPresensi.add(presensi);
        }
        return listPresensi;
      }
    } else {
      throw ("Gagal mengambil data sub-materi");
    }
  }

  Future<List<Rekap>> getDataRekat(
      {String nik_atasan = "", String bulan = "", String tahun = ""}) async {
    Map<String, String> requestHeaders = {
      "Accept": "application/json",
      "Access-Control_Allow_Origin": "*"
    };
    String uri;

    uri =
        "$apiUrl/presensi.php?nik_atasan=$nik_atasan&bulan_rekap=$bulan&tahun_rekap=$tahun";
    final response = await http.get(
      Uri.parse(uri),
      headers: requestHeaders,
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> map = json.decode(response.body);
      // print(map);
      if (map['status'] == 0) {
        throw (map['message']);
      } else {
        List<dynamic> data = map['data'];
        // print(data);
        List<Rekap> listPresensi = [];
        for (int i = 0; i < data.length; i++) {
          Rekap rekap = Rekap(
            nik: data[i]['nik'].toString(),
            jumlah: data[i]['jumlah'].toString(),
            kategori: data[i]['kategori'].toString(),
          );
          listPresensi.add(rekap);
        }
        return listPresensi;
      }
    } else {
      throw ("Gagal mengambil data sub-materi");
    }
  }

  Future<Presensi> gethistoryPresensi(
      {String nik = "",
      String bulan = "",
      String tahun = "",
      String id = ""}) async {
    Map<String, String> requestHeaders = {
      "Accept": "application/json",
      "Access-Control_Allow_Origin": "*"
    };
    String uri;
    print('masuk');
    uri = "$apiUrl/presensi.php?id=$id";
    final response = await http.get(
      Uri.parse(uri),
      headers: requestHeaders,
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> map = json.decode(response.body);
      if (map['status'] == 0) {
        throw (map['message']);
      } else {
        var data = map['data'];
        Presensi presensi = Presensi(
            id: data['id'].toString(),
            nik: data['nik'].toString(),
            idKantor: data['id_kantor'].toString(),
            lokasi: data['lokasi'].toString(),
            tanggal: data['tanggal'].toString(),
            jamMasuk: data['jam_masuk'].toString(),
            jamKeluar: data['jam_keluar'].toString(),
            foto: data['foto'].toString(),
            kategori: data['kategori'].toString(),
            status: data['status'].toString());
        return presensi;
      }
    } else {
      throw ("Gagal mengambil data sub-materi");
    }
  }

  Future<Map<String, dynamic>> cekSudahAbsen(
      {required String nik, required String tanggal, String? mode}) async {
    Map<String, String> requestHeaders = {
      "Accept": "application/json",
      "Access-Control_Allow_Origin": "*"
    };

    String uri = "$apiUrl/presensi.php?nik_pegawai=$nik&tanggal_absen=$tanggal";

    final response = await http.get(Uri.parse(uri), headers: requestHeaders);

    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      // print("aaa" + jsonResponse['data']['id'].toString());
      return {
        'status': jsonResponse['status'],
        'id': jsonResponse['data']['id'],
        'jam_masuk': jsonResponse['data']['jam_masuk'],
        'jam_keluar': jsonResponse['data']['jam_keluar'],
        'jam_kerja': jsonResponse['data']['jam_kerja'],
        'kategori': jsonResponse['data']['kategori'],
      };
    } else {
      throw ("Gagal melakukan cek data api user");
    }
  }

  Future<Map<String, dynamic>> insertAbsenMasuk(
      String nikPegawai,
      int idKantor,
      String tanggal,
      String jamMasuk,
      String base64Image,
      String fileName,
      String kategori,
      int isHistory) async {
    final response = await http.post(Uri.parse("$apiUrl/presensi.php"), body: {
      'nik': nikPegawai.toString(),
      'id_kantor': idKantor.toString(),
      'tanggal': tanggal,
      'jam_masuk': jamMasuk,
      'image': base64Image,
      'img_name': fileName,
      'kategori': kategori,
      'is_history': isHistory.toString()
    });

    if (response.statusCode == 200 || response.statusCode == 201) {
      var jsonResponse = json.decode(response.body);
      if (jsonResponse['status'] == 1) {
        return {
          'status': jsonResponse['status'],
          'message': jsonResponse['message']
        };
      } else {
        throw jsonResponse['message'];
      }
    } else {
      throw ("Gagal memperbarui data user");
    }
  }

  Future<String> updateJamKeluar(
      String nik, String id_presensi, String jamKeluar) async {
    final response = await http.put(
      Uri.parse("$apiUrl/presensi.php"),
      body: json.encode(
        {
          "nik": nik,
          "id_presensi": id_presensi.toString(),
          "jam_keluar": jamKeluar,
        },
      ),
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      var jsonResponse = json.decode(response.body);
      if (jsonResponse['status'] == 1) {
        return "Berhasil";
      } else {
        throw jsonResponse['message'];
      }
    } else {
      throw ("Gagal update jam keluar");
    }
  }

  Future<String> updateHistoryJamKembali(
      {required String nik,
      required String tanggal,
      required String jam}) async {
    final response = await http.put(
      Uri.parse("$apiUrl/presensi.php"),
      body: json.encode(
        {
          "nik": nik.toString(),
          "tanggal": tanggal,
          "jam_kembali": jam,
        },
      ),
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      var jsonResponse = json.decode(response.body);
      if (jsonResponse['status'] == 1) {
        return "Berhasil";
      } else {
        throw jsonResponse['message'];
      }
    } else {
      throw ("Gagal update jam keluar");
    }
  }

  Future<String> updateKategori(String id_presensi, String kategori) async {
    final response = await http.put(
      Uri.parse("$apiUrl/presensi.php"),
      body: json.encode(
        {
          "id_presensi": id_presensi.toString(),
          "kategori": kategori,
        },
      ),
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      var jsonResponse = json.decode(response.body);
      if (jsonResponse['status'] == 1) {
        return "Berhasil";
      } else {
        throw jsonResponse['message'];
      }
    } else {
      throw ("Gagal update jam keluar");
    }
  }

  Future<Map<String, dynamic>> getJamKerja({required String hari}) async {
    Map<String, String> requestHeaders = {
      "Accept": "application/json",
      "Access-Control_Allow_Origin": "*"
    };

    String uri = "$apiUrl/jamkerja.php?hari=$hari";
    final response = await http.get(Uri.parse(uri), headers: requestHeaders);

    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      return {
        'hari': jsonResponse['data']['hari'],
        'jam_masuk': jsonResponse['data']['jam_masuk'],
        'jam_pulang': jsonResponse['data']['jam_pulang'],
      };
    } else {
      throw ("Gagal melakukan cek data api user");
    }
  }

  Future<List<Presensi>> getHistoryKeluarMasukPresensi({
    String nik = "",
    String tanggal = "",
  }) async {
    Map<String, String> requestHeaders = {
      "Accept": "application/json",
      "Access-Control_Allow_Origin": "*"
    };
    String uri;
    print('masuk');
    uri = "$apiUrl/presensi.php?nik_history=$nik&tanggal_history=$tanggal";
    final response = await http.get(
      Uri.parse(uri),
      headers: requestHeaders,
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> map = json.decode(response.body);
      if (map['status'] == 0) {
        throw (map['message']);
      } else {
        List<dynamic> data = map['data'];
        List<Presensi> listPresensi = [];
        for (int i = 0; i < data.length; i++) {
          Presensi presensi = Presensi(
              id: data[i]['id'].toString(),
              nik: data[i]['nik'].toString(),
              idKantor: data[i]['id_kantor'].toString(),
              lokasi: data[i]['lokasi'].toString(),
              tanggal: data[i]['tanggal'].toString(),
              jamMasuk: data[i]['jam_masuk'].toString(),
              jamKeluar: data[i]['jam_keluar'].toString(),
              foto: data[i]['foto'].toString(),
              kategori: data[i]['kategori'].toString(),
              status: data[i]['status'].toString());
          listPresensi.add(presensi);
        }
        return listPresensi;
      }
    } else {
      throw ("Gagal mengambil data sub-materi");
    }
  }
}
