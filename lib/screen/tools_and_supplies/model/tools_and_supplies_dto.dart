class ToolsAndSuppliesDto {
  final String id;
  final String idDonVi;
  final String ten;
  final DateTime ngayNhap;
  final String donViTinh;
  final int soLuong;
  final double giaTri;
  final String soKyHieu;
  final String kyHieu;
  final String congSuat;
  final String nuocSanXuat;
  final int namSanXuat;
  final String ghiChu;
  final String idCongTy;
  final DateTime ngayTao;
  final DateTime ngayCapNhat;
  final String nguoiTao;
  final String nguoiCapNhat;
  final bool isActive;

  ToolsAndSuppliesDto({
    required this.id,
    required this.idDonVi,
    required this.ten,
    required this.ngayNhap,
    required this.donViTinh,
    required this.soLuong,
    required this.giaTri,
    this.soKyHieu = '',
    this.kyHieu = '',
    this.congSuat = '',
    required this.nuocSanXuat,
    required this.namSanXuat,
    this.ghiChu = '',
    required this.idCongTy,
    required this.ngayTao,
    required this.ngayCapNhat,
    required this.nguoiTao,
    required this.nguoiCapNhat,
    required this.isActive,
  });

  factory ToolsAndSuppliesDto.fromJson(Map<String, dynamic> json) {
    return ToolsAndSuppliesDto(
      id: json['id'] ?? '',
      idDonVi: json['idDonVi'] ?? '',
      ten: json['ten'] ?? '',
      ngayNhap: json['ngayNhap'] != null 
          ? DateTime.parse(json['ngayNhap'].toString())
          : DateTime.now(),
      donViTinh: json['donViTinh'] ?? '',
      soLuong: json['soLuong'] ?? 0,
      giaTri: json['giaTri'] ?? 0.0,
      soKyHieu: json['soKyHieu'] ?? '',
      kyHieu: json['kyHieu'] ?? '',
      congSuat: json['congSuat'] ?? '',
      nuocSanXuat: json['nuocSanXuat'] ?? '',
      namSanXuat: json['namSanXuat'] ?? 0,
      ghiChu: json['ghiChu'] ?? '',
      idCongTy: json['idCongTy'] ?? '',
      ngayTao: json['ngayTao'] != null 
          ? DateTime.parse(json['ngayTao'].toString())
          : DateTime.now(),
      ngayCapNhat: json['ngayCapNhat'] != null 
          ? DateTime.parse(json['ngayCapNhat'].toString())
          : DateTime.now(),
      nguoiTao: json['nguoiTao'] ?? '',
      nguoiCapNhat: json['nguoiCapNhat'] ?? '',
      isActive: json['isActive'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'idDonVi': idDonVi,
      'ten': ten,
      'ngayNhap': ngayNhap.toIso8601String(),
      'donViTinh': donViTinh,
      'soLuong': soLuong,
      'giaTri': giaTri,
      'soKyHieu': soKyHieu,
      'kyHieu': kyHieu,
      'congSuat': congSuat,
      'nuocSanXuat': nuocSanXuat,
      'namSanXuat': namSanXuat,
      'ghiChu': ghiChu,
      'idCongTy': idCongTy,
      'ngayTao': ngayTao.toIso8601String(),
      'ngayCapNhat': ngayCapNhat.toIso8601String(),
      'nguoiTao': nguoiTao,
      'nguoiCapNhat': nguoiCapNhat,
      'isActive': isActive,
    };
  }
}