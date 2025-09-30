import 'dart:convert';

class UnitDto {
  final String? id;
  final String? tenDonVi;
  final String? note;

  UnitDto({
    this.id,
    this.tenDonVi,
    this.note,
  });

  factory UnitDto.fromJson(Map<String, dynamic> json) {
    return UnitDto(
      id: json['id']?.toString(),
      tenDonVi: json['tenDonVi'],
      note: json['note'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'tenDonVi': tenDonVi,
      'note': note,
    };
  }

  static List<UnitDto> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => UnitDto.fromJson(json)).toList();
  }

  static String encode(List<UnitDto> units) =>
      json.encode(units.map((u) => u.toJson()).toList());

  static List<UnitDto> decode(String units) =>
      (json.decode(units) as List<dynamic>)
          .map<UnitDto>((item) => UnitDto.fromJson(item))
          .toList();

  Map<String, dynamic> toExportJson() {
    return {
      'Mã đơn vị': id ?? '',
      'Tên đơn vị': tenDonVi ?? '',
      'Ghi chú': note ?? '',
    };
  }
}
