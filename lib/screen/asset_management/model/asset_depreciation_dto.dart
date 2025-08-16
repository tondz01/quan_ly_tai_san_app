import 'package:quan_ly_tai_san_app/screen/asset_management/model/child_assets_dto.dart';

class AssetDepreciationDto {
  final String? id;
  final String? tenTaiSan;
  final double? nguyenGia;
  final int? soKyKhauHao;
  final int? soThangSuDung;
  final int? soKyKhauHaoConLai;
  final double? giaTriKhauHao;
  final double? giaTriThanhLy;
  final double? giaTriKhauHaoBanDau;
  final int? kyKhauHaoBanDau;
  final double? giaTriThanhLyCu; // Trùng tên GiaTriThanhLy trong DB
  final String? idDuDan;
  final String? tenDuAn;
  final String? phuongPhapKhauHao; // as String per request
  final int? taiKhoanTaiSan;
  final int? taiKhoanKhauHao;
  final int? taiKhoanChiPhi;
  final DateTime? ngayVaoSo;
  final DateTime? ngaySuDung;
  final bool? isActive;
  final List<ChildAssetDto>? childAssets;

  const AssetDepreciationDto({
    this.id,
    this.tenTaiSan,
    this.nguyenGia,
    this.soKyKhauHao,
    this.soThangSuDung,
    this.soKyKhauHaoConLai,
    this.giaTriKhauHao,
    this.giaTriThanhLy,
    this.giaTriKhauHaoBanDau,
    this.kyKhauHaoBanDau,
    this.giaTriThanhLyCu,
    this.idDuDan,
    this.tenDuAn,
    this.phuongPhapKhauHao,
    this.taiKhoanTaiSan,
    this.taiKhoanKhauHao,
    this.taiKhoanChiPhi,
    this.ngayVaoSo,
    this.ngaySuDung,
    this.isActive,
    this.childAssets,
  });

  factory AssetDepreciationDto.fromJson(Map<String, dynamic> json) {
    bool? parseIsActive(dynamic value) {
      if (value == null) return null;
      if (value is bool) return value;
      if (value is num) return value != 0;
      final str = value.toString().toLowerCase();
      if (str == 'true') return true;
      if (str == 'false') return false;
      return null;
    }

    int? asInt(dynamic v) => (v is num) ? v.toInt() : int.tryParse(v?.toString() ?? '');
    double? asDouble(dynamic v) => (v is num) ? v.toDouble() : double.tryParse(v?.toString() ?? '');
    DateTime? asDate(dynamic v) => v == null ? null : DateTime.tryParse(v.toString());

    return AssetDepreciationDto(
      id: json['id']?.toString(),
      tenTaiSan: json['tenTaiSan']?.toString(),
      nguyenGia: asDouble(json['nguyenGia']),
      soKyKhauHao: asInt(json['soKyKhauHao']),
      soThangSuDung: asInt(json['soThangSuDung']),
      soKyKhauHaoConLai: asInt(json['soKyKhauHaoConLai']),
      giaTriKhauHao: asDouble(json['giaTriKhauHao']),
      giaTriThanhLy: asDouble(json['giaTriThanhLy']),
      giaTriKhauHaoBanDau: asDouble(json['giaTriKhauHaoBanDau']),
      kyKhauHaoBanDau: asInt(json['kyKhauHaoBanDau']),
      giaTriThanhLyCu: asDouble(json['giaTriThanhLyCu']),
      idDuDan: json['idDuDan']?.toString(),
      tenDuAn: json['tenDuAn']?.toString(),
      phuongPhapKhauHao: json['phuongPhapKhauHao']?.toString(),
      taiKhoanTaiSan: asInt(json['taiKhoanTaiSan']),
      taiKhoanKhauHao: asInt(json['taiKhoanKhauHao']),
      taiKhoanChiPhi: asInt(json['taiKhoanChiPhi']),
      ngayVaoSo: asDate(json['ngayVaoSo']),
      ngaySuDung: asDate(json['ngaySuDung']),
      isActive: parseIsActive(json['isActive']),
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
      'tenTaiSan': tenTaiSan,
      'nguyenGia': nguyenGia,
      'soKyKhauHao': soKyKhauHao,
      'soThangSuDung': soThangSuDung,
      'soKyKhauHaoConLai': soKyKhauHaoConLai,
      'giaTriKhauHao': giaTriKhauHao,
      'giaTriThanhLy': giaTriThanhLy,
      'giaTriKhauHaoBanDau': giaTriKhauHaoBanDau,
      'kyKhauHaoBanDau': kyKhauHaoBanDau,
      'giaTriThanhLyCu': giaTriThanhLyCu,
      'idDuDan': idDuDan,
      'tenDuAn': tenDuAn,
      'phuongPhapKhauHao': phuongPhapKhauHao,
      'taiKhoanTaiSan': taiKhoanTaiSan,
      'taiKhoanKhauHao': taiKhoanKhauHao,
      'taiKhoanChiPhi': taiKhoanChiPhi,
      'ngayVaoSo': ngayVaoSo?.toIso8601String(),
      'ngaySuDung': ngaySuDung?.toIso8601String(),
      'isActive': isActive,
      'childAssets': childAssets?.map((e) => e.toJson()).toList(),
    };
  }
}
