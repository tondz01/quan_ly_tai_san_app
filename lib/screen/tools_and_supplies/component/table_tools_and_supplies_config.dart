import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_base/widgets/table/models/column_definition.dart';
import 'package:table_base/widgets/table/models/table_model.dart';

class TableToolsAndSuppliesConfig {
  static String _fmtDate(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return '';
    try {
      final date = DateTime.tryParse(dateStr);
      if (date == null) return dateStr;
      final dd = date.day.toString().padLeft(2, '0');
      final mm = date.month.toString().padLeft(2, '0');
      final yyyy = date.year.toString();
      return '$dd/$mm/$yyyy';
    } catch (e) {
      return dateStr;
    }
  }

  static String _fmtNum(double? value) {
    if (value == null) return '';
    try {
      final NumberFormat _vnNumber = NumberFormat('#,##0', 'vi_VN');
      return _vnNumber.format(value);
    } catch (e) {
      return value.toString();
    }
  }

  static List<ColumnDefinition> getColumns() {
    return [
      ColumnDefinition(
        config: TableColumnData.select(
          name: 'Mã CCDC',
          key: 'id',
          width: 120,
          flex: 1,
        ),
        builder: (item) {
          return TableCellData(widget: Text(item.id));
        },
      ),
      ColumnDefinition(
        config: TableColumnData.select(
          name: 'Tên CCDC',
          key: 'ten',
          width: 200,
          flex: 1,
        ),
        builder: (item) {
          return TableCellData(widget: Text(item.ten));
        },
      ),
      ColumnDefinition(
        config: TableColumnData.select(
          name: 'Đơn vị nhập',
          key: 'tenDonVi',
          width: 150,
          flex: 1,
        ),
        builder: (item) {
          return TableCellData(widget: Text(item.tenDonVi));
        },
      ),
      ColumnDefinition(
        config: TableColumnData.select(
          name: 'Nhóm CCDC',
          key: 'tenNhomCCDC',
          width: 150,
          flex: 1,
        ),
        builder: (item) {
          return TableCellData(widget: Text(item.tenNhomCCDC));
        },
      ),
      ColumnDefinition(
        config: TableColumnData.select(
          name: 'Ngày nhập',
          key: 'ngayNhap',
          width: 120,
          flex: 1,
        ),
        builder: (item) {
          return TableCellData(widget: Text(_fmtDate(item.ngayNhap)));
        },
      ),
      ColumnDefinition(
        config: TableColumnData.select(
          name: 'Đơn vị tính',
          key: 'donViTinh',
          width: 120,
          flex: 1,
        ),
        builder: (item) {
          return TableCellData(widget: Text(item.donViTinh));
        },
      ),
      ColumnDefinition(
        config: TableColumnData.select(
          name: 'Số lượng',
          key: 'soLuong',
          width: 100,
          flex: 1,
        ),
        builder: (item) {
          return TableCellData(widget: Text(item.soLuong.toString()));
        },
      ),
      ColumnDefinition(
        config: TableColumnData.select(
          name: 'Giá trị',
          key: 'giaTri',
          width: 120,
          flex: 1,
        ),
        builder: (item) {
          return TableCellData(widget: Text(_fmtNum(item.giaTri)));
        },
      ),
      ColumnDefinition(
        config: TableColumnData.select(
          name: 'Ký hiệu',
          key: 'kyHieu',
          width: 120,
          flex: 1,
        ),
        builder: (item) {
          return TableCellData(widget: Text(item.kyHieu));
        },
      ),
      ColumnDefinition(
        config: TableColumnData.select(
          name: 'Công suất',
          key: 'congSuat',
          width: 120,
          flex: 1,
        ),
        builder: (item) {
          return TableCellData(widget: Text(item.congSuat));
        },
      ),
      ColumnDefinition(
        config: TableColumnData.select(
          name: 'Nước sản xuất',
          key: 'nuocSanXuat',
          width: 120,
          flex: 1,
        ),
        builder: (item) {
          return TableCellData(widget: Text(item.nuocSanXuat));
        },
      ),
      ColumnDefinition(
        config: TableColumnData.select(
          name: 'Năm sản xuất',
          key: 'namSanXuat',
          width: 120,
          flex: 1,
        ),
        builder: (item) {
          return TableCellData(widget: Text(item.namSanXuat.toString()));
        },
      ),
      ColumnDefinition(
        config: TableColumnData.select(
          name: 'Số ký hiệu',
          key: 'soKyHieu',
          width: 120,
          flex: 1,
        ),
        builder: (item) {
          return TableCellData(widget: Text(item.soKyHieu));
        },
      ),
      ColumnDefinition(
        config: TableColumnData.select(
          name: 'Ghi chú',
          key: 'ghiChu',
          width: 200,
          flex: 1,
        ),
        builder: (item) {
          return TableCellData(widget: Text(item.ghiChu));
        },
      ),
      ColumnDefinition(
        config: TableColumnData.select(
          name: 'Người tạo',
          key: 'nguoiTao',
          width: 120,
          flex: 1,
        ),
        builder: (item) {
          return TableCellData(widget: Text(item.nguoiTao));
        },
      ),
      ColumnDefinition(
        config: TableColumnData.select(
          name: 'Ngày tạo',
          key: 'ngayTao',
          width: 120,
          flex: 1,
        ),
        builder: (item) {
          return TableCellData(widget: Text(_fmtDate(item.ngayTao)));
        },
      ),
      ColumnDefinition(
        config: TableColumnData.select(
          name: 'Trạng thái',
          key: 'isActive',
          width: 100,
          flex: 1,
        ),
        builder: (item) {
          return TableCellData(
            widget: Container(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: item.isActive ? Colors.green : Colors.red,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                item.isActive ? 'Hoạt động' : 'Không hoạt động',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          );
        },
      ),
    ];
  }
}
