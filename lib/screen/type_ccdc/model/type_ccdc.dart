class TypeCcdc {
  final String? id;
  final String? idLoaiCCDC;
  final String? tenLoai;

  TypeCcdc({this.id, this.idLoaiCCDC, this.tenLoai});

  factory TypeCcdc.fromJson(Map<String, dynamic> json) {
    return TypeCcdc(
      id: json['id'],
      idLoaiCCDC: json['idLoaiCCDC'],
      tenLoai: json['tenLoai'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'idLoaiCCDC': idLoaiCCDC, 'tenLoai': tenLoai};
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
      'Mã loại CCDC': _nullIfEmpty(id),
      'Mã loại CCDC cha': _nullIfEmpty(idLoaiCCDC),
      'Tên loại CCDC': _nullIfEmpty(tenLoai),
    };
  }
}
