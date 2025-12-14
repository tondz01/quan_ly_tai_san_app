import 'package:flutter/material.dart';
import 'package:table_base/widgets/table/models/column_definition.dart';
import 'package:table_base/widgets/table/models/table_model.dart';

class TableCurrentStatusConfig {
  static List<ColumnDefinition> getColumns() {
    return [
      ColumnDefinition(
        config: TableColumnData.select(
          name: 'Mã trạng thái',
          key: 'code_current_status',
          width: 120,
          flex: 1,
          isFixed: false,
        ),
        builder: (item) {
          return TableCellData(widget: Text(item.id.toString()));
        },
      ),
      ColumnDefinition(
        config: TableColumnData.select(
          name: 'Tên trạng thái',
          key: 'name_current_status',
          width: 200,
          flex: 2,
          isFixed: false,
        ),
        builder: (item) {
          return TableCellData(widget: Text(item.tenHTKT ?? ''));
        },
      ),
    ];
  }
}
