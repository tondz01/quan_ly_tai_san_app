class InventoryMinutes {
  final String? id;
  final String? tenTaiSan;
  final String donViTinh;
  final String? nuocSanXuat;
  final String? phuongThucKiemKe;
  final int? soLuongKiemKeThucTe;
  final String? hienTrang;
  final String? ghiChu;
  final String? loai; // "TaiSan" hoặc "CCDCVatTu"

  InventoryMinutes({
    this.id,
    required this.tenTaiSan,
    required this.donViTinh,
    required this.nuocSanXuat,
    this.phuongThucKiemKe,
    this.soLuongKiemKeThucTe,
    required this.hienTrang,
    required this.ghiChu,
    this.loai,
  });

  factory InventoryMinutes.fromJson(Map<String, dynamic> json) {
    String parseString(dynamic v) => v?.toString() ?? '';
    int? parseInt(dynamic v) => v != null ? int.tryParse(v.toString()) : null;

    return InventoryMinutes(
      id: parseString(json['id']),
      tenTaiSan: parseString(json['tenTaiSan']),
      donViTinh: parseString(json['donViTinh']),
      nuocSanXuat: parseString(json['nuocSanXuat']),
      phuongThucKiemKe: parseString(json['phuongThucKiemKe']),
      soLuongKiemKeThucTe: parseInt(json['soLuongKiemKeThucTe']),
      hienTrang: parseString(json['hienTrang']),
      ghiChu: parseString(json['ghiChu']),
      loai: parseString(json['loai']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'tenTaiSan': tenTaiSan,
      'donViTinh': donViTinh,
      'nuocSanXuat': nuocSanXuat,
      'phuongThucKiemKe': phuongThucKiemKe,
      'soLuongKiemKeThucTe': soLuongKiemKeThucTe,
      'hienTrang': hienTrang,
      'ghiChu': ghiChu,
      'loai': loai,
    };
  }

  factory InventoryMinutes.empty() {
    return InventoryMinutes(
      id: '',
      tenTaiSan: '',
      donViTinh: '',
      nuocSanXuat: '',
      phuongThucKiemKe: '',
      soLuongKiemKeThucTe: 0,
      hienTrang: '',
      ghiChu: '',
      loai: '',
    );
  }

  /// Getter để hiển thị loại tài sản
  String get loaiDisplay {
    if (loai == 'TaiSan') return 'Tài sản';
    if (loai == 'CCDCVatTu') return 'Công cụ dụng cụ vật tư';
    return loai ?? '';
  }
}