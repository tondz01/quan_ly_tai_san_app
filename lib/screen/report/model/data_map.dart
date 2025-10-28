class DataMap {
  String? id;
  String? soHieu1;
  String? soHieu2;
  String? ngayThang1;
  String? ngayThang2;
  String? donViTinh;
  String? soLuong;
  String? soLuong2;
  String? donGia;
  String? soTien;
  String? soTien2;
  String? lyDo;
  String? ghiChu;

  DataMap({
    this.id,
    this.soHieu1,
    this.soHieu2,
    this.ngayThang1,
    this.ngayThang2,
    this.donViTinh,
    this.soLuong,
    this.soLuong2,
    this.donGia,
    this.soTien,
    this.soTien2,
    this.lyDo,
    this.ghiChu,
  });

  factory DataMap.fromJson(Map<String, dynamic> json) {
    return DataMap(
      id: json['id'],
      soHieu1: json['soHieu1'],
      soHieu2: json['soHieu2'],
      ngayThang1: json['ngayThang1'],
      ngayThang2: json['ngayThang2'],
      donViTinh: json['donViTinh'],
      soLuong: json['soLuong'],
      soLuong2: json['soLuong2'],
      donGia: json['donGia'],
      soTien: json['soTien'],
      soTien2: json['soTien2'],
      lyDo: json['lyDo'],
      ghiChu: json['ghiChu'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'soHieu1': soHieu1,
      'soHieu2': soHieu2,
      'ngayThang1': ngayThang1,
      'ngayThang2': ngayThang2,
      'donViTinh': donViTinh,
      'soLuong': soLuong,
      'soLuong2': soLuong2,
      'donGia': donGia,
      'soTien': soTien,
      'soTien2': soTien2,
      'lyDo': lyDo,
      'ghiChu': ghiChu,
    };
  }
}
