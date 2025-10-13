import 'package:flutter/material.dart';
import 'package:table_base/widgets/table/models/column_definition.dart';
import 'package:table_base/widgets/table/models/table_model.dart';

class TableAssetCategoryConfig {
  static List<ColumnDefinition> getColumns() {
    return [
      ColumnDefinition(
        config: TableColumnData.select(
          name: 'Mã mô hình',
          key: 'code_asset_category',
          width: 120,
          flex: 1,
          isFixed: false,
        ),
        builder: (item) {
          return TableCellData(widget: Text(item.id ?? ''));
        },
      ),
      ColumnDefinition(
        config: TableColumnData.select(
          name: 'Tên mô hình tài sản',
          key: 'name_asset_category',
          width: 200,
          flex: 2,
          isFixed: false,
        ),
        builder: (item) {
          return TableCellData(widget: Text(item.tenMoHinh ?? ''));
        },
      ),
      ColumnDefinition(
        config: TableColumnData.select(
          name: 'Phương pháp khấu hao',
          key: 'depreciation_method',
          width: 150,
          flex: 1,
          isFixed: false,
        ),
        builder: (item) {
          final method = item.phuongPhapKhauHao == 1 ? 'Đường thẳng' : 'Khác';
          return TableCellData(widget: Text(method));
        },
      ),
      ColumnDefinition(
        config: TableColumnData.select(
          name: 'Kỳ khấu hao',
          key: 'depreciation_period',
          width: 100,
          flex: 1,
          isFixed: false,
        ),
        builder: (item) {
          return TableCellData(widget: Text(item.kyKhauHao?.toString() ?? ''));
        },
      ),
      ColumnDefinition(
        config: TableColumnData.select(
          name: 'Loại kỳ khấu hao',
          key: 'depreciation_period_type',
          width: 120,
          flex: 1,
          isFixed: false,
        ),
        builder: (item) {
          String periodType = '';
          if (item.loaiKyKhauHao == '1') {
            periodType = 'Tháng';
          } else if (item.loaiKyKhauHao == '2') {
            periodType = 'Năm';
          } else {
            periodType = item.loaiKyKhauHao ?? '';
          }
          return TableCellData(widget: Text(periodType));
        },
      ),
      ColumnDefinition(
        config: TableColumnData.select(
          name: 'Tài khoản tài sản',
          key: 'asset_account',
          width: 120,
          flex: 1,
          isFixed: false,
        ),
        builder: (item) {
          return TableCellData(widget: Text(item.taiKhoanTaiSan ?? ''));
        },
      ),
      ColumnDefinition(
        config: TableColumnData.select(
          name: 'Tài khoản khấu hao',
          key: 'depreciation_account',
          width: 120,
          flex: 1,
          isFixed: false,
        ),
        builder: (item) {
          return TableCellData(widget: Text(item.taiKhoanKhauHao ?? ''));
        },
      ),
      ColumnDefinition(
        config: TableColumnData.select(
          name: 'Tài khoản chi phí',
          key: 'expense_account',
          width: 120,
          flex: 1,
          isFixed: false,
        ),
        builder: (item) {
          return TableCellData(widget: Text(item.taiKhoanChiPhi ?? ''));
        },
      ),
    ];
  }
}
