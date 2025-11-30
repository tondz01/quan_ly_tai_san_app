class InventoryMinutes {
  final String? tenTaiSan;
  final String donViTinh;
  final String? nuocSanXuat;
  final String? hienTrang;
  final String? ghiChu;

  InventoryMinutes({
    required this.tenTaiSan,
    required this.donViTinh,
    required this.nuocSanXuat,
    required this.hienTrang,
    required this.ghiChu,
  });

  factory InventoryMinutes.fromJson(Map<String, dynamic> json) {
    String parseString(dynamic v) => v?.toString() ?? '';

    return InventoryMinutes(
      tenTaiSan: parseString(json['tenTaiSan']),
      donViTinh: parseString(json['donViTinh']),
      nuocSanXuat: parseString(json['nuocSanXuat']),
      hienTrang: parseString(json['hienTrang']),
      ghiChu: parseString(json['ghiChu']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': tenTaiSan,
      'idDieuDongTaiSan': donViTinh,
      'soQuyetDinh': nuocSanXuat,
      'hienTrang': hienTrang,
      'ghiChu': ghiChu,
    };
  }

  factory InventoryMinutes.empty() {
    return InventoryMinutes(tenTaiSan: '', donViTinh: '', nuocSanXuat: '', hienTrang: '0', ghiChu: '');
  }
}