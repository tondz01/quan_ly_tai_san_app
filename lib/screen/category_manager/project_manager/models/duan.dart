import 'package:equatable/equatable.dart';

class DuAn extends Equatable {
  final String? id;
  final String? tenDuAn;
  final String? ghiChu;
  final bool? hieuLuc;
  final String? idCongTy;
  final String? nguoiTao;
  final bool? isActive;

  const DuAn({
    this.id,
    this.tenDuAn,
    this.ghiChu,
    this.hieuLuc,
    this.idCongTy,
    this.nguoiTao,
    this.isActive,
  });

  factory DuAn.fromJson(Map<String, dynamic> json) {
    return DuAn(
      id: json['id'] as String?,
      tenDuAn: json['tenDuAn'] as String?,
      ghiChu: json['ghiChu'] as String?,
      hieuLuc: json['hieuLuc'] as bool?,
      idCongTy: json['idCongTy'] as String?,
      nguoiTao: json['nguoiTao'] as String?,
      isActive: json['isActive'] as bool?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'tenDuAn': tenDuAn,
      'ghiChu': ghiChu,
      'hieuLuc': hieuLuc,
      'idCongTy': "ct001",
      'nguoiTao': nguoiTao,
      'isActive': true,
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

  /// Dữ liệu export cho Dự án
  Map<String, dynamic> toExportJson() {
    return {
      'id': _nullIfEmpty(id),
      'tenDuAn': _nullIfEmpty(tenDuAn),
      'ghiChu': _nullIfEmpty(ghiChu),
      'hieuLuc': hieuLuc ?? false,
      'idCongTy': _nullIfEmpty("ct001"),
      'nguoiTao': _nullIfEmpty(nguoiTao),
      'isActive': true,
    };
  }

  @override
  List<Object?> get props => [
        id,
        tenDuAn,
        ghiChu,
        hieuLuc,
        idCongTy,
        nguoiTao,
        isActive,
      ];
}
