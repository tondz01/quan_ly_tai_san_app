import 'package:equatable/equatable.dart';

class PhongBan extends Equatable {
  final String? id;
  final String? idNhomDonVi;
  final String? tenPhongBan;
  final String? idQuanLy;
  final String? idCongTy;
  final String? phongCapTren;
  final String? mauSac;
  final String? tenNhom;
  final String? hoTenQuanLy;
  final String? nguoiTao;
  final String? nguoiCapNhat;
  final int? soLuongNhanVien;


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
    this.tenNhom,
    this.hoTenQuanLy,
    this.nguoiTao,
    this.nguoiCapNhat,
    this.soLuongNhanVien,
    this.ngayTao,
    this.ngayCapNhat,
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
      tenNhom: json['tenNhom'],
      hoTenQuanLy: json['hoTenQuanLy'],
      nguoiTao: json['nguoiTao'],
      nguoiCapNhat: json['nguoiCapNhat'],
      soLuongNhanVien: json['soLuongNhanVien'],
      ngayTao: json['ngayTao'],
      ngayCapNhat: json['ngayCapNhat'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'idNhomDonvi': idNhomDonVi ?? "",
      'tenPhongBan': tenPhongBan ?? "",
      'idQuanLy': idQuanLy ?? "",
      'idCongTy': "ct001", // Assuming a default company ID
      'phongCapTren': phongCapTren ?? "",
      'mauSac': mauSac ?? "",
      'tenNhom': tenNhom ?? "",
      'hoTenQuanLy': hoTenQuanLy ?? "",
      'nguoiTao': nguoiTao ?? "",
      'nguoiCapNhat': nguoiCapNhat ?? "",
      'ngayTao': ngayTao ?? DateTime.now().toIso8601String(),
      'ngayCapNhat': ngayCapNhat ?? DateTime.now().toIso8601String(),
      'isActive': true,
    };
  }

  dynamic _nullIfEmpty(dynamic value) {
    if (value == null) {
      return "null";
    }
    if (value is String) {
      return value.trim().isEmpty ? "null" : value;
    }
    return value;
  }

  Map<String, dynamic> toExportJson() {
    return {
      'id': _nullIfEmpty(id),
      'idNhomDonVi': _nullIfEmpty(idNhomDonVi),
      'tenPhongBan': _nullIfEmpty(tenPhongBan),
      'idQuanLy': _nullIfEmpty(idQuanLy),
      'idCongTy': _nullIfEmpty("ct001"),
      'phongCapTren': _nullIfEmpty(phongCapTren),
      'mauSac': _nullIfEmpty(mauSac),
      'tenNhom': _nullIfEmpty(tenNhom),
      'hoTenQuanLy': _nullIfEmpty(hoTenQuanLy),
      'nguoiTao': _nullIfEmpty(nguoiTao),
      'nguoiCapNhat': _nullIfEmpty(nguoiCapNhat),
      'soLuongNhanVien': soLuongNhanVien,
      'ngayTao': _nullIfEmpty(ngayTao),
      'ngayCapNhat': _nullIfEmpty(ngayCapNhat),
      'isActive': true,
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
        tenNhom,
        hoTenQuanLy,
        nguoiTao,
        nguoiCapNhat,
        ngayTao,
        ngayCapNhat,
      ];
}
