/// DTO cho báo cáo tăng giảm trong kỳ (Mẫu số 01)
/// API: GET /api/baocao/tang-giam-trong-ky?idPhongBan={idPhongBan}&denNgay={denNgay}
class TangGiamTrongKyDto {
  final String id;
  final String tenTaiSan;
  final String donViTinh;
  final String nuocSanXuat;
  final int soDuDauKy;
  final int soLuongTangTrongKy;
  final String? lyDoTangTrongKy;
  final int soLuongGiamTrongKy;
  final String? lyDoGiamTrongKy;
  final int soDuCuoiKy;
  final String tinhTrangKyThuat;
  final String? ghiChu;
  final String loai; // "TaiSan" hoặc "CCDCVatTu"

  TangGiamTrongKyDto({
    required this.id,
    required this.tenTaiSan,
    required this.donViTinh,
    required this.nuocSanXuat,
    required this.soDuDauKy,
    required this.soLuongTangTrongKy,
    this.lyDoTangTrongKy,
    required this.soLuongGiamTrongKy,
    this.lyDoGiamTrongKy,
    required this.soDuCuoiKy,
    required this.tinhTrangKyThuat,
    this.ghiChu,
    required this.loai,
  });

  factory TangGiamTrongKyDto.fromJson(Map<String, dynamic> json) {
    return TangGiamTrongKyDto(
      id: json['id']?.toString() ?? '',
      tenTaiSan: json['tenTaiSan']?.toString() ?? '',
      donViTinh: json['donViTinh']?.toString() ?? '',
      nuocSanXuat: json['nuocSanXuat']?.toString() ?? '',
      soDuDauKy: int.tryParse(json['soDuDauKy']?.toString() ?? '0') ?? 0,
      soLuongTangTrongKy:
          int.tryParse(json['soLuongTangTrongKy']?.toString() ?? '0') ?? 0,
      lyDoTangTrongKy: json['lyDoTangTrongKy']?.toString(),
      soLuongGiamTrongKy:
          int.tryParse(json['soLuongGiamTrongKy']?.toString() ?? '0') ?? 0,
      lyDoGiamTrongKy: json['lyDoGiamTrongKy']?.toString(),
      soDuCuoiKy: int.tryParse(json['soDuCuoiKy']?.toString() ?? '0') ?? 0,
      tinhTrangKyThuat: json['tinhTrangKyThuat']?.toString() ?? '',
      ghiChu: json['ghiChu']?.toString(),
      loai: json['loai']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'tenTaiSan': tenTaiSan,
      'donViTinh': donViTinh,
      'nuocSanXuat': nuocSanXuat,
      'soDuDauKy': soDuDauKy,
      'soLuongTangTrongKy': soLuongTangTrongKy,
      'lyDoTangTrongKy': lyDoTangTrongKy,
      'soLuongGiamTrongKy': soLuongGiamTrongKy,
      'lyDoGiamTrongKy': lyDoGiamTrongKy,
      'soDuCuoiKy': soDuCuoiKy,
      'tinhTrangKyThuat': tinhTrangKyThuat,
      'ghiChu': ghiChu,
      'loai': loai,
    };
  }

  /// Getter để hiển thị loại tài sản
  String get loaiDisplay {
    if (loai == 'TaiSan') return 'Tài sản cố định';
    if (loai == 'CCDCVatTu') return 'Công cụ dụng cụ';
    return loai;
  }

  /// Kiểm tra xem có phải là Tài sản không
  bool get isTaiSan => loai == 'TaiSan';

  /// Kiểm tra xem có phải là CCDC không
  bool get isCCDC => loai == 'CCDCVatTu';
}
