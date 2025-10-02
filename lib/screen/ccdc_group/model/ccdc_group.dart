import 'package:quan_ly_tai_san_app/core/utils/utils.dart';

class CcdcGroup {
  final String? id;
  final String? ten;
  final bool? hieuLuc;
  final String? idCongTy;
  final String? ngayTao;
  final String? ngayCapNhat;
  final String? nguoiTao;
  final String? nguoiCapNhat;

  CcdcGroup({
    this.id,
    this.ten,
    this.hieuLuc,
    this.idCongTy,
    this.ngayTao,
    this.ngayCapNhat,
    this.nguoiTao,
    this.nguoiCapNhat,
  });

  factory CcdcGroup.fromJson(Map<String, dynamic> json) {
    return CcdcGroup(
      id: json['id'],
      ten: json['ten'],
      hieuLuc: json['hieuLuc'],
      idCongTy: json['idCongTy'],
      ngayTao:
          json['ngayTao'] != null
              ? AppUtility.formatFromISOString(json['ngayTao'])
              : null,
      ngayCapNhat:
          json['ngayCapNhat'] != null
              ? AppUtility.formatFromISOString(json['ngayCapNhat'])
              : null,
      nguoiTao: json['nguoiTao'],
      nguoiCapNhat: json['nguoiCapNhat'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'ten': ten,
      'hieuLuc': hieuLuc,
      'idCongTy': idCongTy,
      'ngayTao': AppUtility.formatFromISOString(ngayTao ?? ''),
      'ngayCapNhat': AppUtility.formatFromISOString(ngayCapNhat ?? ''),
      'nguoiTao': nguoiTao,
      'nguoiCapNhat': nguoiCapNhat,
    };
  }

  // Helper chuyển null/empty string thành chuỗi rỗng để export
  dynamic _nullIfEmpty(dynamic value) {
    if (value == null) {
      return "";
    }
    if (value is String) {
      return value.trim().isEmpty ? "" : value;
    }
    return value;
  }

  /// Dữ liệu export cho Nhóm CCDC
  Map<String, dynamic> toExportJson() {
    return {
      'Mã nhóm CCDC': _nullIfEmpty(id),
      'Tên nhóm CCDC': _nullIfEmpty(ten),
      'Hiệu lực': hieuLuc ?? false,
      'Ngày tạo': _nullIfEmpty(AppUtility.formatFromISOString(ngayTao ?? '')),
      'Ngày cập nhật': _nullIfEmpty(
        AppUtility.formatFromISOString(ngayCapNhat ?? ''),
      ),
    };
  }
}
