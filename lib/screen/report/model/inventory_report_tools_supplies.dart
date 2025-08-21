import 'package:quan_ly_tai_san_app/screen/report/model/ccdc_inventory_report.dart';

class InventoryReportToolsSupplies {
  final String tenTaiSan;
  final String donViTinh;
  final String nuocSanXuat;
  final CCDCInventoryReport ccdcInventoryReport;
  final String ghiChu;

  InventoryReportToolsSupplies({
    required this.tenTaiSan,
    required this.donViTinh,
    required this.nuocSanXuat,
    required this.ccdcInventoryReport,
    required this.ghiChu,
  });

  factory InventoryReportToolsSupplies.fromJson(Map<String, dynamic> json) {
    String parseString(dynamic v) => v?.toString() ?? '';
    return InventoryReportToolsSupplies(
      tenTaiSan: parseString(json['tenTaiSan']),
      donViTinh: parseString(json['donViTinh']),
      nuocSanXuat: parseString(json['nuocSanXuat']),
      ccdcInventoryReport: CCDCInventoryReport.fromJson(json['ccdcInventoryReport']),
      ghiChu: parseString(json['ghiChu']),
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': tenTaiSan, 'idDieuDongTaiSan': donViTinh, 'soQuyetDinh': nuocSanXuat, 'ghiChu': ghiChu};
  }

  factory InventoryReportToolsSupplies.empty() {
    return InventoryReportToolsSupplies(
      tenTaiSan: '',
      donViTinh: '',
      nuocSanXuat: '',
      ccdcInventoryReport: CCDCInventoryReport.empty(),
      ghiChu: '',
    );
  }
}