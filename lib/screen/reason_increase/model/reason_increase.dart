class ReasonIncrease {
  final String? id;
  final String? ten;
  final int? tangGiam;

  ReasonIncrease({this.id, this.ten, this.tangGiam});

  factory ReasonIncrease.fromJson(Map<String, dynamic> json) {
    return ReasonIncrease(
      id: json['id']?.toString(),
      ten: json['ten']?.toString(),
      tangGiam: json['tangGiam']?.toInt(),
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'ten': ten, 'tangGiam': tangGiam};
  }

  dynamic _nullIfEmpty(dynamic value) {
    if (value == null) {
      return "";
    }
    if (value is String) {
      return value.trim().isEmpty ? "" : value;
    }
    return value;
  }

  Map<String, dynamic> toExportJson() {
    return {
      'Mã lý do tăng': _nullIfEmpty(id),
      'Tên lý do tăng': _nullIfEmpty(ten),
      'Tăng giảm': _nullIfEmpty(tangGiam?.toString()),
    };
  }
}
