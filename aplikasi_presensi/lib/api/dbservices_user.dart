import 'dart:convert';

// import 'package:e_learning/model/user.dart';
import 'package:aplikasi_presensi/models/pegawai.dart';
import 'package:http/http.dart' as http;
import 'apidbconfig.dart';

class UserService {
  Future<Pegawai> getCurrentUser({String nik = ""}) async {
    Map<String, String> requestHeaders = {
      "Accept": "application/json",
      "Access-Control_Allow_Origin": "*"
    };

    String uri = "$apiRUTAN/pegawai.php?nik=$nik";
    final response = await http.get(Uri.parse(uri), headers: requestHeaders);

    if (response.statusCode == 200) {
      Map<String, dynamic> map = json.decode(response.body);
      if (map['status'] == 0) {
        throw (map['message']);
      } else {
        var data = map['data'];
        Pegawai pegawai = Pegawai(
          nama: data['nama'],
          nik: data['nik'],
          jabatan: data['jabatan'],
          nik_atasan: data['nik_atasan'],
          email: data['email'],
        );
        // print(pegawai.imei);
        return pegawai;
      }
    } else {
      throw ("Gagal mengambil data user");
    }
  }

  Future<List<apiRutanPegawai>> getBawahanUser({String nik = ""}) async {
    Map<String, String> requestHeaders = {
      "Accept": "application/json",
      "Access-Control_Allow_Origin": "*"
    };

    String uri = "$apiRUTAN/pegawai.php?nik_atasan=$nik";
    final response = await http.get(Uri.parse(uri), headers: requestHeaders);

    if (response.statusCode == 200) {
      Map<String, dynamic> map = json.decode(response.body);
      if (map['status'] == 0) {
        throw (map['message']);
      } else {
        List<dynamic> data = map['data'];
        // print(data);
        List<apiRutanPegawai> listBawahan = [];
        for (int i = 0; i < data.length; i++) {
          apiRutanPegawai pegawai = apiRutanPegawai(
              nik: data[i]['nik'].toString(),
              nama: data[i]['nama'].toString(),
              jabatan: data[i]['jabatan'].toString(),
              email: data[i]['email'].toString());
          listBawahan.add(pegawai);
        }
        return listBawahan;
      }
    } else {
      throw ("Gagal mengambil data user");
    }
  }

  Future<DataHpPegawai> getDataHPPegawai({String nik = ""}) async {
    Map<String, String> requestHeaders = {
      "Accept": "application/json",
      "Access-Control_Allow_Origin": "*"
    };

    String uri = "$apiUrl/pegawai.php?nik=$nik";

    // if (nik != "") {
    //   uri =
    //       "http://127.0.0.1:8888/contoh-api-rutan/contoh-api-rutan/api/pegawai.php?id=$nik";
    // }

    final response = await http.get(Uri.parse(uri), headers: requestHeaders);

    if (response.statusCode == 200) {
      Map<String, dynamic> map = json.decode(response.body);
      if (map['status'] == 0) {
        throw (map['message']);
      } else {
        var data = map['data'];
        DataHpPegawai hppegawai = DataHpPegawai(
          nik: data['nik'],
          imei: data['imei'],
          securityCode: data['security_code'],
        );
        // print(pegawai.imei);
        return hppegawai;
      }
    } else {
      throw ("Gagal mengambil data user");
    }
  }

  Future<Map<String, dynamic>> loginAPI({
    required String nik,
    required String password,
  }) async {
    final response = await http.post(Uri.parse("$apiRUTAN/pegawai.php"), body: {
      "nik": nik,
      "password": password,
    });

    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      return {
        'status': jsonResponse['status'],
        'message': jsonResponse['message']
      };
    } else {
      throw ("Gagal melakukan cek data api user");
    }
  }

  Future<Map<String, dynamic>> cekNIKSudahTerdaftar({
    required String nik,
  }) async {
    final response = await http.get(Uri.parse("$apiUrl/pegawai.php?nik=$nik"));

    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      return {
        'status': jsonResponse['status'],
        'message': jsonResponse['data']
      };
    } else {
      throw ("Gagal melakukan cek data userr");
    }
  }

  Future<String> insertDataPertamaLogin(String nik, String code) async {
    final response = await http.post(
      Uri.parse("$apiUrl/pegawai.php"),
      body: {
        'nik': nik.toString(),
        'security_code': code.toString(),
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
      throw ("Gagal insert data user");
    }
  }

  Future<String> updateSecurityCodeLogin(String nik, String code) async {
    final response = await http.put(
      Uri.parse("$apiUrl/pegawai.php"),
      // body: {
      //   'nik': nik.toString(),
      //   'security_code': code.toString(),
      // },
      body: json.encode(
        {
          "nik": nik,
          "security_code": code,
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
      throw ("Gagal insert data user");
    }
  }

  Future<String> updateIMEI(String nik, String imei) async {
    final response = await http.put(
      Uri.parse("$apiUrl/pegawai.php"),
      body: json.encode(
        {
          "nik": nik,
          "imei": imei,
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
      throw ("Gagal update IMEI");
    }
  }
}
