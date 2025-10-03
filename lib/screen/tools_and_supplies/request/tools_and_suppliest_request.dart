import 'package:quan_ly_tai_san_app/core/utils/utils.dart';

class ToolsAndSuppliesRequest {
  final String id;
  final String idDonVi;
  final String idNhomCCDC;
  final String idLoaiCCDCCon;
  final String ten;
  final String ngayNhap;
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
  final String ngayTao;
  final String ngayCapNhat;
  final String nguoiTao;
  final String nguoiCapNhat;
  final bool isActive;

  ToolsAndSuppliesRequest({
    required this.id,
    required this.idDonVi,
    required this.idNhomCCDC,
    required this.idLoaiCCDCCon,
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

  factory ToolsAndSuppliesRequest.fromJson(Map<String, dynamic> json) {
    return ToolsAndSuppliesRequest(
      id: json['id'] ?? '',
      idDonVi: json['idDonVi'] ?? '',
      idNhomCCDC: json['idNhomCCDC'] ?? '',
      idLoaiCCDCCon: json['idLoaiCCDCCon'] ?? '',
      ten: json['ten'] ?? '',
      ngayNhap: AppUtility.formatFromISOString(json['ngayNhap'].toString()),
      donViTinh: json['donViTinh'] ?? '',
      soLuong: json['soLuong'] ?? 0,
      giaTri: json['giaTri'] is num ? (json['giaTri'] as num).toDouble() : 0.0,
      soKyHieu: json['soKyHieu'] ?? '',
      kyHieu: json['kyHieu'] ?? '',
      congSuat: json['congSuat'] ?? '',
      nuocSanXuat: json['nuocSanXuat'] ?? '',
      namSanXuat: json['namSanXuat'] ?? 0,
      ghiChu: json['ghiChu'] ?? '',
      idCongTy: json['idCongTy'] ?? '',
      ngayTao: AppUtility.formatFromISOString(json['ngayTao'].toString()),
      ngayCapNhat: AppUtility.formatFromISOString(
        json['ngayCapNhat'].toString(),
      ),
      nguoiTao: json['nguoiTao'] ?? '',
      nguoiCapNhat: json['nguoiCapNhat'] ?? '',
      isActive: json['isActive'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'idDonVi': idDonVi,
      'idNhomCCDC': idNhomCCDC,
      'idLoaiCCDCCon': idLoaiCCDCCon,
      'ten': ten,
      'ngayNhap': ngayNhap,
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
      'ngayTao': ngayTao,
      'ngayCapNhat': ngayCapNhat,
      'nguoiTao': nguoiTao,
      'nguoiCapNhat': nguoiCapNhat,
      'isActive': isActive,
    };
  }
}
