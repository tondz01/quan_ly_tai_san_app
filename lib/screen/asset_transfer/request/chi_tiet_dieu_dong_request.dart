class ChiTietDieuDongRequest {
  final String idDieuDongTaiSan;
  final String idTaiSan;
  final int soLuong;
  final String ghiChu;
  final String ngayTao;
  final String ngayCapNhat;
  final String nguoiTao;
  final String nguoiCapNhat;
  final bool isActive;

  ChiTietDieuDongRequest({
    required this.idDieuDongTaiSan,
    required this.idTaiSan,
    required this.soLuong,
    required this.ghiChu,
    required this.ngayTao,
    required this.ngayCapNhat,
    required this.nguoiTao,
    required this.nguoiCapNhat,
    required this.isActive,
  });

  factory ChiTietDieuDongRequest.fromJson(Map<String, dynamic> json) {
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

    return ChiTietDieuDongRequest(
      idDieuDongTaiSan: json['idDieuDongTaiSan'] ?? '',
      idTaiSan: json['idTaiSan'] ?? '',
      soLuong: parseInt(json['soLuong']),
      ghiChu: json['ghiChu'] ?? '',
      ngayTao: json['ngayTao'] ?? '',
      ngayCapNhat: json['ngayCapNhat'] ?? '',
      nguoiTao: json['nguoiTao'] ?? '',
      nguoiCapNhat: json['nguoiCapNhat'] ?? '',
      isActive: parseBool(json['isActive']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idDieuDongTaiSan': idDieuDongTaiSan,
      'idTaiSan': idTaiSan,
      'soLuong': soLuong,
      'ghiChu': ghiChu,
      'ngayTao': ngayTao,
      'ngayCapNhat': ngayCapNhat,
      'nguoiTao': nguoiTao,
      'nguoiCapNhat': nguoiCapNhat,
      'isActive': isActive,
    };
  }

  ChiTietDieuDongRequest copyWith({
    String? idDieuDongTaiSan,
    String? idTaiSan,
    int? soLuong,
    String? ghiChu,
    String? ngayTao,
    String? ngayCapNhat,
    String? nguoiTao,
    String? nguoiCapNhat,
    bool? isActive,
  }) {
    return ChiTietDieuDongRequest(
      idDieuDongTaiSan: idDieuDongTaiSan ?? this.idDieuDongTaiSan,
      idTaiSan: idTaiSan ?? this.idTaiSan,
      soLuong: soLuong ?? this.soLuong,
      ghiChu: ghiChu ?? this.ghiChu,
      ngayTao: ngayTao ?? this.ngayTao,
      ngayCapNhat: ngayCapNhat ?? this.ngayCapNhat,
      nguoiTao: nguoiTao ?? this.nguoiTao,
      nguoiCapNhat: nguoiCapNhat ?? this.nguoiCapNhat,
      isActive: isActive ?? this.isActive,
    );
  }
}
