// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/utils.dart';
import 'package:quan_ly_tai_san_app/common/popup/popup_confirm.dart';
import 'package:quan_ly_tai_san_app/core/constants/app_colors.dart';
import 'package:quan_ly_tai_san_app/routes/routes.dart';
import 'package:quan_ly_tai_san_app/screen/asset_group/model/asset_group_dto.dart';
import 'package:quan_ly_tai_san_app/screen/asset_management/bloc/asset_management_bloc.dart';
import 'package:quan_ly_tai_san_app/screen/asset_management/bloc/asset_management_event.dart';
import 'package:quan_ly_tai_san_app/screen/asset_management/component/item_asset_group.dart';
import 'package:quan_ly_tai_san_app/screen/asset_management/component/table_asset_management_config.dart';
import 'package:quan_ly_tai_san_app/screen/asset_management/model/asset_management_dto.dart';
import 'package:quan_ly_tai_san_app/screen/asset_management/provider/asset_management_provider.dart';
import 'package:quan_ly_tai_san_app/screen/asset_management/provider/table_asset_management_provider.dart';
import 'package:se_gay_components/common/sg_text.dart';
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

class AssetManagementList extends StatefulWidget {
  const AssetManagementList({super.key, required this.provider});
  final AssetManagementProvider provider;

  @override
  State<AssetManagementList> createState() => _AssetManagementListState();
}

class _AssetManagementListState extends State<AssetManagementList> {
  List<AssetManagementDto> listSelected = [];

  // Table configuration
  late List<ColumnDefinition> _definitions;
  late List<TableColumnData> _columns;
  late List<TableColumnData> _allColumns;
  late Map<String, TableCellBuilder> _buildersByKey;
  late List<String> _hiddenKeys;

  ScrollController horizontalController = ScrollController();

  @override
  void initState() {
    super.initState();
    _initializeTableConfig();
  }

  void _initializeTableConfig() {
    _definitions = TableAssetManagementConfig.getColumns(widget.provider);
    _columns = _definitions.map((d) => d.config).toList(growable: true);
    _allColumns = List<TableColumnData>.from(_columns);
    _buildersByKey = {for (final d in _definitions) d.config.key: d.builder};
    _hiddenKeys = <String>[];
  }

  dynamic getValueForColumn(AssetManagementDto item, int columnIndex) {
    final int offset = 1; // showCheckboxColumn
    final int adjustedIndex = columnIndex - offset;

    if (adjustedIndex < 0 || adjustedIndex >= _columns.length) {
      return null;
    }

    final String key = _columns[adjustedIndex].key;
    switch (key) {
      case 'code_asset':
        return item.soThe;
      case 'so_the':
        return item.id;
      case 'name_asset':
        return item.tenTaiSan;
      case 'book_entry_date':
        return item.ngayVaoSo;
      case 'von_ns':
        return item.vonNS;
      case 'von_vay':
        return item.vonVay;
      case 'von_khac':
        return item.vonKhac;
      case 'usage_start_date':
        return item.ngaySuDung;
      case 'using_unit':
        return item.tenNhom; // Đơn vị sử dụng
      case 'so_luong_ts_con':
        return widget.provider
            .getListChildAssetsByIdAsset(item.id ?? '')
            .length
            .toString(); // Số lượng
      case 'nhom_tai_san':
        return item.tenNhom; // Nhóm tài sản
      case 'loai_tai_san':
        return item.tenNhom; // Loại tài sản
      case 'hien_trang':
        try {
          return widget.provider.getHienTrang(item.hienTrang ?? 0).name;
        } catch (e) {
          return 'Không xác định';
        }
      case 'so_luong':
        return item.soLuong;
      case 'don_vi_tinh':
        return item.donViTinh;
      case 'ky_hieu':
        return item.kyHieu;
      case 'so_ky_hieu':
        return item.soKyHieu;
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
    final groups = widget.provider.dataGroup ?? const <AssetGroupDto>[];
    final data = widget.provider.data ?? const <AssetManagementDto>[];
    return Container(
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
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFF21A366),
              borderRadius: BorderRadius.circular(8),
              // border: Border.all(color: Colors.grey[300]!),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 8,
              children: [
                SGText(
                  text: 'Danh sách nhóm tài sản',
                  size: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                Visibility(visible: groups.isNotEmpty, child: Divider()),
                Visibility(
                  visible: groups.isEmpty,
                  child: Center(
                    child: SGText(
                      text: 'Không có loại tài sản nào',
                      color: ColorValue.link,
                      size: 14,
                    ),
                  ),
                ),
                if (groups.isNotEmpty)
                  Scrollbar(
                    controller: horizontalController,
                    thumbVisibility: true,
                    thickness: 4,
                    notificationPredicate:
                        (notification) =>
                            notification.metrics.axis == Axis.horizontal,
                    child: SingleChildScrollView(
                      controller: horizontalController,
                      scrollDirection: Axis.horizontal,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 13.0),
                        child: Row(
                          // spacing: 16,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ...groups.map(
                              (item) => Visibility(
                                visible:
                                    getCountAssetByAssetManagement(
                                      data,
                                      '${item.id}',
                                    ) !=
                                    0,
                                child: ItemAssetGroup(
                                  titleName: item.tenNhom,
                                  numberAsset:
                                      getCountAssetByAssetManagement(
                                        data,
                                        '${item.id}',
                                      ).toString(),
                                  image: "assets/images/assets.png",
                                  onTap: () {
                                    context.go(AppRoute.staffManager.path);
                                  },
                                  valueCheckBox: widget.provider
                                      .getCheckBoxStatus(item.id),
                                  onChange: (value) {
                                    widget.provider.updateCheckBoxStatus(
                                      item.id,
                                      value,
                                    );
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          SizedBox(height: 16),
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
                      'Quản lý tài sản (${widget.provider.data?.length ?? 0})',
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
                          width: (availableWidth * 0.35).toDouble(),
                          onSearch: (value) {
                            ref
                                .read(tableAssetManagementProvider.notifier)
                                .searchTerm = value;
                          },
                        );
                      },
                    ),
                    SizedBox(
                      width: (availableWidth * 0.65).toDouble(),
                      child: riverpod.Consumer(
                        builder: (context, ref, _) {
                          final hasFilters = ref.watch(
                            tableAssetManagementProvider.select(
                              (s) => s.filterState.hasActiveFilters,
                            ),
                          );
                          final tableState = ref.watch(
                            tableAssetManagementProvider,
                          );
                          final selectedCount = tableState.selectedItems.length;
                          listSelected = tableState.selectedItems;
                          final buttons = _buildButtonList(selectedCount);
                          final processedButtons =
                              buttons.map((button) {
                                if (button.text == 'Xóa bộ lọc') {
                                  return ResponsiveButtonData.fromButtonIcon(
                                    text: button.text,
                                    iconPath: button.iconPath!,
                                    backgroundColor: button.backgroundColor!,
                                    iconColor: button.iconColor!,
                                    textColor: button.textColor!,
                                    width: button.width,
                                    onPressed: () {
                                      ref
                                          .read(
                                            tableAssetManagementProvider
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
                                        (button) => button.text != 'Xóa bộ lọc',
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
          // bộ lọc
          ClipRRect(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(8.0),
              bottomRight: Radius.circular(8.0),
            ),
            child: riverpod.Consumer(
              builder: (context, ref, child) {
                final dataFiltered = widget.provider.filteredData ?? [];
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  ref
                      .read(tableAssetManagementProvider.notifier)
                      .setData(dataFiltered);
                });

                return RiverpodTable<AssetManagementDto>(
                  tableProvider: tableAssetManagementProvider,
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
                    widget.provider.onChangeDetail(item);
                  },
                  onDelete: (item) {
                    showConfirmDialog(
                      context,
                      type: ConfirmType.delete,
                      title: 'Xóa tài sản',
                      message: 'Bạn có chắc muốn xóa ${item.tenTaiSan}',
                      highlight: item.tenTaiSan ?? '',
                      cancelText: 'Không',
                      confirmText: 'Xóa',
                      onConfirm: () {
                        context.read<AssetManagementBloc>().add(
                          DeleteAssetEvent(context, item.id!),
                        );
                      },
                    );
                  },
                  showActionsColumn: true,
                  actionsColumnWidth: 120,
                  maxHeight: MediaQuery.of(context).size.height * 0.8,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  int getCountAssetByAssetManagement(
    List<AssetManagementDto> data,
    String idNhomTaiSan,
  ) {
    return data.where((i) => i.idNhomTaiSan == idNhomTaiSan).length;
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
          iconPath: AppIconSvg.iconTrash2,
          backgroundColor: Colors.redAccent,
          iconColor: AppColor.textWhite,
          textColor: AppColor.textWhite,
          width: 130,
          onPressed: () {
            final ids = listSelected.map((e) => e.id!).toList();
            showConfirmDialog(
              context,
              type: ConfirmType.delete,
              title: 'Xóa tài sản',
              message: 'Bạn có chắc muốn xóa ${listSelected.length} tài sản',
              highlight: listSelected.length.toString(),
              cancelText: 'Không',
              confirmText: 'Xóa',
              onConfirm: () {
                context.read<AssetManagementBloc>().add(
                  DeleteAssetBatchEvent(ids),
                );
              },
            );
          },
        ),

      ResponsiveButtonData.fromButtonIcon(
        text: 'Khấu hao tài sản',
        iconPath: 'assets/icons/chart-column-decreasing.svg',
        backgroundColor: ColorValue.coral,
        iconColor: AppColor.textWhite,
        textColor: AppColor.textWhite,
        width: 150,
        onPressed: () {
          widget.provider.onChangeBody(ShowBody.khauHao, context);
        },
      ),
    ];
  }
}
