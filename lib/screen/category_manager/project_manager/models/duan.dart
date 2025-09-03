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
