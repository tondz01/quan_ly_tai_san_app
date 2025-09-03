import 'dart:convert';

import 'package:quan_ly_tai_san_app/screen/asset_management/model/detail_assets_dto.dart';
import 'package:quan_ly_tai_san_app/screen/tools_and_supplies/model/ownership_unit_detail_dto.dart';

class ToolsAndSuppliesDto {
  String id;
  String ten;
  String idDonVi;
  String tenDonVi;
  String idNhomCCDC;
  String tenNhomCCDC;
  DateTime ngayNhap;
  String donViTinh;
  int soLuong;
  double giaTri;
  String soKyHieu;
  String kyHieu;
  String congSuat;
  String nuocSanXuat;
  int namSanXuat;
  String ghiChu;
  String idCongTy;
  DateTime ngayTao;
  DateTime ngayCapNhat;
  String nguoiTao;
  String nguoiCapNhat;
  List<DetailAssetDto> chiTietTaiSanList;
  int soLuongXuat;
  bool isActive;
  List<OwnershipUnitDetailDto> detailOwnershipUnit;

  ToolsAndSuppliesDto({
    required this.id,
    required this.ten,
    required this.idDonVi,
    required this.tenDonVi,
    required this.idNhomCCDC,
    required this.tenNhomCCDC,
    required this.ngayNhap,
    required this.donViTinh,
    required this.soLuong,
    required this.giaTri,
    this.soKyHieu = '',
    this.kyHieu = '',
    this.congSuat = '',
    required this.nuocSanXuat,
    required this.namSanXuat,
    this.ghiChu = '',
    required this.idCongTy,
    required this.ngayTao,
    required this.ngayCapNhat,
    required this.nguoiTao,
    required this.nguoiCapNhat,
    required this.isActive,
    this.chiTietTaiSanList = const [],
    this.soLuongXuat = 0,
    this.detailOwnershipUnit = const [],
  });

  factory ToolsAndSuppliesDto.fromJson(Map<String, dynamic> json) {
    return ToolsAndSuppliesDto(
      id: json['id'] ?? '',
      ten: json['ten'] ?? '',
      idDonVi: json['idDonVi'] ?? '',
      tenDonVi: json['tenDonVi'] ?? '',
      idNhomCCDC: json['idNhomCCDC'] ?? '',
      tenNhomCCDC: json['tenNhomCCDC'] ?? '',
      ngayNhap:
          json['ngayNhap'] != null
              ? DateTime.parse(json['ngayNhap'].toString())
              : DateTime.now(),
      donViTinh: json['donViTinh'] ?? '',
      soLuong: json['soLuong'] ?? 0,
      giaTri: json['giaTri'] ?? 0.0,
      soKyHieu: json['soKyHieu'] ?? '',
      kyHieu: json['kyHieu'] ?? '',
      congSuat: json['congSuat'] ?? '',
      nuocSanXuat: json['nuocSanXuat'] ?? '',
      namSanXuat: json['namSanXuat'] ?? 0,
      ghiChu: json['ghiChu'] ?? '',
      idCongTy: json['idCongTy'] ?? '',
      ngayTao:
          json['ngayTao'] != null
              ? DateTime.parse(json['ngayTao'].toString())
              : DateTime.now(),
      ngayCapNhat:
          json['ngayCapNhat'] != null
              ? DateTime.parse(json['ngayCapNhat'].toString())
              : DateTime.now(),
      nguoiTao: json['nguoiTao'] ?? '',
      nguoiCapNhat: json['nguoiCapNhat'] ?? '',
      isActive: json['isActive'] ?? true,
      chiTietTaiSanList:
          json['chiTietTaiSanList'] != null
              ? (json['chiTietTaiSanList'] as List)
                  .map((item) => DetailAssetDto.fromJson(item))
                  .toList()
              : [],
      soLuongXuat: json['soLuongXuat'] ?? 0,
      detailOwnershipUnit:
          json['detailOwnershipUnit'] != null
              ? (json['detailOwnershipUnit'] as List)
                  .map((item) => OwnershipUnitDetailDto.fromJson(item))
                  .toList()
              : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'idDonVi': idDonVi,
      'ten': ten,
      'ngayNhap': ngayNhap.toIso8601String(),
      'donViTinh': donViTinh,
      'soLuong': soLuong,
      'giaTri': giaTri,
      'soKyHieu': soKyHieu,
      'kyHieu': kyHieu,
      'congSuat': congSuat,
      'nuocSanXuat': nuocSanXuat,
      'namSanXuat': namSanXuat,
      'ghiChu': ghiChu,
      'idCongTy': idCongTy,
      'ngayTao': ngayTao.toIso8601String(),
      'ngayCapNhat': ngayCapNhat.toIso8601String(),
      'nguoiTao': nguoiTao,
      'nguoiCapNhat': nguoiCapNhat,
      'isActive': isActive,
      'soLuongXuat': soLuongXuat.toString(),
      'detailOwnershipUnit': detailOwnershipUnit,
    };
  }

  factory ToolsAndSuppliesDto.empty() {
    return ToolsAndSuppliesDto(
      id: '',
      ten: '',
      idDonVi: '',
      tenDonVi: '',
      idNhomCCDC: '',
      tenNhomCCDC: '',
      ngayNhap: DateTime.now(),
      donViTinh: '',
      soLuong: 0,
      giaTri: 0.0,
      soKyHieu: '',
      kyHieu: '',
      congSuat: '',
      nuocSanXuat: '',
      namSanXuat: 0,
      ghiChu: '',
      idCongTy: '',
      ngayTao: DateTime.now(),
      ngayCapNhat: DateTime.now(),
      nguoiTao: '',
      nguoiCapNhat: '',
      isActive: true,
      chiTietTaiSanList: [],
      soLuongXuat: 0,
      detailOwnershipUnit: [],
    );
  }

  static List<ToolsAndSuppliesDto> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => ToolsAndSuppliesDto.fromJson(json)).toList();
  }

  static String encode(List<ToolsAndSuppliesDto> assets) =>
      json.encode(assets.map((asset) => asset.toJson()).toList());

  static List<ToolsAndSuppliesDto> decode(String assets) =>
      (json.decode(assets) as List<dynamic>)
          .map<ToolsAndSuppliesDto>(
            (item) => ToolsAndSuppliesDto.fromJson(item),
          )
          .toList();

  @override
  String toString() {
    return ten; // hoặc bất kỳ field nào bạn muốn hiển thị
  }

  ToolsAndSuppliesDto copyWith({
    String? id,
    String? idDonVi,
    String? ten,
    DateTime? ngayNhap,
    String? donViTinh,
    int? soLuong,
    double? giaTri,
    String? soKyHieu,
    String? kyHieu,
    String? congSuat,
    String? nuocSanXuat,
    int? namSanXuat,
    String? ghiChu,
    String? idCongTy,
    DateTime? ngayTao,
    DateTime? ngayCapNhat,
    String? nguoiTao,
    String? nguoiCapNhat,
    int? soLuongXuat,
    bool? isActive,
    List<OwnershipUnitDetailDto>? detailOwnershipUnit,
  }) {
    return ToolsAndSuppliesDto(
      id: id ?? this.id,
      ten: ten ?? this.ten,
      idDonVi: idDonVi ?? this.idDonVi,
      tenDonVi: idDonVi ?? this.idDonVi,
      idNhomCCDC: idDonVi ?? this.idDonVi,
      tenNhomCCDC: idDonVi ?? this.idDonVi,
      ngayNhap: ngayNhap ?? this.ngayNhap,
      donViTinh: donViTinh ?? this.donViTinh,
      soLuong: soLuong ?? this.soLuong,
      giaTri: giaTri ?? this.giaTri,
      soKyHieu: soKyHieu ?? this.soKyHieu,
      kyHieu: kyHieu ?? this.kyHieu,
      congSuat: congSuat ?? this.congSuat,
      nuocSanXuat: nuocSanXuat ?? this.nuocSanXuat,
      namSanXuat: namSanXuat ?? this.namSanXuat,
      ghiChu: ghiChu ?? this.ghiChu,
      idCongTy: idCongTy ?? this.idCongTy,
      ngayTao: ngayTao ?? this.ngayTao,
      ngayCapNhat: ngayCapNhat ?? this.ngayCapNhat,
      nguoiTao: nguoiTao ?? this.nguoiTao,
      nguoiCapNhat: nguoiCapNhat ?? this.nguoiCapNhat,
      isActive: isActive ?? this.isActive,
      soLuongXuat: soLuongXuat ?? this.soLuongXuat,
      detailOwnershipUnit: detailOwnershipUnit ?? this.detailOwnershipUnit,
    );
  }
}
