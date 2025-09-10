class ChiTietBanGiaoRequest {
  final String id;
  final String idDieuDongCCDCVatTu;
  final String idCCDCVatTu;
  final int soLuong;
  final String idChiTietCCDCVatTu;
  final int soLuongXuat;
  final String ghiChu;
  final String nguoiTao;
  final String nguoiCapNhat;
  final bool isActive;

  ChiTietBanGiaoRequest({
    required this.id,
    required this.idDieuDongCCDCVatTu,
    required this.idCCDCVatTu,
    required this.soLuong,
    required this.idChiTietCCDCVatTu,
    required this.soLuongXuat,
    required this.ghiChu,
    required this.nguoiTao,
    required this.nguoiCapNhat,
    required this.isActive,
  });

  factory ChiTietBanGiaoRequest.fromJson(Map<String, dynamic> json) {
    bool parseBool(dynamic v) {
      if (v is bool) return v;
      if (v is num) return v != 0;
      if (v is String) return v.toLowerCase() == 'true' || v == '1';
      return false;
    }

    int parseInt(dynamic v) {
      if (v is int) return v;
      return int.tryParse(v?.toString() ?? '0') ?? 0;
    }

    return ChiTietBanGiaoRequest(
      id: json['id'] ?? '',
      idDieuDongCCDCVatTu: json['idDieuDongCCDCVatTu'] ?? '',
      idCCDCVatTu: json['idCCDCVatTu'] ?? '',
      soLuong: parseInt(json['soLuong']),
      idChiTietCCDCVatTu: json['idChiTietCCDCVatTu'] ?? '',
      soLuongXuat: parseInt(json['soLuongXuat']),
      ghiChu: json['ghiChu'] ?? '',
      nguoiTao: json['nguoiTao'] ?? '',
      nguoiCapNhat: json['nguoiCapNhat'] ?? '',
      isActive: parseBool(json['isActive']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'idDieuDongCCDCVatTu': idDieuDongCCDCVatTu,
      'idCCDCVatTu': idCCDCVatTu,
      'soLuong': soLuong,
      'idChiTietCCDCVatTu': idChiTietCCDCVatTu,
      'soLuongXuat': soLuongXuat,
      'ghiChu': ghiChu,
      'nguoiTao': nguoiTao,
      'nguoiCapNhat': nguoiCapNhat,
      'isActive': isActive,
    };
  }

  ChiTietBanGiaoRequest copyWith({
    String? id,
    String? idDieuDongCCDCVatTu,
    String? idCCDCVatTu,
    int? soLuong,
    String? idChiTietCCDCVatTu,
    int? soLuongXuat,
    String? ghiChu,
    String? nguoiTao,
    String? nguoiCapNhat,
    bool? isActive,
  }) {
    return ChiTietBanGiaoRequest(
      id: id ?? this.id,
      idDieuDongCCDCVatTu: idDieuDongCCDCVatTu ?? this.idDieuDongCCDCVatTu,
      idCCDCVatTu: idCCDCVatTu ?? this.idCCDCVatTu,
      soLuong: soLuong ?? this.soLuong,
      idChiTietCCDCVatTu: idChiTietCCDCVatTu ?? this.idChiTietCCDCVatTu,
      soLuongXuat: soLuongXuat ?? this.soLuongXuat,
      ghiChu: ghiChu ?? this.ghiChu,
      nguoiTao: nguoiTao ?? this.nguoiTao,
      nguoiCapNhat: nguoiCapNhat ?? this.nguoiCapNhat,
      isActive: isActive ?? this.isActive,
    );
  }
}
