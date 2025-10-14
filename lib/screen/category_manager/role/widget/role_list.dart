// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' as riverpod;
import 'package:quan_ly_tai_san_app/common/button/action_button_config.dart';
import 'package:quan_ly_tai_san_app/common/popup/popup_confirm.dart';
import 'package:quan_ly_tai_san_app/common/widgets/column_display_popup.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/role/bloc/role_bloc.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/role/bloc/role_event.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/role/component/table_role_config.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/role/model/chuc_vu.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/role/provider/role_provide.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/role/providers/table_role_provider.dart';
import 'package:se_gay_components/core/utils/sg_log.dart';
import 'package:table_base/core/themes/app_color.dart';
import 'package:table_base/core/themes/app_icon_svg.dart';
import 'package:table_base/widgets/box_search.dart';
import 'package:table_base/widgets/responsive_button_bar/responsive_button_bar.dart';
import 'package:table_base/widgets/table/models/column_definition.dart';
import 'package:table_base/widgets/table/models/table_model.dart';
import 'package:table_base/widgets/table/widgets/column_config_dialog.dart';
import 'package:table_base/widgets/table/widgets/riverpod_table.dart';

class RoleList extends StatefulWidget {
  final RoleProvider provider;
  const RoleList({super.key, required this.provider});

  @override
  State<RoleList> createState() => _RoleListState();
}

class _RoleListState extends State<RoleList> {
  final ScrollController horizontalController = ScrollController();
  String searchTerm = "";

  List<ChucVu> listSelected = [];
  List<String> _hiddenKeys = [];
  bool showCheckboxColumn = true;
  final bool _showActionsColumn = true;

  late final List<TableColumnData> _allColumns;
  List<TableColumnData> _columns = [];
  late final List<ColumnDefinition> _definitions;
  late final Map<String, TableCellBuilder> _buildersByKey;

  // Column display options
  late List<ColumnDisplayOption> columnOptions;
  List<String> visibleColumnIds = [
    'role_code',
    'role_name',
    'manage_staff',
    'manage_department',
    'manage_project',
    'manage_capital',
    'manage_asset_model',
    'manage_asset',
    'manage_supplies',
    'transfer_asset',
    'transfer_supplies',
    'handover_asset',
    'handover_supplies',
    'report',
    'actions',
  ];

  @override
  void initState() {
    super.initState();
    _definitions = TableRoleConfig.getColumns();
    _columns = _definitions.map((d) => d.config).toList(growable: true);
    _allColumns = List<TableColumnData>.from(_columns);
    _buildersByKey = {for (final d in _definitions) d.config.key: d.builder};
    _initializeColumnOptions();
  }

  void _initializeColumnOptions() {
    columnOptions = [
      ColumnDisplayOption(
        id: 'role_code',
        label: 'Mã chức vụ',
        isChecked: visibleColumnIds.contains('role_code'),
      ),
      ColumnDisplayOption(
        id: 'role_name',
        label: 'Tên chức vụ',
        isChecked: visibleColumnIds.contains('role_name'),
      ),
      ColumnDisplayOption(
        id: 'manage_staff',
        label: 'Quản lý nhân viên',
        isChecked: visibleColumnIds.contains('manage_staff'),
      ),
      ColumnDisplayOption(
        id: 'manage_department',
        label: 'Quản lý phòng ban',
        isChecked: visibleColumnIds.contains('manage_department'),
      ),
      ColumnDisplayOption(
        id: 'manage_project',
        label: 'Quản lý dự án',
        isChecked: visibleColumnIds.contains('manage_project'),
      ),
      ColumnDisplayOption(
        id: 'manage_capital',
        label: 'Quản lý nguồn vốn',
        isChecked: visibleColumnIds.contains('manage_capital'),
      ),
      ColumnDisplayOption(
        id: 'manage_asset_model',
        label: 'Quản lý mô hình tài sản',
        isChecked: visibleColumnIds.contains('manage_asset_model'),
      ),
      ColumnDisplayOption(
        id: 'manage_asset',
        label: 'Quản lý tài sản',
        isChecked: visibleColumnIds.contains('manage_asset'),
      ),
      ColumnDisplayOption(
        id: 'manage_supplies',
        label: 'Quản lý CCDC - Vật tư',
        isChecked: visibleColumnIds.contains('manage_supplies'),
      ),
      ColumnDisplayOption(
        id: 'transfer_asset',
        label: 'Điều động tài sản',
        isChecked: visibleColumnIds.contains('transfer_asset'),
      ),
      ColumnDisplayOption(
        id: 'transfer_supplies',
        label: 'Điều động CCDC - Vật tư',
        isChecked: visibleColumnIds.contains('transfer_supplies'),
      ),
      ColumnDisplayOption(
        id: 'handover_asset',
        label: 'Bán giao tài sản',
        isChecked: visibleColumnIds.contains('handover_asset'),
      ),
      ColumnDisplayOption(
        id: 'handover_supplies',
        label: 'Bán giao CCDC - Vật tư',
        isChecked: visibleColumnIds.contains('handover_supplies'),
      ),
      ColumnDisplayOption(
        id: 'report',
        label: 'Báo cáo',
        isChecked: visibleColumnIds.contains('report'),
      ),
      ColumnDisplayOption(
        id: 'actions',
        label: 'Thao tác',
        isChecked: visibleColumnIds.contains('actions'),
      ),
    ];
  }

  dynamic getValueForColumn(ChucVu item, int columnIndex) {
    final int offset = showCheckboxColumn ? 1 : 0;
    final int adjustedIndex = columnIndex - offset;

    if (adjustedIndex < 0 || adjustedIndex >= _columns.length) {
      return null;
    }

    final String key = _columns[adjustedIndex].key;
    switch (key) {
      case 'role_code':
        return item.id;
      case 'role_name':
        return item.tenChucVu;
      case 'manage_staff':
        return item.quanLyNhanVien;
      case 'manage_department':
        return item.quanLyPhongBan;
      case 'manage_project':
        return item.quanLyDuAn;
      case 'manage_capital':
        return item.quanLyNguonVon;
      case 'manage_asset_model':
        return item.quanLyMoHinhTaiSan;
      case 'manage_asset':
        return item.quanLyTaiSan;
      case 'manage_supplies':
        return item.quanLyCCDCVatTu;
      case 'transfer_asset':
        return item.dieuDongTaiSan;
      case 'transfer_supplies':
        return item.dieuDongCCDCVatTu;
      case 'handover_asset':
        return item.banGiaoTaiSan;
      case 'handover_supplies':
        return item.banGiaoCCDCVatTu;
      case 'report':
        return item.baoCao;
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
        title: 'Cấu hình cột',
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
                  children: [
                    Icon(
                      Icons.table_chart,
                      color: Colors.grey.shade600,
                      size: 18,
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Quản lý chức vụ (${widget.provider.filteredData?.length ?? 0})',
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
                            ref.read(tableRoleProvider.notifier).searchTerm =
                                value;
                          },
                        );
                      },
                    ),
                    SizedBox(
                      width: (availableWidth * 0.65).toDouble(),
                      child: riverpod.Consumer(
                        builder: (context, ref, _) {
                          final hasFilters = ref.watch(
                            tableRoleProvider.select(
                              (s) => s.filterState.hasActiveFilters,
                            ),
                          );
                          final tableState = ref.watch(tableRoleProvider);
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
                                          .read(tableRoleProvider.notifier)
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
                final data = widget.provider.dataPage;
                ref.read(tableRoleProvider.notifier).setData(data);

                return RiverpodTable<ChucVu>(
                  tableProvider: tableRoleProvider,
                  columns: _columns,
                  showCheckboxColumn: showCheckboxColumn,
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
                  },
                  onDelete: (item) {
                    showConfirmDialog(
                      context,
                      type: ConfirmType.delete,
                      title: 'Xóa chức vụ',
                      message: 'Bạn có chắc muốn xóa ${item.tenChucVu}',
                      highlight: item.tenChucVu,
                      cancelText: 'Không',
                      confirmText: 'Xóa',
                      onConfirm: () {
                        context.read<RoleBloc>().add(DeleteRoleEvent(item.id));
                      },
                    );
                  },
                  showActionsColumn: _showActionsColumn,
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

  List<ResponsiveButtonData> _buildButtonList(int itemCount) {
    return [
      // Configure columns button
      ResponsiveButtonData.fromButtonIcon(
        text: 'Cấu hình cột',
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
          text: '$itemCount Xóa đã chọn',
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
              title: 'Xóa chức vụ',
              message: 'Bạn có chắc muốn xóa ${listSelected.length} chức vụ',
              highlight: listSelected.length.toString(),
              cancelText: 'Không',
              confirmText: 'Xóa',
              onConfirm: () {
                final roleBloc = context.read<RoleBloc>();
                roleBloc.add(DeleteRoleBatchEvent(ids));
              },
            );
          },
        ),
    ];
  }

  Widget viewAction(ChucVu item) {
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
                title: 'Xóa chức vụ',
                message: 'Bạn có chắc muốn xóa ${item.tenChucVu}',
                highlight: item.tenChucVu,
                cancelText: 'Không',
                confirmText: 'Xóa',
                onConfirm: () {
                  context.read<RoleBloc>().add(DeleteRoleEvent(item.id));
                },
              ),
            },
      ),
    ]);
  }
}
