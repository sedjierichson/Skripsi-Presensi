import 'dart:convert';
import 'package:http/http.dart' as http;
import 'apidbconfig.dart';

class LogService {
  Future<String> insertLogBeacon({
    required String jarak,
    required String jam,
    required String keterangan,
  }) async {
    final response = await http.post(Uri.parse("$apiUrl/log.php"), body: {
      "jarak": jarak.toString(),
      "jam": jam,
      "keterangan": keterangan
    });
    if (response.statusCode == 200 || response.statusCode == 201) {
      var jsonResponse = json.decode(response.body);
      if (jsonResponse['status'] == 1) {
        print('data masuk');
        return "Berhasil";
      } else {
        throw jsonResponse['message'];
      }
    } else {
      throw ("Gagal insert");
    }
  }
}
