// ignore_for_file: deprecated_member_use

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:quan_ly_tai_san_app/common/table/tabale_base_view.dart';
import 'package:quan_ly_tai_san_app/common/table/table_base_config.dart';
import 'package:quan_ly_tai_san_app/common/widgets/column_display_popup.dart';
import 'package:quan_ly_tai_san_app/core/constants/app_colors.dart';
import 'package:quan_ly_tai_san_app/screen/asset_group/model/asset_group_dto.dart';
import 'package:quan_ly_tai_san_app/screen/asset_group/provider/asset_group_provide.dart';
import 'package:se_gay_components/common/switch/sg_checkbox.dart';
import 'package:se_gay_components/common/table/sg_table_component.dart';

class AssetGroupList extends StatefulWidget {
  final AssetGroupProvider provider;
  const AssetGroupList({super.key, required this.provider});

  @override
  State<AssetGroupList> createState() => _AssetGroupListState();
}

class _AssetGroupListState extends State<AssetGroupList> {
  final ScrollController horizontalController = ScrollController();
  String searchTerm = "";

  // Column display options
  late List<ColumnDisplayOption> columnOptions;
  List<String> visibleColumnIds = [
    'asset_group',
    'code_asset_group',
    'name_asset_group',
    'is_active',
    // 'created_at',
    // 'updated_at',
    // 'created_by',
    // 'updated_by',
  ];

  @override
  void initState() {
    super.initState();
    _initializeColumnOptions();
  }

  void _initializeColumnOptions() {
    columnOptions = [
      ColumnDisplayOption(
        id: 'asset_group',
        label: 'Nhóm tài sản',
        isChecked: visibleColumnIds.contains('asset_group'),
      ),
      ColumnDisplayOption(
        id: 'code_asset_group',
        label: 'Mã nhóm tài sản',
        isChecked: visibleColumnIds.contains('code_asset_group'),
      ),
      ColumnDisplayOption(
        id: 'name_asset_group',
        label: 'Tên nhóm tài sản',
        isChecked: visibleColumnIds.contains('name_asset_group'),
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
    ];
  }

  List<SgTableColumn<AssetGroupDto>> _buildColumns() {
    final List<SgTableColumn<AssetGroupDto>> columns = [];

    // Thêm cột dựa trên visibleColumnIds
    for (String columnId in visibleColumnIds) {
      switch (columnId) {
        case 'asset_group':
          columns.add(
            TableBaseConfig.columnTable<AssetGroupDto>(
              title: 'Nhóm tài sản',
              getValue: (item) => "${item.id} - ${item.tenNhom}",
              width: 170,
            ),
          );
          break;
        case 'code_asset_group':
          columns.add(
            TableBaseConfig.columnTable<AssetGroupDto>(
              title: 'Mã nhóm tài sản',
              getValue: (item) => item.id ?? '',
              width: 120,
            ),
          );
          break;
        case 'name_asset_group':
          columns.add(
            TableBaseConfig.columnTable<AssetGroupDto>(
              title: 'Tên nhóm tài sản',
              getValue: (item) => item.tenNhom ?? '',
              width: 120,
            ),
          );
          break;
        case 'is_active':
          columns.add(
            TableBaseConfig.columnWidgetBase<AssetGroupDto>(
              title: 'Có hiệu lực',
              width: 100,
              cellBuilder: (item) => SgCheckbox(value: item.isActive ?? false),
            ),
          );
          break;
        case 'created_at':
          columns.add(
            TableBaseConfig.columnTable<AssetGroupDto>(
              title: 'Ngày tạo',
              getValue: (item) => item.ngayTao.toString(),
              width: 120,
            ),
          );
          break;
        case 'updated_at':
          columns.add(
            TableBaseConfig.columnTable<AssetGroupDto>(
              title: 'Ngày cập nhật',
              getValue: (item) => item.ngayCapNhat.toString(),
              width: 120,
            ),
          );
          break;
        case 'created_by':
          columns.add(
            TableBaseConfig.columnTable<AssetGroupDto>(
              title: 'Người tạo',
              getValue: (item) => item.nguoiTao.toString(),
              width: 120,
            ),
          );
          break;
        case 'updated_by':
          columns.add(
            TableBaseConfig.columnTable<AssetGroupDto>(
              title: 'Người cập nhật',
              getValue: (item) => item.nguoiCapNhat.toString(),
              width: 120,
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
        // Reset về trạng thái ban đầu
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
    final List<SgTableColumn<AssetGroupDto>> columns = _buildColumns();

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
                        'Biên bản bàn giao tài sản (${widget.provider.data.length})',
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
              ],
            ),
          ),
          Expanded(
            child: TableBaseView<AssetGroupDto>(
              searchTerm: '',
              columns: columns,
              data: widget.provider.dataPage ?? [],
              horizontalController: ScrollController(),
              onRowTap: (item) {
                log('message onRowTap: ${item.toJson()}');
                widget.provider.onChangeDetail(item);
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

  String getNameColumnAssetGroup(AssetGroupDto item) {
    return "${item.id} - ${item.tenNhom}";
  }
}
