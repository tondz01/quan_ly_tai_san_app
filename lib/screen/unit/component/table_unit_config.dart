import 'package:flutter/material.dart';
import 'package:table_base/widgets/table/models/column_definition.dart';
import 'package:table_base/widgets/table/models/table_model.dart';

class TableUnitConfig {
  static List<ColumnDefinition> getColumns() {
    return [
      ColumnDefinition(
        config: TableColumnData.select(
          name: 'Mã đơn vị tính',
          key: 'code_unit',
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
          name: 'Tên đơn vị tính',
          key: 'name_unit',
          width: 200,
          flex: 1,
          isFixed: false,
        ),
        builder: (item) {
          return TableCellData(widget: Text(item.tenDonVi ?? ''));
        },
      ),
      ColumnDefinition(
        config: TableColumnData.select(
          name: 'Ghi chú',
          key: 'note',
          width: 150,
          flex: 1,
          isFixed: false,
        ),
        builder: (item) {
          return TableCellData(widget: Text(item.note ?? ''));
        },
      ),
    ];
  }
}
