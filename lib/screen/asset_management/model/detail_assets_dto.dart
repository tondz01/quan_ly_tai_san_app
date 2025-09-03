import 'dart:convert';

class DetailAssetDto {
  String? id;
  String? idTaiSan;
  String? ngayVaoSo;
  String? ngaySuDung;
  String? soKyHieu;
  String? congSuat;
  int? soLuong;
  String? nuocSanXuat;
  int? namSanXuat;
  String? idDonVi;

  DetailAssetDto({
    this.id,
    this.idTaiSan,
    this.ngayVaoSo,
    this.ngaySuDung,
    this.soKyHieu,
    this.congSuat,
    this.soLuong,
    this.nuocSanXuat,
    this.namSanXuat,
    this.idDonVi,
  });

  factory DetailAssetDto.fromJson(Map<String, dynamic> json) {
    String? formatDateIfNotNull(dynamic value) {
      if (value == null) return null;
      if (value is String) return value;
      if (value is DateTime) return value.toIso8601String();
      return null;
    }

    return DetailAssetDto(
      id: json['id'] as String?,
      idTaiSan: json['idTaiSan'] as String?,
      ngayVaoSo: formatDateIfNotNull(json['ngayVaoSo']),
      ngaySuDung: formatDateIfNotNull(json['ngaySuDung']),
      soKyHieu: json['soKyHieu'] as String?,
      congSuat: json['congSuat'] as String?,
      soLuong: json['soLuong'] as int?,
      namSanXuat: json['namSanXuat'] as int?,
      nuocSanXuat: json['nuocSanXuat'] as String?,
      idDonVi: json['idDonVi'] as String?,
    );
  }


  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'idTaiSan': idTaiSan,
      'ngayVaoSo': ngayVaoSo,
      'ngaySuDung': ngaySuDung,
      'soKyHieu': soKyHieu,
      'congSuat': congSuat,
      'soLuong': soLuong,
      'namSanXuat': namSanXuat,
      'nuocSanXuat': nuocSanXuat,
      'idDonVi': idDonVi,
    };
  }

  DetailAssetDto copyWith({
    String? id,
    String? idTaiSan,
    String? ngayVaoSo,
    String? ngaySuDung,
    String? soKyHieu,
    String? congSuat,
    int? soLuong,
    String? nuocSanXuat,
    int? namSanXuat,
    String? idDonVi,
  }) {
    return DetailAssetDto(
      id: id ?? this.id,
      idTaiSan: idTaiSan ?? this.idTaiSan,
      ngayVaoSo: ngayVaoSo ?? this.ngayVaoSo,
      ngaySuDung: ngaySuDung ?? this.ngaySuDung,
      soKyHieu: soKyHieu ?? this.soKyHieu,
      congSuat: congSuat ?? this.congSuat,
      soLuong: soLuong ?? this.soLuong,
      namSanXuat: namSanXuat ?? this.namSanXuat,
      nuocSanXuat: nuocSanXuat ?? this.nuocSanXuat,
      idDonVi: idDonVi ?? this.idDonVi,
    );
  }

  static List<DetailAssetDto> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((e) => DetailAssetDto.fromJson(e)).toList();
  }

  static String encode(List<DetailAssetDto> items) =>
      json.encode(items.map((e) => e.toJson()).toList());

  static List<DetailAssetDto> decode(String source) =>
      (json.decode(source) as List<dynamic>)
          .map<DetailAssetDto>((e) => DetailAssetDto.fromJson(e))
          .toList();

  factory DetailAssetDto.empty() {
    return DetailAssetDto(
      id: '',
      idTaiSan: '',
      ngayVaoSo: '',
      ngaySuDung: '',
      soKyHieu: '',
      congSuat: '',
      soLuong: 0,
      namSanXuat: 0,
      nuocSanXuat: '',
      idDonVi: '',
    );
  }
}
