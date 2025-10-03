// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quan_ly_tai_san_app/common/button/action_button_config.dart';
import 'package:quan_ly_tai_san_app/common/popup/popup_confirm.dart';
import 'package:quan_ly_tai_san_app/common/table/tabale_base_view.dart';
import 'package:quan_ly_tai_san_app/common/table/table_base_config.dart';
import 'package:quan_ly_tai_san_app/common/widgets/column_display_popup.dart';
import 'package:quan_ly_tai_san_app/common/widgets/material_components.dart';
import 'package:quan_ly_tai_san_app/core/constants/app_colors.dart';
import 'package:quan_ly_tai_san_app/screen/reason_increase/bloc/reason_increase_bloc.dart';
import 'package:quan_ly_tai_san_app/screen/reason_increase/bloc/reason_increase_event.dart';
import 'package:quan_ly_tai_san_app/screen/reason_increase/model/reason_increase.dart';
import 'package:quan_ly_tai_san_app/screen/reason_increase/provider/reason_increase_provider.dart';
import 'package:se_gay_components/common/sg_colors.dart';
import 'package:se_gay_components/common/sg_text.dart';
import 'package:se_gay_components/common/switch/sg_checkbox.dart';
import 'package:se_gay_components/common/table/sg_table_component.dart';

class ReasonIncreaseList extends StatefulWidget {
  final ReasonIncreaseProvider provider;
  const ReasonIncreaseList({super.key, required this.provider});

  @override
  State<ReasonIncreaseList> createState() => _ReasonIncreaseListState();
}

class _ReasonIncreaseListState extends State<ReasonIncreaseList> {
  final ScrollController horizontalController = ScrollController();
  String searchTerm = "";

  List<ReasonIncrease> listSelected = [];

  late List<ColumnDisplayOption> columnOptions;
  List<String> visibleColumnIds = ['id', 'name', 'tang_giam', 'actions'];

  @override
  void initState() {
    super.initState();
    _initializeColumnOptions();
  }

  void _initializeColumnOptions() {
    columnOptions = [
      ColumnDisplayOption(
        id: 'id',
        label: 'Mã lý do tăng',
        isChecked: visibleColumnIds.contains('id'),
      ),
      ColumnDisplayOption(
        id: 'name',
        label: 'Tên lý do tăng',
        isChecked: visibleColumnIds.contains('name'),
      ),
      ColumnDisplayOption(
        id: 'tang_giam',
        label: 'Tăng giảm',
        isChecked: visibleColumnIds.contains('tang_giam'),
      ),
      ColumnDisplayOption(
        id: 'actions',
        label: 'Thao tác',
        isChecked: visibleColumnIds.contains('actions'),
      ),
    ];
  }

  List<SgTableColumn<ReasonIncrease>> _buildColumns() {
    final List<SgTableColumn<ReasonIncrease>> columns = [];

    for (String columnId in visibleColumnIds) {
      switch (columnId) {
        case 'id':
          columns.add(
            TableBaseConfig.columnTable<ReasonIncrease>(
              title: 'Mã lý do tăng',
              getValue: (item) => item.id ?? '',
              width: 120,
              titleAlignment: TextAlign.left,
            ),
          );
          break;
        case 'name':
          columns.add(
            TableBaseConfig.columnTable<ReasonIncrease>(
              title: 'Tên lý do tăng',
              getValue: (item) => item.ten ?? '',
              width: 120,
              titleAlignment: TextAlign.left,
            ),
          );
          break;
        case 'tang_giam':
          columns.add(
            TableBaseConfig.columnTable<ReasonIncrease>(
              title: 'Tăng giảm',
              getValue: (item) => item.tangGiam == 1 ? 'Tăng' : 'Giảm',
              width: 120,
              titleAlignment: TextAlign.left,
            ),
          );
          break;
        case 'actions':
          columns.add(
            TableBaseConfig.columnWidgetBase<ReasonIncrease>(
              title: 'Thao tác',
              cellBuilder: (item) => viewAction(item),
              width: 60,
              searchable: true,
            ),
          );
          break;
      }
    }

    return columns;
  }

  @override
  Widget build(BuildContext context) {
    final List<SgTableColumn<ReasonIncrease>> columns = _buildColumns();

    return Container(
      height: MediaQuery.of(context).size.height,
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
                  spacing: 8,
                  children: [
                    Icon(
                      Icons.table_chart,
                      color: Colors.grey.shade600,
                      size: 18,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 2.5),
                      child: Text(
                        'Danh sách lý do tăng (${widget.provider.data?.length ?? 0})',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ),
                  ],
                ),
                Visibility(
                  visible: listSelected.isNotEmpty,
                  child: Row(
                    children: [
                      SGText(
                        text:
                            'Danh sách lý do tăng đã chọn: ${listSelected.length}',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey.shade700,
                        ),
                      ),
                      SizedBox(width: 16),
                      MaterialTextButton(
                        text: 'Xóa lý do tăng đã chọn',
                        icon: Icons.delete,
                        backgroundColor: ColorValue.error,
                        foregroundColor: Colors.white,
                        onPressed: () {
                          setState(() {
                            final ids = listSelected.map((e) => e.id!).toList();
                            showConfirmDialog(
                              context,
                              type: ConfirmType.delete,
                              title: 'Xóa lý do tăng',
                              message:
                                  'Bạn có chắc muốn xóa ${listSelected.length} lý do tăng',
                              highlight: listSelected.length.toString(),
                              cancelText: 'Không',
                              confirmText: 'Xóa',
                              onConfirm: () {
                                final roleBloc =
                                    context.read<ReasonIncreaseBloc>();
                                roleBloc.add(
                                  DeleteReasonIncreaseBatchEvent(ids),
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
            child: TableBaseView<ReasonIncrease>(
              searchTerm: '',
              columns: columns,
              data: widget.provider.dataPage ?? [],
              horizontalController: ScrollController(),
              onRowTap: (item) {
                widget.provider.onChangeDetail(item);
              },
              onSelectionChanged: (items) {
                setState(() {
                  listSelected = items;
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget showCheckBoxActive(bool isActive) {
    return SgCheckbox(value: isActive);
  }

  String getNameColumnAssetGroup(ReasonIncrease item) {
    return "${item.id} - ${item.ten}";
  }

  Widget viewAction(ReasonIncrease item) {
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
                title: 'Xóa lý do tăng',
                message: 'Bạn có chắc muốn xóa ${item.ten}',
                highlight: item.ten ?? '',
                cancelText: 'Không',
                confirmText: 'Xóa',
                onConfirm: () {
                  context.read<ReasonIncreaseBloc>().add(
                    DeleteReasonIncreaseEvent(context, item.id!),
                  );
                },
              ),
            },
      ),
    ]);
  }
}
