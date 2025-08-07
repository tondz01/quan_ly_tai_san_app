import 'package:equatable/equatable.dart';

class NguonKinhPhi extends Equatable {
  final String? id;
  final String? tenNguonKinhPhi;
  final String? ghiChu;
  final bool? hieuLuc;
  final String? idCongTy;
  final DateTime? ngayTao;
  final DateTime? ngayCapNhat;
  final String? nguoiTao;
  final String? nguoiCapNhat;
  final bool? isActive;

  const NguonKinhPhi({
    this.id,
    this.tenNguonKinhPhi,
    this.ghiChu,
    this.hieuLuc,
    this.idCongTy,
    this.ngayTao,
    this.ngayCapNhat,
    this.nguoiTao,
    this.nguoiCapNhat,
    this.isActive,
  });

  factory NguonKinhPhi.fromJson(Map<String, dynamic> json) {
    return NguonKinhPhi(
      id: json['id'],
      tenNguonKinhPhi: json['tenNguonKinhPhi'],
      ghiChu: json['ghiChu'],
      hieuLuc: json['hieuLuc'],
      idCongTy: json['idCongTy'],
      ngayTao: json['ngayTao'] != null ? DateTime.parse(json['ngayTao']) : null,
      ngayCapNhat: json['ngayCapNhat'] != null ? DateTime.parse(json['ngayCapNhat']) : null,
      nguoiTao: json['nguoiTao'],
      nguoiCapNhat: json['nguoiCapNhat'],
      isActive: json['isActive'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'tenNguonKinhPhi': tenNguonKinhPhi,
      'ghiChu': ghiChu,
      'hieuLuc': hieuLuc,
      'idCongTy': "id001", // Assuming a default company ID
      'ngayTao': ngayTao?.toIso8601String(),
      'ngayCapNhat': ngayCapNhat?.toIso8601String(),
      'nguoiTao': nguoiTao,
      'nguoiCapNhat': nguoiCapNhat,
      'isActive': isActive,
    };
  }

  @override
  List<Object?> get props => [
        id,
        tenNguonKinhPhi,
        ghiChu,
        hieuLuc,
        idCongTy,
        ngayTao,
        ngayCapNhat,
        nguoiTao,
        nguoiCapNhat,
        isActive,
      ];
}
