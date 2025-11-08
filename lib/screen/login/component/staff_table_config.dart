import 'package:flutter/material.dart';
import 'package:table_base/widgets/table/models/column_definition.dart';
import 'package:table_base/widgets/table/models/table_model.dart';

class StaffTableConfig {
  static List<ColumnDefinition> getColumns() {
    return [
      ColumnDefinition(
        config: TableColumnData.select(
          name: 'Mã nhân viên',
          key: 'id',
          width: 170,
          flex: 1,
          isFixed: false,
        ),
        builder: (item) {
          return TableCellData(widget: Text(item.id ?? ''));
        },
      ),
      ColumnDefinition(
        config: TableColumnData.select(
          name: 'Họ tên',
          key: 'hoTen',
          width: 150,
          flex: 1,
        ),
        builder: (item) {
          return TableCellData(widget: Text(item.hoTen ?? ''));
        },
      ),
      ColumnDefinition(
        config: TableColumnData.select(
          name: 'Email công việc',
          key: 'emailCongViec',
          width: 200,
          flex: 1,
        ),
        builder: (item) {
          return TableCellData(widget: Text(item.emailCongViec ?? ''));
        },
      ),
      ColumnDefinition(
        config: TableColumnData.select(
          name: 'Số điện thoại',
          key: 'diDong',
          width: 150,
          flex: 1,
        ),
        builder: (item) {
          return TableCellData(widget: Text(item.diDong ?? ''));
        },
      ),
      ColumnDefinition(
        config: TableColumnData.select(
          name: 'Chức vụ',
          key: 'chucVu',
          width: 150,
          flex: 1,
        ),
        builder: (item) {
          return TableCellData(widget: Text(item.tenChucVu ?? ''));
        },
      ),
      ColumnDefinition(
        config: TableColumnData.select(
          name: 'Phòng ban',
          key: 'tenPhongBan',
          width: 150,
          flex: 1,
        ),
        builder: (item) {
          return TableCellData(widget: Text(item.tenPhongBan ?? ''));
        },
      ),
      ColumnDefinition(
        config: TableColumnData.select(
          name: 'Trạng thái tài khoản',
          key: 'trangThaiTaiKhoan',
          width: 180,
          flex: 1,
        ),
        builder: (item) {
          // Sẽ được set trong getColumnsWithActions
          return TableCellData(widget: Text(''));
        },
      ),
      ColumnDefinition(
        config: TableColumnData.select(
          name: 'Người tạo',
          key: 'nguoiTao',
          width: 150,
          flex: 1,
        ),
        builder: (item) {
          return TableCellData(widget: Text(item.nguoiTao ?? ''));
        },
      ),
    ];
  }

  static List<ColumnDefinition> getColumnsWithActions(
    TableCellBuilder actionsBuilder,
    TableCellBuilder trangThaiBuilder,
  ) {
    final columns = getColumns();
    // Cập nhật builder cho trạng thái tài khoản
    final trangThaiIndex = columns.indexWhere((col) => col.config.key == 'trangThaiTaiKhoan');
    if (trangThaiIndex != -1) {
      columns[trangThaiIndex] = ColumnDefinition(
        config: columns[trangThaiIndex].config,
        builder: trangThaiBuilder,
      );
    }
    // Thêm actions column
    columns.insert(
      0,
      ColumnDefinition(
        config: TableColumnData.select(
          name: 'Thao tác',
          key: 'actions',
          width: 120,
          flex: 0,
          isFixed: true,
        ),
        builder: actionsBuilder,
      ),
    );
    return columns;
  }
}

