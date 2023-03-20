class Presensi {
  String id;
  String nik;
  String idKantor;
  String? lokasi;
  String tanggal;
  String? jamMasuk;
  String? jamKeluar;
  String foto;
  String status;

  Presensi({
    required this.id,
    required this.nik,
    required this.idKantor,
    this.lokasi,
    required this.tanggal,
    this.jamMasuk,
    this.jamKeluar,
    required this.foto,
    required this.status,
  });
}
