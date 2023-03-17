import 'apidbconfig.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class PresensiService {
  Future<Map<String, dynamic>> cekSudahAbsen(
      {required String nik, required String tanggal}) async {
    Map<String, String> requestHeaders = {
      "Accept": "application/json",
      "Access-Control_Allow_Origin": "*"
    };

    String uri = "$apiUrl/presensi.php?nik_pegawai=$nik&tanggal_absen=$tanggal";

    // if (nik != "") {
    //   uri =
    //       "http://127.0.0.1:8888/contoh-api-rutan/contoh-api-rutan/api/pegawai.php?id=$nik";
    // }

    final response = await http.get(Uri.parse(uri), headers: requestHeaders);

    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      print("aaa" + jsonResponse['data']['status'].toString());
      return {
        'status': jsonResponse['data']['status'],
        'message': jsonResponse['data']['message']
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
    String foto,
  ) async {
    final response = await http.post(Uri.parse("$apiUrl/presensi.php"), body: {
      'nik': nikPegawai.toString(),
      'id_kantor': idKantor.toString(),
      'tanggal': tanggal,
      'jam_masuk': jamMasuk,
      'foto': foto,
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

  Future<String> updateJamKeluar(String id_presensi, String jamKeluar) async {
    final response = await http.put(
      Uri.parse("$apiUrl/presensi.php"),
      body: json.encode(
        {
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
}
