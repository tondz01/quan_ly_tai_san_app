import 'dart:convert';

class OwnershipUnitDetailDto {
  String id;
  String idCCDCVT;
  String idDonViSoHuu;
  int soLuong;
  DateTime thoiGianBanGiao;
  DateTime ngayTao;
  String nguoiTao;

  OwnershipUnitDetailDto({
    required this.id,
    required this.idCCDCVT,
    required this.idDonViSoHuu,
    required this.soLuong,
    required this.thoiGianBanGiao,
    required this.ngayTao,
    required this.nguoiTao,
  });

  static String _formatDateTime(DateTime dateTime) {
    // Format: YYYY-MM-DD HH:mm:ss
    final y = dateTime.year.toString().padLeft(4, '0');
    final m = dateTime.month.toString().padLeft(2, '0');
    final d = dateTime.day.toString().padLeft(2, '0');
    final hh = dateTime.hour.toString().padLeft(2, '0');
    final mm = dateTime.minute.toString().padLeft(2, '0');
    final ss = dateTime.second.toString().padLeft(2, '0');
    return "$y-$m-$d $hh:$mm:$ss";
  }

  factory OwnershipUnitDetailDto.fromJson(Map<String, dynamic> json) {
    return OwnershipUnitDetailDto(
      id: json['id']?.toString() ?? '',
      idCCDCVT: json['idCCDCVT']?.toString() ?? '',
      idDonViSoHuu: json['idDonViSoHuu']?.toString() ?? '',
      soLuong:
          json['soLuong'] is int
              ? (json['soLuong'] as int)
              : int.tryParse(json['soLuong']?.toString() ?? '0') ?? 0,
      thoiGianBanGiao:
          json['thoiGianBanGiao'] != null
              ? DateTime.parse(json['thoiGianBanGiao'].toString())
              : DateTime.now(),
      ngayTao:
          json['ngayTao'] != null
              ? DateTime.parse(json['ngayTao'].toString())
              : DateTime.now(),
      nguoiTao: json['nguoiTao']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'idCCDCVT': idCCDCVT,
      'idDonViSoHuu': idDonViSoHuu,
      'soLuong': soLuong,
      'thoiGianBanGiao': _formatDateTime(thoiGianBanGiao),
      'ngayTao': _formatDateTime(ngayTao),
      'nguoiTao': nguoiTao,
    };
  }

  factory OwnershipUnitDetailDto.empty() {
    return OwnershipUnitDetailDto(
      id: '',
      idCCDCVT: '',
      idDonViSoHuu: '',
      soLuong: 0,
      thoiGianBanGiao: DateTime.now(),
      ngayTao: DateTime.now(),
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
    String? idDonViSoHuu,
    int? soLuong,
    DateTime? thoiGianBanGiao,
    DateTime? ngayTao,
    String? nguoiTao,
  }) {
    return OwnershipUnitDetailDto(
      id: id ?? this.id,
      idCCDCVT: idCCDCVT ?? this.idCCDCVT,
      idDonViSoHuu: idDonViSoHuu ?? this.idDonViSoHuu,
      soLuong: soLuong ?? this.soLuong,
      thoiGianBanGiao: thoiGianBanGiao ?? this.thoiGianBanGiao,
      ngayTao: ngayTao ?? this.ngayTao,
      nguoiTao: nguoiTao ?? this.nguoiTao,
    );
  }
}
