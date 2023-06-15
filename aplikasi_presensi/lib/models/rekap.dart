class Rekap {
  String nik;
  String jumlah;
  String? kategori;
  String? kategoriA;
  String? kategoriB;
  String? kategoriC;
  String? kategoriD;

  Rekap({
    required this.nik,
    required this.jumlah,
    this.kategori,
    this.kategoriA,
    this.kategoriB,
    this.kategoriC,
    this.kategoriD,
  });
}
