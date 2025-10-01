class InventoryMinutes {
  final String? tenTaiSan;
  final String donViTinh;
  final String? nuocSanXuat;
  final int? hienTrang;
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
    int parseInt(dynamic v) {
      if (v is int) return v;
      if (v is num) return v.toInt();
      return int.tryParse(v?.toString() ?? '0') ?? 0;
    }

    return InventoryMinutes(
      tenTaiSan: parseString(json['tenTaiSan']),
      donViTinh: parseString(json['donViTinh']),
      nuocSanXuat: parseString(json['nuocSanXuat']),
      hienTrang: parseInt(json['hienTrang']),
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
    return InventoryMinutes(tenTaiSan: '', donViTinh: '', nuocSanXuat: '', hienTrang: 0, ghiChu: '');
  }
}