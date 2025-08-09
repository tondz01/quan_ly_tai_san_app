import 'package:equatable/equatable.dart';

class NhomDonVi extends Equatable {
  final String? id;
  final String? tenNhom;
  final DateTime? ngayTao;
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
      ngayTao: json['ngayTao'] != null ? DateTime.parse(json['ngayTao']) : null,
      nguoiTao: json['nguoiTao'],
      idCongTy: json['idCongTy'],
      isActive: json['isActive'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'tenNhom': tenNhom,
      'ngayTao': ngayTao?.toIso8601String(),
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
