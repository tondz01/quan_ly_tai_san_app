import 'package:quan_ly_tai_san_app/screen/report/model/inventory_minutes.dart';
import 'package:quan_ly_tai_san_app/screen/report/model/tai_san_co_dinh_dto.dart';

class DataConverter {
  // Convert từ TaiSanCoDinhDto sang InventoryMinutes
  static List<InventoryMinutes> convertTaiSanCoDinhToInventoryMinutes(
    List<TaiSanCoDinhDto> taiSanCoDinhList,
  ) {
    return taiSanCoDinhList.map((item) {
      return InventoryMinutes(
        tenTaiSan: item.tenTaiSan,
        donViTinh: 'Cái', // Default value
        nuocSanXuat: '', // Default value
        hienTrang: '1', // Default value
        ghiChu: item.ghiChu,
      );
    }).toList();
  }

  // Convert từ InventoryMinutes sang TaiSanCoDinhDto
  static List<TaiSanCoDinhDto> convertInventoryMinutesToTaiSanCoDinh(
    List<InventoryMinutes> inventoryMinutesList,
  ) {
    return inventoryMinutesList.map((item) {
      return TaiSanCoDinhDto(
        id: '', // Default value since InventoryMinutes doesn't have id
        tenTaiSan: item.tenTaiSan ?? '',
        soLuong: 1, // Default value
        nguyenGia: 0.0, // Default value
        giaTriKhauHaoBanDau: 0.0, // Default value
        idDonViHienThoi: '', // Default value
        ghiChu: item.ghiChu ?? '',
      );
    }).toList();
  }
}
