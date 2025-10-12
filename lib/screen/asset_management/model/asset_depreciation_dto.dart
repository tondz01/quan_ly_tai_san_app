import 'package:quan_ly_tai_san_app/screen/asset_management/model/child_assets_dto.dart';

class AssetDepreciationDto {
  final String? id;
  final String? soThe;
  final String? tenTaiSan;
  final String? nguonVon;
  final String? maTk;
  final DateTime? ngayTinhKhao;
  final int? thangKh;
  final double? nguyenGia;
  final double? khauHaoBanDau;
  final double? khauHaoPsdk;
  final double? gtclBanDau;
  final double? khauHaoPsck;
  final double? gtclHienTai;
  final double? khauHaoBinhQuan;
  final double? soTien;
  final double? chenhLech;
  final double? khKyTruoc;
  final double? clKyTruoc;
  final double? hsdCkh;
  final String? tkNo;
  final String? tkCo;
  final String? dtgt;
  final String? dtth;
  final String? kmcp;
  final String? ghiChuKhao;
  final String? userId;
  final double? nvNS;
  final double? vonVay;
  final double? vonKhac;
  final DateTime? userTime;
  final List<ChildAssetDto>? childAssets;

  const AssetDepreciationDto({
    this.id,
    this.soThe,
    this.tenTaiSan,
    this.nguonVon,
    this.maTk,
    this.ngayTinhKhao,
    this.thangKh,
    this.nguyenGia,
    this.khauHaoBanDau,
    this.khauHaoPsdk,
    this.gtclBanDau,
    this.khauHaoPsck,
    this.gtclHienTai,
    this.khauHaoBinhQuan,
    this.soTien,
    this.chenhLech,
    this.khKyTruoc,
    this.clKyTruoc,
    this.hsdCkh,
    this.tkNo,
    this.tkCo,
    this.dtgt,
    this.dtth,
    this.kmcp,
    this.ghiChuKhao,
    this.userId,
    this.nvNS,
    this.vonVay,
    this.vonKhac,
    this.userTime,
    this.childAssets,
  });

  factory AssetDepreciationDto.fromJson(Map<String, dynamic> json) {
    int? asInt(dynamic v) => (v is num) ? v.toInt() : int.tryParse(v?.toString() ?? '');
    double? asDouble(dynamic v) => (v is num) ? v.toDouble() : double.tryParse(v?.toString() ?? '');
    DateTime? asDate(dynamic v) => v == null ? null : DateTime.tryParse(v.toString());

    return AssetDepreciationDto(
      id: json['id']?.toString(),
      soThe: json['soThe']?.toString(),
      tenTaiSan: json['tenTaiSan']?.toString(),
      nguonVon: json['nguonVon']?.toString(),
      maTk: json['maTk']?.toString(),
      ngayTinhKhao: asDate(json['ngayTinhKhao']),
      thangKh: asInt(json['thangKh']),
      nguyenGia: asDouble(json['nguyenGia']),
      khauHaoBanDau: asDouble(json['khauHaoBanDau']),
      khauHaoPsdk: asDouble(json['khauHaoPsdk']),
      gtclBanDau: asDouble(json['gtclBanDau']),
      khauHaoPsck: asDouble(json['khauHaoPsck']),
      gtclHienTai: asDouble(json['gtclHienTai']),
      khauHaoBinhQuan: asDouble(json['khauHaoBinhQuan']),
      soTien: asDouble(json['soTien']),
      chenhLech: asDouble(json['chenhLech']),
      khKyTruoc: asDouble(json['khKyTruoc']),
      clKyTruoc: asDouble(json['clKyTruoc']),
      hsdCkh: asDouble(json['hsdCkh']),
      tkNo: json['tkNo']?.toString(),
      tkCo: json['tkCo']?.toString(),
      dtgt: json['dtgt']?.toString(),
      dtth: json['dtth']?.toString(),
      kmcp: json['kmcp']?.toString(),
      ghiChuKhao: json['ghiChuKhao']?.toString(),
      userId: json['userId']?.toString(),
      nvNS: asDouble(json['nvNS']),
      vonVay: asDouble(json['vonVay']),
      vonKhac: asDouble(json['vonKhac']),
      userTime: asDate(json['userTime']),
      childAssets: json['childAssets'] != null
          ? (json['childAssets'] as List)
              .map((e) => ChildAssetDto.fromJson(e))
              .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'soThe': soThe,
      'tenTaiSan': tenTaiSan,
      'nguonVon': nguonVon,
      'maTk': maTk,
      'ngayTinhKhao': ngayTinhKhao?.toIso8601String(),
      'thangKh': thangKh,
      'nguyenGia': nguyenGia,
      'khauHaoBanDau': khauHaoBanDau,
      'khauHaoPsdk': khauHaoPsdk,
      'gtclBanDau': gtclBanDau,
      'khauHaoPsck': khauHaoPsck,
      'gtclHienTai': gtclHienTai,
      'khauHaoBinhQuan': khauHaoBinhQuan,
      'soTien': soTien,
      'chenhLech': chenhLech,
      'khKyTruoc': khKyTruoc,
      'clKyTruoc': clKyTruoc,
      'hsdCkh': hsdCkh,
      'tkNo': tkNo,
      'tkCo': tkCo,
      'dtgt': dtgt,
      'dtth': dtth,
      'kmcp': kmcp,
      'ghiChuKhao': ghiChuKhao,
      'userId': userId,
      'nvNS': nvNS,
      'vonVay': vonVay,
      'vonKhac': vonKhac,
      'userTime': userTime?.toIso8601String(),
      'childAssets': childAssets?.map((e) => e.toJson()).toList(),
    };
  }
}
