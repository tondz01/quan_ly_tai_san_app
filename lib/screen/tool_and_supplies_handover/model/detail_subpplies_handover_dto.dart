import 'package:quan_ly_tai_san_app/screen/tool_and_material_transfer/model/detail_tool_and_material_transfer_dto.dart';

class DetailSubppliesHandoverDto {
  final String id;
  final String idBanGiaoCCDCVatTu;
  final String idCCDCVatTu;
  final int soLuong;
  final String idChiTietCCDCVatTu;

  // Legacy field (kept for backward-compatibility). Mirrors idChiTietDieuDong
  final String iddieudongccdcvattu;

  // New top-level display fields from API
  final String? tenPhieuBanGiao;
  final String? tenVatTu;
  final String? donViTinh;
  final String? kyHieu;
  final String? soKyHieu;
  final String? congSuat;
  final String? nuocSanXuat;
  final String? namSanXuat; // API returns string for this field

  // Link to transfer detail
  final String? idChiTietDieuDong; // mirrors iddieudongccdcvattu
  final DetailToolAndMaterialTransferDto? chiTietDieuDongCCDCVatTuDTO;

  final String ngayTao;
  final String ngayCapNhat;
  final String nguoiTao;
  final String nguoiCapNhat;
  final bool isActive; // keep existing name, parse from active/isActive

  DetailSubppliesHandoverDto({
    required this.id,
    required this.idBanGiaoCCDCVatTu,
    required this.idCCDCVatTu,
    required this.soLuong,
    required this.idChiTietCCDCVatTu,
    required this.iddieudongccdcvattu,
    this.tenPhieuBanGiao,
    this.tenVatTu,
    this.donViTinh,
    this.kyHieu,
    this.soKyHieu,
    this.congSuat,
    this.nuocSanXuat,
    this.namSanXuat,
    this.idChiTietDieuDong,
    this.chiTietDieuDongCCDCVatTuDTO,
    required this.ngayTao,
    required this.ngayCapNhat,
    required this.nguoiTao,
    required this.nguoiCapNhat,
    required this.isActive,
  });

  factory DetailSubppliesHandoverDto.fromJson(Map<String, dynamic> json) {
    String parseString(dynamic v) => v?.toString() ?? '';
    String? parseNullableString(dynamic v) => v == null ? null : v.toString();
    bool parseBool(dynamic v) {
      if (v is bool) return v;
      if (v is num) return v != 0;
      if (v is String) return v.toLowerCase() == 'true' || v == '1';
      return false;
    }
    int? parseNullableInt(dynamic v) {
      if (v == null) return null;
      if (v is int) return v;
      if (v is num) return v.toInt();
      final parsed = int.tryParse(v.toString());
      return parsed;
    }

    final String legacyIdChiTietDieuDong = parseString(
      json['iddieudongccdcvattu'] ?? json['idChiTietDieuDong'],
    );

    return DetailSubppliesHandoverDto(
      id: parseString(json['id']),
      idBanGiaoCCDCVatTu: parseString(json['idBanGiaoCCDCVatTu']),
      idCCDCVatTu: parseString(json['idCCDCVatTu']),
      soLuong: parseNullableInt(json['soLuong']) ?? 0,
      idChiTietCCDCVatTu: parseString(json['idChiTietCCDCVatTu']),
      iddieudongccdcvattu: legacyIdChiTietDieuDong,
      tenPhieuBanGiao: parseNullableString(json['tenPhieuBanGiao']),
      tenVatTu: parseNullableString(json['tenVatTu']),
      donViTinh: parseNullableString(json['donViTinh']),
      kyHieu: parseNullableString(json['kyHieu']),
      soKyHieu: parseNullableString(json['soKyHieu']),
      congSuat: parseNullableString(json['congSuat']),
      nuocSanXuat: parseNullableString(json['nuocSanXuat']),
      namSanXuat: parseNullableString(json['namSanXuat']),
      idChiTietDieuDong: parseNullableString(json['idChiTietDieuDong']) ?? legacyIdChiTietDieuDong,
      chiTietDieuDongCCDCVatTuDTO: json['chiTietDieuDongCCDCVatTuDTO'] == null
          ? null
          : DetailToolAndMaterialTransferDto.fromJson(
              json['chiTietDieuDongCCDCVatTuDTO'] as Map<String, dynamic>,
            ),
      ngayTao: parseString(json['ngayTao']),
      ngayCapNhat: parseString(json['ngayCapNhat']),
      nguoiTao: parseString(json['nguoiTao']),
      nguoiCapNhat: parseString(json['nguoiCapNhat']),
      isActive: parseBool(json['isActive'] ?? json['active']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'idBanGiaoCCDCVatTu': idBanGiaoCCDCVatTu,
      'tenPhieuBanGiao': tenPhieuBanGiao,
      'idCCDCVatTu': idCCDCVatTu,
      'tenVatTu': tenVatTu,
      'donViTinh': donViTinh,
      'kyHieu': kyHieu,
      'soKyHieu': soKyHieu,
      'congSuat': congSuat,
      'nuocSanXuat': nuocSanXuat,
      'namSanXuat': namSanXuat,
      'soLuong': soLuong,
      'ngayTao': ngayTao,
      'ngayCapNhat': ngayCapNhat,
      'nguoiTao': nguoiTao,
      'nguoiCapNhat': nguoiCapNhat,
      'idChiTietCCDCVatTu': idChiTietCCDCVatTu,
      // New key
      'idChiTietDieuDong': idChiTietDieuDong ?? iddieudongccdcvattu,
      // Legacy key for backward-compatibility
      'iddieudongccdcvattu': iddieudongccdcvattu,
      'chiTietDieuDongCCDCVatTuDTO': chiTietDieuDongCCDCVatTuDTO?.toJson(),
      // Keep both for compatibility
      'active': isActive,
      'isActive': isActive,
    };
  }

  factory DetailSubppliesHandoverDto.empty() {
    final now = DateTime.now().toIso8601String();
    return DetailSubppliesHandoverDto(
      id: '',
      idBanGiaoCCDCVatTu: '',
      idCCDCVatTu: '',
      soLuong: 0,
      idChiTietCCDCVatTu: '',
      iddieudongccdcvattu: '',
      tenPhieuBanGiao: null,
      tenVatTu: null,
      donViTinh: null,
      kyHieu: null,
      soKyHieu: null,
      congSuat: null,
      nuocSanXuat: null,
      namSanXuat: null,
      idChiTietDieuDong: null,
      chiTietDieuDongCCDCVatTuDTO: null,
      ngayTao: now,
      ngayCapNhat: now,
      nguoiTao: '',
      nguoiCapNhat: '',
      isActive: false,
    );
  }

  DetailSubppliesHandoverDto copyWith({
    String? id,
    String? idBanGiaoCCDCVatTu,
    String? idCCDCVatTu,
    int? soLuong,
    String? idChiTietCCDCVatTu,
    String? idChiTietDieuDong,
    String? tenPhieuBanGiao,
    String? tenVatTu,
    String? donViTinh,
    String? kyHieu,
    String? soKyHieu,
    String? congSuat,
    String? nuocSanXuat,
    String? namSanXuat,
    DetailToolAndMaterialTransferDto? chiTietDieuDongCCDCVatTuDTO,
    String? ngayTao,
    String? ngayCapNhat,
    String? nguoiTao,
    String? nguoiCapNhat,
    bool? isActive,
  }) {
    return DetailSubppliesHandoverDto(
      id: id ?? this.id,
      idBanGiaoCCDCVatTu: idBanGiaoCCDCVatTu ?? this.idBanGiaoCCDCVatTu,
      idCCDCVatTu: idCCDCVatTu ?? this.idCCDCVatTu,
      soLuong: soLuong ?? this.soLuong,
      idChiTietCCDCVatTu: idChiTietCCDCVatTu ?? this.idChiTietCCDCVatTu,
      iddieudongccdcvattu: idChiTietDieuDong ?? this.iddieudongccdcvattu,
      idChiTietDieuDong: idChiTietDieuDong ?? this.idChiTietDieuDong,
      tenPhieuBanGiao: tenPhieuBanGiao ?? this.tenPhieuBanGiao,
      tenVatTu: tenVatTu ?? this.tenVatTu,
      donViTinh: donViTinh ?? this.donViTinh,
      kyHieu: kyHieu ?? this.kyHieu,
      soKyHieu: soKyHieu ?? this.soKyHieu,
      congSuat: congSuat ?? this.congSuat,
      nuocSanXuat: nuocSanXuat ?? this.nuocSanXuat,
      namSanXuat: namSanXuat ?? this.namSanXuat,
      chiTietDieuDongCCDCVatTuDTO:
          chiTietDieuDongCCDCVatTuDTO ?? this.chiTietDieuDongCCDCVatTuDTO,
      ngayTao: ngayTao ?? this.ngayTao,
      ngayCapNhat: ngayCapNhat ?? this.ngayCapNhat,
      nguoiTao: nguoiTao ?? this.nguoiTao,
      nguoiCapNhat: nguoiCapNhat ?? this.nguoiCapNhat,
      isActive: isActive ?? this.isActive,
    );
  }
}
