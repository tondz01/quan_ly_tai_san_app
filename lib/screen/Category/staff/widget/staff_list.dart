// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:quan_ly_tai_san_app/common/button/action_button_config.dart';
import 'package:quan_ly_tai_san_app/common/popup/popup_confirm.dart';
import 'package:quan_ly_tai_san_app/common/table/tabale_base_view.dart';
import 'package:quan_ly_tai_san_app/common/table/table_base_config.dart';
import 'package:quan_ly_tai_san_app/screen/category/staff/models/nhan_vien.dart';
import 'package:se_gay_components/common/sg_text.dart';

class StaffList extends StatefulWidget {
  final List<NhanVien> data;
  final void Function(NhanVien)? onChangeDetail;
  final void Function(NhanVien)? onEdit;
  final void Function(NhanVien)? onDelete;
  const StaffList({
    super.key,
    required this.data,
    this.onChangeDetail,
    this.onEdit,
    this.onDelete,
  });

  @override
  State<StaffList> createState() => _StaffListState();
}

class _StaffListState extends State<StaffList> {
  List<NhanVien> selectedItems = [];

  @override
  Widget build(BuildContext context) {
    final columns = [
      TableBaseConfig.columnTable<NhanVien>(
        title: 'Mã nhân viên',
        getValue: (item) => item.id ?? '',
        width: 70,
      ),
      TableBaseConfig.columnTable<NhanVien>(
        title: 'Tên nhân viên',
        getValue: (item) => item.hoTen ?? '',
        titleAlignment: TextAlign.start,
        width: 150,
      ),
      TableBaseConfig.columnTable<NhanVien>(
        title: 'Số điện thoại',
        getValue: (item) => item.diDong ?? '',
        titleAlignment: TextAlign.start,
        width: 120,
      ),
      TableBaseConfig.columnTable<NhanVien>(
        title: 'Email',
        getValue: (item) => item.emailCongViec ?? '',
        titleAlignment: TextAlign.start,
        width: 120,
      ),
      TableBaseConfig.columnTable<NhanVien>(
        title: 'Hoạt động',
        getValue:
            (item) =>
                item.isActive == true ? 'Đang hoạt động' : 'Ngừng hoạt động',
        titleAlignment: TextAlign.start,
        width: 150,
      ),
      TableBaseConfig.columnTable<NhanVien>(
        title: 'Hạn chót cho hoạt động tiếp theo',
        getValue: (item) => item.gioLamViec ?? '',
        titleAlignment: TextAlign.center,
        width: 150,
      ),
      TableBaseConfig.columnTable<NhanVien>(
        title: 'Phòng ban',
        getValue: (item) => item.tenPhongBan ?? '',
        titleAlignment: TextAlign.center,
        width: 150,
      ),
      TableBaseConfig.columnTable<NhanVien>(
        title: 'Chức vụ',
        getValue: (item) => item.tenChucVu ?? '',
        titleAlignment: TextAlign.center,
        width: 100,
      ),
      TableBaseConfig.columnTable<NhanVien>(
        title: 'Người quản lý',
        getValue: (item) => item.tenQuanLy ?? '',
        titleAlignment: TextAlign.start,
        width: 150,
      ),
      TableBaseConfig.columnWidgetBase<NhanVien>(
        title: '',
        cellBuilder: (item) => viewAction(item),
        width: 120,
        searchable: true,
      ),
    ];
    return Container(
      height: MediaQuery.of(context).size.height - 170,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        // mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(8),
                topRight: Radius.circular(8),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.table_chart,
                      color: Colors.grey.shade600,
                      size: 18,
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Danh sách nhân viên',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    SGText(
                      text:
                          'Danh sách nhân viên đã chọn: ${selectedItems.length}',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey.shade700,
                      ),
                    ),
                    SizedBox(width: 16),
                    IconButton(
                      onPressed: () {
                        // TODO: Xóa nhân viên đã chọn
                      },
                      icon: Icon(Icons.delete, color: Colors.grey.shade700),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: TableBaseView<NhanVien>(
              searchTerm: '',
              columns: columns,
              data: widget.data,
              horizontalController: ScrollController(),
              onRowTap: (item) {
                widget.onChangeDetail?.call(item);
              },
              onSelectionChanged: (items) {
                setState(() {
                  selectedItems = items;
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget viewAction(NhanVien item) {
    return viewActionButtons([
      ActionButtonConfig(
        icon: Icons.delete,
        tooltip: 'Xóa',
        iconColor: Colors.red.shade700,
        backgroundColor: Colors.red.shade50,
        borderColor: Colors.red.shade200,
        onPressed:
            () => {
              showConfirmDialog(
                context,
                type: ConfirmType.delete,
                title: 'Xóa chức vụ',
                message: 'Bạn có chắc muốn xóa ${item.hoTen}',
                highlight: item.hoTen ?? '',
                cancelText: 'Không',
                confirmText: 'Xóa',
                onConfirm: () {
                  widget.onDelete?.call(item);
                },
              ),
            },
      ),
    ]);
  }
}
