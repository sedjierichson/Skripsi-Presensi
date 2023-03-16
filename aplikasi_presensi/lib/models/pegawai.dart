class Pegawai {
  String nik;
  String nama;
  String jabatan;
  String? imei;
  String nik_atasan;

  Pegawai(
      {required this.nik,
      required this.nama,
      required this.jabatan,
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
