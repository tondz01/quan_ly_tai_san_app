// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quan_ly_tai_san_app/common/button/action_button_config.dart';
import 'package:quan_ly_tai_san_app/common/popup/popup_confirm.dart';
import 'package:quan_ly_tai_san_app/common/table/tabale_base_view.dart';
import 'package:quan_ly_tai_san_app/common/table/table_base_config.dart';
import 'package:quan_ly_tai_san_app/common/widgets/column_display_popup.dart';
import 'package:quan_ly_tai_san_app/core/constants/app_colors.dart';
import 'package:quan_ly_tai_san_app/screen/asset_category/bloc/asset_category_bloc.dart';
import 'package:quan_ly_tai_san_app/screen/asset_category/bloc/asset_category_event.dart';
import 'package:quan_ly_tai_san_app/screen/asset_category/model/asset_category_dto.dart';
import 'package:quan_ly_tai_san_app/screen/asset_category/provider/asset_category_provide.dart';
import 'package:se_gay_components/common/switch/sg_checkbox.dart';
import 'package:se_gay_components/common/table/sg_table_component.dart';

class AssetCategoryList extends StatefulWidget {
  final AssetCategoryProvider provider;
  const AssetCategoryList({super.key, required this.provider});

  @override
  State<AssetCategoryList> createState() => _AssetCategoryListState();
}

class _AssetCategoryListState extends State<AssetCategoryList> {
  final ScrollController horizontalController = ScrollController();
  String searchTerm = "";

  // Column display options
  late List<ColumnDisplayOption> columnOptions;
  List<String> visibleColumnIds = [
    // 'id',
    'tenMoHinh',
    'phuongPhapKhauHao',
    'kyKhauHao',
    'loaiKyKhauHao',
    'taiKhoanTaiSan',
    'taiKhoanKhauHao',
    'taiKhoanChiPhi',
    'actions',
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
        id: 'id',
        label: 'Mã mô hình tài sản',
        isChecked: visibleColumnIds.contains('id'),
      ),
      ColumnDisplayOption(
        id: 'tenMoHinh',
        label: 'Tên mô hình tài sản',
        isChecked: visibleColumnIds.contains('id'),
      ),
      ColumnDisplayOption(
        id: 'phuongPhapKhauHao',
        label: 'Phương pháp khấu hao',
        isChecked: visibleColumnIds.contains('phuongPhapKhauHao'),
      ),
      ColumnDisplayOption(
        id: 'kyKhauHao',
        label: 'Kỳ khấu hao',
        isChecked: visibleColumnIds.contains('kyKhauHao'),
      ),
      ColumnDisplayOption(
        id: 'loaiKyKhauHao',
        label: 'Loại kỳ khấu hao',
        isChecked: visibleColumnIds.contains('loaiKyKhauHao'),
      ),
      ColumnDisplayOption(
        id: 'taiKhoanTaiSan',
        label: 'Tài khoản tài sản',
        isChecked: visibleColumnIds.contains('taiKhoanTaiSan'),
      ),
      ColumnDisplayOption(
        id: 'taiKhoanKhauHao',
        label: 'Tài khoản khấu hao',
        isChecked: visibleColumnIds.contains('taiKhoanKhauHao'),
      ),
      ColumnDisplayOption(
        id: 'taiKhoanChiPhi',
        label: 'Tài khoản chi phí',
        isChecked: visibleColumnIds.contains('taiKhoanChiPhi'),
      ),
      ColumnDisplayOption(
        id: 'actions',
        label: 'Thao tác',
        isChecked: visibleColumnIds.contains('actions'),
      ),
    ];
  }

  List<SgTableColumn<AssetCategoryDto>> _buildColumns() {
    final List<SgTableColumn<AssetCategoryDto>> columns = [];

    // Thêm cột dựa trên visibleColumnIds
    for (String columnId in visibleColumnIds) {
      switch (columnId) {
        case 'id':
          columns.add(
            TableBaseConfig.columnTable<AssetCategoryDto>(
              title: 'Mã mô hình tài sản',
              getValue: (item) => item.id ?? "",
              width: 170,
            ),
          );
          break;
        case 'tenMoHinh':
          columns.add(
            TableBaseConfig.columnTable<AssetCategoryDto>(
              title: 'Tên mô hình tài sản',
              getValue: (item) => item.tenMoHinh ?? '',
              width: 120,
            ),
          );
          break;
        case 'phuongPhapKhauHao':
          columns.add(
            TableBaseConfig.columnTable<AssetCategoryDto>(
              title: 'Phương pháp khấu hao',
              getValue:
                  (item) => getDepreciationMethod(item.phuongPhapKhauHao!),
              width: 120,
            ),
          );
          break;
        case 'kyKhauHao':
          columns.add(
            TableBaseConfig.columnTable<AssetCategoryDto>(
              title: 'Kỳ khấu hao',
              getValue: (item) => item.kyKhauHao.toString(),
              width: 100,
            ),
          );
          break;
        case 'loaiKyKhauHao':
          columns.add(
            TableBaseConfig.columnTable<AssetCategoryDto>(
              title: 'Loại kỳ khấu hao',
              getValue: (item) => item.loaiKyKhauHao.toString(),
              width: 120,
            ),
          );
          break;
        case 'taiKhoanTaiSan':
          columns.add(
            TableBaseConfig.columnTable<AssetCategoryDto>(
              title: 'Tài khoản tài sản',
              getValue: (item) => item.taiKhoanTaiSan.toString(),
              width: 120,
            ),
          );
          break;
        case 'taiKhoanKhauHao':
          columns.add(
            TableBaseConfig.columnTable<AssetCategoryDto>(
              title: 'Tài khoản khấu hao',
              getValue: (item) => item.taiKhoanKhauHao.toString(),
              width: 120,
            ),
          );
          break;
        case 'taiKhoanChiPhi':
          columns.add(
            TableBaseConfig.columnTable<AssetCategoryDto>(
              title: 'Tài khoản chi phí',
              getValue: (item) => item.taiKhoanChiPhi.toString(),
              width: 120,
            ),
          );
          break;
        case 'actions':
          columns.add(
            TableBaseConfig.columnWidgetBase<AssetCategoryDto>(
              title: '',
              cellBuilder: (item) => viewAction(context, item),
              width: 120,
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
    final List<SgTableColumn<AssetCategoryDto>> columns = _buildColumns();

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
            child: TableBaseView<AssetCategoryDto>(
              searchTerm: '',
              columns: columns,
              data: widget.provider.dataPage ?? [],
              horizontalController: ScrollController(),
              onRowTap: (item) {
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

  String getDepreciationMethod(int type) {
    String nameDepreciationMethod = 'Đường thẳng';
    switch (type) {
      case 1:
        nameDepreciationMethod = 'Đường thẳng';
    }
    return nameDepreciationMethod;
  }

  Widget viewAction(BuildContext context, AssetCategoryDto item) {
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
                message: 'Bạn có chắc muốn xóa ${item.tenMoHinh}',
                highlight: item.tenMoHinh!,
                cancelText: 'Không',
                confirmText: 'Xóa',
                onConfirm: () {
                  context.read<AssetCategoryBloc>().add(
                    DeleteAssetCategoryEvent(context, item.id!),
                  );
                },
              ),
            },
      ),
    ]);
  }
}
