// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/export.dart';
import 'package:provider/provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' as riverpod;
import 'package:quan_ly_tai_san_app/common/popup/popup_confirm.dart';
import 'package:quan_ly_tai_san_app/common/widgets/column_display_popup.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/current_status/bloc/current_status_bloc.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/current_status/bloc/current_status_event.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/current_status/component/table_current_status_config.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/current_status/model/current_status.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/current_status/provider/current_status_provider.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/current_status/provider/table_current_status_provider.dart';
import 'package:se_gay_components/common/switch/sg_checkbox.dart';
import 'package:se_gay_components/core/utils/sg_log.dart';
import 'package:table_base/core/themes/app_color.dart';
import 'package:table_base/core/themes/app_icon_svg.dart';
import 'package:table_base/widgets/box_search.dart';
import 'package:table_base/widgets/responsive_button_bar/responsive_button_bar.dart';
import 'package:table_base/widgets/table/models/column_definition.dart';
import 'package:table_base/widgets/table/models/table_model.dart';
import 'package:table_base/widgets/table/widgets/column_config_dialog.dart';
import 'package:table_base/widgets/table/widgets/riverpod_table.dart';

class CurrentStatusList extends StatefulWidget {
  final CurrentStatusProvider provider;
  const CurrentStatusList({super.key, required this.provider});

  @override
  State<CurrentStatusList> createState() => _CurrentStatusListState();
}

class _CurrentStatusListState extends State<CurrentStatusList> {
  final ScrollController horizontalController = ScrollController();
  String searchTerm = "";

  List<CurrentStatus> listSelected = [];
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
    'code_current_status',
    'name_current_status',
  ];

  @override
  void initState() {
    super.initState();
    _definitions = TableCurrentStatusConfig.getColumns();
    _columns = _definitions.map((d) => d.config).toList(growable: true);
    _allColumns = List<TableColumnData>.from(_columns);
    _buildersByKey = {for (final d in _definitions) d.config.key: d.builder};
  }

  dynamic getValueForColumn(CurrentStatus item, int columnIndex) {
    final int offset = showCheckboxColumn ? 1 : 0;
    final int adjustedIndex = columnIndex - offset;

    if (adjustedIndex < 0 || adjustedIndex >= _columns.length) {
      return null;
    }

    final String key = _columns[adjustedIndex].key;
    switch (key) {
      case 'code_current_status':
        return item.id;
      case 'name_current_status':
        return item.tenHTKT;
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
                            'Quản lý hiện trạng (${widget.provider.data?.length ?? 0})',
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
                                .read(tableCurrentStatusProvider.notifier)
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
                            tableCurrentStatusProvider.select(
                              (s) => s.filterState.hasActiveFilters,
                            ),
                          );
                          final tableState = ref.watch(tableCurrentStatusProvider);
                          final selectedCount = tableState.selectedItems.length;
                          listSelected = tableState.selectedItems;
                          final buttons = _buildButtonList(selectedCount);
                          final processedButtons =
                              buttons.map((button) {
                                if (button.text == 'table.clear_filters'.tr) {
                                  return ResponsiveButtonData.fromButtonIcon(
                                    text: button.text,
                                    iconPath: button.iconPath!,
                                    backgroundColor: button.backgroundColor!,
                                    iconColor: button.iconColor!,
                                    textColor: button.textColor!,
                                    width: button.width,
                                    onPressed: () {
                                      ref
                                          .read(tableCurrentStatusProvider.notifier)
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
                                            button.text !=
                                            'table.clear_filters'.tr,
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
                final data = widget.provider.data ?? [];
                ref.read(tableCurrentStatusProvider.notifier).setData(data);

                return RiverpodTable<CurrentStatus>(
                  tableProvider: tableCurrentStatusProvider,
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
                    widget.provider.onChangeDetail(item);
                  },
                  onDelete: (item) {
                    showConfirmDialog(
                      context,
                      type: ConfirmType.delete,
                      title: 'Xóa hiện trạng',
                      message: 'Bạn có chắc muốn xóa ${item.tenHTKT}',
                      highlight: item.tenHTKT ?? '',
                      cancelText: 'Không',
                      confirmText: 'Xóa',
                      onConfirm: () {
                        context.read<CurrentStatusBloc>().add(
                          DeleteCurrentStatusEvent(context, item.id!.toString()),
                        );
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

  Widget showCheckBoxActive(bool isActive) {
    return SgCheckbox(value: isActive);
  }

  String getNameColumnCurrentStatus(CurrentStatus item) {
    return "${item.id} - ${item.tenHTKT}";
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
            final ids = listSelected.map((e) => e.id!.toString()).toList();
            showConfirmDialog(
              context,
              type: ConfirmType.delete,
              title: 'Xóa hiện trạng',
              message: 'Bạn có chắc muốn xóa ${listSelected.length} hiện trạng',
              highlight: listSelected.length.toString(),
              cancelText: 'Không',
              confirmText: 'Xóa',
              onConfirm: () {
                final bloc = context.read<CurrentStatusBloc>();
                bloc.add(DeleteCurrentStatusBatchEvent(ids.map((e) => e.toString()).toList()));
              },
            );
          },
        ),
    ];
  }
}
