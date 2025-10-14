// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get/utils.dart';
import 'package:quan_ly_tai_san_app/common/popup/popup_confirm.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/staff/models/nhan_vien.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/staff/component/table_staff_config.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/staff/provider/table_staff_provider.dart';
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

class StaffList extends StatefulWidget {
  final List<NhanVien> data;
  final void Function(NhanVien)? onChangeDetail;
  final void Function(NhanVien)? onEdit;
  final void Function(NhanVien)? onDelete;
  final void Function(List<String>)? onDeleteBatch;
  final bool isCanDelete;
  const StaffList({
    super.key,
    required this.data,
    this.onChangeDetail,
    this.onEdit,
    this.onDelete,
    this.onDeleteBatch,
    this.isCanDelete = false,
  });

  @override
  State<StaffList> createState() => _StaffListState();
}

class _StaffListState extends State<StaffList> {
  List<NhanVien> selectedItems = [];

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
    _definitions = TableStaffConfig.getColumns();
    _columns = _definitions.map((d) => d.config).toList(growable: true);
    _allColumns = List<TableColumnData>.from(_columns);
    _buildersByKey = {for (final d in _definitions) d.config.key: d.builder};
    _hiddenKeys = <String>[];
  }

  dynamic getValueForColumn(NhanVien item, int columnIndex) {
    final int offset = 1; // showCheckboxColumn
    final int adjustedIndex = columnIndex - offset;

    if (adjustedIndex < 0 || adjustedIndex >= _columns.length) {
      return null;
    }

    final String key = _columns[adjustedIndex].key;
    switch (key) {
      case 'code_staff':
        return item.id;
      case 'name_staff':
        return item.hoTen;
      case 'phone_staff':
        return item.diDong;
      case 'email_staff':
        return item.emailCongViec;
      case 'department_staff':
        return item.tenPhongBan;
      case 'position_staff':
        return item.tenChucVu;
      case 'signing_status':
        return TableStaffConfig.showSigningStatus(item);
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
                      'Quản lý nhân viên (${widget.data.length})',
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
                            ref.read(tableStaffProvider.notifier).searchTerm =
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
                            tableStaffProvider.select(
                              (s) => s.filterState.hasActiveFilters,
                            ),
                          );
                          final tableState = ref.watch(tableStaffProvider);
                          final selectedCount = tableState.selectedItems.length;
                          selectedItems = tableState.selectedItems;
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
                                          .read(tableStaffProvider.notifier)
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
                ref.read(tableStaffProvider.notifier).setData(widget.data);

                return RiverpodTable<NhanVien>(
                  tableProvider: tableStaffProvider,
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
                widget.onChangeDetail?.call(item);
              },
                  onDelete: (item) {
                    if (widget.isCanDelete) {
                  showConfirmDialog(
                    context,
                    type: ConfirmType.delete,
                    title: 'Xóa nhân viên',
                    message: 'Bạn có chắc muốn xóa ${item.hoTen}',
                    highlight: item.hoTen ?? '',
                    cancelText: 'Không',
                    confirmText: 'Xóa',
                    onConfirm: () {
                      widget.onDelete?.call(item);
                        },
                      );
                    }
                  },
                  showActionsColumn: widget.isCanDelete,
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
      if (widget.isCanDelete && itemCount > 0)
        ResponsiveButtonData.fromButtonIcon(
          text: '$itemCount ${'table.delete_selected'.tr}',
          iconPath: AppIconSvg.iconSetting,
          backgroundColor: Colors.redAccent,
          iconColor: AppColor.textWhite,
          textColor: AppColor.textWhite,
          width: 130,
          onPressed: () {
            final ids = selectedItems.map((e) => e.id!).toList();
            showConfirmDialog(
              context,
              type: ConfirmType.delete,
              title: 'Xóa nhân viên',
              message: 'Bạn có chắc muốn xóa ${selectedItems.length} nhân viên',
              highlight: selectedItems.length.toString(),
              cancelText: 'Không',
              confirmText: 'Xóa',
              onConfirm: () {
                widget.onDeleteBatch?.call(ids);
              },
            );
          },
        ),
    ];
  }
}
