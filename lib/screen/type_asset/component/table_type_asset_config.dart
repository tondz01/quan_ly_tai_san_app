import 'package:flutter/material.dart';
import 'package:table_base/widgets/table/models/column_definition.dart';
import 'package:table_base/widgets/table/models/table_model.dart';

class TableTypeAssetConfig {
  static List<ColumnDefinition> getColumns() {
    return [
      ColumnDefinition(
        config: TableColumnData.select(
          name: 'Mã loại tài sản',
          key: 'code_type_asset',
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
          name: 'Mã loại tài sản cha',
          key: 'parent_code_type_asset',
          width: 150,
          flex: 1,
          isFixed: false,
        ),
        builder: (item) {
          return TableCellData(widget: Text(item.idLoaiTs ?? ''));
        },
      ),
      ColumnDefinition(
        config: TableColumnData.select(
          name: 'Tên loại tài sản',
          key: 'name_type_asset',
          width: 200,
          flex: 2,
          isFixed: false,
        ),
        builder: (item) {
          return TableCellData(widget: Text(item.tenLoai ?? ''));
        },
      ),
    ];
  }
}
