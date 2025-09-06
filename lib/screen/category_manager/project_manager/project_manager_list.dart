import 'package:flutter/material.dart';
import 'package:quan_ly_tai_san_app/common/table/tabale_base_view.dart';
import 'package:quan_ly_tai_san_app/common/table/table_base_config.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/project_manager/models/duan.dart';
import 'package:se_gay_components/common/sg_text.dart';

class ProjectManagerList extends StatefulWidget {
  final List<DuAn> data;
  final void Function(DuAn)? onChangeDetail;
  final void Function(DuAn)? onEdit;
  final void Function(DuAn)? onDelete;
  const ProjectManagerList({
    super.key,
    required this.data,
    this.onChangeDetail,
    this.onEdit,
    this.onDelete,
  });

  @override
  State<ProjectManagerList> createState() => _ProjectManagerListState();
}

class _ProjectManagerListState extends State<ProjectManagerList> {
  List<DuAn> selectedItems = [];

  @override
  Widget build(BuildContext context) {
    final columns = [
      TableBaseConfig.columnTable<DuAn>(
        title: 'Mã',
        getValue: (item) => item.id ?? '',
        width: 70,
      ),
      TableBaseConfig.columnTable<DuAn>(
        title: 'Tên',
        getValue: (item) => item.tenDuAn ?? '',
        width: 150,
        titleAlignment: TextAlign.start,
      ),
      TableBaseConfig.columnTable<DuAn>(
        title: 'Ghi chú',
        getValue: (item) => item.ghiChu ?? '',
        width: 150,
        titleAlignment: TextAlign.start,
      ),
      TableBaseConfig.columnTable<DuAn>(
        title: 'Có hiệu lực',
        getValue: (item) => item.hieuLuc ?? false ? 'Có' : 'Không',
        width: 150,
        titleAlignment: TextAlign.start,
      ),
      TableBaseConfig.columnWidgetBase<DuAn>(
        title: '',
        cellBuilder:
            (item) => TableBaseConfig.viewActionBase<DuAn>(
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
                    Icon(Icons.table_chart, color: Colors.grey.shade600, size: 18),
                    SizedBox(width: 8),
                    SGText(
                      text: 'Danh sách dự án',
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
                          'Danh sách dự án đã chọn: ${selectedItems.length}',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey.shade700,
                      ),
                    ),
                    SizedBox(width: 16),
                    // IconButton(
                    //   onPressed: () {
                    //     // TODO: Xóa nhân viên đã chọn
                    //   },
                    //   icon: Icon(Icons.delete, color: Colors.grey.shade700),
                    // ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: TableBaseView<DuAn>(
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
