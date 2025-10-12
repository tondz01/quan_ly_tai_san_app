import 'package:flutter/material.dart';
import 'package:quan_ly_tai_san_app/screen/asset_management/provider/asset_management_provider.dart';
import 'package:quan_ly_tai_san_app/screen/login/auth/account_helper.dart';
import 'package:table_base/widgets/table/models/column_definition.dart';
import 'package:table_base/widgets/table/models/table_model.dart';

class TableAssetManagementConfig {
  static List<ColumnDefinition> getColumns(AssetManagementProvider provider) {
    return [
      ColumnDefinition(
        config: TableColumnData.select(
          name: 'Mã tài sản',
          key: 'code_asset',
          width: 100,
          flex: 1,
          isFixed: false,
        ),
        builder: (item) {
          return TableCellData(widget: Text(item.soThe ?? ''));
        },
      ),
      ColumnDefinition(
        config: TableColumnData.select(
          name: 'Số thẻ',
          key: 'so_the',
          width: 100,
          flex: 1,
          isFixed: false,
        ),
        builder: (item) {
          return TableCellData(widget: Text(item.id ?? ''));
        },
      ),
      ColumnDefinition(
        config: TableColumnData.select(
          name: 'Tên tài sản',
          key: 'name_asset',
          width: 200,
          flex: 1,
          isFixed: false,
        ),
        builder: (item) {
          return TableCellData(widget: Text(item.tenTaiSan ?? ''));
        },
      ),
      ColumnDefinition(
        config: TableColumnData.select(
          name: 'Ngày vào sổ',
          key: 'book_entry_date',
          width: 120,
          flex: 1,
          isFixed: false,
        ),
        builder: (item) {
          return TableCellData(widget: Text(item.ngayVaoSo?.toString() ?? ''));
        },
      ),
      ColumnDefinition(
        config: TableColumnData.select(
          name: 'Vốn NS',
          key: 'von_ns',
          width: 100,
          flex: 1,
          isFixed: false,
        ),
        builder: (item) {
          return TableCellData(widget: Text(item.vonNS?.toString() ?? '0'));
        },
      ),
      ColumnDefinition(
        config: TableColumnData.select(
          name: 'Vốn vay',
          key: 'von_vay',
          width: 100,
          flex: 1,
          isFixed: false,
        ),
        builder: (item) {
          return TableCellData(widget: Text(item.vonVay?.toString() ?? '0'));
        },
      ),
      ColumnDefinition(
        config: TableColumnData.select(
          name: 'Vốn khác',
          key: 'von_khac',
          width: 100,
          flex: 1,
          isFixed: false,
        ),
        builder: (item) {
          return TableCellData(widget: Text(item.vonKhac?.toString() ?? '0'));
        },
      ),
      ColumnDefinition(
        config: TableColumnData.select(
          name: 'Ngày sử dụng',
          key: 'usage_start_date',
          width: 120,
          flex: 1,
          isFixed: false,
        ),
        builder: (item) {
          return TableCellData(widget: Text(item.ngaySuDung?.toString() ?? ''));
        },
      ),
      ColumnDefinition(
        config: TableColumnData.select(
          name: 'Đơn vị sử dụng',
          key: 'using_unit',
          width: 150,
          flex: 1,
          isFixed: false,
        ),
        builder: (item) {
          String donViSuDung =
              AccountHelper.instance
                  .getDepartmentById(item.idDonViHienThoi ?? '')
                  ?.tenPhongBan ??
              '';
          return TableCellData(widget: Text(donViSuDung));
        },
      ),
      ColumnDefinition(
        config: TableColumnData.select(
          name: 'Số lượng TS con',
          key: 'so_luong_ts_con',
          width: 150,
          flex: 1,
          isFixed: false,
        ),
        builder: (item) {
          int soLuongTsCon =
              provider.getListChildAssetsByIdAsset(item.id ?? '').length;
          return TableCellData(widget: Text(soLuongTsCon.toString()));
        },
      ),
      ColumnDefinition(
        config: TableColumnData.select(
          name: 'Nhóm tài sản',
          key: 'nhom_tai_san',
          width: 150,
          flex: 1,
          isFixed: false,
        ),
        builder: (item) {
          String tenNhomTaiSan =
              AccountHelper.instance
                  .getAssetGroupById(item.idNhomTaiSan ?? '')
                  ?.tenNhom ??
              '';
          return TableCellData(widget: Text(tenNhomTaiSan));
        },
      ),
      ColumnDefinition(
        config: TableColumnData.select(
          name: 'Loại tài sản',
          key: 'loai_tai_san',
          width: 150,
          flex: 1,
          isFixed: false,
        ),
        builder: (item) {
          if (item.idLoaiTaiSanCon == null) {
            return TableCellData(widget: Text(''));
          }
         
          return TableCellData(widget: Text(''));
        },
      ),
      ColumnDefinition(
        config: TableColumnData.select(
          name: 'Hiện trạng',
          key: 'hien_trang',
          width: 120,
          flex: 1,
          isFixed: false,
        ),
        builder: (item) {
          String hienTrang = provider.getHienTrang(item.hienTrang ?? 0).name;
          return TableCellData(widget: Text(hienTrang));
        },
      ),
      ColumnDefinition(
        config: TableColumnData.select(
          name: 'Số lượng',
          key: 'so_luong',
          width: 100,
          flex: 1,
          isFixed: false,
        ),
        builder: (item) {
          return TableCellData(widget: Text(item.soLuong?.toString() ?? '0'));
        },
      ),
      ColumnDefinition(
        config: TableColumnData.select(
          name: 'Đơn vị tính',
          key: 'don_vi_tinh',
          width: 120,
          flex: 1,
          isFixed: false,
        ),
        builder: (item) {
          String donViTinh =
              AccountHelper.instance
                  .getUnitById(item.donViTinh ?? '')
                  ?.tenDonVi ??
              '';
          return TableCellData(widget: Text(donViTinh));
        },
      ),
      ColumnDefinition(
        config: TableColumnData.select(
          name: 'Ký hiệu',
          key: 'ky_hieu',
          width: 100,
          flex: 1,
          isFixed: false,
        ),
        builder: (item) {
          return TableCellData(widget: Text(item.kyHieu ?? ''));
        },
      ),
      ColumnDefinition(
        config: TableColumnData.select(
          name: 'Số ký hiệu',
          key: 'so_ky_hieu',
          width: 120,
          flex: 1,
          isFixed: false,
        ),
        builder: (item) {
          return TableCellData(widget: Text(item.soKyHieu ?? ''));
        },
      ),
    ];
  }
}
