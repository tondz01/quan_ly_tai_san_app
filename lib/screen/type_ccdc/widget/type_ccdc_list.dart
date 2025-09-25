// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quan_ly_tai_san_app/common/button/action_button_config.dart';
import 'package:quan_ly_tai_san_app/common/popup/popup_confirm.dart';
import 'package:quan_ly_tai_san_app/common/table/tabale_base_view.dart';
import 'package:quan_ly_tai_san_app/common/table/table_base_config.dart';
import 'package:quan_ly_tai_san_app/common/widgets/column_display_popup.dart';
import 'package:quan_ly_tai_san_app/core/constants/app_colors.dart';
import 'package:quan_ly_tai_san_app/screen/type_ccdc/bloc/type_ccdc_bloc.dart';
import 'package:quan_ly_tai_san_app/screen/type_ccdc/bloc/type_ccdc_event.dart';
import 'package:quan_ly_tai_san_app/screen/type_ccdc/model/type_ccdc.dart';
import 'package:quan_ly_tai_san_app/screen/type_ccdc/provider/type_ccdc_provider.dart';
import 'package:se_gay_components/common/sg_text.dart';
import 'package:se_gay_components/common/table/sg_table_component.dart';

class TypeCcdcList extends StatefulWidget {
  final TypeCcdcProvider provider;
  const TypeCcdcList({super.key, required this.provider});

  @override
  State<TypeCcdcList> createState() => _TypeCcdcListState();
}

class _TypeCcdcListState extends State<TypeCcdcList> {
  final ScrollController horizontalController = ScrollController();
  String searchTerm = "";

  List<TypeCcdc> listSelected = [];

  late List<ColumnDisplayOption> columnOptions;
  List<String> visibleColumnIds = [
    'code',
    'code_loai_ccdc',
    'name_loai_ccdc',
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
        id: 'code',
        label: 'Mã loại CCDC',
        isChecked: visibleColumnIds.contains('code'),
      ),
      ColumnDisplayOption(
        id: 'code_loai_ccdc',
        label: 'Mã loại CCDC cha',
        isChecked: visibleColumnIds.contains('code_loai_ccdc'),
      ),
      ColumnDisplayOption(
        id: 'name_loai_ccdc',
        label: 'Tên loại CCDC',
        isChecked: visibleColumnIds.contains('name_loai_ccdc'),
      ),

      ColumnDisplayOption(
        id: 'actions',
        label: 'Thao tác',
        isChecked: visibleColumnIds.contains('actions'),
      ),
    ];
  }

  List<SgTableColumn<TypeCcdc>> _buildColumns() {
    final List<SgTableColumn<TypeCcdc>> columns = [];

    for (String columnId in visibleColumnIds) {
      switch (columnId) {
        case 'code':
          columns.add(
            TableBaseConfig.columnTable<TypeCcdc>(
              title: 'Mã loại CCDC',
              getValue: (item) => item.id ?? '',
              width: 80,
              titleAlignment: TextAlign.left,
            ),
          );
          break;
        case 'code_loai_ccdc':
          columns.add(
            TableBaseConfig.columnTable<TypeCcdc>(
              title: 'Mã loại CCDC cha',
              getValue: (item) => item.idLoaiCCDC ?? '',
              width: 80,
              titleAlignment: TextAlign.left,
            ),
          );
          break;
        case 'name_loai_ccdc':
          columns.add(
            TableBaseConfig.columnTable<TypeCcdc>(
              title: 'Tên loại CCDC',
              getValue: (item) => item.tenLoai ?? '',
              width: 80,
              titleAlignment: TextAlign.left,
            ),
          );
          break;
        case 'actions':
          columns.add(
            TableBaseConfig.columnWidgetBase<TypeCcdc>(
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
    final List<SgTableColumn<TypeCcdc>> columns = _buildColumns();

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
                        'Danh sách loại CCDC (${widget.provider.data.length})',
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
                        text: 'Danh sách đã chọn: ${listSelected.length}',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey.shade700,
                        ),
                      ),
                      SizedBox(width: 16),
                      IconButton(
                        onPressed: () {
                          final ids = listSelected.map((e) => e.id!).toList();
                          showConfirmDialog(
                            context,
                            type: ConfirmType.delete,
                            title: 'Xóa loại CCDC',
                            message:
                                'Bạn có chắc muốn xóa ${listSelected.length} loại CCDC',
                            highlight: listSelected.length.toString(),
                            cancelText: 'Không',
                            confirmText: 'Xóa',
                            onConfirm: () {
                              final bloc = context.read<TypeCcdcBloc>();
                              bloc.add(DeleteTypeCcdcBatchEvent(ids));
                            },
                          );
                        },
                        icon: Icon(Icons.delete, color: Colors.grey.shade700),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: TableBaseView<TypeCcdc>(
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

  Widget viewAction(TypeCcdc item) {
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
                title: 'Xóa loại CCDC',
                message: 'Bạn có chắc muốn xóa ${item.tenLoai}',
                highlight: item.tenLoai ?? '',
                cancelText: 'Không',
                confirmText: 'Xóa',
                onConfirm: () {
                  context.read<TypeCcdcBloc>().add(
                    DeleteTypeCcdcEvent(context, item.id!),
                  );
                },
              ),
            },
      ),
    ]);
  }
}
