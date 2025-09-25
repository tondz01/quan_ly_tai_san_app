class TypeAsset {
  final String? id;
  final String? idLoaiTs;
  final String? tenLoai;

  TypeAsset({this.id, this.idLoaiTs, this.tenLoai});

  factory TypeAsset.fromJson(Map<String, dynamic> json) {
    return TypeAsset(
      id: json['id'],
      idLoaiTs: json['idLoaiTs'],
      tenLoai: json['tenLoai'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'idLoaiTs': idLoaiTs,
      'tenLoai': tenLoai,
    };
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
      'Mã loại tài sản': _nullIfEmpty(id),
      'Mã loại tài sản cha': _nullIfEmpty(idLoaiTs),
      'Tên loại tài sản con': _nullIfEmpty(tenLoai),
    };
  }
}
