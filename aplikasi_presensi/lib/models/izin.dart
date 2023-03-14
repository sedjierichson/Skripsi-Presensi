class Izin {
  int id;
  int idJenisIzin;
  String jenis;
  int nik;
  int nikAtasan;
  String? tanggalAwal;
  String? tanggalAkhir;
  String? jamAwal;
  String? jamAkhir;
  String? alasan;
  String? tempatTujuan;
  String? uraianTugas;
  String? tanggalPengajuan;
  String? tanggalRespon;
  int status;

  Izin(
      {required this.id,
      required this.idJenisIzin,
      required this.jenis,
      required this.nik,
      required this.nikAtasan,
      this.tanggalAwal,
      this.tanggalAkhir,
      this.jamAwal,
      this.jamAkhir,
      this.alasan,
      this.tempatTujuan,
      this.uraianTugas,
      this.tanggalPengajuan,
      this.tanggalRespon,
      required this.status});
}
