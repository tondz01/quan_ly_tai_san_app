// ignore_for_file: deprecated_member_use

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:quan_ly_tai_san_app/common/popup/popup_confirm.dart';
import 'package:quan_ly_tai_san_app/common/table/tabale_base_view.dart';
import 'package:quan_ly_tai_san_app/common/table/table_base_config.dart';
import 'package:quan_ly_tai_san_app/common/widgets/column_display_popup.dart';
import 'package:quan_ly_tai_san_app/common/widgets/material_components.dart';
import 'package:quan_ly_tai_san_app/core/constants/app_colors.dart';
import 'package:quan_ly_tai_san_app/screen/tools_and_supplies/bloc/tools_and_supplies_bloc.dart';
import 'package:quan_ly_tai_san_app/screen/tools_and_supplies/bloc/tools_and_supplies_event.dart';
import 'package:quan_ly_tai_san_app/screen/tools_and_supplies/component/ownership_unit_details.dart';
import 'package:quan_ly_tai_san_app/screen/tools_and_supplies/model/tools_and_supplies_dto.dart';
import 'package:quan_ly_tai_san_app/screen/tools_and_supplies/provider/tools_and_supplies_provide.dart';
import 'package:se_gay_components/common/sg_colors.dart';
import 'package:se_gay_components/common/table/sg_table_component.dart';
import 'package:se_gay_components/common/sg_text.dart';

class ToolsAndSuppliesList extends StatefulWidget {
  final ToolsAndSuppliesProvider provider;
  const ToolsAndSuppliesList({super.key, required this.provider});

  @override
  State<ToolsAndSuppliesList> createState() => _ToolsAndSuppliesListState();
}

class _ToolsAndSuppliesListState extends State<ToolsAndSuppliesList> {
  final ScrollController horizontalController = ScrollController();

  ToolsAndSuppliesDto? selectedItem;
  List<ToolsAndSuppliesDto> selectedItems = [];

  String searchTerm = "";
  String titleDetailDepartmentTree = "";
  bool isShowDetailDepartmentTree = false;
  List<Map<String, DateTime Function(ToolsAndSuppliesDto)>> getters = [
    {'Ngày tạo': (item) => DateTime.tryParse(item.ngayTao) ?? DateTime.now()},
    {'Ngày cập nhật': (item) => DateTime.tryParse(item.ngayCapNhat) ?? DateTime.now()},
    {'Ngày nhập': (item) => DateTime.tryParse(item.ngayNhap) ?? DateTime.now()},
  ];

  // Column display options
  late List<ColumnDisplayOption> columnOptions;
  List<String> visibleColumnIds = [
    'id',
    'ten',
    'idDonVi',
    'ngayNhap',
    'donViTinh',
    'soLuong',
    'giaTri',
    'kyHieu',
    'actions',
  ];

  void _showDetailDepartmentTree(ToolsAndSuppliesDto item) {
    setState(() {
      selectedItem = item;
      titleDetailDepartmentTree = item.ten;
      isShowDetailDepartmentTree =
          item.chiTietTaiSanList.isNotEmpty &&
          item.detailOwnershipUnit.isNotEmpty;
    });
  }

  @override
  void initState() {
    super.initState();
    _initializeColumnOptions();
  }

  void _initializeColumnOptions() {
    columnOptions = [
      ColumnDisplayOption(
        id: 'id',
        label: 'Mã công cụ dụng cụ',
        isChecked: visibleColumnIds.contains('id'),
      ),
      ColumnDisplayOption(
        id: 'ten',
        label: 'Công cụ dụng cụ',
        isChecked: visibleColumnIds.contains('ten'),
      ),
      ColumnDisplayOption(
        id: 'idDonVi',
        label: 'Đơn vị nhập',
        isChecked: visibleColumnIds.contains('idDonVi'),
      ),
      ColumnDisplayOption(
        id: 'ngayNhap',
        label: 'Ngày nhập',
        isChecked: visibleColumnIds.contains('ngayNhap'),
      ),
      ColumnDisplayOption(
        id: 'donViTinh',
        label: 'Đơn vị tính',
        isChecked: visibleColumnIds.contains('donViTinh'),
      ),
      ColumnDisplayOption(
        id: 'soLuong',
        label: 'Số lượng',
        isChecked: visibleColumnIds.contains('soLuong'),
      ),
      ColumnDisplayOption(
        id: 'giaTri',
        label: 'Giá trị',
        isChecked: visibleColumnIds.contains('giaTri'),
      ),
      ColumnDisplayOption(
        id: 'kyHieu',
        label: 'Ký hiệu',
        isChecked: visibleColumnIds.contains('kyHieu'),
      ),
      ColumnDisplayOption(
        id: 'actions',
        label: 'Thao tác',
        isChecked: visibleColumnIds.contains('actions'),
      ),
    ];
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

  List<SgTableColumn<ToolsAndSuppliesDto>> _buildColumns() {
    final List<SgTableColumn<ToolsAndSuppliesDto>> columns = [];

    // Thêm cột dựa trên visibleColumnIds
    for (String columnId in visibleColumnIds) {
      switch (columnId) {
        case 'id':
          columns.add(
            TableBaseConfig.columnTable<ToolsAndSuppliesDto>(
              title: 'Mã công cụ dụng cụ',
              getValue: (item) => item.id,
              width: 170,
              searchValueGetter: (item) => item.id,
              filterable: true,
            ),
          );
          break;
        case 'ten':
          columns.add(
            TableBaseConfig.columnTable<ToolsAndSuppliesDto>(
              title: 'Công cụ dụng cụ',
              getValue: (item) => item.ten,
              width: 170,
              searchValueGetter: (item) => item.ten,
              filterable: true,
            ),
          );
          break;
        case 'idDonVi':
          columns.add(
            TableBaseConfig.columnTable<ToolsAndSuppliesDto>(
              title: 'Đơn vị nhập',
              getValue: (item) => item.idDonVi,
              width: 170,
              searchValueGetter: (item) => item.idDonVi,
              filterable: true,
            ),
          );
          break;

        case 'ngayNhap':
          columns.add(
            TableBaseConfig.columnTable<ToolsAndSuppliesDto>(
              title: 'Ngày nhập',
              getValue: (item) => item.ngayNhap.toString(),
              width: 120,
              filterable: true,
            ),
          );
          break;
        case 'donViTinh':
          columns.add(
            TableBaseConfig.columnTable<ToolsAndSuppliesDto>(
              title: 'Đơn vị tính',
              getValue: (item) => item.donViTinh,
              width: 120,
              searchValueGetter: (item) => item.donViTinh,
              filterable: true,
            ),
          );
          break;
        case 'soLuong':
          columns.add(
            TableBaseConfig.columnTable<ToolsAndSuppliesDto>(
              title: 'Số lượng',
              getValue: (item) => item.soLuong.toString(),
              width: 120,
              searchValueGetter: (item) => item.soLuong.toString(),
              filterable: true,
            ),
          );
          break;
        case 'giaTri':
          columns.add(
            TableBaseConfig.columnTable<ToolsAndSuppliesDto>(
              title: 'Giá trị',
              getValue:
                  (item) => NumberFormat.currency(
                    locale: 'vi_VN',
                    symbol: '',
                  ).format(item.giaTri),
              width: 120,
              searchValueGetter: (item) => item.giaTri.toString(),
              filterable: true,
            ),
          );
          break;
        case 'kyHieu':
          columns.add(
            TableBaseConfig.columnTable<ToolsAndSuppliesDto>(
              title: 'Ký hiệu',
              getValue: (item) => item.kyHieu,
              width: 120,
              searchValueGetter: (item) => item.kyHieu,
              filterable: true,
            ),
          );
          break;
        case 'actions':
          columns.add(
            TableBaseConfig.columnWidgetBase<ToolsAndSuppliesDto>(
              title: 'Thao tác',
              cellBuilder:
                  (item) => TableBaseConfig.viewActionBase<ToolsAndSuppliesDto>(
                    item: item,
                    onDelete: (item) {
                      // widget.onDelete?.call(item);
                      showConfirmDialog(
                        context,
                        type: ConfirmType.delete,
                        title: 'Xóa CCDC - Vật Tư?',
                        message: 'Bạn có chắc muốn xóa ${item.ten}',
                        highlight: item.ten,
                        cancelText: 'Không',
                        confirmText: 'Xóa',
                        onConfirm: () {
                          List<String> listIdAssetDetail =
                              item.chiTietTaiSanList
                                  .where(
                                    (detail) =>
                                        detail.id != null &&
                                        detail.id!.isNotEmpty,
                                  )
                                  .map((detail) => detail.id!)
                                  .toList();

                          final jsonIdAssetDetail = jsonEncode(
                            listIdAssetDetail,
                          );

                          context.read<ToolsAndSuppliesBloc>().add(
                            DeleteToolsAndSuppliesEvent(
                              item.id,
                              jsonIdAssetDetail,
                            ),
                          );
                        },
                      );
                    },
                  ),
              width: 120,
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
    final columns = _buildColumns();

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
      child: Row(
        children: [
          Expanded(
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
                        children: [
                          Icon(
                            Icons.table_chart,
                            color: Colors.grey.shade600,
                            size: 18,
                          ),
                          SizedBox(width: 8),
                          Text(
                            'Quản lý CCDC - Vật tư (${widget.provider.data?.length ?? 0})',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey.shade700,
                            ),
                          ),
                          SizedBox(width: 8),
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

                      Row(
                        spacing: 16,
                        children: [
                          Visibility(
                            visible: selectedItems.isNotEmpty,
                            child: Row(
                              children: [
                                SGText(
                                  text:
                                      'Danh sách CCDC - Vật tư đã chọn: ${selectedItems.length}',
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
                                    List<String> data =
                                        selectedItems
                                            .map((e) => e.id)
                                            .whereType<String>()
                                            .toList();
                                    showConfirmDialog(
                                      context,
                                      type: ConfirmType.delete,
                                      title: 'Xóa CCDC - Vật tư',
                                      message:
                                          'Bạn có chắc muốn xóa ${selectedItems.length} CCDC - Vật tư đã chọn',
                                      highlight:
                                          selectedItems.length.toString(),
                                      cancelText: 'Không',
                                      confirmText: 'Xóa',
                                      onConfirm: () {
                                        final roleBloc =
                                            context
                                                .read<ToolsAndSuppliesBloc>();
                                        roleBloc.add(
                                          DeleteAssetBatchEvent(data),
                                        );
                                      },
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      // FindByStateAssetHandover(provider: widget.provider),
                    ],
                  ),
                ),
                Divider(
                  height: 1,
                  thickness: 1,
                  color: SGAppColors.colorBorderGray.withValues(alpha: 0.3),
                ),
                Expanded(
                  child:
                      widget.provider.dataPage != null
                          ? TableBaseView<ToolsAndSuppliesDto>(
                            searchTerm: '',
                            columns: columns,
                            data: widget.provider.dataPage!,
                            horizontalController: ScrollController(),
                            getters: getters,
                            startDate: DateTime.tryParse(
                              widget.provider.dataPage!.isNotEmpty
                                  ? widget.provider.dataPage!.first.ngayTao
                                      .toString()
                                  : '',
                            ),
                            onRowTap: (item) {
                              widget.provider.onChangeDetail(context, item);
                              setState(() {
                                _showDetailDepartmentTree(item);
                              });
                            },
                            onSelectionChanged: (items) {
                              setState(() {
                                selectedItems = items;
                              });
                            },
                          )
                          : const Center(
                            child: Text('Không có dữ liệu để hiển thị'),
                          ),
                ),
              ],
            ),
          ),

          // Department tree sidebar
          Visibility(
            visible: isShowDetailDepartmentTree,
            child: OwnershipUnitDetails(
              title: 'Chi tiết đơn vị sở hữu "${selectedItem?.ten}"',
              item: selectedItem ?? ToolsAndSuppliesDto.empty(),
              provider: widget.provider,
              onHiden: () {
                setState(() {
                  isShowDetailDepartmentTree = false;
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}
