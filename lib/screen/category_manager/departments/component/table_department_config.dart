import 'package:flutter/material.dart';
import 'package:table_base/widgets/table/models/column_definition.dart';
import 'package:table_base/widgets/table/models/table_model.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/departments/models/department.dart'; // ignore: unused_import
import 'package:quan_ly_tai_san_app/screen/login/auth/account_helper.dart';

class TableDepartmentConfig {
  static List<ColumnDefinition> getColumns() {
    return [
      ColumnDefinition(
        config: TableColumnData.select(
          name: 'Mã đơn vị',
          key: 'department_code',
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
          name: 'Tên phòng/ban',
          key: 'department_name',
          width: 200,
          flex: 2,
          isFixed: false,
        ),
        builder: (item) {
          return TableCellData(widget: Text(item.tenPhongBan ?? ''));
        },
      ),
      ColumnDefinition(
        config: TableColumnData.select(
          name: 'Số lượng nhân viên',
          key: 'employee_count',
          width: 150,
          flex: 1,
          isFixed: false,
        ),
        builder: (item) {
          final count =
              ((AccountHelper.instance.getNhanVien() ?? const [])
                  .where((e) => e.phongBanId == item.id)
                  .length);
          return TableCellData(widget: Text(count.toString()));
        },
      ),
      ColumnDefinition(
        config: TableColumnData.select(
          name: 'Phòng/Ban cấp trên',
          key: 'parent_department',
          width: 180,
          flex: 1,
          isFixed: false,
        ),
        builder: (item) {
          return TableCellData(widget: Text(item.phongCapTren ?? ''));
        },
      ),
      ColumnDefinition(
        config: TableColumnData.select(
          name: 'Trạng thái',
          key: 'status',
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
                    (item.isActive ?? true)
                        ? Colors.green.shade100
                        : Colors.red.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                (item.isActive ?? true) ? 'Hoạt động' : 'Không hoạt động',
                style: TextStyle(
                  fontSize: 12,
                  color:
                      (item.isActive ?? true)
                          ? Colors.green.shade700
                          : Colors.red.shade700,
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
