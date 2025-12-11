/// DTO cho báo cáo kiểm kê tài sản cố định theo phòng ban
/// API: GET /api/baocao/kiemke-taisan-theo-phongban
class TaiSanCoDinhDto {
  final String idTaiSan;
  final String tenTaiSan;
  final String maSo;
  final String noiSuDung;
  final String idDonViHienThoi;

  // Dữ liệu sổ sách (kế toán)
  final int soLuongSoSach;
  final double nguyenGiaSoSach;
  final double giaTriConLaiSoSach;

  // Dữ liệu kiểm kê thực tế
  final int soLuongKiemKe;
  final double nguyenGiaKiemKe;
  final double giaTriConLaiKiemKe;

  // Chênh lệch
  final int chenhLechSoLuong;
  final double chenhLechNguyenGia;
  final double chenhLechGiaTriConLai;

  final String ghiChu;
  final String donViTinh;
  final String hienTrang;

  TaiSanCoDinhDto({
    required this.idTaiSan,
    required this.tenTaiSan,
    required this.maSo,
    required this.noiSuDung,
    required this.idDonViHienThoi,
    required this.soLuongSoSach,
    required this.nguyenGiaSoSach,
    required this.giaTriConLaiSoSach,
    required this.soLuongKiemKe,
    required this.nguyenGiaKiemKe,
    required this.giaTriConLaiKiemKe,
    required this.chenhLechSoLuong,
    required this.chenhLechNguyenGia,
    required this.chenhLechGiaTriConLai,
    required this.ghiChu,
    required this.donViTinh,
    required this.hienTrang,
  });

  factory TaiSanCoDinhDto.fromJson(Map<String, dynamic> json) {
    return TaiSanCoDinhDto(
      idTaiSan: json['idTaiSan']?.toString() ?? '',
      tenTaiSan: json['tenTaiSan']?.toString() ?? '',
      maSo: json['maSo']?.toString() ?? '',
      noiSuDung: json['noiSuDung']?.toString() ?? '',
      idDonViHienThoi: json['idDonViHienThoi']?.toString() ?? '',
      soLuongSoSach: int.tryParse(json['soLuongSoSach']?.toString() ?? '0') ?? 0,
      nguyenGiaSoSach: double.tryParse(json['nguyenGiaSoSach']?.toString() ?? '0') ?? 0.0,
      giaTriConLaiSoSach: double.tryParse(json['giaTriConLaiSoSach']?.toString() ?? '0') ?? 0.0,
      soLuongKiemKe: int.tryParse(json['soLuongKiemKe']?.toString() ?? '0') ?? 0,
      nguyenGiaKiemKe: double.tryParse(json['nguyenGiaKiemKe']?.toString() ?? '0') ?? 0.0,
      giaTriConLaiKiemKe: double.tryParse(json['giaTriConLaiKiemKe']?.toString() ?? '0') ?? 0.0,
      chenhLechSoLuong: int.tryParse(json['chenhLechSoLuong']?.toString() ?? '0') ?? 0,
      chenhLechNguyenGia: double.tryParse(json['chenhLechNguyenGia']?.toString() ?? '0') ?? 0.0,
      chenhLechGiaTriConLai: double.tryParse(json['chenhLechGiaTriConLai']?.toString() ?? '0') ?? 0.0,
      ghiChu: json['ghiChu']?.toString() ?? '',
      donViTinh: json['donViTinh']?.toString() ?? '',
      hienTrang: json['hienTrang']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idTaiSan': idTaiSan,
      'tenTaiSan': tenTaiSan,
      'maSo': maSo,
      'noiSuDung': noiSuDung,
      'idDonViHienThoi': idDonViHienThoi,
      'soLuongSoSach': soLuongSoSach,
      'nguyenGiaSoSach': nguyenGiaSoSach,
      'giaTriConLaiSoSach': giaTriConLaiSoSach,
      'soLuongKiemKe': soLuongKiemKe,
      'nguyenGiaKiemKe': nguyenGiaKiemKe,
      'giaTriConLaiKiemKe': giaTriConLaiKiemKe,
      'chenhLechSoLuong': chenhLechSoLuong,
      'chenhLechNguyenGia': chenhLechNguyenGia,
      'chenhLechGiaTriConLai': chenhLechGiaTriConLai,
      'ghiChu': ghiChu,
      'donViTinh': donViTinh,
      'hienTrang': hienTrang,
    };
  }

  // Getter aliases cho tương thích ngược với code cũ
  String get id => idTaiSan;
  int get soLuong => soLuongSoSach;
  double get nguyenGia => nguyenGiaSoSach;
  double get giaTriKhauHaoBanDau => giaTriConLaiSoSach;
}
