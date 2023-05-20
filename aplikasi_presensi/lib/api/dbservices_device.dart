import 'dart:convert';
import 'package:http/http.dart' as http;
import 'apidbconfig.dart';

class DeviceService {
  void insertFCMToken({
    required String nik,
    required String token,
  }) {
    http.post(Uri.parse("$apiUrl/fcm-device-id.php"), body: {
      "nik": nik.toString(),
      "token": token,
    });
  }

  void removeDeviceId({
    required String nik,
    required String token,
  }) async {
    final response = await http.delete(Uri.parse("$apiUrl/fcm-device-id.php"),
        body: json.encode({
          "nik": nik,
          "token": token,
        }));

    if (response.statusCode == 200) {
      Map<String, dynamic> map = json.decode(response.body);
      if (map['status'] == 1) {
        return;
      } else {
        throw map['message'];
      }
    } else {
      throw ("Gagal memasukkan Device ID");
    }
  }
}
