import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/staff/models/nhan_vien.dart';
import 'package:se_gay_components/common/sg_text.dart';
import 'package:table_base/widgets/table/models/column_definition.dart';
import 'package:table_base/widgets/table/models/table_model.dart';

class TableStaffConfig {
  static List<ColumnDefinition> getColumns() {
    return [
      ColumnDefinition(
        config: TableColumnData.select(
          name: 'Mã nhân viên',
          key: 'code_staff',
          width: 70,
          flex: 1,
          isFixed: false,
        ),
        builder: (item) {
          return TableCellData(widget: Text(item.id ?? ''));
        },
      ),
      ColumnDefinition(
        config: TableColumnData.select(
          name: 'Tên nhân viên',
          key: 'name_staff',
          width: 150,
          flex: 1,
          isFixed: false,
        ),
        builder: (item) {
          return TableCellData(widget: Text(item.hoTen ?? ''));
        },
      ),
      ColumnDefinition(
        config: TableColumnData.select(
          name: 'Số điện thoại',
          key: 'phone_staff',
          width: 120,
          flex: 1,
          isFixed: false,
        ),
        builder: (item) {
          return TableCellData(widget: Text(item.diDong ?? ''));
        },
      ),
      ColumnDefinition(
        config: TableColumnData.select(
          name: 'Email',
          key: 'email_staff',
          width: 120,
          flex: 1,
          isFixed: false,
        ),
        builder: (item) {
          return TableCellData(widget: Text(item.emailCongViec ?? ''));
        },
      ),
      ColumnDefinition(
        config: TableColumnData.select(
          name: 'Phòng ban',
          key: 'department_staff',
          width: 150,
          flex: 1,
          isFixed: false,
        ),
        builder: (item) {
          return TableCellData(widget: Text(item.tenPhongBan ?? ''));
        },
      ),
      ColumnDefinition(
        config: TableColumnData.select(
          name: 'Chức vụ',
          key: 'position_staff',
          width: 100,
          flex: 1,
          isFixed: false,
        ),
        builder: (item) {
          return TableCellData(widget: Text(item.tenChucVu ?? ''));
        },
      ),
      ColumnDefinition(
        config: TableColumnData.select(
          name: 'Quyền ký',
          key: 'signing_status',
          width: 100,
          flex: 1,
        ),
        builder: (item) {
          return TableCellData(widget: showSigningStatus(item));
        },
      ),
    ];
  }

  static Widget showSigningStatus(NhanVien item) {
    if (item.kyNhay == false && item.kyThuong == false && item.kySo == false) {
      log('Không ký');
      return showStatusDocument(0, 'Không ký');
    }
    return Wrap(
      spacing: 4,
      runSpacing: 4,
      children: [
        if (item.kyNhay == true) showStatusDocument(1, 'Ký nháy'),
        if (item.kyThuong == true) showStatusDocument(2, 'Ký thường'),
        if (item.kySo == true) showStatusDocument(3, 'Ký số'),
      ],
    );
  }

  static Widget showStatusDocument(int status, String text) {
    return Container(
      constraints: const BoxConstraints(maxHeight: 48.0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
        margin: const EdgeInsets.only(bottom: 2),
        decoration: BoxDecoration(
          color:
              status == 0
                  ? Colors.red
                  : status == 1
                  ? Colors.deepOrangeAccent
                  : status == 2
                  ? Colors.blue
                  : Colors.green,
          borderRadius: BorderRadius.circular(4),
        ),
        child: SGText(
          text: text,
          size: 12,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: Colors.white,
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}
