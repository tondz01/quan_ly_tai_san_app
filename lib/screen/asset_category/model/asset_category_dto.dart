import 'dart:convert';

class AssetCategoryDto {
  final String? id;
  final String? tenMoHinh;
  final int? phuongPhapKhauHao;
  final int? kyKhauHao;
  final String? loaiKyKhauHao;
  final String? taiKhoanTaiSan;
  final String? taiKhoanKhauHao;
  final String? taiKhoanChiPhi;
  final String? idCongTy;
  final DateTime? ngayTao;
  final DateTime? ngayCapNhat;
  final String? nguoiTao;
  final String? nguoiCapNhat;
  final bool? isActive;

  AssetCategoryDto({
    this.id,
    this.tenMoHinh,
    this.phuongPhapKhauHao,
    this.kyKhauHao,
    this.loaiKyKhauHao,
    this.taiKhoanTaiSan,
    this.taiKhoanKhauHao,
    this.taiKhoanChiPhi,
    this.idCongTy,
    this.ngayTao,
    this.ngayCapNhat,
    this.nguoiTao,
    this.nguoiCapNhat,
    this.isActive,
  });

  factory AssetCategoryDto.fromJson(Map<String, dynamic> json) {
    return AssetCategoryDto(
      id: json['id'],
      tenMoHinh: json['tenMoHinh'],
      phuongPhapKhauHao: json['phuongPhapKhauHao'],
      kyKhauHao: json['kyKhauHao'],
      loaiKyKhauHao: json['loaiKyKhauHao'],
      taiKhoanTaiSan: json['taiKhoanTaiSan'],
      taiKhoanKhauHao: json['taiKhoanKhauHao'],
      taiKhoanChiPhi: json['taiKhoanChiPhi'],
      idCongTy: json['idCongTy'],
      ngayTao: json['ngayTao'] != null 
          ? DateTime.fromMillisecondsSinceEpoch(json['ngayTao'])
          : null,
      ngayCapNhat: json['ngayCapNhat'] != null 
          ? DateTime.fromMillisecondsSinceEpoch(json['ngayCapNhat'])
          : null,
      nguoiTao: json['nguoiTao'],
      nguoiCapNhat: json['nguoiCapNhat'],
      isActive: json['isActive'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'tenMoHinh': tenMoHinh,
      'phuongPhapKhauHao': phuongPhapKhauHao,
      'kyKhauHao': kyKhauHao,
      'loaiKyKhauHao': loaiKyKhauHao,
      'taiKhoanTaiSan': taiKhoanTaiSan,
      'taiKhoanKhauHao': taiKhoanKhauHao,
      'taiKhoanChiPhi': taiKhoanChiPhi,
      'idCongTy': idCongTy,
      'ngayTao': ngayTao?.millisecondsSinceEpoch,
      'ngayCapNhat': ngayCapNhat?.millisecondsSinceEpoch,
      'nguoiTao': nguoiTao,
      'nguoiCapNhat': nguoiCapNhat,
      'isActive': isActive,
    };
  }

  static List<AssetCategoryDto> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => AssetCategoryDto.fromJson(json)).toList();
  }

  static String encode(List<AssetCategoryDto> categories) =>
      json.encode(categories.map((category) => category.toJson()).toList());

  static List<AssetCategoryDto> decode(String categories) =>
      (json.decode(categories) as List<dynamic>)
          .map<AssetCategoryDto>((item) => AssetCategoryDto.fromJson(item))
          .toList();
}