import 'package:flutter/material.dart';
import 'package:table_base/widgets/table/models/column_definition.dart';
import 'package:table_base/widgets/table/models/table_model.dart';
import 'package:quan_ly_tai_san_app/screen/reason_increase/model/reason_increase.dart'; // ignore: unused_import

class TableReasonIncreaseConfig {
  static List<ColumnDefinition> getColumns() {
    return [
      ColumnDefinition(
        config: TableColumnData.select(
          name: 'Mã lý do tăng',
          key: 'reason_code',
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
          name: 'Tên lý do tăng',
          key: 'reason_name',
          width: 200,
          flex: 2,
          isFixed: false,
        ),
        builder: (item) {
          return TableCellData(widget: Text(item.ten ?? ''));
        },
      ),
      ColumnDefinition(
        config: TableColumnData.select(
          name: 'Tăng giảm',
          key: 'increase_decrease',
          width: 120,
          flex: 1,
          isFixed: false,
        ),
        builder: (item) {
          final isIncrease = item.tangGiam == 1;
          return TableCellData(
            widget: Container(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: isIncrease ? Colors.green.shade100 : Colors.red.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                isIncrease ? 'Tăng' : 'Giảm',
                style: TextStyle(
                  fontSize: 12,
                  color:
                      isIncrease ? Colors.green.shade700 : Colors.red.shade700,
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
