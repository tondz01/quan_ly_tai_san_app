// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quan_ly_tai_san_app/common/button/action_button_config.dart';
import 'package:quan_ly_tai_san_app/common/popup/popup_confirm.dart';
import 'package:quan_ly_tai_san_app/common/table/tabale_base_view.dart';
import 'package:quan_ly_tai_san_app/common/table/table_base_config.dart';
import 'package:quan_ly_tai_san_app/common/widgets/column_display_popup.dart';
import 'package:quan_ly_tai_san_app/core/constants/app_colors.dart';
import 'package:quan_ly_tai_san_app/screen/type_asset/bloc/type_asset_bloc.dart';
import 'package:quan_ly_tai_san_app/screen/type_asset/bloc/type_asset_event.dart';
import 'package:quan_ly_tai_san_app/screen/type_asset/model/type_asset.dart';
import 'package:quan_ly_tai_san_app/screen/type_asset/provider/type_asset_provider.dart';
import 'package:se_gay_components/common/sg_text.dart';
import 'package:se_gay_components/common/table/sg_table_component.dart';

class TypeAssetList extends StatefulWidget {
  final TypeAssetProvider provider;
  const TypeAssetList({super.key, required this.provider});

  @override
  State<TypeAssetList> createState() => _TypeAssetListState();
}

class _TypeAssetListState extends State<TypeAssetList> {
  final ScrollController horizontalController = ScrollController();
  String searchTerm = "";

  List<TypeAsset> listSelected = [];

  late List<ColumnDisplayOption> columnOptions;
  List<String> visibleColumnIds = ['code', 'code_loai_ts', 'name_loai_ts', 'actions'];

  @override
  void initState() {
    super.initState();
    _initializeColumnOptions();
  }

  void _initializeColumnOptions() {
    columnOptions = [
      ColumnDisplayOption(
        id: 'code',
        label: 'Mã loại tài sản',
        isChecked: visibleColumnIds.contains('code'),
      ),
      ColumnDisplayOption(
        id: 'code_loai_ts',
        label: 'Mã loại tài sản cha',
        isChecked: visibleColumnIds.contains('code_loai_ts'),
      ),
      ColumnDisplayOption(
        id: 'name_loai_ts',
        label: 'Tên loại tài sản',
        isChecked: visibleColumnIds.contains('name_loai_ts'),
      ),
      ColumnDisplayOption(
        id: 'actions',
        label: 'Thao tác',
        isChecked: visibleColumnIds.contains('actions'),
      ),
    ];
  }

  List<SgTableColumn<TypeAsset>> _buildColumns() {
    final List<SgTableColumn<TypeAsset>> columns = [];

    for (String columnId in visibleColumnIds) {
      switch (columnId) {
        case 'code':
          columns.add(
            TableBaseConfig.columnTable<TypeAsset>(
              title: 'Mã loại tài sản',
              getValue: (item) => item.id ?? '',
              width: 120,
              titleAlignment: TextAlign.left,
            ),
          );
          break;
        case 'code_loai_ts':
          columns.add(
            TableBaseConfig.columnTable<TypeAsset>(
              title: 'Mã loại tài sản cha',
              getValue: (item) => item.idLoaiTs ?? '',
              width: 120,
              titleAlignment: TextAlign.left,
            ),
          );
          break;
        case 'name_loai_ts':
          columns.add(
            TableBaseConfig.columnTable<TypeAsset>(
              title: 'Tên loại tài sản',
              getValue: (item) => item.tenLoai ?? '',
              width: 120,
              titleAlignment: TextAlign.left,
            ),
          );
          break;
        case 'actions':
          columns.add(
            TableBaseConfig.columnWidgetBase<TypeAsset>(
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
    final List<SgTableColumn<TypeAsset>> columns = _buildColumns();

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
                        'Danh sách loại tài sản (${widget.provider.data.length})',
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
                            title: 'Xóa loại tài sản',
                            message:
                                'Bạn có chắc muốn xóa ${listSelected.length} loại tài sản',
                            highlight: listSelected.length.toString(),
                            cancelText: 'Không',
                            confirmText: 'Xóa',
                            onConfirm: () {
                              final bloc = context.read<TypeAssetBloc>();
                              bloc.add(DeleteTypeAssetBatchEvent(ids));
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
            child: TableBaseView<TypeAsset>(
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

  Widget viewAction(TypeAsset item) {
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
                title: 'Xóa loại tài sản',
                message: 'Bạn có chắc muốn xóa ${item.tenLoai}',
                highlight: item.tenLoai ?? '',
                cancelText: 'Không',
                confirmText: 'Xóa',
                onConfirm: () {
                  context.read<TypeAssetBloc>().add(
                    DeleteTypeAssetEvent(context, item.id!),
                  );
                },
              ),
            },
      ),
    ]);
  }
}
