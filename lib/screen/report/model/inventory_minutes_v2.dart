class InventoryMinutesV2 {
  final String? tenTaiSan;
  final String donViTinh;
  final String? nuocSanXuat;
  final String? hienTrang;
  final String? ghiChu;

  InventoryMinutesV2({
    required this.tenTaiSan,
    required this.donViTinh,
    required this.nuocSanXuat,
    required this.hienTrang,
    required this.ghiChu,
  });

  factory InventoryMinutesV2.fromJson(Map<String, dynamic> json) {
    String parseString(dynamic v) => v?.toString() ?? '';
    int parseInt(dynamic v) {
      if (v is int) return v;
      if (v is num) return v.toInt();
      return int.tryParse(v?.toString() ?? '0') ?? 0;
    }

    return InventoryMinutesV2(
      tenTaiSan: parseString(json['tenTaiSan']),
      donViTinh: parseString(json['donViTinh']),
      nuocSanXuat: parseString(json['nuocSanXuat']),
      hienTrang: parseString(json['hienTrang']),
      ghiChu: parseString(json['ghiChu']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'tenTaiSan': tenTaiSan,
      'donViTinh': donViTinh,
      'nuocSanXuat': nuocSanXuat,
      'hienTrang': hienTrang,
      'ghiChu': ghiChu,
    };
  }

  factory InventoryMinutesV2.empty() {
    return InventoryMinutesV2(tenTaiSan: '', donViTinh: '', nuocSanXuat: '', hienTrang: '', ghiChu: '');
  }
}