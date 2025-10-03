import 'dart:convert';

import 'package:quan_ly_tai_san_app/core/utils/utils.dart';

class AssetGroupDto {
  final String? id;
  final String? tenNhom;
  final bool? hieuLuc;
  final String? idCongTy;
  final String? ngayTao;
  final String? ngayCapNhat;
  final String? nguoiTao;
  final String? nguoiCapNhat;
  final bool? isActive;

  AssetGroupDto({
    this.id,
    this.tenNhom,
    this.hieuLuc,
    this.idCongTy,
    this.ngayTao,
    this.ngayCapNhat,
    this.nguoiTao,
    this.nguoiCapNhat,
    this.isActive,
  });

  factory AssetGroupDto.fromJson(Map<String, dynamic> json) {
    return AssetGroupDto(
      id: json['id']?.toString(),
      tenNhom: json['tenNhom'],
      hieuLuc: json['hieuLuc'],
      idCongTy: json['idCongTy'],
      ngayTao:
          json['ngayTao'] != null ? AppUtility.formatFromISOString(json['ngayTao']) : null,
      ngayCapNhat:
          json['ngayCapNhat'] != null
              ? AppUtility.formatFromISOString(json['ngayCapNhat'])
              : null,
      nguoiTao: json['nguoiTao'],
      nguoiCapNhat: json['nguoiCapNhat'],
      isActive: json['isActive'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'tenNhom': tenNhom,
      'hieuLuc': hieuLuc,
      'idCongTy': idCongTy,
      'ngayTao': AppUtility.formatFromISOString(ngayTao ?? ''),
      'ngayCapNhat': AppUtility.formatFromISOString(ngayCapNhat ?? ''),
      'nguoiTao': nguoiTao,
      'nguoiCapNhat': nguoiCapNhat,
      'isActive': isActive,
    };
  }

  Map<String, dynamic> toLoaiTaisanJson() {
    return {
      'id': id,
      'tenLoaiTaiSan': tenNhom,
      'idCongTy': idCongTy,
      'ngayTao': AppUtility.formatFromISOString(ngayTao ?? ''),
      'ngayCapNhat': AppUtility.formatFromISOString(ngayCapNhat ?? ''),
      'nguoiTao': nguoiTao,
      'nguoiCapNhat': nguoiCapNhat,
      'isActive': isActive,
    };
  }

  static List<AssetGroupDto> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => AssetGroupDto.fromJson(json)).toList();
  }

  static String encode(List<AssetGroupDto> categories) =>
      json.encode(categories.map((category) => category.toJson()).toList());

  static List<AssetGroupDto> decode(String categories) =>
      (json.decode(categories) as List<dynamic>)
          .map<AssetGroupDto>((item) => AssetGroupDto.fromJson(item))
          .toList();

  // Helper chuyển null/empty string thành "null" để export
  dynamic _nullIfEmpty(dynamic value) {
    if (value == null) {
      return "";
    }
    if (value is String) {
      return value.trim().isEmpty ? "" : value;
    }
    return value;
  }

  /// Dữ liệu export cho Nhóm tài sản
  Map<String, dynamic> toExportJson() {
    return {
      'Mã nhóm': _nullIfEmpty(id),
      'Tên nhóm': _nullIfEmpty(tenNhom),
      'Hiệu lực': hieuLuc ?? true,
      'Ngày tạo': _nullIfEmpty(AppUtility.formatFromISOString(ngayTao ?? '')),
      'Ngày cập nhật': _nullIfEmpty(AppUtility.formatFromISOString(ngayCapNhat ?? '')),
    };
  }
}
