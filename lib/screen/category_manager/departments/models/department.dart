import 'package:equatable/equatable.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/departments/constants/department_constants.dart';

class PhongBan extends Equatable {
  final String? id;
  final String? idNhomDonVi;
  final String? tenPhongBan;
  final String? idQuanLy;
  final String? idCongTy;
  final String? phongCapTren;
  final String? mauSac;
  final String? nguoiTao;
  final String? nguoiCapNhat;
  final bool? isActive;


  final String? ngayTao;
  final String? ngayCapNhat;

  const PhongBan({
    this.id,
    this.idNhomDonVi,
    this.tenPhongBan,
    this.idQuanLy,
    this.idCongTy,
    this.phongCapTren,
    this.mauSac,
    this.nguoiTao,
    this.nguoiCapNhat,
    this.ngayTao,
    this.ngayCapNhat,
    this.isActive
  });

  factory PhongBan.fromJson(Map<String, dynamic> json) {
    return PhongBan(
      id: json['id'],
      idNhomDonVi: json['idNhomDonVi'],
      tenPhongBan: json['tenPhongBan'],
      idQuanLy: json['idQuanLy'],
      idCongTy: json['idCongTy'],
      phongCapTren: json['phongCapTren'],
      mauSac: json['mauSac'],
      ngayTao: json['ngayTao'],
      ngayCapNhat: json['ngayCapNhat'],
      nguoiTao: json['nguoiTao'],
      nguoiCapNhat: json['nguoiCapNhat'],
      isActive: json['isActive'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'idNhomDonvi': idNhomDonVi ?? "",
      'tenPhongBan': tenPhongBan ?? "",
      'idQuanLy': idQuanLy ?? "",
      'idCongTy': idCongTy ?? DepartmentConstants.defaultCompanyId,
      'phongCapTren': phongCapTren ?? "",
      'mauSac': mauSac ?? "",
      'nguoiTao': nguoiTao ?? "",
      'nguoiCapNhat': nguoiCapNhat ?? "",
      'ngayTao': ngayTao ?? DateTime.now().toIso8601String(),
      'ngayCapNhat': ngayCapNhat ?? DateTime.now().toIso8601String(),
      'isActive': isActive ?? DepartmentConstants.defaultIsActive,
    };
  }

  dynamic _nullIfEmpty(dynamic value) {
    if (value == null) {
      return "";
    }
    if (value is String) {
      return value.trim().isEmpty ? "" : value;
    }
    return value;
  }

  Map<String, dynamic> toExportJson() {
    return {
      'Mã phòng ban': _nullIfEmpty(id),
      'Tên phòng ban': _nullIfEmpty(tenPhongBan),
      'Mã phòng cấp trên': _nullIfEmpty(phongCapTren),
      'Ngày tạo': _nullIfEmpty(ngayTao),
      'Ngày cập nhật': _nullIfEmpty(ngayCapNhat),
    };
  }

  @override
  List<Object?> get props => [
        id,
        idNhomDonVi,
        tenPhongBan,
        idQuanLy,
        idCongTy,
        phongCapTren,
        mauSac,
        nguoiTao,
        nguoiCapNhat,
        ngayTao,
        ngayCapNhat,
      ];
}
