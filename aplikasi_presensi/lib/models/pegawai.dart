class Pegawai {
  String nik;
  String nama;
  String jabatan;
  String? imei;
  String nik_atasan;
  int? idPresensi;

  Pegawai(
      {required this.nik,
      required this.nama,
      required this.jabatan,
      this.idPresensi,
      required this.nik_atasan});
}

class DataHpPegawai {
  String nik;
  String imei;
  String securityCode;

  DataHpPegawai({
    required this.nik,
    required this.imei,
    required this.securityCode,
  });
}

class apiRutanPegawai {
  String nik;
  String nama;
  String jabatan;

  apiRutanPegawai({
    required this.nik,
    required this.nama,
    required this.jabatan,
  });
}
