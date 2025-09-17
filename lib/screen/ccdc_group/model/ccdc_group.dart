class CcdcGroup {
  final String? id;
  final String? ten;
  final bool? hieuLuc;
  final String? idCongTy;
  final DateTime? ngayTao;
  final DateTime? ngayCapNhat;
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
          json['ngayTao'] != null ? DateTime.tryParse(json['ngayTao']) : null,
      ngayCapNhat:
          json['ngayCapNhat'] != null
              ? DateTime.tryParse(json['ngayCapNhat'])
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
      'ngayTao': ngayTao?.toIso8601String(),
      'ngayCapNhat': ngayCapNhat?.toIso8601String(),
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
      'Hiệu lực': hieuLuc,
      'Mã công ty': _nullIfEmpty(idCongTy),
      'Ngày tạo': _nullIfEmpty(ngayTao?.toIso8601String()),
      'Ngày cập nhật': _nullIfEmpty(ngayCapNhat?.toIso8601String()),
      'Người tạo': _nullIfEmpty(nguoiTao),
      'Người cập nhật': _nullIfEmpty(nguoiCapNhat),
    };
  }
}
