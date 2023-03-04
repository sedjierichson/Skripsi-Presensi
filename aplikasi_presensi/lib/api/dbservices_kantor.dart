import 'dart:convert';
import 'package:aplikasi_presensi/models/kantor.dart';
import 'package:http/http.dart' as http;
import 'apidbconfig.dart';

class KantorServices {
  Future<List<Kantor>> getDataKantor() async {
    Map<String, String> requestHeaders = {
      "Accept": "application/json",
      "Access-Control_Allow_Origin": "*"
    };
    final response = await http.get(
      Uri.parse("$apiUrl/kantor.php"),
      headers: requestHeaders,
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> map = json.decode(response.body);
      if (map['status'] == 0) {
        throw (map['message']);
      } else {
        List<dynamic> data = map['data'];
        List<Kantor> listKantor = [];
        for (int i = 0; i < data.length; i++) {
          Kantor kantor = Kantor(
              id: int.parse(data[i]['id']),
              nama: data[i]['nama'],
              alamat: data[i]['alamat']);
          listKantor.add(kantor);
        }
        return listKantor;
      }
    } else {
      throw ("Gagal mengambil data sub-materi");
    }
  }
}
