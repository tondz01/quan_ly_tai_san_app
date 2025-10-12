import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/utils.dart';
import 'package:intl/intl.dart';
import 'package:quan_ly_tai_san_app/common/input/common_form_date.dart';
import 'package:quan_ly_tai_san_app/screen/asset_management/component/table_asset_depreciation_config.dart';
import 'package:quan_ly_tai_san_app/screen/asset_management/model/asset_depreciation_dto.dart';
import 'package:quan_ly_tai_san_app/screen/asset_management/provider/asset_management_provider.dart';
import 'package:quan_ly_tai_san_app/screen/asset_management/provider/table_asset_depreciation_provider.dart';
import 'package:se_gay_components/core/enum/sg_date_time_mode.dart';
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

class AssetDepreciationList extends StatefulWidget {
  const AssetDepreciationList({super.key, required this.provider});
  final AssetManagementProvider provider;

  @override
  State<AssetDepreciationList> createState() => _AssetDepreciationListState();
}

class _AssetDepreciationListState extends State<AssetDepreciationList> {
  List<AssetDepreciationDto> listSelected = [];
  TextEditingController ctrlSelectDate = TextEditingController();

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
    ctrlSelectDate = TextEditingController(text: _fmtDate(DateTime.now()));
    // Lắng nghe thay đổi từ provider để cập nhật UI khi dữ liệu khấu hao thay đổi
    widget.provider.addListener(_onProviderChanged);
  }

  void _initializeTableConfig() {
    _definitions = TableAssetDepreciationConfig.getColumns(widget.provider);
    _columns = _definitions.map((d) => d.config).toList(growable: true);
    _allColumns = List<TableColumnData>.from(_columns);
    _buildersByKey = {for (final d in _definitions) d.config.key: d.builder};
    _hiddenKeys = <String>[];
  }

  String _fmtDate(DateTime? d) {
    if (d == null) return '';
    final dd = d.day.toString().padLeft(2, '0');
    final mm = d.month.toString().padLeft(2, '0');
    final yyyy = d.year.toString();
    return '$dd/$mm/$yyyy';
  }

  String _fmtNum(double? v) {
    if (v == null) return '';
    try {
      final NumberFormat _vnNumber = NumberFormat('#,##0', 'vi_VN');
      return _vnNumber.format(v);
    } catch (_) {
      return v.toString();
    }
  }

  @override
  void didUpdateWidget(covariant AssetDepreciationList oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Nếu instance provider thay đổi, gỡ listener cũ và đăng ký lại
    if (oldWidget.provider != widget.provider) {
      oldWidget.provider.removeListener(_onProviderChanged);
      widget.provider.addListener(_onProviderChanged);
    }
  }

  void _onProviderChanged() {
    log(
      'providerChanged: isLoadingKhauHao=${widget.provider.isLoadingKhauHao}',
    );
    // Khi provider báo loading xong hoặc dữ liệu thay đổi, cập nhật danh sách
    if (!widget.provider.isLoadingKhauHao) {
      setState(() {
        // Data sẽ được cập nhật trong RiverpodTable
      });
      log(
        'getListKhauHaoSuccess providerChanged: ${widget.provider.dataKhauHao?.length}',
      );
    }
  }

  @override
  void dispose() {
    widget.provider.removeListener(_onProviderChanged);
    ctrlSelectDate.dispose();
    super.dispose();
  }

  dynamic getValueForColumn(AssetDepreciationDto item, int columnIndex) {
    final int offset = 1; // showCheckboxColumn
    final int adjustedIndex = columnIndex - offset;

    if (adjustedIndex < 0 || adjustedIndex >= _columns.length) {
      return null;
    }

    final String key = _columns[adjustedIndex].key;
    switch (key) {
      case 'id':
        return item.id;
      case 'soThe':
        return item.soThe;
      case 'tenTaiSan':
        return item.tenTaiSan;
      case 'nvNS':
        return _fmtNum(item.nvNS);
      case 'vonVay':
        return _fmtNum(item.vonVay);
      case 'vonKhac':
        return _fmtNum(item.vonKhac);
      case 'maTk':
        return item.maTk;
      case 'ngayTinhKhao':
        return _fmtDate(item.ngayTinhKhao);
      case 'thangKh':
        return item.thangKh?.toString();
      case 'nguyenGia':
        return _fmtNum(item.nguyenGia);
      case 'khauHaoBanDau':
        return _fmtNum(item.khauHaoBanDau);
      case 'khauHaoPsdk':
        return _fmtNum(item.khauHaoPsdk);
      case 'gtclBanDau':
        return _fmtNum(item.gtclBanDau);
      case 'khauHaoPsck':
        return _fmtNum(item.khauHaoPsck);
      case 'gtclHienTai':
        return _fmtNum(item.gtclHienTai);
      case 'khauHaoBinhQuan':
        return _fmtNum(item.khauHaoBinhQuan);
      case 'soTien':
        return _fmtNum(item.soTien);
      case 'chenhLech':
        return _fmtNum(item.chenhLech);
      case 'khKyTruoc':
        return _fmtNum(item.khKyTruoc);
      case 'clKyTruoc':
        return _fmtNum(item.clKyTruoc);
      case 'hsdCkh':
        return _fmtNum(item.hsdCkh);
      case 'tkNo':
        return item.tkNo;
      case 'tkCo':
        return item.tkCo;
      case 'dtgt':
        return item.dtgt;
      case 'dtth':
        return item.dtth;
      case 'kmcp':
        return item.kmcp;
      case 'ghiChuKhao':
        return item.ghiChuKhao;
      case 'userId':
        return item.userId;
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
    final data = widget.provider.dataKhauHao ?? const <AssetDepreciationDto>[];

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
                      'Danh sách khấu hao tài sản (${data.length})',
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
                          width: (availableWidth * 0.25).toDouble(),
                          onSearch: (value) {
                            ref
                                .read(tableAssetDepreciationProvider.notifier)
                                .searchTerm = value;
                          },
                        );
                      },
                    ),
                    SizedBox(width: 16),
                    ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: 180),
                      child: CmFormDate(
                        sizePadding: 0,
                        label: 'Chọn thời gian khấu hao',
                        controller: ctrlSelectDate,
                        isEditing: true,
                        onChanged: (value) {
                          widget.provider.getDepreciationByDate(
                            context,
                            value ?? DateTime.now(),
                          );
                          setState(() {});
                        },
                        dateTimeMode: SGDateTimeMode.monthYear,
                        showTimeSection: false,
                      ),
                    ),
                    SizedBox(
                      width: (availableWidth * 0.50).toDouble(),
                      child: riverpod.Consumer(
                        builder: (context, ref, _) {
                          final hasFilters = ref.watch(
                            tableAssetDepreciationProvider.select(
                              (s) => s.filterState.hasActiveFilters,
                            ),
                          );
                          final tableState = ref.watch(
                            tableAssetDepreciationProvider,
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
                                            tableAssetDepreciationProvider
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
                ref.read(tableAssetDepreciationProvider.notifier).setData(data);

                return widget.provider.isLoadingKhauHao
                    ? Center(child: CircularProgressIndicator())
                    : data.isEmpty
                    ? Center(child: Text('Không có dữ liệu'))
                    : RiverpodTable<AssetDepreciationDto>(
                      tableProvider: tableAssetDepreciationProvider,
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
                        widget.provider.onChangeDepreciationDetail(item);
                      },
                      showActionsColumn: false,
                      maxHeight: MediaQuery.of(context).size.height * 0.6,
                    );
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
    ];
  }
}
