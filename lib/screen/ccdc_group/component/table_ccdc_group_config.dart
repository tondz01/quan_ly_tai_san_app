import 'package:flutter/material.dart';
import 'package:table_base/widgets/table/models/column_definition.dart';
import 'package:table_base/widgets/table/models/table_model.dart';
import 'package:table_base/widgets/table/providers/table_state.dart';

class TableCcdcGroupConfig {
  static List<ColumnDefinition> getColumns() {
    return [
      ColumnDefinition(
        config: TableColumnData.select(
          name: 'Mã nhóm ccdc',
          key: 'code_ccdc_group',
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
          name: 'Tên nhóm ccdc',
          key: 'name_ccdc_group',
          width: 100,
          flex: 1,
          isFixed: false,
        ),
        builder: (item) {
          return TableCellData(widget: Text(item.ten ?? ''));
        },
      ),
      ColumnDefinition(
        config: TableColumnData.withFilter(
          name: 'Ngày tạo',
          key: 'created_at',
          width: 100,
          flex: 1,
          filterType: FilterType.date,
        ),
        builder: (item) {
          return TableCellData(widget: Text(item.ngayTao ?? ''));
        },
      ),
      ColumnDefinition(
        config: TableColumnData.withFilter(
          name: 'Ngày cập nhật',
          key: 'updated_at',
          width: 100,
          flex: 1,
          filterType: FilterType.date,
        ),
        builder: (item) {
          return TableCellData(widget: Text(item.ngayCapNhat ?? ''));
        },
      ),
      ColumnDefinition(
        config: TableColumnData.select(
          name: 'Người tạo',
          key: 'created_by',
          width: 100,
          flex: 1,
        ),
        builder: (item) {
          return TableCellData(widget: Text(item.nguoiTao ?? ''));
        },
      ),
      ColumnDefinition(
        config: TableColumnData.select(
          name: 'Người cập nhật',
          key: 'updated_by',
          width: 100,
          flex: 1,
        ),
        builder: (item) {
          return TableCellData(widget: Text(item.nguoiCapNhat ?? ''));
        },
      ),
    ];
  }
}
