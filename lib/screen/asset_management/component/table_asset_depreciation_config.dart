import 'package:flutter/material.dart';
import 'package:quan_ly_tai_san_app/screen/asset_management/provider/asset_management_provider.dart';
import 'package:table_base/widgets/table/models/column_definition.dart';
import 'package:table_base/widgets/table/models/table_model.dart';
import 'package:intl/intl.dart';

class TableAssetDepreciationConfig {
  static final NumberFormat _vnNumber = NumberFormat('#,##0', 'vi_VN');

  static String _fmtNum(double? v) {
    if (v == null) return '';
    try {
      return _vnNumber.format(v);
    } catch (_) {
      return v.toString();
    }
  }

  static String _fmtDate(DateTime? d) {
    if (d == null) return '';
    final dd = d.day.toString().padLeft(2, '0');
    final mm = d.month.toString().padLeft(2, '0');
    final yyyy = d.year.toString();
    return '$dd/$mm/$yyyy';
  }

  static List<ColumnDefinition> getColumns(AssetManagementProvider provider) {
    return [
      ColumnDefinition(
        config: TableColumnData.select(
          name: 'ID',
          key: 'id',
          width: 80,
          flex: 1,
          isFixed: false,
        ),
        builder: (item) {
          return TableCellData(widget: Text(item.id ?? ''));
        },
      ),
      ColumnDefinition(
        config: TableColumnData.select(
          name: 'Số thẻ',
          key: 'soThe',
          width: 120,
          flex: 1,
          isFixed: false,
        ),
        builder: (item) {
          return TableCellData(widget: Text(item.soThe ?? ''));
        },
      ),

      ColumnDefinition(
        config: TableColumnData.select(
          name: 'Tên tài sản',
          key: 'tenTaiSan',
          width: 220,
          flex: 1,
          isFixed: false,
        ),
        builder: (item) {
          return TableCellData(widget: Text(item.tenTaiSan ?? ''));
        },
      ),
      ColumnDefinition(
        config: TableColumnData.select(
          name: 'Vốn NS',
          key: 'nvNS',
          width: 140,
          flex: 1,
          isFixed: false,
        ),
        builder: (item) {
          return TableCellData(widget: Text(_fmtNum(item.nvNS)));
        },
      ),
      ColumnDefinition(
        config: TableColumnData.select(
          name: 'Vốn vay',
          key: 'vonVay',
          width: 140,
          flex: 1,
          isFixed: false,
        ),
        builder: (item) {
          return TableCellData(widget: Text(_fmtNum(item.vonVay)));
        },
      ),
      ColumnDefinition(
        config: TableColumnData.select(
          name: 'Vốn khác',
          key: 'vonKhac',
          width: 140,
          flex: 1,
          isFixed: false,
        ),
        builder: (item) {
          return TableCellData(widget: Text(_fmtNum(item.vonKhac)));
        },
      ),
      ColumnDefinition(
        config: TableColumnData.select(
          name: 'Mã tài khoản',
          key: 'maTk',
          width: 140,
          flex: 1,
          isFixed: false,
        ),
        builder: (item) {
          return TableCellData(widget: Text(item.maTk ?? ''));
        },
      ),
      ColumnDefinition(
        config: TableColumnData.select(
          name: 'Ngày tính khấu hao',
          key: 'ngayTinhKhao',
          width: 160,
          flex: 1,
          isFixed: false,
        ),
        builder: (item) {
          return TableCellData(widget: Text(_fmtDate(item.ngayTinhKhao)));
        },
      ),
      ColumnDefinition(
        config: TableColumnData.select(
          name: 'Tháng khấu hao',
          key: 'thangKh',
          width: 100,
          flex: 1,
          isFixed: false,
        ),
        builder: (item) {
          return TableCellData(widget: Text(item.thangKh?.toString() ?? ''));
        },
      ),
      ColumnDefinition(
        config: TableColumnData.select(
          name: 'Nguyên giá',
          key: 'nguyenGia',
          width: 140,
          flex: 1,
          isFixed: false,
        ),
        builder: (item) {
          return TableCellData(widget: Text(_fmtNum(item.nguyenGia)));
        },
      ),
      ColumnDefinition(
        config: TableColumnData.select(
          name: 'Khấu hao ban đầu',
          key: 'khauHaoBanDau',
          width: 140,
          flex: 1,
          isFixed: false,
        ),
        builder: (item) {
          return TableCellData(widget: Text(_fmtNum(item.khauHaoBanDau)));
        },
      ),
      ColumnDefinition(
        config: TableColumnData.select(
          name: 'Khấu hao PSDK',
          key: 'khauHaoPsdk',
          width: 140,
          flex: 1,
        ),
        builder: (item) {
          return TableCellData(widget: Text(_fmtNum(item.khauHaoPsdk)));
        },
      ),
      ColumnDefinition(
        config: TableColumnData.select(
          name: 'GTCL ban đầu',
          key: 'gtclBanDau',
          width: 140,
          flex: 1,
        ),
        builder: (item) {
          return TableCellData(widget: Text(_fmtNum(item.gtclBanDau)));
        },
      ),
      ColumnDefinition(
        config: TableColumnData.select(
          name: 'Khấu hao PSCK',
          key: 'khauHaoPsck',
          width: 140,
          flex: 1,
        ),
        builder: (item) {
          return TableCellData(widget: Text(_fmtNum(item.khauHaoPsck)));
        },
      ),
      ColumnDefinition(
        config: TableColumnData.select(
          name: 'GTCL hiện tại',
          key: 'gtclHienTai',
          width: 140,
          flex: 1,
        ),
        builder: (item) {
          return TableCellData(widget: Text(_fmtNum(item.gtclHienTai)));
        },
      ),
      ColumnDefinition(
        config: TableColumnData.select(
          name: 'Khấu hao bình quân',
          key: 'khauHaoBinhQuan',
          width: 140,
          flex: 1,
        ),
        builder: (item) {
          return TableCellData(widget: Text(_fmtNum(item.khauHaoBinhQuan)));
        },
      ),
      ColumnDefinition(
        config: TableColumnData.select(
          name: 'Số tiền',
          key: 'soTien',
          width: 120,
          flex: 1,
        ),
        builder: (item) {
          return TableCellData(widget: Text(_fmtNum(item.soTien)));
        },
      ),
      ColumnDefinition(
        config: TableColumnData.select(
          name: 'Chênh lệch',
          key: 'chenhLech',
          width: 120,
          flex: 1,
        ),
        builder: (item) {
          return TableCellData(widget: Text(_fmtNum(item.chenhLech)));
        },
      ),
      ColumnDefinition(
        config: TableColumnData.select(
          name: 'Khấu hao kỳ trước',
          key: 'khKyTruoc',
          width: 140,
          flex: 1,
        ),
        builder: (item) {
          return TableCellData(widget: Text(_fmtNum(item.khKyTruoc)));
        },
      ),
      ColumnDefinition(
        config: TableColumnData.select(
          name: 'Chênh lệch kỳ trước',
          key: 'clKyTruoc',
          width: 140,
          flex: 1,
        ),
        builder: (item) {
          return TableCellData(widget: Text(_fmtNum(item.clKyTruoc)));
        },
      ),
      ColumnDefinition(
        config: TableColumnData.select(
          name: 'HSDCKH',
          key: 'hsdCkh',
          width: 120,
          flex: 1,
        ),
        builder: (item) {
          return TableCellData(widget: Text(_fmtNum(item.hsdCkh)));
        },
      ),
      ColumnDefinition(
        config: TableColumnData.select(
          name: 'Tài khoản nợ',
          key: 'tkNo',
          width: 140,
          flex: 1,
        ),
        builder: (item) {
          return TableCellData(widget: Text(item.tkNo ?? ''));
        },
      ),
      ColumnDefinition(
        config: TableColumnData.select(
          name: 'Tài khoản có',
          key: 'tkCo',
          width: 140,
          flex: 1,
        ),
        builder: (item) {
          return TableCellData(widget: Text(item.tkCo ?? ''));
        },
      ),
      ColumnDefinition(
        config: TableColumnData.select(
          name: 'DTGT',
          key: 'dtgt',
          width: 100,
          flex: 1,
        ),
        builder: (item) {
          return TableCellData(widget: Text(item.dtgt ?? ''));
        },
      ),
      ColumnDefinition(
        config: TableColumnData.select(
          name: 'DTTH',
          key: 'dtth',
          width: 100,
          flex: 1,
        ),
        builder: (item) {
          return TableCellData(widget: Text(item.dtth ?? ''));
        },
      ),
      ColumnDefinition(
        config: TableColumnData.select(
          name: 'KMCP',
          key: 'kmcp',
          width: 100,
          flex: 1,
        ),
        builder: (item) {
          return TableCellData(widget: Text(item.kmcp ?? ''));
        },
      ),
      ColumnDefinition(
        config: TableColumnData.select(
          name: 'Ghi chú khấu hao',
          key: 'ghiChuKhao',
          width: 220,
          flex: 1,
        ),
        builder: (item) {
          return TableCellData(widget: Text(item.ghiChuKhao ?? ''));
        },
      ),
      ColumnDefinition(
        config: TableColumnData.select(
          name: 'Người tạo',
          key: 'userId',
          width: 120,
          flex: 1,
        ),
        builder: (item) {
          return TableCellData(widget: Text(item.userId ?? ''));
        },
      ),
    ];
  }
}
