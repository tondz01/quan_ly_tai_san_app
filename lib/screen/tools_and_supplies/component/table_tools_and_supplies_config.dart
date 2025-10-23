import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:quan_ly_tai_san_app/core/constants/app_colors.dart';
import 'package:quan_ly_tai_san_app/screen/login/auth/account_helper.dart';
import 'package:quan_ly_tai_san_app/screen/tools_and_supplies/model/ownership_unit_detail_dto.dart';
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
          return TableCellData(
            alignment: Alignment.center,
            widget: Text(item.id),
          );
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
          return TableCellData(
            alignment: Alignment.center,
            widget: Text(item.ten),
          );
        },
      ),
      ColumnDefinition(
        config: TableColumnData.select(
          name: 'Đơn vị nhập',
          key: 'tenDonVi',
          width: 250,
          flex: 1,
        ),
        builder: (item) {
          return TableCellData(
            alignment: Alignment.center,
            widget: Text(item.tenDonVi),
          );
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
          return TableCellData(
            alignment: Alignment.center,
            widget: Text(item.tenNhomCCDC),
          );
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
          return TableCellData(
            alignment: Alignment.center,
            widget: Text(item.donViTinh),
          );
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
          return TableCellData(
            alignment: Alignment.center,
            widget: Text(item.soLuong.toString()),
          );
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
          return TableCellData(
            alignment: Alignment.center,
            widget: Text(_fmtNum(item.giaTri)),
          );
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
          return TableCellData(
            alignment: Alignment.center,
            widget: Text(item.kyHieu),
          );
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
          return TableCellData(
            alignment: Alignment.center,
            widget: Text(item.ghiChu),
          );
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
          return TableCellData(
            alignment: Alignment.center,
            widget: Text(item.nguoiTao),
          );
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
          return TableCellData(
            alignment: Alignment.center,
            widget: Text(_fmtDate(item.ngayTao)),
          );
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
            alignment: Alignment.center,
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

  static List<TableColumnData> getChildColumns() {
    return [
      TableColumnData(name: 'Mã chi tiết CCDC - Vật tư', key: 'id', width: 300),
      TableColumnData(name: 'Đơn vị sở hữu', key: 'idDonViSoHuu', width: 300),
      TableColumnData(name: 'Số lượng đang sở hữu', key: 'soLuong', width: 300),
      TableColumnData(
        name: 'Thời gian ban giao',
        key: 'thoiGianBanGiao',
        width: 300,
      ),
    ];
  }

  static TableCellData? buildChildCell(
    OwnershipUnitDetailDto item,
    String columnKey,
  ) {
    switch (columnKey) {
      case 'id':
        return TableCellData(
          widget: Text(
            item.idTsCon,
            style: const TextStyle(color: ColorValue.accentLightCyan),
          ),
        );
      case 'idDonViSoHuu':
        String tenDonViSoHuu =
            AccountHelper.instance
                .getDepartmentById(item.idDonViSoHuu)
                ?.tenPhongBan ??
            '';
        return TableCellData(widget: Text(tenDonViSoHuu));
      case 'soLuong':
        return TableCellData(widget: Text(item.soLuong.toString()));
      case 'thoiGianBanGiao':
        return TableCellData(widget: Text(item.thoiGianBanGiao));
      default:
        return null;
    }
  }
}
