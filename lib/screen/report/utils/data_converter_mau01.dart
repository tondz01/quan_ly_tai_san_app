import 'package:quan_ly_tai_san_app/core/utils/utils.dart';
import 'package:quan_ly_tai_san_app/screen/asset_management/model/asset_management_dto.dart';
import 'package:quan_ly_tai_san_app/screen/report/model/ccdc_inventory_report.dart';
import 'package:quan_ly_tai_san_app/screen/report/model/data_map.dart';
import 'package:quan_ly_tai_san_app/screen/report/model/inventory_minutes.dart';
import 'package:quan_ly_tai_san_app/screen/tools_and_supplies/model/tools_and_supplies_dto.dart';

/// Converter để chuyển đổi AssetManagement, CCDC, InventoryMinutes sang DataMap
class DataConverterMau01 {
  /// Chuyển đổi AssetManagementDto sang DataMap
  static List<DataMap> convertAssetToDataMap(
    List<AssetManagementDto> assets,
  ) {
    return assets.map((asset) {
      return DataMap(
        id: asset.id,
        tenTaiSan: asset.tenTaiSan,
        soHieu: asset.soThe, // Số thẻ tài sản
        ngayThang: AppUtility.formatDateString(asset.ngayVaoSo), // Ngày vào sổ
        donViTinh: asset.donViTinh,
        soLuong: asset.soLuong,
        donGia: asset.nguyenGia, // Nguyên giá
        soTien: (asset.nguyenGia ?? 0) * (asset.soLuong ?? 1), // = đơn giá * số lượng
        lyDo: asset.lyDoTang, // Lý do tăng
        ghiChu: asset.ghiChu,
        type: null, // Có thể set DataMapType.INCREASE hoặc REDUCE nếu cần
      );
    }).toList();
  }

  /// Chuyển đổi ToolsAndSuppliesDto sang DataMap
  static List<DataMap> convertCCDCToDataMap(
    List<ToolsAndSuppliesDto> ccdcList,
  ) {
    return ccdcList.map((ccdc) {
      return DataMap(
        id: ccdc.id,
        tenTaiSan: ccdc.ten,
        soHieu: ccdc.soKyHieu, // Số ký hiệu
        ngayThang: ccdc.ngayNhap, // Ngày nhập
        donViTinh: ccdc.donViTinh,
        soLuong: ccdc.soLuong,
        donGia: ccdc.giaTri, // Giá trị
        soTien: ccdc.giaTri * ccdc.soLuong, // = giá trị * số lượng
        lyDo: '', // CCDC không có lý do tăng
        ghiChu: ccdc.ghiChu,
        type: null, // Có thể set DataMapType.INCREASE hoặc REDUCE nếu cần
      );
    }).toList();
  }

  /// Chuyển đổi cả 2 list và merge lại
  static List<DataMap> convertAllToDataMap({
    List<AssetManagementDto>? assets,
    List<ToolsAndSuppliesDto>? ccdcList,
  }) {
    final List<DataMap> result = [];

    // Convert assets nếu có
    if (assets != null && assets.isNotEmpty) {
      result.addAll(convertAssetToDataMap(assets));
    }

    // Convert CCDC nếu có
    if (ccdcList != null && ccdcList.isNotEmpty) {
      result.addAll(convertCCDCToDataMap(ccdcList));
    }

    return result;
  }

  /// Filter data theo loại (INCREASE/REDUCE)
  static List<DataMap> filterByType(
    List<DataMap> dataList,
    DataMapType type,
  ) {
    return dataList.where((data) => data.type == type).toList();
  }

  /// Group data theo tên tài sản
  static Map<String, List<DataMap>> groupByTenTaiSan(
    List<DataMap> dataList,
  ) {
    final Map<String, List<DataMap>> grouped = {};

    for (final data in dataList) {
      final key = data.tenTaiSan ?? 'Không xác định';
      if (!grouped.containsKey(key)) {
        grouped[key] = [];
      }
      grouped[key]!.add(data);
    }

    return grouped;
  }

  /// Chuyển đổi InventoryMinutes sang DataMap
  static List<DataMap> convertInventoryMinutesToDataMap(
    List<InventoryMinutes> inventoryList,
  ) {
    return inventoryList.map((item) {
      return DataMap(
        id: null, // InventoryMinutes không có id
        tenTaiSan: item.tenTaiSan,
        soHieu: null,
        ngayThang: null,
        donViTinh: item.donViTinh,
        soLuong: null,
        donGia: null,
        soTien: null,
        lyDo: null,
        ghiChu: item.ghiChu,
        type: null,
      );
    }).toList();
  }

  /// Chuyển đổi CCDCInventoryReport sang DataMap
  static List<DataMap> convertCCDCInventoryReportToDataMap(
    List<CCDCInventoryReport> ccdcReportList,
  ) {
    return ccdcReportList.map((item) {
      return DataMap(
        id: null, // CCDCInventoryReport không có id
        tenTaiSan: item.tenTaiSan,
        soHieu: null,
        ngayThang: null,
        donViTinh: item.donViTinh,
        soLuong: null,
        donGia: null,
        soTien: null,
        lyDo: null,
        ghiChu: item.ghiChu,
        type: null,
      );
    }).toList();
  }
}
