// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quan_ly_tai_san_app/common/popup/popup_confirm.dart';
import 'package:quan_ly_tai_san_app/common/table/tabale_base_view.dart';
import 'package:quan_ly_tai_san_app/common/table/table_base_config.dart';
import 'package:quan_ly_tai_san_app/common/widgets/material_components.dart';
import 'package:quan_ly_tai_san_app/core/constants/app_colors.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/capital_source/bloc/capital_source_bloc.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/capital_source/bloc/capital_source_event.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/capital_source/models/capital_source.dart';
import 'package:se_gay_components/common/sg_colors.dart';
import 'package:se_gay_components/common/sg_text.dart';

class CapitalSourceList extends StatefulWidget {
  final List<NguonKinhPhi> data;
  final void Function(NguonKinhPhi)? onChangeDetail;
  final void Function(NguonKinhPhi)? onEdit;
  final void Function(NguonKinhPhi)? onDelete;
  const CapitalSourceList({
    super.key,
    required this.data,
    this.onChangeDetail,
    this.onEdit,
    this.onDelete,
  });

  @override
  State<CapitalSourceList> createState() => _CapitalSourceListState();
}

class _CapitalSourceListState extends State<CapitalSourceList> {
  List<NguonKinhPhi> selectedItems = [];

  @override
  Widget build(BuildContext context) {
    final columns = [
      TableBaseConfig.columnTable<NguonKinhPhi>(
        title: 'Mã nguồn kinh phí',
        getValue: (item) => item.id ?? "",
        width: 100,
      ),
      TableBaseConfig.columnTable<NguonKinhPhi>(
        title: 'Tên nguồn kinh phí',
        getValue: (item) => item.tenNguonKinhPhi ?? "",
        width: 150,
        titleAlignment: TextAlign.start,
      ),
      TableBaseConfig.columnTable<NguonKinhPhi>(
        title: 'Ghi chú',
        getValue: (item) => item.ghiChu ?? "",
        width: MediaQuery.of(context).size.width / 4,
        titleAlignment: TextAlign.start,
      ),
      TableBaseConfig.columnTable<NguonKinhPhi>(
        title: 'Có hiệu lực',
        getValue: (item) => item.isActive ?? false ? 'Có' : 'Không',
        width: 150,
      ),
      TableBaseConfig.columnWidgetBase<NguonKinhPhi>(
        title: 'Thao tác',
        cellBuilder:
            (item) => TableBaseConfig.viewActionBase<NguonKinhPhi>(
              item: item,
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
                      text: 'Danh sách nguồn vốn',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ],
                ),
                Visibility(
                  visible: selectedItems.isNotEmpty,
                  child: Row(
                    children: [
                      SGText(
                        text:
                            'Danh sách nguồn vốn đã chọn: ${selectedItems.length}',
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
                              title: 'Xóa nguồn vốn',
                              message:
                                  'Bạn có chắc muốn xóa ${selectedItems.length} nguồn vốn',
                              highlight: selectedItems.length.toString(),
                              cancelText: 'Không',
                              confirmText: 'Xóa',
                              onConfirm: () {
                                final capitalSourceBloc =
                                    context.read<CapitalSourceBloc>();
                                capitalSourceBloc.add(
                                  DeleteCapitalSourceBatch(data),
                                );
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
            child: TableBaseView<NguonKinhPhi>(
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
