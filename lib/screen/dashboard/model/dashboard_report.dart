import 'dart:convert';

class DashboardReport {
  final List<GrowthByYear> tangTruongTaiSanTheoNamSX;
  final int tongPhieuDieuDongTaiSan;
  final List<AssetByType> taiSanTheoLoai;
  final List<AssetByDepartment> taiSanTheoPhongBan;
  final List<dynamic> ccdcTheoPhongBan;
  final int tongTaiSan;
  final List<TopAsset> top5TaiSanGiaTriCao;
  final int tongCCDC;
  final int tongDuAn;
  final int tongSoLuongCCDCDieuDong;
  final int nguonVonHieuLuc;
  final List<AssetByGroup> taiSanTheoNhom;
  final List<dynamic> nhapKhoCCDCTheoNam;
  final List<ProjectValue> giaTriTheoDuAn;
  final List<CapitalValue> giaTriTheoNguonVon;
  final int tongNhanVien;
  final int tongPhieuDieuDongCCDC;
  final double tongNguyenGia;
  final int tongChiTietDieuDongTaiSan;
  final List<CompanyValue> giaTriTaiSanTheoCongTy;
  final List<dynamic> taiSanChuaDieuDong;
  final int tongPhongBan;

  DashboardReport({
    required this.tangTruongTaiSanTheoNamSX,
    required this.tongPhieuDieuDongTaiSan,
    required this.taiSanTheoLoai,
    required this.taiSanTheoPhongBan,
    required this.ccdcTheoPhongBan,
    required this.tongTaiSan,
    required this.top5TaiSanGiaTriCao,
    required this.tongCCDC,
    required this.tongDuAn,
    required this.tongSoLuongCCDCDieuDong,
    required this.nguonVonHieuLuc,
    required this.taiSanTheoNhom,
    required this.nhapKhoCCDCTheoNam,
    required this.giaTriTheoDuAn,
    required this.giaTriTheoNguonVon,
    required this.tongNhanVien,
    required this.tongPhieuDieuDongCCDC,
    required this.tongNguyenGia,
    required this.tongChiTietDieuDongTaiSan,
    required this.giaTriTaiSanTheoCongTy,
    required this.taiSanChuaDieuDong,
    required this.tongPhongBan,
  });

  factory DashboardReport.fromJson(Map<String, dynamic> json) {
    return DashboardReport(
      tangTruongTaiSanTheoNamSX: (json['tangTruongTaiSanTheoNamSX'] as List)
          .map((e) => GrowthByYear.fromJson(e))
          .toList(),
      tongPhieuDieuDongTaiSan: json['tongPhieuDieuDongTaiSan'],
      taiSanTheoLoai: (json['taiSanTheoLoai'] as List)
          .map((e) => AssetByType.fromJson(e))
          .toList(),
      taiSanTheoPhongBan: (json['taiSanTheoPhongBan'] as List)
          .map((e) => AssetByDepartment.fromJson(e))
          .toList(),
      ccdcTheoPhongBan: json['ccdcTheoPhongBan'] ?? [],
      tongTaiSan: json['tongTaiSan'],
      top5TaiSanGiaTriCao: (json['top5TaiSanGiaTriCao'] as List)
          .map((e) => TopAsset.fromJson(e))
          .toList(),
      tongCCDC: json['tongCCDC'],
      tongDuAn: json['tongDuAn'],
      tongSoLuongCCDCDieuDong: json['tongSoLuongCCDCDieuDong'],
      nguonVonHieuLuc: json['nguonVonHieuLuc'],
      taiSanTheoNhom: (json['taiSanTheoNhom'] as List)
          .map((e) => AssetByGroup.fromJson(e))
          .toList(),
      nhapKhoCCDCTheoNam: json['nhapKhoCCDCTheoNam'] ?? [],
      giaTriTheoDuAn: (json['giaTriTheoDuAn'] as List)
          .map((e) => ProjectValue.fromJson(e))
          .toList(),
      giaTriTheoNguonVon: (json['giaTriTheoNguonVon'] as List)
          .map((e) => CapitalValue.fromJson(e))
          .toList(),
      tongNhanVien: json['tongNhanVien'],
      tongPhieuDieuDongCCDC: json['tongPhieuDieuDongCCDC'],
      tongNguyenGia: (json['tongNguyenGia'] as num).toDouble(),
      tongChiTietDieuDongTaiSan: json['tongChiTietDieuDongTaiSan'],
      giaTriTaiSanTheoCongTy: (json['giaTriTaiSanTheoCongTy'] as List)
          .map((e) => CompanyValue.fromJson(e))
          .toList(),
      taiSanChuaDieuDong: json['taiSanChuaDieuDong'] ?? [],
      tongPhongBan: json['tongPhongBan'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'tangTruongTaiSanTheoNamSX':
          tangTruongTaiSanTheoNamSX.map((e) => e.toJson()).toList(),
      'tongPhieuDieuDongTaiSan': tongPhieuDieuDongTaiSan,
      'taiSanTheoLoai': taiSanTheoLoai.map((e) => e.toJson()).toList(),
      'taiSanTheoPhongBan': taiSanTheoPhongBan.map((e) => e.toJson()).toList(),
      'ccdcTheoPhongBan': ccdcTheoPhongBan,
      'tongTaiSan': tongTaiSan,
      'top5TaiSanGiaTriCao':
          top5TaiSanGiaTriCao.map((e) => e.toJson()).toList(),
      'tongCCDC': tongCCDC,
      'tongDuAn': tongDuAn,
      'tongSoLuongCCDCDieuDong': tongSoLuongCCDCDieuDong,
      'nguonVonHieuLuc': nguonVonHieuLuc,
      'taiSanTheoNhom': taiSanTheoNhom.map((e) => e.toJson()).toList(),
      'nhapKhoCCDCTheoNam': nhapKhoCCDCTheoNam,
      'giaTriTheoDuAn': giaTriTheoDuAn.map((e) => e.toJson()).toList(),
      'giaTriTheoNguonVon':
          giaTriTheoNguonVon.map((e) => e.toJson()).toList(),
      'tongNhanVien': tongNhanVien,
      'tongPhieuDieuDongCCDC': tongPhieuDieuDongCCDC,
      'tongNguyenGia': tongNguyenGia,
      'tongChiTietDieuDongTaiSan': tongChiTietDieuDongTaiSan,
      'giaTriTaiSanTheoCongTy':
          giaTriTaiSanTheoCongTy.map((e) => e.toJson()).toList(),
      'taiSanChuaDieuDong': taiSanChuaDieuDong,
      'tongPhongBan': tongPhongBan,
    };
  }

  static DashboardReport fromJsonString(String str) =>
      DashboardReport.fromJson(json.decode(str));

  String toJsonString() => json.encode(toJson());
}

class GrowthByYear {
  final int? nam;
  final int? soLuong;

  GrowthByYear({this.nam, this.soLuong});

  factory GrowthByYear.fromJson(Map<String, dynamic> json) =>
      GrowthByYear(nam: json['nam'], soLuong: json['soLuong']);

  Map<String, dynamic> toJson() => {'nam': nam, 'soLuong': soLuong};
}

class AssetByType {
  final String? ten;
  final int? soLuong;

  AssetByType({this.ten, this.soLuong});

  factory AssetByType.fromJson(Map<String, dynamic> json) =>
      AssetByType(ten: json['ten'], soLuong: json['soLuong']);

  Map<String, dynamic> toJson() => {'ten': ten, 'soLuong': soLuong};
}

class AssetByDepartment {
  final String? phongBan;
  final int? soLuong;

  AssetByDepartment({this.phongBan, this.soLuong});

  factory AssetByDepartment.fromJson(Map<String, dynamic> json) =>
      AssetByDepartment(phongBan: json['phongBan'], soLuong: json['soLuong']);

  Map<String, dynamic> toJson() => {'phongBan': phongBan, 'soLuong': soLuong};
}

class TopAsset {
  final String? tenTaiSan;
  final double? nguyenGia;

  TopAsset({this.tenTaiSan, this.nguyenGia});

  factory TopAsset.fromJson(Map<String, dynamic> json) => TopAsset(
        tenTaiSan: json['TenTaiSan'],
        nguyenGia: (json['NguyenGia'] as num).toDouble(),
      );

  Map<String, dynamic> toJson() =>
      {'TenTaiSan': tenTaiSan, 'NguyenGia': nguyenGia};
}

class AssetByGroup {
  final String? ten;
  final int? soLuong;

  AssetByGroup({this.ten, this.soLuong});

  factory AssetByGroup.fromJson(Map<String, dynamic> json) =>
      AssetByGroup(ten: json['ten'], soLuong: json['soLuong']);

  Map<String, dynamic> toJson() => {'ten': ten, 'soLuong': soLuong};
}

class ProjectValue {
  final String? duAn;
  final double? tongGiaTri;

  ProjectValue({required this.duAn, required this.tongGiaTri});

  factory ProjectValue.fromJson(Map<String, dynamic> json) => ProjectValue(
        duAn: json['duAn'],
        tongGiaTri: (json['tongGiaTri'] as num).toDouble(),
      );

  Map<String, dynamic> toJson() => {'duAn': duAn, 'tongGiaTri': tongGiaTri};
}

class CapitalValue {
  final String? nguonVon;
  final double? tongGiaTri;

  CapitalValue({this.nguonVon, this.tongGiaTri});

  factory CapitalValue.fromJson(Map<String, dynamic> json) => CapitalValue(
        nguonVon: json['nguonVon'],
        tongGiaTri: (json['tongGiaTri'] as num).toDouble(),
      );

  Map<String, dynamic> toJson() =>
      {'nguonVon': nguonVon, 'tongGiaTri': tongGiaTri};
}

class CompanyValue {
  final String? congTy;
  final double? tongGiaTri;

  CompanyValue({this.congTy, this.tongGiaTri});

  factory CompanyValue.fromJson(Map<String, dynamic> json) => CompanyValue(
        congTy: json['congTy'],
        tongGiaTri: (json['tongGiaTri'] as num).toDouble(),
      );

  Map<String, dynamic> toJson() =>
      {'congTy': congTy, 'tongGiaTri': tongGiaTri};
}
