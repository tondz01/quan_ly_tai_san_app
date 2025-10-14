import 'package:flutter/material.dart';
import 'package:table_base/widgets/table/models/column_definition.dart';
import 'package:table_base/widgets/table/models/table_model.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/role/model/chuc_vu.dart'; // ignore: unused_import
import 'package:se_gay_components/common/switch/sg_checkbox.dart';

class TableRoleConfig {
  static List<ColumnDefinition> getColumns() {
    return [
      ColumnDefinition(
        config: TableColumnData.select(
          name: 'Mã chức vụ',
          key: 'role_code',
          width: 120,
          flex: 1,
          isFixed: false,
        ),
        builder: (item) {
          return TableCellData(widget: Text(item.id));
        },
      ),
      ColumnDefinition(
        config: TableColumnData.select(
          name: 'Tên chức vụ',
          key: 'role_name',
          width: 150,
          flex: 2,
          isFixed: false,
        ),
        builder: (item) {
          return TableCellData(widget: Text(item.tenChucVu));
        },
      ),
      ColumnDefinition(
        config: TableColumnData.select(
          name: 'Quản lý nhân viên',
          key: 'manage_staff',
          width: 120,
          flex: 1,
          isFixed: false,
        ),
        builder: (item) {
          return TableCellData(
            widget: SgCheckbox(value: item.quanLyNhanVien, isDisabled: true),
          );
        },
      ),
      ColumnDefinition(
        config: TableColumnData.select(
          name: 'Quản lý phòng ban',
          key: 'manage_department',
          width: 120,
          flex: 1,
          isFixed: false,
        ),
        builder: (item) {
          return TableCellData(
            widget: SgCheckbox(value: item.quanLyPhongBan, isDisabled: true),
          );
        },
      ),
      ColumnDefinition(
        config: TableColumnData.select(
          name: 'Quản lý dự án',
          key: 'manage_project',
          width: 120,
          flex: 1,
          isFixed: false,
        ),
        builder: (item) {
          return TableCellData(
            widget: SgCheckbox(value: item.quanLyDuAn, isDisabled: true),
          );
        },
      ),
      ColumnDefinition(
        config: TableColumnData.select(
          name: 'Quản lý nguồn vốn',
          key: 'manage_capital',
          width: 120,
          flex: 1,
          isFixed: false,
        ),
        builder: (item) {
          return TableCellData(
            widget: SgCheckbox(value: item.quanLyNguonVon, isDisabled: true),
          );
        },
      ),
      ColumnDefinition(
        config: TableColumnData.select(
          name: 'Quản lý mô hình tài sản',
          key: 'manage_asset_model',
          width: 140,
          flex: 1,
          isFixed: false,
        ),
        builder: (item) {
          return TableCellData(
            widget: SgCheckbox(
              value: item.quanLyMoHinhTaiSan,
              isDisabled: true,
            ),
          );
        },
      ),
      ColumnDefinition(
        config: TableColumnData.select(
          name: 'Quản lý tài sản',
          key: 'manage_asset',
          width: 120,
          flex: 1,
          isFixed: false,
        ),
        builder: (item) {
          return TableCellData(
            widget: SgCheckbox(value: item.quanLyTaiSan, isDisabled: true),
          );
        },
      ),
      ColumnDefinition(
        config: TableColumnData.select(
          name: 'Quản lý CCDC - Vật tư',
          key: 'manage_supplies',
          width: 140,
          flex: 1,
          isFixed: false,
        ),
        builder: (item) {
          return TableCellData(
            widget: SgCheckbox(value: item.quanLyCCDCVatTu, isDisabled: true),
          );
        },
      ),
      ColumnDefinition(
        config: TableColumnData.select(
          name: 'Điều động tài sản',
          key: 'transfer_asset',
          width: 120,
          flex: 1,
          isFixed: false,
        ),
        builder: (item) {
          return TableCellData(
            widget: SgCheckbox(value: item.dieuDongTaiSan, isDisabled: true),
          );
        },
      ),
      ColumnDefinition(
        config: TableColumnData.select(
          name: 'Điều động CCDC - Vật tư',
          key: 'transfer_supplies',
          width: 140,
          flex: 1,
          isFixed: false,
        ),
        builder: (item) {
          return TableCellData(
            widget: SgCheckbox(value: item.dieuDongCCDCVatTu, isDisabled: true),
          );
        },
      ),
      ColumnDefinition(
        config: TableColumnData.select(
          name: 'Bàn giao tài sản',
          key: 'handover_asset',
          width: 120,
          flex: 1,
          isFixed: false,
        ),
        builder: (item) {
          return TableCellData(
            widget: SgCheckbox(value: item.banGiaoTaiSan, isDisabled: true),
          );
        },
      ),
      ColumnDefinition(
        config: TableColumnData.select(
          name: 'Bàn giao CCDC - Vật tư',
          key: 'handover_supplies',
          width: 140,
          flex: 1,
          isFixed: false,
        ),
        builder: (item) {
          return TableCellData(
            widget: SgCheckbox(value: item.banGiaoCCDCVatTu, isDisabled: true),
          );
        },
      ),
      ColumnDefinition(
        config: TableColumnData.select(
          name: 'Báo cáo',
          key: 'report',
          width: 100,
          flex: 1,
          isFixed: false,
        ),
        builder: (item) {
          return TableCellData(
            widget: SgCheckbox(value: item.baoCao, isDisabled: true),
          );
        },
      ),
    ];
  }
}
