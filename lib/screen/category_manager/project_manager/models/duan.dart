import 'package:equatable/equatable.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/project_manager/constants/project_constants.dart';

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
      'idCongTy': idCongTy ?? ProjectConstants.defaultCompanyId,
      'nguoiTao': nguoiTao,
      'isActive': isActive ?? ProjectConstants.defaultIsActive,
    };
  }

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

  /// Dữ liệu export cho Dự án
  Map<String, dynamic> toExportJson() {
    return {
      ProjectConstants.exportProjectId: _nullIfEmpty(id),
      ProjectConstants.exportProjectName: _nullIfEmpty(tenDuAn),
      ProjectConstants.exportProjectNote: _nullIfEmpty(ghiChu),
      ProjectConstants.exportIsActive: hieuLuc ?? ProjectConstants.defaultHieuLuc,
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
