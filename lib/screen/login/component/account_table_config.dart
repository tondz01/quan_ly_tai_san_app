import 'package:flutter/material.dart';
import 'package:quan_ly_tai_san_app/screen/login/auth/account_helper.dart';
import 'package:quan_ly_tai_san_app/screen/login/model/user/user_info_dto.dart';
import 'package:table_base/widgets/table/models/column_definition.dart';
import 'package:table_base/widgets/table/models/table_model.dart';

class AccountTableConfig {
  
  static List<ColumnDefinition> getColumns(UserInfoDTO userInfo) {
    return [
      ColumnDefinition(
        config: TableColumnData.select(
          name: 'Mã danh bộ',
          key: 'id',
          width: 170,
          flex: 1,
          isFixed: false,
        ),
        builder: (item) {
          return TableCellData(
            widget: Text(item.tenDangNhap ?? ''),
          );
        },
      ),
      ColumnDefinition(
        config: TableColumnData.select(
          name: 'Phòng ban',
          key: 'phongBan',
          width: 170,
          flex: 1,
          isFixed: false,
        ),
        builder: (item) {
          final nhanVien = AccountHelper.instance.getNhanVienById(item.tenDangNhap);
          return TableCellData(
            widget: Text(AccountHelper.instance.getDepartmentById(nhanVien?.phongBanId ?? nhanVien?.boPhan ?? '')?.tenPhongBan ?? ''),
          );
        },
      ),
      ColumnDefinition(
        config: TableColumnData.select(
          name: 'Tên đăng nhập',
          key: 'tenDangNhap',
          width: 150,
          flex: 1,
          isFixed: false,
        ),
        builder: (item) {
          return TableCellData(widget: Text(item.username ?? ''));
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
          name: 'Email',
          key: 'email',
          width: 150,
          flex: 1,
        ),
        builder: (item) {
          return TableCellData(widget: Text(item.email ?? ''));
        },
      ),
      ColumnDefinition(
        config: TableColumnData.select(
          name: 'Số điện thoại',
          key: 'document',
          width: 150,
          flex: 1,
        ),
        builder: (item) {
          return TableCellData(widget: Text(item.soDienThoai ?? ''));
        },
      ),
      ColumnDefinition(
        config: TableColumnData.select(
          name: 'Ngày tạo',
          key: 'ngayTao',
          width: 150,
          flex: 1,
          isFixed: false,
        ),
        builder: (item) {
          return TableCellData(widget: Text(item.ngayTao ?? ''));
        },
      ),
      ColumnDefinition(
        config: TableColumnData.select(
          name: 'Ngày cập nhật',
          key: 'ngayCapNhat',
          width: 150,
          flex: 1,
        ),
        builder: (item) {
          return TableCellData(widget: Text(item.ngayCapNhat ?? ''));
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
      ColumnDefinition(
        config: TableColumnData.select(
          name: 'Người cập nhật',
          key: 'nguoiCapNhat',
          width: 150,
          flex: 1,
        ),
        builder: (item) {
          return TableCellData(widget: Text(item.nguoiCapNhat ?? ''));
        },
      ),
    ];
  }
  
  static List<ColumnDefinition> getColumnsWithActions(
    UserInfoDTO userInfo,
    TableCellBuilder actionsBuilder,
  ) {
    final columns = getColumns(userInfo);
    columns.add(
      ColumnDefinition(
        config: TableColumnData.select(
          name: 'Thao tác',
          key: 'actions',
          width: 180,
          flex: 0,
          isFixed: true,
        ),
        builder: actionsBuilder,
      ),
    );
    return columns;
  }
}
