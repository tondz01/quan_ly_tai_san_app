import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/utils.dart';
import 'package:intl/intl.dart';
import 'package:quan_ly_tai_san_app/common/popup/popup_confirm.dart';
import 'package:quan_ly_tai_san_app/screen/tools_and_supplies/bloc/tools_and_supplies_bloc.dart';
import 'package:quan_ly_tai_san_app/screen/tools_and_supplies/bloc/tools_and_supplies_event.dart';
import 'package:quan_ly_tai_san_app/screen/tools_and_supplies/component/ownership_unit_details.dart';
import 'package:quan_ly_tai_san_app/screen/tools_and_supplies/component/table_tools_and_supplies_config.dart';
import 'package:quan_ly_tai_san_app/screen/tools_and_supplies/model/tools_and_supplies_dto.dart';
import 'package:quan_ly_tai_san_app/screen/tools_and_supplies/provider/table_tools_and_supplies_provider.dart';
import 'package:quan_ly_tai_san_app/screen/tools_and_supplies/provider/tools_and_supplies_provide.dart';
import 'package:se_gay_components/core/utils/sg_log.dart';
import 'package:table_base/core/themes/app_color.dart';
import 'package:table_base/core/themes/app_icon_svg.dart';
import 'package:table_base/widgets/box_search.dart';
import 'package:table_base/widgets/responsive_button_bar/responsive_button_bar.dart';
import 'package:table_base/widgets/table/models/column_definition.dart';
import 'package:table_base/widgets/table/models/table_model.dart';
import 'package:table_base/widgets/table/widgets/column_config_dialog.dart';
import 'package:table_base/widgets/table/widgets/riverpod_table.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' as riverpod;

class ToolsAndSuppliesList extends StatefulWidget {
  final ToolsAndSuppliesProvider provider;
  const ToolsAndSuppliesList({super.key, required this.provider});

  @override
  State<ToolsAndSuppliesList> createState() => _ToolsAndSuppliesListState();
}

class _ToolsAndSuppliesListState extends State<ToolsAndSuppliesList> {
  final ScrollController horizontalController = ScrollController();

  ToolsAndSuppliesDto? selectedItem;
  List<ToolsAndSuppliesDto> listSelected = [];

  String titleDetailDepartmentTree = "";
  bool isShowDetailDepartmentTree = false;

  // Table configuration
  late List<ColumnDefinition> _definitions;
  late List<TableColumnData> _columns;
  late List<TableColumnData> _allColumns;
  late Map<String, TableCellBuilder> _buildersByKey;
  late List<String> _hiddenKeys;

  @override
  void initState() {
    super.initState();
    _initializeTableConfig();
  }

  void _initializeTableConfig() {
    _definitions = TableToolsAndSuppliesConfig.getColumns();
    _columns = _definitions.map((d) => d.config).toList(growable: true);
    _allColumns = List<TableColumnData>.from(_columns);
    _buildersByKey = {for (final d in _definitions) d.config.key: d.builder};
    _hiddenKeys = <String>[];
  }

  void _showDetailDepartmentTree(ToolsAndSuppliesDto item) {
    setState(() {
      selectedItem = item;
      titleDetailDepartmentTree = item.ten;
      isShowDetailDepartmentTree =
          item.chiTietTaiSanList.isNotEmpty &&
          item.detailOwnershipUnit.isNotEmpty;
    });
  }

  String _fmtDate(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return '';
    try {
      final date = DateTime.tryParse(dateStr);
      if (date == null) return dateStr;
      final dd = date.day.toString().padLeft(2, '0');
      final mm = date.month.toString().padLeft(2, '0');
      final yyyy = date.year.toString();
      return '$dd/$mm/$yyyy';
    } catch (e) {
      return dateStr;
    }
  }

  String _fmtNum(double? value) {
    if (value == null) return '';
    try {
      final NumberFormat _vnNumber = NumberFormat('#,##0', 'vi_VN');
      return _vnNumber.format(value);
    } catch (e) {
      return value.toString();
    }
  }

  dynamic getValueForColumn(ToolsAndSuppliesDto item, int columnIndex) {
    final int offset = 1; // showCheckboxColumn
    final int adjustedIndex = columnIndex - offset;

    if (adjustedIndex < 0 || adjustedIndex >= _columns.length) {
      return null;
    }

    final String key = _columns[adjustedIndex].key;
    switch (key) {
      case 'id':
        return item.id;
      case 'ten':
        return item.ten;
      case 'tenDonVi':
        return item.tenDonVi;
      case 'tenNhomCCDC':
        return item.tenNhomCCDC;
      case 'ngayNhap':
        return _fmtDate(item.ngayNhap);
      case 'donViTinh':
        return item.donViTinh;
      case 'soLuong':
        return item.soLuong.toString();
      case 'giaTri':
        return _fmtNum(item.giaTri);
      case 'kyHieu':
        return item.kyHieu;
      case 'congSuat':
        return item.congSuat;
      case 'nuocSanXuat':
        return item.nuocSanXuat;
      case 'namSanXuat':
        return item.namSanXuat.toString();
      case 'soKyHieu':
        return item.soKyHieu;
      case 'ghiChu':
        return item.ghiChu;
      case 'nguoiTao':
        return item.nguoiTao;
      case 'ngayTao':
        return _fmtDate(item.ngayTao);
      case 'isActive':
        return item.isActive ? 'Hoạt động' : 'Không hoạt động';
      default:
        return null;
    }
  }

  Future<void> _openColumnConfigDialog() async {
    try {
      final apply = await showColumnConfigAndApply(
        context: context,
        allColumns: _allColumns,
        currentColumns: _columns,
        initialHiddenKeys: _hiddenKeys,
        title: 'table.config_column'.tr,
      );
      if (apply != null) {
        setState(() {
          _hiddenKeys = apply.hiddenKeys;
          _columns = apply.updatedColumns;
        });
      }
    } catch (e) {
      SGLog.error('ColumnConfigDialog', 'Error at _openColumnConfigDialog: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final data = widget.provider.data ?? <ToolsAndSuppliesDto>[];

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
                            'Quản lý CCDC - Vật tư (${data.length})',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey.shade700,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final availableWidth = constraints.maxWidth;
                      return Row(
                        children: [
                          riverpod.Consumer(
                            builder: (context, ref, _) {
                              return BoxSearch(
                                width: (availableWidth * 0.30).toDouble(),
                                onSearch: (value) {
                                  ref
                                      .read(
                                        tableToolsAndSuppliesProvider.notifier,
                                      )
                                      .searchTerm = value;
                                },
                              );
                            },
                          ),
                          SizedBox(width: 16),
                          SizedBox(
                            width: (availableWidth * 0.65).toDouble(),
                            child: riverpod.Consumer(
                              builder: (context, ref, _) {
                                final hasFilters = ref.watch(
                                  tableToolsAndSuppliesProvider.select(
                                    (s) => s.filterState.hasActiveFilters,
                                  ),
                                );
                                final tableState = ref.watch(
                                  tableToolsAndSuppliesProvider,
                                );
                                final selectedCount =
                                    tableState.selectedItems.length;
                                listSelected = tableState.selectedItems;
                                final buttons = _buildButtonList(selectedCount);
                                final processedButtons =
                                    buttons.map((button) {
                                      if (button.text == 'Xóa bộ lọc') {
                                        return ResponsiveButtonData.fromButtonIcon(
                                          text: button.text,
                                          iconPath: button.iconPath!,
                                          backgroundColor:
                                              button.backgroundColor!,
                                          iconColor: button.iconColor!,
                                          textColor: button.textColor!,
                                          width: button.width,
                                          onPressed: () {
                                            ref
                                                .read(
                                                  tableToolsAndSuppliesProvider
                                                      .notifier,
                                                )
                                                .clearAllFilters();
                                          },
                                        );
                                      }
                                      return button;
                                    }).toList();

                                final filteredButtons =
                                    hasFilters
                                        ? processedButtons
                                        : processedButtons
                                            .where(
                                              (button) =>
                                                  button.text != 'Xóa bộ lọc',
                                            )
                                            .toList();

                                return ResponsiveButtonBar(
                                  buttons: filteredButtons,
                                  spacing: 12,
                                  overflowSide: OverflowSide.start,
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  popupPosition: PopupMenuPosition.under,
                                  popupOffset: const Offset(0, 8),
                                  popupShape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  popupElevation: 6,
                                  moreLabel: 'Khác',
                                );
                              },
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
                Expanded(
                  child: riverpod.Consumer(
                    builder: (context, ref, child) {
                      ref
                          .read(tableToolsAndSuppliesProvider.notifier)
                          .setData(data);

                      return data.isEmpty
                          ? const Center(
                            child: Text('Không có dữ liệu để hiển thị'),
                          )
                          : RiverpodTable<ToolsAndSuppliesDto>(
                            tableProvider: tableToolsAndSuppliesProvider,
                            columns: _columns,
                            showCheckboxColumn: true,
                            enableRowSelection: true,
                            enableRowHover: true,
                            showAlternatingRowColors: true,
                            valueGetter: getValueForColumn,
                            cellsBuilder: (_) => [],
                            cellBuilderByKey: (item, key) {
                              final builder = _buildersByKey[key];
                              if (builder != null) return builder(item);
                              return null;
                            },
                            onRowTap: (item) {
                              widget.provider.onChangeDetail(context, item);
                              setState(() {
                                _showDetailDepartmentTree(item);
                              });
                            },
                            showActionsColumn: false,
                            maxHeight: MediaQuery.of(context).size.height * 0.6,
                          );
                    },
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

  List<ResponsiveButtonData> _buildButtonList(int itemCount) {
    return [
      // Configure columns button
      ResponsiveButtonData.fromButtonIcon(
        text: 'table.config_column'.tr,
        iconPath: AppIconSvg.iconSetting,
        backgroundColor: AppColor.white,
        iconColor: AppColor.textDark,
        textColor: AppColor.textDark,
        width: 130,
        onPressed: () {
          _openColumnConfigDialog();
        },
      ),
      if (itemCount > 0)
        ResponsiveButtonData.fromButtonIcon(
          text: '$itemCount ${'table.delete_selected'.tr}',
          iconPath: AppIconSvg.iconSetting,
          backgroundColor: Colors.redAccent,
          iconColor: AppColor.textWhite,
          textColor: AppColor.textWhite,
          width: 130,
          onPressed: () {
            final ids = listSelected.map((e) => e.id).toList();
            showConfirmDialog(
              context,
              type: ConfirmType.delete,
              title: 'Xóa loại CCDC',
              message: 'Bạn có chắc muốn xóa ${listSelected.length} loại CCDC',
              highlight: listSelected.length.toString(),
              cancelText: 'Không',
              confirmText: 'Xóa',
              onConfirm: () {
                final bloc = context.read<ToolsAndSuppliesBloc>();
                bloc.add(DeleteAssetBatchEvent(ids));
              },
            );
          },
        ),
    ];
  }
}
