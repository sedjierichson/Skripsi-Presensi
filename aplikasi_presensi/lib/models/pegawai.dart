class Pegawai {
  String nik;
  String nama;
  String jabatan;
  String? imei;
  String nik_atasan;
  String? email;
  int? idPresensi;

  Pegawai({
    required this.nik,
    required this.nama,
    required this.jabatan,
    this.idPresensi,
    required this.nik_atasan,
    this.email,
  });
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
  String email;

  apiRutanPegawai(
      {required this.nik,
      required this.nama,
      required this.jabatan,
      required this.email});
}
