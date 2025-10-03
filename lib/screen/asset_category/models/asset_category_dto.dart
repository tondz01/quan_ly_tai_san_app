import 'dart:convert';

import 'package:quan_ly_tai_san_app/core/utils/utils.dart';

class AssetCategoryDto {
  final String? id;
  final String? tenMoHinh;
  final int? phuongPhapKhauHao;
  final int? kyKhauHao;
  final String? loaiKyKhauHao;
  final String? taiKhoanTaiSan;
  final String? taiKhoanKhauHao;
  final String? taiKhoanChiPhi;
  final String? idCongTy;
  final String? ngayTao;
  final String? ngayCapNhat;
  final String? nguoiTao;
  final String? nguoiCapNhat;
  final bool? isActive;

  AssetCategoryDto({
    this.id,
    this.tenMoHinh,
    this.phuongPhapKhauHao,
    this.kyKhauHao,
    this.loaiKyKhauHao,
    this.taiKhoanTaiSan,
    this.taiKhoanKhauHao,
    this.taiKhoanChiPhi,
    this.idCongTy,
    this.ngayTao,
    this.ngayCapNhat,
    this.nguoiTao,
    this.nguoiCapNhat,
    this.isActive,
  });

  factory AssetCategoryDto.fromJson(Map<String, dynamic> json) {
    return AssetCategoryDto(
      id: json['id'],
      tenMoHinh: json['tenMoHinh'],
      phuongPhapKhauHao:
          json['phuongPhapKhauHao'] is int
              ? json['phuongPhapKhauHao']
              : int.tryParse(json['phuongPhapKhauHao']?.toString() ?? ''),
      kyKhauHao:
          json['kyKhauHao'] is int
              ? json['kyKhauHao']
              : int.tryParse(json['kyKhauHao']?.toString() ?? ''),
      loaiKyKhauHao: json['loaiKyKhauHao'],
      taiKhoanTaiSan: json['taiKhoanTaiSan'],
      taiKhoanKhauHao: json['taiKhoanKhauHao'],
      taiKhoanChiPhi: json['taiKhoanChiPhi'],
      idCongTy: json['idCongTy'],
      ngayTao: AppUtility.formatFromISOString(json['ngayTao']),
      ngayCapNhat: AppUtility.formatFromISOString(json['ngayCapNhat']),
      nguoiTao: json['nguoiTao'],
      nguoiCapNhat: json['nguoiCapNhat'],
      isActive: json['isActive'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'tenMoHinh': tenMoHinh,
      'phuongPhapKhauHao': phuongPhapKhauHao,
      'kyKhauHao': kyKhauHao,
      'loaiKyKhauHao': loaiKyKhauHao,
      'taiKhoanTaiSan': taiKhoanTaiSan,
      'taiKhoanKhauHao': taiKhoanKhauHao,
      'taiKhoanChiPhi': taiKhoanChiPhi,
      'idCongTy': idCongTy,
      'ngayTao': AppUtility.formatFromISOString(ngayTao ?? ''),
      'ngayCapNhat': AppUtility.formatFromISOString(ngayCapNhat ?? ''),
      'nguoiTao': nguoiTao,
      'nguoiCapNhat': nguoiCapNhat,
      'isActive': isActive,
    };
  }

  static List<AssetCategoryDto> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => AssetCategoryDto.fromJson(json)).toList();
  }

  static String encode(List<AssetCategoryDto> categories) =>
      json.encode(categories.map((category) => category.toJson()).toList());

  static List<AssetCategoryDto> decode(String categories) =>
      (json.decode(categories) as List<dynamic>)
          .map<AssetCategoryDto>((item) => AssetCategoryDto.fromJson(item))
          .toList();

  Map<String, dynamic> toExportJson() {
    return {
      'Id': _nullIfEmpty(id),
      'Tên mô hình': _nullIfEmpty(tenMoHinh),
      'Phương pháp khấu hao': _nullIfEmpty(phuongPhapKhauHao),
      'Kỳ khấu hao': _nullIfEmpty(kyKhauHao),
      'Loại kỳ khấu hao': _nullIfEmpty(loaiKyKhauHao),
      'Tài khoản tài sản': _nullIfEmpty(taiKhoanTaiSan),
      'Tài khoản khấu hao': _nullIfEmpty(taiKhoanKhauHao),
      'Tài khoản chi phí': _nullIfEmpty(taiKhoanChiPhi),
      'Ngày tạo': _nullIfEmpty(AppUtility.formatFromISOString(ngayTao ?? '')),
      'Ngày cập nhật': _nullIfEmpty(AppUtility.formatFromISOString(ngayCapNhat ?? '')),
    };
  }

  // Helper chuyển null/empty string thành "null" để export
  dynamic _nullIfEmpty(dynamic value) {
    if (value == null) {
      return "null";
    }
    if (value is String) {
      return value.trim().isEmpty ? "null" : value;
    }
    return value;
  }
}
