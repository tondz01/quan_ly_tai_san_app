// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quan_ly_tai_san_app/common/button/action_button_config.dart';
import 'package:quan_ly_tai_san_app/common/popup/popup_confirm.dart';
import 'package:quan_ly_tai_san_app/common/table/tabale_base_view.dart';
import 'package:quan_ly_tai_san_app/common/table/table_base_config.dart';
import 'package:quan_ly_tai_san_app/common/widgets/column_display_popup.dart';
import 'package:quan_ly_tai_san_app/core/constants/app_colors.dart';
import 'package:quan_ly_tai_san_app/screen/ccdc_group/bloc/ccdc_group_bloc.dart';
import 'package:quan_ly_tai_san_app/screen/ccdc_group/bloc/ccdc_group_event.dart';
import 'package:quan_ly_tai_san_app/screen/ccdc_group/model/ccdc_group.dart';
import 'package:quan_ly_tai_san_app/screen/ccdc_group/provider/ccdc_group_provide.dart';
import 'package:se_gay_components/common/sg_text.dart';
import 'package:se_gay_components/common/switch/sg_checkbox.dart';
import 'package:se_gay_components/common/table/sg_table_component.dart';

class CcdcGroupList extends StatefulWidget {
  final CcdcGroupProvider provider;
  const CcdcGroupList({super.key, required this.provider});

  @override
  State<CcdcGroupList> createState() => _CcdcGroupListState();
}

class _CcdcGroupListState extends State<CcdcGroupList> {
  final ScrollController horizontalController = ScrollController();
  String searchTerm = "";

  List<CcdcGroup> listSelected = [];

  // Column display options
  late List<ColumnDisplayOption> columnOptions;
  List<String> visibleColumnIds = [
    'code_ccdc_group',
    'name_ccdc_group',
    'is_active',
    'actions',
  ];

  @override
  void initState() {
    super.initState();
    _initializeColumnOptions();
  }

  void _initializeColumnOptions() {
    columnOptions = [
      ColumnDisplayOption(
        id: 'code_ccdc_group',
        label: 'Mã nhóm ccdc',
        isChecked: visibleColumnIds.contains('code_ccdc_group'),
      ),
      ColumnDisplayOption(
        id: 'name_ccdc_group',
        label: 'Tên nhóm ccdc',
        isChecked: visibleColumnIds.contains('name_ccdc_group'),
      ),
      ColumnDisplayOption(
        id: 'is_active',
        label: 'Ngày bàn giao',
        isChecked: visibleColumnIds.contains('is_active'),
      ),
      ColumnDisplayOption(
        id: 'created_at',
        label: 'Ngày tạo',
        isChecked: visibleColumnIds.contains('created_at'),
      ),
      ColumnDisplayOption(
        id: 'updated_at',
        label: 'Ngày cập nhật',
        isChecked: visibleColumnIds.contains('updated_at'),
      ),
      ColumnDisplayOption(
        id: 'created_by',
        label: 'Người tạo',
        isChecked: visibleColumnIds.contains('created_by'),
      ),
      ColumnDisplayOption(
        id: 'updated_by',
        label: 'Người cập nhật',
        isChecked: visibleColumnIds.contains('updated_by'),
      ),
      ColumnDisplayOption(
        id: 'actions',
        label: 'Thao tác',
        isChecked: visibleColumnIds.contains('actions'),
      ),
    ];
  }

  List<SgTableColumn<CcdcGroup>> _buildColumns() {
    final List<SgTableColumn<CcdcGroup>> columns = [];

    for (String columnId in visibleColumnIds) {
      switch (columnId) {
        case 'code_ccdc_group':
          columns.add(
            TableBaseConfig.columnTable<CcdcGroup>(
              title: 'Mã nhóm ccdc',
              getValue: (item) => item.id ?? '',
              width: 120,
              titleAlignment: TextAlign.left,
            ),
          );
          break;
        case 'name_ccdc_group':
          columns.add(
            TableBaseConfig.columnTable<CcdcGroup>(
              title: 'Tên nhóm ccdc',
              getValue: (item) => item.ten ?? '',
              width: 120,
              titleAlignment: TextAlign.left,
            ),
          );
          break;
        case 'is_active':
          columns.add(
            TableBaseConfig.columnWidgetBase<CcdcGroup>(
              title: 'Có hiệu lực',
              width: 100,
              cellBuilder: (item) => SgCheckbox(value: item.hieuLuc ?? false),
              titleAlignment: TextAlign.center,
            ),
          );
          break;
        case 'created_at':
          columns.add(
            TableBaseConfig.columnTable<CcdcGroup>(
              title: 'Ngày tạo',
              getValue: (item) => item.ngayTao.toString(),
              width: 120,
              titleAlignment: TextAlign.left,
            ),
          );
          break;
        case 'updated_at':
          columns.add(
            TableBaseConfig.columnTable<CcdcGroup>(
              title: 'Ngày cập nhật',
              getValue: (item) => item.ngayCapNhat.toString(),
              width: 120,
              titleAlignment: TextAlign.left,
            ),
          );
          break;
        case 'created_by':
          columns.add(
            TableBaseConfig.columnTable<CcdcGroup>(
              title: 'Người tạo',
              getValue: (item) => item.nguoiTao.toString(),
              width: 120,
              titleAlignment: TextAlign.left,
            ),
          );
          break;
        case 'updated_by':
          columns.add(
            TableBaseConfig.columnTable<CcdcGroup>(
              title: 'Người cập nhật',
              getValue: (item) => item.nguoiCapNhat.toString(),
              width: 120,
              titleAlignment: TextAlign.left,
            ),
          );
          break;
        case 'actions':
          columns.add(
            TableBaseConfig.columnWidgetBase<CcdcGroup>(
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

  void _showColumnDisplayPopup() async {
    await showColumnDisplayPopup(
      context: context,
      columns: columnOptions,
      onSave: (selectedColumns) {
        setState(() {
          visibleColumnIds = selectedColumns;
          _updateColumnOptions();
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Đã cập nhật hiển thị cột'),
            backgroundColor: Colors.green,
          ),
        );
      },
      onCancel: () {
        _updateColumnOptions();
      },
    );
  }

  void _updateColumnOptions() {
    for (var option in columnOptions) {
      option.isChecked = visibleColumnIds.contains(option.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<SgTableColumn<CcdcGroup>> columns = _buildColumns();

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
                        'Danh sách nhóm CCDC - Vật tư (${widget.provider.data.length})',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: _showColumnDisplayPopup,
                      child: Icon(
                        Icons.settings,
                        color: ColorValue.link,
                        size: 18,
                      ),
                    ),
                  ],
                ),
                Visibility(
                  visible: listSelected.isNotEmpty,
                  child: Row(
                    children: [
                      SGText(
                        text: 'Danh sách nhóm đã chọn: ${listSelected.length}',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey.shade700,
                        ),
                      ),
                      SizedBox(width: 16),
                      IconButton(
                        onPressed: () {
                          List<String> ids =
                              listSelected.map((e) => e.id!).toList();
                          showConfirmDialog(
                            context,
                            type: ConfirmType.delete,
                            title: 'Xóa nhân nhóm CCDC - Vật tư',
                            message:
                                'Bạn có chắc muốn xóa ${listSelected.length} nhóm CCDC - Vật tư',
                            highlight: listSelected.length.toString(),
                            cancelText: 'Không',
                            confirmText: 'Xóa',
                            onConfirm: () {
                              final roleBloc = context.read<CcdcGroupBloc>();
                              roleBloc.add(DeleteCcdcGroupBatchEvent(ids));
                            },
                          );
                        },
                        icon: Icon(Icons.delete, color: Colors.redAccent),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: TableBaseView<CcdcGroup>(
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

  String getNameColumnAssetGroup(CcdcGroup item) {
    return "${item.id} - ${item.ten}";
  }

  Widget viewAction(CcdcGroup item) {
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
                title: 'Xóa nhóm tài sản',
                message: 'Bạn có chắc muốn xóa ${item.ten}',
                highlight: item.ten ?? '',
                cancelText: 'Không',
                confirmText: 'Xóa',
                onConfirm: () {
                  context.read<CcdcGroupBloc>().add(
                    DeleteCcdcGroupEvent(context, item.id!),
                  );
                },
              ),
            },
      ),
    ]);
  }
}
