class CCDCInventoryReport {
  final String tenTaiSan;
  final String donViTinh;
  final String nuocSanXuat;
  final String ghiChu;

  CCDCInventoryReport({
    required this.tenTaiSan,
    required this.donViTinh,
    required this.nuocSanXuat,
    required this.ghiChu,
  });

  factory CCDCInventoryReport.fromJson(Map<String, dynamic> json) {
    String parseString(dynamic v) => v?.toString() ?? '';

    return CCDCInventoryReport(
      tenTaiSan: parseString(json['tenTaiSan']),
      donViTinh: parseString(json['donViTinh']),
      nuocSanXuat: parseString(json['nuocSanXuat']),
      ghiChu: parseString(json['ghiChu']),
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': tenTaiSan, 'idDieuDongTaiSan': donViTinh, 'soQuyetDinh': nuocSanXuat, 'ghiChu': ghiChu};
  }

  factory CCDCInventoryReport.empty() {
    return CCDCInventoryReport(tenTaiSan: '', donViTinh: '', nuocSanXuat: '', ghiChu: '');
  }
}
