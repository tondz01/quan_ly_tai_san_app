import 'package:flutter/material.dart';
import 'package:table_base/widgets/table/models/column_definition.dart';
import 'package:table_base/widgets/table/models/table_model.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/project_manager/models/duan.dart'; // ignore: unused_import

class TableProjectConfig {
  static List<ColumnDefinition> getColumns() {
    return [
      ColumnDefinition(
        config: TableColumnData.select(
          name: 'Mã dự án',
          key: 'project_code',
          width: 100,
          flex: 1,
          isFixed: false,
        ),
        builder: (item) {
          return TableCellData(widget: Text(item.id ?? '', textAlign: TextAlign.center));
        },
      ),
      ColumnDefinition(
        config: TableColumnData.select(
          name: 'Tên dự án',
          key: 'project_name',
          width: 200,
          flex: 2,
          isFixed: false,
        ),
        builder: (item) {
          return TableCellData(widget: Text(item.tenDuAn ?? '', textAlign: TextAlign.center));
        },
      ),
      ColumnDefinition(
        config: TableColumnData.select(
          name: 'Ghi chú',
          key: 'note',
          width: 250,
          flex: 2,
          isFixed: false,
        ),
        builder: (item) {
          return TableCellData(
            widget: Container(
              constraints: BoxConstraints(maxWidth: 200),
              child: Text(
                item.ghiChu ?? '',
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
                style: TextStyle(fontSize: 12),
                textAlign: TextAlign.center,
              ),
            ),
          );
        },
      ),
      ColumnDefinition(
        config: TableColumnData.select(
          name: 'Hiệu lực',
          key: 'effectiveness',
          width: 100,
          flex: 1,
          isFixed: false,
        ),
        builder: (item) {
          return TableCellData(
            widget: Container(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color:
                    (item.hieuLuc ?? false)
                        ? Colors.green.shade100
                        : Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                (item.hieuLuc ?? false) ? 'Có hiệu lực' : 'Không hiệu lực',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  color:
                      (item.hieuLuc ?? false)
                          ? Colors.green.shade700
                          : Colors.grey.shade700,
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
