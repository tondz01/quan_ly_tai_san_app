// ignore_for_file: constant_identifier_names

enum DataMapType {
  INCREASE,
  REDUCE,
}

class DataMap {
  String? id;
  String? tenTaiSan;
  String? soHieu;
  String? ngayThang;
  String? donViTinh;
  int? soLuong;
  double? donGia;
  double? soTien;
  String? lyDo;
  String? ghiChu;
  DataMapType? type;

  DataMap({
    this.id,
    this.tenTaiSan,
    this.soHieu,
    this.ngayThang,
    this.donViTinh,
    this.soLuong,
    this.donGia,
    this.soTien,
    this.lyDo,
    this.ghiChu,
    this.type,
  });

  factory DataMap.fromJson(Map<String, dynamic> json) {
    return DataMap(
      id: json['id'],
      tenTaiSan: json['tenTaiSan'],
      soHieu: json['soHieu1'],
      ngayThang: json['ngayThang1'],
      donViTinh: json['donViTinh'],
      soLuong: json['soLuong'],
      donGia: json['donGia'],
      soTien: json['soTien'],
      lyDo: json['lyDo'],
      ghiChu: json['ghiChu'],
      type: json['type'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'tenTaiSan': tenTaiSan,
      'soHieu1': soHieu,
      'ngayThang1': ngayThang,
      'donViTinh': donViTinh,
      'soLuong': soLuong,
      'donGia': donGia,
      'soTien': soTien,
      'lyDo': lyDo,
      'ghiChu': ghiChu,
      'type': type?.index,
    };
  }
}
