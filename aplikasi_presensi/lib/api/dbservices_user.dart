import 'dart:convert';

// import 'package:e_learning/model/user.dart';
import 'package:http/http.dart' as http;
import 'apidbconfig.dart';

class UserService {
  Future<Map<String, dynamic>> loginAPI({
    required String nik,
    required String password,
  }) async {
    final response = await http.post(
        Uri.parse(
            "http://127.0.0.1:8888/contoh-api-rutan/contoh-api-rutan/api/pegawai.php"),
        body: {
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
        'message': jsonResponse['message']
      };
    } else {
      throw ("Gagal melakukan cek data user");
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
}
