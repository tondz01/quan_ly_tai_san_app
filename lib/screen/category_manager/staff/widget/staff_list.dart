// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:quan_ly_tai_san_app/common/button/action_button_config.dart';
import 'package:quan_ly_tai_san_app/common/popup/popup_confirm.dart';
import 'package:quan_ly_tai_san_app/common/table/tabale_base_view.dart';
import 'package:quan_ly_tai_san_app/common/table/table_base_config.dart';
import 'package:quan_ly_tai_san_app/common/widgets/material_components.dart';
import 'package:quan_ly_tai_san_app/core/constants/app_colors.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/staff/models/nhan_vien.dart';
import 'package:se_gay_components/common/sg_colors.dart';
import 'package:se_gay_components/common/sg_text.dart';

class StaffList extends StatefulWidget {
  final List<NhanVien> data;
  final void Function(NhanVien)? onChangeDetail;
  final void Function(NhanVien)? onEdit;
  final void Function(NhanVien)? onDelete;
  final void Function(List<String>)? onDeleteBatch;
  final bool isCanDelete;
  const StaffList({
    super.key,
    required this.data,
    this.onChangeDetail,
    this.onEdit,
    this.onDelete,
    this.onDeleteBatch,
    this.isCanDelete = false,
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
      TableBaseConfig.columnWidgetBase<NhanVien>(
        title: 'Thao tác',
        cellBuilder: (item) => viewAction(item),
        width: 60,
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
                if (widget.isCanDelete)
                  Visibility(
                    visible: selectedItems.isNotEmpty,
                    child: Row(
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
                        MaterialTextButton(
                          text: 'Xóa đã chọn',
                          icon: Icons.delete,
                          backgroundColor: ColorValue.error,
                          foregroundColor: Colors.white,
                          onPressed: () {
                            setState(() {
                              List<String> data =
                                  selectedItems.map((e) => e.id!).toList();
                              showConfirmDialog(
                                context,
                                type: ConfirmType.delete,
                                title: 'Xóa nhân viên',
                                message:
                                    'Bạn có chắc muốn xóa ${selectedItems.length} nhân viên',
                                highlight: selectedItems.length.toString(),
                                cancelText: 'Không',
                                confirmText: 'Xóa',
                                onConfirm: () {
                                  widget.onDeleteBatch?.call(data);
                                },
                              );
                            });
                          },
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
          Divider(
            height: 1,
            thickness: 1,
            color: SGAppColors.colorBorderGray.withValues(alpha: 0.3),
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
        iconColor:
            widget.isCanDelete ? Colors.red.shade700 : Colors.grey.shade700,
        backgroundColor:
            widget.isCanDelete ? Colors.red.shade50 : Colors.grey.shade50,
        borderColor:
            widget.isCanDelete ? Colors.red.shade200 : Colors.grey.shade200,
        onPressed:
            () => {
              if (widget.isCanDelete)
                {
                  showConfirmDialog(
                    context,
                    type: ConfirmType.delete,
                    title: 'Xóa nhân viên',
                    message: 'Bạn có chắc muốn xóa ${item.hoTen}',
                    highlight: item.hoTen ?? '',
                    cancelText: 'Không',
                    confirmText: 'Xóa',
                    onConfirm: () {
                      widget.onDelete?.call(item);
                    },
                  ),
                },
            },
      ),
    ]);
  }
}
