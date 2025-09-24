class DetailSubppliesHandoverDto {
  final String id;
  final String idBanGiaoCCDCVatTu;
  final String idCCDCVatTu;
  final int soLuong;
  final String idChiTietCCDCVatTu;
  final String idChiTietDieuDong;
  final String ngayTao;
  final String ngayCapNhat;
  final String nguoiTao;
  final String nguoiCapNhat;
  final bool isActive;

  DetailSubppliesHandoverDto({
    required this.id,
    required this.idBanGiaoCCDCVatTu,
    required this.idCCDCVatTu,
    required this.soLuong,
    required this.idChiTietCCDCVatTu,
    required this.idChiTietDieuDong,
    required this.ngayTao,
    required this.ngayCapNhat,
    required this.nguoiTao,
    required this.nguoiCapNhat,
    required this.isActive,
  });

  factory DetailSubppliesHandoverDto.fromJson(Map<String, dynamic> json) {
    String parseString(dynamic v) => v?.toString() ?? '';
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
    return DetailSubppliesHandoverDto(
      id: parseString(json['id']),
      idBanGiaoCCDCVatTu: parseString(json['idBanGiaoCCDCVatTu']),
      idCCDCVatTu: parseString(json['idCCDCVatTu']),
      soLuong: parseNullableInt(json['soLuong']) ?? 0,
      idChiTietCCDCVatTu: parseString(json['idChiTietCCDCVatTu']),
      idChiTietDieuDong: parseString(json['idChiTietDieuDong']),
      ngayTao: parseString(json['ngayTao']),
      ngayCapNhat: parseString(json['ngayCapNhat']),
      nguoiTao: parseString(json['nguoiTao']),
      nguoiCapNhat: parseString(json['nguoiCapNhat']),
      isActive: parseBool(json['isActive']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'idBanGiaoCCDCVatTu': idBanGiaoCCDCVatTu,
      'idCCDCVatTu': idCCDCVatTu,
      'soLuong': soLuong,
      'idChiTietCCDCVatTu': idChiTietCCDCVatTu,
      'idChiTietDieuDong': idChiTietDieuDong,
      'ngayTao': ngayTao,
      'ngayCapNhat': ngayCapNhat,
      'nguoiTao': nguoiTao,
      'nguoiCapNhat': nguoiCapNhat,
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
      idChiTietDieuDong: '',
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
      idChiTietDieuDong: idChiTietDieuDong ?? this.idChiTietDieuDong,
      ngayTao: ngayTao ?? this.ngayTao,
      ngayCapNhat: ngayCapNhat ?? this.ngayCapNhat,
      nguoiTao: nguoiTao ?? this.nguoiTao,
      nguoiCapNhat: nguoiCapNhat ?? this.nguoiCapNhat,
      isActive: isActive ?? this.isActive,
    );
  }
}
