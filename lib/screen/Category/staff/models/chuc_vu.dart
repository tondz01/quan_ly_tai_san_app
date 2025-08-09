import 'package:equatable/equatable.dart';

class ChucVu extends Equatable {
  final String id;
  final String tenChucVu;
  final String idCongTy;
  final DateTime ngayTao;
  final DateTime ngayCapNhat;
  final String nguoiTao;
  final String nguoiCapNhat;
  final bool isActive;
  final bool active;

  const ChucVu({
    required this.id,
    required this.tenChucVu,
    required this.idCongTy,
    required this.ngayTao,
    required this.ngayCapNhat,
    required this.nguoiTao,
    required this.nguoiCapNhat,
    required this.isActive,
    required this.active,
  });

  /// Tạo object từ JSON
  factory ChucVu.fromJson(Map<String, dynamic> json) {
    return ChucVu(
      id: json['id'] as String,
      tenChucVu: json['tenChucVu'] as String,
      idCongTy: json['idCongTy'] as String,
      ngayTao: DateTime.parse(json['ngayTao'] as String),
      ngayCapNhat: DateTime.parse(json['ngayCapNhat'] as String),
      nguoiTao: json['nguoiTao'] as String,
      nguoiCapNhat: json['nguoiCapNhat'] as String,
      isActive: json['isActive'] as bool,
      active: json['active'] as bool,
    );
  }

  /// Chuyển object thành JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'tenChucVu': tenChucVu,
      'idCongTy': idCongTy,
      'ngayTao': ngayTao.toIso8601String(),
      'ngayCapNhat': ngayCapNhat.toIso8601String(),
      'nguoiTao': nguoiTao,
      'nguoiCapNhat': nguoiCapNhat,
      'isActive': isActive,
      'active': active,
    };
  }

  /// copyWith để dễ dàng cập nhật field
  ChucVu copyWith({
    String? id,
    String? tenChucVu,
    String? idCongTy,
    DateTime? ngayTao,
    DateTime? ngayCapNhat,
    String? nguoiTao,
    String? nguoiCapNhat,
    bool? isActive,
    bool? active,
  }) {
    return ChucVu(
      id: id ?? this.id,
      tenChucVu: tenChucVu ?? this.tenChucVu,
      idCongTy: idCongTy ?? this.idCongTy,
      ngayTao: ngayTao ?? this.ngayTao,
      ngayCapNhat: ngayCapNhat ?? this.ngayCapNhat,
      nguoiTao: nguoiTao ?? this.nguoiTao,
      nguoiCapNhat: nguoiCapNhat ?? this.nguoiCapNhat,
      isActive: isActive ?? this.isActive,
      active: active ?? this.active,
    );
  }

  @override
  List<Object?> get props => [
        id,
        tenChucVu,
        idCongTy,
        ngayTao,
        ngayCapNhat,
        nguoiTao,
        nguoiCapNhat,
        isActive,
        active,
      ];
}
