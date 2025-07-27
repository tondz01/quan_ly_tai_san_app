class TaiSan {
  final String maTaiSan;
  final String tenTaiSan;
  final String ngayVaoSo;
  final String ngaySuDung;
  final String donViSuDung;
  final String soLuongTSCon;
  final String soLuongPhuLuc;
  final String ghiChu;
  final String taiKhoanTaiSan;
  final String duAn;
  final String moHinhTaiSan;
  final String nguyenGiaTaiSan;
  final String khauHaoBanDau;
  final String kyKhauHaoBanDau;
  final String gtclBanDau;
  final String khauHaoPhatSinh;
  final String kyKhauHaoPhatSinh;
  final String khauHaoConLai;
  final String kyKhauHaoConLai;

  TaiSan({
    required this.maTaiSan,
    required this.tenTaiSan,
    required this.ngayVaoSo,
    required this.ngaySuDung,
    required this.donViSuDung,
    required this.soLuongTSCon,
    required this.soLuongPhuLuc,
    required this.ghiChu,
    required this.taiKhoanTaiSan,
    required this.duAn,
    required this.moHinhTaiSan,
    required this.nguyenGiaTaiSan,
    required this.khauHaoBanDau,
    required this.kyKhauHaoBanDau,
    required this.gtclBanDau,
    required this.khauHaoPhatSinh,
    required this.kyKhauHaoPhatSinh,
    required this.khauHaoConLai,
    required this.kyKhauHaoConLai,
  });

  factory TaiSan.fromCsv(List<dynamic> row) {
    return TaiSan(
      maTaiSan: row[0],
      tenTaiSan: row[1],
      ngayVaoSo: row[2],
      ngaySuDung: row[3],
      donViSuDung: row[4],
      soLuongTSCon: row[5],
      soLuongPhuLuc: row[6],
      ghiChu: row[7],
      taiKhoanTaiSan: row[8],
      duAn: row[9],
      moHinhTaiSan: row[10],
      nguyenGiaTaiSan: row[11],
      khauHaoBanDau: row[12],
      kyKhauHaoBanDau: row[13],
      gtclBanDau: row[14],
      khauHaoPhatSinh: row[15],
      kyKhauHaoPhatSinh: row[16],
      khauHaoConLai: row[17],
      kyKhauHaoConLai: row[18],
    );
  }
}