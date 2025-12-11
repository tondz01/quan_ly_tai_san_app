import 'package:quan_ly_tai_san_app/screen/report/model/inventory_minutes.dart';
import 'package:quan_ly_tai_san_app/screen/report/model/tai_san_co_dinh_dto.dart';

class DataConverter {
  // Convert từ TaiSanCoDinhDto sang InventoryMinutes
  static List<InventoryMinutes> convertTaiSanCoDinhToInventoryMinutes(
    List<TaiSanCoDinhDto> taiSanCoDinhList,
  ) {
    return taiSanCoDinhList.map((item) {
      return InventoryMinutes(
        id: item.idTaiSan,
        tenTaiSan: item.tenTaiSan,
        donViTinh: item.donViTinh,
        nuocSanXuat: '',
        phuongThucKiemKe: '',
        soLuongKiemKeThucTe: item.soLuongKiemKe,
        hienTrang: item.hienTrang,
        ghiChu: item.ghiChu,
        loai: 'TaiSan',
      );
    }).toList();
  }

  // Convert từ InventoryMinutes sang TaiSanCoDinhDto
  static List<TaiSanCoDinhDto> convertInventoryMinutesToTaiSanCoDinh(
    List<InventoryMinutes> inventoryMinutesList,
  ) {
    return inventoryMinutesList.map((item) {
      return TaiSanCoDinhDto(
        idTaiSan: item.id ?? '',
        tenTaiSan: item.tenTaiSan ?? '',
        maSo: '',
        noiSuDung: '',
        idDonViHienThoi: '',
        soLuongSoSach: item.soLuongKiemKeThucTe ?? 0,
        nguyenGiaSoSach: 0.0,
        giaTriConLaiSoSach: 0.0,
        soLuongKiemKe: item.soLuongKiemKeThucTe ?? 0,
        nguyenGiaKiemKe: 0.0,
        giaTriConLaiKiemKe: 0.0,
        chenhLechSoLuong: 0,
        chenhLechNguyenGia: 0.0,
        chenhLechGiaTriConLai: 0.0,
        ghiChu: item.ghiChu ?? '',
        donViTinh: item.donViTinh,
        hienTrang: item.hienTrang ?? '',
      );
    }).toList();
  }
}
