import 'dart:convert';

import 'package:quan_ly_tai_san_app/core/utils/utils.dart';

class OwnershipUnitDetailDto {
  String id;
  String idCCDCVT;
  String idTsCon;
  String idDonViSoHuu;
  int soLuong;
  String thoiGianBanGiao;
  String ngayTao;
  String nguoiTao;

  OwnershipUnitDetailDto({
    required this.id,
    required this.idCCDCVT,
    required this.idTsCon,
    required this.idDonViSoHuu,
    required this.soLuong,
    required this.thoiGianBanGiao,
    required this.ngayTao,
    required this.nguoiTao,
  });

  factory OwnershipUnitDetailDto.fromJson(Map<String, dynamic> json) {
    return OwnershipUnitDetailDto(
      id: json['id']?.toString() ?? '',
      idCCDCVT: json['idCCDCVT']?.toString() ?? '',
      idTsCon: json['idTsCon']?.toString() ?? '',
      idDonViSoHuu: json['idDonViSoHuu']?.toString() ?? '',
      soLuong:
          json['soLuong'] is int
              ? (json['soLuong'] as int)
              : int.tryParse(json['soLuong']?.toString() ?? '0') ?? 0,
      thoiGianBanGiao: AppUtility.formatFromISOString(
        json['thoiGianBanGiao']?.toString() ?? '',
      ),
      ngayTao: AppUtility.formatFromISOString(
        json['ngayTao']?.toString() ?? '',
      ),
      nguoiTao: json['nguoiTao']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'idCCDCVT': idCCDCVT,
      'idTsCon': idTsCon,
      'idDonViSoHuu': idDonViSoHuu,
      'soLuong': soLuong,
      'thoiGianBanGiao': thoiGianBanGiao,
      'ngayTao': ngayTao,
      'nguoiTao': nguoiTao,
    };
  }

  factory OwnershipUnitDetailDto.empty() {
    return OwnershipUnitDetailDto(
      id: '',
      idCCDCVT: '',
      idTsCon: '',
      idDonViSoHuu: '',
      soLuong: 0,
      thoiGianBanGiao: '',
      ngayTao: '',
      nguoiTao: '',
    );
  }

  static List<OwnershipUnitDetailDto> fromJsonList(List<dynamic> jsonList) {
    return jsonList
        .map(
          (json) =>
              OwnershipUnitDetailDto.fromJson(json as Map<String, dynamic>),
        )
        .toList();
  }

  static String encode(List<OwnershipUnitDetailDto> items) =>
      json.encode(items.map((e) => e.toJson()).toList());

  static List<OwnershipUnitDetailDto> decode(String items) =>
      (json.decode(items) as List<dynamic>)
          .map<OwnershipUnitDetailDto>(
            (item) => OwnershipUnitDetailDto.fromJson(item),
          )
          .toList();

  @override
  String toString() {
    return idCCDCVT;
  }

  OwnershipUnitDetailDto copyWith({
    String? id,
    String? idCCDCVT,
    String? idTsCon,
    String? idDonViSoHuu,
    int? soLuong,
    String? thoiGianBanGiao,
    String? ngayTao,
    String? nguoiTao,
  }) {
    return OwnershipUnitDetailDto(
      id: id ?? this.id,
      idCCDCVT: idCCDCVT ?? this.idCCDCVT,
      idTsCon: idTsCon ?? this.idTsCon,
      idDonViSoHuu: idDonViSoHuu ?? this.idDonViSoHuu,
      soLuong: soLuong ?? this.soLuong,
      thoiGianBanGiao: thoiGianBanGiao ?? this.thoiGianBanGiao,
      ngayTao: ngayTao ?? this.ngayTao,
      nguoiTao: nguoiTao ?? this.nguoiTao,
    );
  }
}
