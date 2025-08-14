import 'dart:convert';

class ChildAssetDto {
  String? id;
  String? idTaiSan;
  DateTime? ngayTao;
  DateTime? ngayCapNhat;
  String? nguoiTao;
  String? nguoiCapNhat;
  bool? isActive;

  ChildAssetDto({
    this.id,
    this.idTaiSan,
    this.ngayTao,
    this.ngayCapNhat,
    this.nguoiTao,
    this.nguoiCapNhat,
    this.isActive,
  });

  static DateTime? _parseDateYmd(dynamic v) {
    if (v == null) return null;
    if (v is DateTime) return v;
    if (v is String && v.isNotEmpty) {
      // Expect format yyyy-MM-dd
      try {
        return DateTime.parse(v);
      } catch (_) {
        return null;
      }
    }
    if (v is int) {
      // Accept epoch ms as fallback
      return DateTime.fromMillisecondsSinceEpoch(v);
    }
    return null;
  }

  static bool? _parseBool(dynamic v) {
    if (v == null) return null;
    if (v is bool) return v;
    if (v is String) {
      final s = v.toLowerCase().trim();
      if (s == 'true' || s == '1') return true;
      if (s == 'false' || s == '0') return false;
    }
    if (v is num) return v != 0;
    return null;
  }

  factory ChildAssetDto.fromJson(Map<String, dynamic> json) {
    return ChildAssetDto(
      id: json['id'] as String?,
      idTaiSan: json['idTaiSan'] as String?,
      ngayTao: _parseDateYmd(json['ngayTao']),
      ngayCapNhat: _parseDateYmd(json['ngayCapNhat']),
      nguoiTao: json['nguoiTao'] as String?,
      nguoiCapNhat: json['nguoiCapNhat'] as String?,
      isActive: _parseBool(json['isActive']),
    );
  }

  Map<String, dynamic> toJson() {
    String? _fmt(DateTime? d) =>
        d == null
            ? null
            : '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

    return {
      'id': id,
      'idTaiSan': idTaiSan,
      'ngayTao': _fmt(ngayTao),
      'ngayCapNhat': _fmt(ngayCapNhat),
      'nguoiTao': nguoiTao,
      'nguoiCapNhat': nguoiCapNhat,
      'isActive': isActive,
    };
  }

  ChildAssetDto copyWith({
    String? id,
    String? idTaiSan,
    DateTime? ngayTao,
    DateTime? ngayCapNhat,
    String? nguoiTao,
    String? nguoiCapNhat,
    bool? isActive,
  }) {
    return ChildAssetDto(
      id: id ?? this.id,
      idTaiSan: idTaiSan ?? this.idTaiSan,
      ngayTao: ngayTao ?? this.ngayTao,
      ngayCapNhat: ngayCapNhat ?? this.ngayCapNhat,
      nguoiTao: nguoiTao ?? this.nguoiTao,
      nguoiCapNhat: nguoiCapNhat ?? this.nguoiCapNhat,
      isActive: isActive ?? this.isActive,
    );
  }

  static List<ChildAssetDto> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((e) => ChildAssetDto.fromJson(e)).toList();
  }

  static String encode(List<ChildAssetDto> items) =>
      json.encode(items.map((e) => e.toJson()).toList());

  static List<ChildAssetDto> decode(String source) =>
      (json.decode(source) as List<dynamic>)
          .map<ChildAssetDto>((e) => ChildAssetDto.fromJson(e))
          .toList();

  factory ChildAssetDto.empty() {
    return ChildAssetDto(
      id: '',
      idTaiSan: '',
      ngayTao: DateTime.now(),
      ngayCapNhat: DateTime.now(),
      nguoiTao: '',
      nguoiCapNhat: '',
      isActive: true,
    );
  }
}
