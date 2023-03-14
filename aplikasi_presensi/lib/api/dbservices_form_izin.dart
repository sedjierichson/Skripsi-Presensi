import 'apidbconfig.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class FormIzinService {
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
