class Izin {
  String id;
  String idJenisIzin;
  String jenis;
  String nik;
  String nama;
  String nikAtasan;
  String? id_kantor;
  String? tanggalAwal;
  String? tanggalAkhir;
  String? jamAwal;
  String? jamAkhir;
  String? alasan;
  String? tempatTujuan;
  String? uraianTugas;
  String? tanggalPengajuan;
  String? tanggalRespon;
  String status;

  Izin(
      {required this.id,
      required this.idJenisIzin,
      required this.jenis,
      required this.nik,
      required this.nama,
      required this.nikAtasan,
      this.id_kantor,
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
