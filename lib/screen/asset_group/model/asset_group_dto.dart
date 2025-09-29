import 'dart:convert';

class AssetGroupDto {
  final String? id;
  final String? tenNhom;
  final bool? hieuLuc;
  final String? idCongTy;
  final DateTime? ngayTao;
  final DateTime? ngayCapNhat;
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
      idCongTy: json['idCongTy']?.toString(),
      ngayTao: json['ngayTao'] != null
          ? DateTime.tryParse(json['ngayTao'])
          : null,
      ngayCapNhat: json['ngayCapNhat'] != null
          ? DateTime.tryParse(json['ngayCapNhat'])
          : null,
      nguoiTao: json['nguoiTao']?.toString(),
      nguoiCapNhat: json['nguoiCapNhat']?.toString(),
      isActive: json['isActive'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'tenNhom': tenNhom,
      'hieuLuc': hieuLuc,
      'idCongTy': idCongTy,
      'ngayTao': ngayTao?.millisecondsSinceEpoch,
      'ngayCapNhat': ngayCapNhat?.millisecondsSinceEpoch,
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
      'Hiệu lực': hieuLuc,
      'Mã công ty': _nullIfEmpty(idCongTy),
      'Ngày tạo': _nullIfEmpty(ngayTao?.toIso8601String()),
      'Ngày cập nhật': _nullIfEmpty(ngayCapNhat?.toIso8601String()),
      'Người tạo': _nullIfEmpty(nguoiTao),
      'Người cập nhật': _nullIfEmpty(nguoiCapNhat),
      'Kích hoạt': isActive,
    };
  }
}