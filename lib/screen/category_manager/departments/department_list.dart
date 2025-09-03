// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:quan_ly_tai_san_app/common/table/tabale_base_view.dart';
import 'package:quan_ly_tai_san_app/common/table/table_base_config.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/departments/models/department.dart';
import 'package:se_gay_components/common/sg_text.dart';

class DepartmentList extends StatefulWidget {
  final List<PhongBan> data;
  final void Function(PhongBan)? onChangeDetail;
  final void Function(PhongBan)? onEdit;
  final void Function(PhongBan)? onDelete;
  const DepartmentList({
    super.key,
    required this.data,
    this.onChangeDetail,
    this.onEdit,
    this.onDelete,
  });

  @override
  State<DepartmentList> createState() => _DepartmentListState();
}

class _DepartmentListState extends State<DepartmentList> {
  List<PhongBan> selectedItems = [];

  @override
  Widget build(BuildContext context) {
    final columns = [
      TableBaseConfig.columnTable<PhongBan>(
        title: 'Mã đơn vị',
        getValue: (item) => item.id ?? "",
        width: 80,
      ),
      TableBaseConfig.columnTable<PhongBan>(
        title: 'Tên phòng/ban',
        getValue: (item) => item.tenPhongBan ?? "",
        width: 150,
      ),
      TableBaseConfig.columnTable<PhongBan>(
        title: 'Nhân viên',
        getValue: (item) => item.soLuongNhanVien.toString(),
        width: 150,
      ),
      TableBaseConfig.columnTable<PhongBan>(
        title: 'Phòng/ Ban cấp trên',
        getValue: (item) => item.phongCapTren ?? "",
        width: 150,
      ),
      TableBaseConfig.columnWidgetBase<PhongBan>(
        title: '',
        cellBuilder:
            (item) => TableBaseConfig.viewActionBase<PhongBan>(
              item: item,
              onEdit: (item) {
                widget.onEdit?.call(item);
              },
              onDelete: (item) {
                widget.onDelete?.call(item);
              },
            ),
        width: 120,
        searchable: true,
      ),
    ];
    return Container(
      height: MediaQuery.of(context).size.height - 200,
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
                  children: [
                    Icon(
                      Icons.table_chart,
                      color: Colors.grey.shade600,
                      size: 18,
                    ),
                    SizedBox(width: 8),
                    SGText(
                      text: 'Danh sách nhân viên',
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
                      },
                      icon: Icon(Icons.delete, color: Colors.grey.shade700),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: TableBaseView<PhongBan>(
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
}
