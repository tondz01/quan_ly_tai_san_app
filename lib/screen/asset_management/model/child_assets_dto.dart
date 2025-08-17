import 'dart:convert';

class ChildAssetDto {
  String? id;
  String? idTaiSan;
  String? ngayTao;
  String? ngayCapNhat;
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
    String? formatDateIfNotNull(dynamic value) {
      if (value == null) return null;
      if (value is String) return value;
      if (value is DateTime) return value.toIso8601String();
      return null;
    }
    
    return ChildAssetDto(
      id: json['id'] as String?,
      idTaiSan: json['idTaiSan'] as String?,
      ngayTao: formatDateIfNotNull(json['ngayTao']),
      ngayCapNhat: formatDateIfNotNull(json['ngayCapNhat']),
      nguoiTao: json['nguoiTao'] as String?,
      nguoiCapNhat: json['nguoiCapNhat'] as String?,
      isActive: _parseBool(json['isActive']),
    );
  }

  Map<String, dynamic> toJson() {
   

    return {
      'id': id,
      'idTaiSan': idTaiSan,
      'ngayTao': ngayTao,
      'ngayCapNhat': ngayCapNhat,
      'nguoiTao': nguoiTao,
      'nguoiCapNhat': nguoiCapNhat,
      'isActive': isActive,
    };
  }

  ChildAssetDto copyWith({
    String? id,
    String? idTaiSan,
    String? ngayTao,
    String? ngayCapNhat,
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
      ngayTao: DateTime.now().toIso8601String(),
      ngayCapNhat: DateTime.now().toIso8601String(),
      nguoiTao: '',
      nguoiCapNhat: '',
      isActive: true,
    );
  }
}
