import 'dart:convert';

class AssetGroupDto {
  final String? id;
  final String? tenNhom;
  final bool? hieuLuc;
  final String? idCongTy;
  final DateTime? ngayTao;
  final DateTime? ngayCapNhat;
  final String? nguoiTao;
  final String? nguoiCapNhat;
  final bool? isActive;

  AssetGroupDto({
    this.id,
    this.tenNhom,
    this.hieuLuc,
    this.idCongTy,
    this.ngayTao,
    this.ngayCapNhat,
    this.nguoiTao,
    this.nguoiCapNhat,
    this.isActive,
  });

  factory AssetGroupDto.fromJson(Map<String, dynamic> json) {
    return AssetGroupDto(
      id: json['id'],
      tenNhom: json['tenNhom'],
      hieuLuc: json['hieuLuc'],
      idCongTy: json['idCongTy'],
      ngayTao: json['ngayTao'] != null
          ? DateTime.tryParse(json['ngayTao'])
          : null,
      ngayCapNhat: json['ngayCapNhat'] != null
          ? DateTime.tryParse(json['ngayCapNhat'])
          : null,
      nguoiTao: json['nguoiTao'],
      nguoiCapNhat: json['nguoiCapNhat'],
      isActive: json['isActive'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'tenNhom': tenNhom,
      'hieuLuc': hieuLuc,
      'idCongTy': idCongTy,
      'ngayTao': ngayTao?.millisecondsSinceEpoch,
      'ngayCapNhat': ngayCapNhat?.millisecondsSinceEpoch,
      'nguoiTao': nguoiTao,
      'nguoiCapNhat': nguoiCapNhat,
      'isActive': isActive,
    };
  }

  static List<AssetGroupDto> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => AssetGroupDto.fromJson(json)).toList();
  }

  static String encode(List<AssetGroupDto> categories) =>
      json.encode(categories.map((category) => category.toJson()).toList());

  static List<AssetGroupDto> decode(String categories) =>
      (json.decode(categories) as List<dynamic>)
          .map<AssetGroupDto>((item) => AssetGroupDto.fromJson(item))
          .toList();
}