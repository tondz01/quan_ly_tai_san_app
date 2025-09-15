import 'package:equatable/equatable.dart';

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
      'idCongTy': "ct001", // Assuming a default company ID
      'phongCapTren': phongCapTren ?? "",
      'mauSac': mauSac ?? "",
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
      'ngayTao': _nullIfEmpty(ngayTao),
      'ngayCapNhat': _nullIfEmpty(ngayCapNhat),
      'nguoiTao': _nullIfEmpty(nguoiTao),
      'nguoiCapNhat': _nullIfEmpty(nguoiCapNhat),
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
        nguoiTao,
        nguoiCapNhat,
        ngayTao,
        ngayCapNhat,
      ];
}
