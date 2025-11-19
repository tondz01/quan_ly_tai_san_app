import 'package:equatable/equatable.dart';
import 'package:quan_ly_tai_san_app/core/utils/utils.dart';

class NhomDonVi extends Equatable {
  final String? id;
  final String? tenNhom;
  final String? ngayTao;
  final String? nguoiTao;
  final String? idCongTy;
  final bool? isActive;

  const NhomDonVi({
    this.id,
    this.tenNhom,
    this.ngayTao,
    this.nguoiTao,
    this.idCongTy,
    this.isActive,
  });

  factory NhomDonVi.fromJson(Map<String, dynamic> json) {
    return NhomDonVi(
      id: json['id'],
      tenNhom: json['tenNhom'],
      ngayTao: json['ngayTao'] != null
          ? AppUtility.formatFromISOString(json['ngayTao'])
          : null,
      nguoiTao: json['nguoiTao'],
      idCongTy: json['idCongTy'],
      isActive: json['isActive'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'tenNhom': tenNhom,
      'ngayTao': AppUtility.formatFromISOString(ngayTao ?? ''),
      'nguoiTao': nguoiTao,
      'idCongTy': "ct001", // Assuming a default company ID
      'isActive': isActive,
    };
  }

  @override
  List<Object?> get props => [
        id,
        tenNhom,
        ngayTao,
        nguoiTao,
        idCongTy,
        isActive,
      ];
}
