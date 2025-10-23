class TaiSanCoDinhDto {
  final String id;
  final String tenTaiSan;
  final int soLuong;
  final double nguyenGia;
  final double giaTriKhauHaoBanDau;
  final String idDonViHienThoi;
  final String ghiChu;

  TaiSanCoDinhDto({
    required this.id,
    required this.tenTaiSan,
    required this.soLuong,
    required this.nguyenGia,
    required this.giaTriKhauHaoBanDau,
    required this.idDonViHienThoi,
    required this.ghiChu,
  });

  factory TaiSanCoDinhDto.fromJson(Map<String, dynamic> json) {
    return TaiSanCoDinhDto(
      id: json['Id']?.toString() ?? '',
      tenTaiSan: json['TenTaiSan']?.toString() ?? '',
      soLuong: int.tryParse(json['SoLuong']?.toString() ?? '0') ?? 0,
      nguyenGia: double.tryParse(json['NguyenGia']?.toString() ?? '0') ?? 0.0,
      giaTriKhauHaoBanDau:
          double.tryParse(json['GiaTriKhauHaoBanDau']?.toString() ?? '0') ??
          0.0,
      idDonViHienThoi: json['IdDonViHienThoi']?.toString() ?? '',
      ghiChu: json['GhiChu']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Id': id,
      'TenTaiSan': tenTaiSan,
      'SoLuong': soLuong,
      'NguyenGia': nguyenGia,
      'GiaTriKhauHaoBanDau': giaTriKhauHaoBanDau,
      'IdDonViHienThoi': idDonViHienThoi,
      'GhiChu': ghiChu,
    };
  }
}
