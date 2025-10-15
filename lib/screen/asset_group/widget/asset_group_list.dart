// ignore_for_file: deprecated_member_use

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/export.dart';
import 'package:provider/provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'
    as riverpod;
import 'package:quan_ly_tai_san_app/common/button/action_button_config.dart';
import 'package:quan_ly_tai_san_app/common/popup/popup_confirm.dart';
import 'package:quan_ly_tai_san_app/common/widgets/column_display_popup.dart';
import 'package:quan_ly_tai_san_app/screen/asset_group/bloc/asset_group_bloc.dart';
import 'package:quan_ly_tai_san_app/screen/asset_group/bloc/asset_group_event.dart';
import 'package:quan_ly_tai_san_app/screen/asset_group/component/table_asset_group_config.dart';
import 'package:quan_ly_tai_san_app/screen/asset_group/model/asset_group_dto.dart';
import 'package:quan_ly_tai_san_app/screen/asset_group/provider/asset_group_provide.dart';
import 'package:quan_ly_tai_san_app/screen/asset_group/provider/table_asset_group_provider.dart';
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

class AssetGroupList extends StatefulWidget {
  final AssetGroupProvider provider;
  const AssetGroupList({super.key, required this.provider});

  @override
  State<AssetGroupList> createState() =>
      _AssetGroupListState();
}

class _AssetGroupListState extends State<AssetGroupList> {
  final ScrollController horizontalController =
      ScrollController();
  String searchTerm = "";

  List<AssetGroupDto> listSelected = [];
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
    'code_asset_group',
    'name_asset_group',
    'is_active',
    'created_at',
    'updated_at',
    'created_by',
    'updated_by',
    'actions',
  ];

  @override
  void initState() {
    super.initState();
    _definitions = TableAssetGroupConfig.getColumns();
    _columns = _definitions
        .map((d) => d.config)
        .toList(growable: true);
    log('columns: $_columns');
    _allColumns = List<TableColumnData>.from(_columns);
    _buildersByKey = {
      for (final d in _definitions) d.config.key: d.builder,
    };
  }

  dynamic getValueForColumn(
    AssetGroupDto item,
    int columnIndex,
  ) {
    final int offset = showCheckboxColumn ? 1 : 0;
    final int adjustedIndex = columnIndex - offset;

    if (adjustedIndex < 0 ||
        adjustedIndex >= _columns.length) {
      return null;
    }

    final String key = _columns[adjustedIndex].key;
    switch (key) {
      case 'code_asset_group':
        return item.id;
      case 'name_asset_group':
        return item.tenNhom;
      case 'is_active':
        return item.hieuLuc;
      case 'created_at':
        return item.ngayTao;
      case 'updated_at':
        return item.ngayCapNhat;
      case 'created_by':
        return item.nguoiTao;
      case 'updated_by':
        return item.nguoiCapNhat;
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
      SGLog.error(
        'ColumnConfigDialog',
        'Error at _openColumnConfigDialog: $e',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Colors.grey.shade300,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(8),
                  topRight: Radius.circular(8),
                ),
              ),
              child: Row(
                mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,
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
                        'Quản lý nhóm tài sản (${widget.provider.data?.length ?? 0})',
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
                  final availableWidth =
                      constraints.maxWidth;
                  return Row(
                    children: [
                      riverpod.Consumer(
                        builder: (context, ref, _) {
                          return BoxSearch(
                            width:
                                (availableWidth * 0.35)
                                    .toDouble(),
                            onSearch: (value) {
                              ref
                                  .read(
                                    tableAssetGroupProvider
                                        .notifier,
                                  )
                                  .searchTerm = value;
                            },
                          );
                        },
                      ),
                      SizedBox(
                        width:
                            (availableWidth * 0.65)
                                .toDouble(),
                        child: riverpod.Consumer(
                          builder: (context, ref, _) {
                            final hasFilters = ref.watch(
                              tableAssetGroupProvider.select(
                                (s) =>
                                    s
                                        .filterState
                                        .hasActiveFilters,
                              ),
                            );
                            final tableState = ref.watch(
                              tableAssetGroupProvider,
                            );
                            final selectedCount =
                                tableState
                                    .selectedItems
                                    .length;
                            listSelected =
                                tableState.selectedItems;
                            final buttons =
                                _buildButtonList(
                                  selectedCount,
                                );
                            final processedButtons =
                                buttons.map((button) {
                                  if (button.text ==
                                      'table.clear_filters'
                                          .tr) {
                                    return ResponsiveButtonData.fromButtonIcon(
                                      text: button.text,
                                      iconPath:
                                          button.iconPath!,
                                      backgroundColor:
                                          button
                                              .backgroundColor!,
                                      iconColor:
                                          button.iconColor!,
                                      textColor:
                                          button.textColor!,
                                      width: button.width,
                                      onPressed: () {
                                        ref
                                            .read(
                                              tableAssetGroupProvider
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
                                              button.text !=
                                              'table.clear_filters'
                                                  .tr,
                                        )
                                        .toList();

                            return ResponsiveButtonBar(
                              buttons: filteredButtons,
                              spacing: 12,
                              overflowSide:
                                  OverflowSide.start,
                              mainAxisAlignment:
                                  MainAxisAlignment.end,
                              popupPosition:
                                  PopupMenuPosition.under,
                              popupOffset: const Offset(
                                0,
                                8,
                              ),
                              popupShape:
                                  RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.circular(
                                          8,
                                        ),
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
                  ref
                      .read(
                        tableAssetGroupProvider.notifier,
                      )
                      .setData(data);

                  return RiverpodTable<AssetGroupDto>(
                    tableProvider: tableAssetGroupProvider,
                    columns: _columns,
                    showCheckboxColumn: showCheckboxColumn,
                    enableRowSelection: true,
                    enableRowHover: true,
                    showAlternatingRowColors: true,
                    valueGetter: getValueForColumn,
                    cellsBuilder: (_) => [],
                    cellBuilderByKey: (item, key) {
                      final builder = _buildersByKey[key];
                      if (builder != null)
                        return builder(item);
                      return null;
                    },
                    onRowTap: (item) {
                      widget.provider.onChangeDetail(item);
                    },
                    onDelete: (item) {
                      showConfirmDialog(
                        context,
                        type: ConfirmType.delete,
                        title: 'Xóa nhóm tài sản',
                        message:
                            'Bạn có chắc muốn xóa ${item.tenNhom}',
                        highlight: item.tenNhom ?? '',
                        cancelText: 'Không',
                        confirmText: 'Xóa',
                        onConfirm: () {
                          context
                              .read<AssetGroupBloc>()
                              .add(
                                DeleteAssetGroupEvent(
                                  context,
                                  item.id!,
                                ),
                              );
                        },
                      );
                    },
                    showActionsColumn: _showActionsColumn,
                    actionsColumnWidth: 120,
                    maxHeight:
                        MediaQuery.of(context).size.height *
                        0.8,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget showCheckBoxActive(bool isActive) {
    return SgCheckbox(value: isActive);
  }

  String getNameColumnAssetGroup(AssetGroupDto item) {
    return "${item.id} - ${item.tenNhom}";
  }

  Widget viewAction(AssetGroupDto item) {
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
                message:
                    'Bạn có chắc muốn xóa ${item.tenNhom}',
                highlight: item.tenNhom ?? '',
                cancelText: 'Không',
                confirmText: 'Xóa',
                onConfirm: () {
                  context.read<AssetGroupBloc>().add(
                    DeleteAssetGroupEvent(
                      context,
                      item.id!,
                    ),
                  );
                },
              ),
            },
      ),
    ]);
  }

  List<ResponsiveButtonData> _buildButtonList(
    int itemCount,
  ) {
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
            final ids =
                listSelected.map((e) => e.id!).toList();
            showConfirmDialog(
              context,
              type: ConfirmType.delete,
              title: 'Xóa nhóm tài sản',
              message:
                  'Bạn có chắc muốn xóa ${listSelected.length} nhóm tài sản',
              highlight: listSelected.length.toString(),
              cancelText: 'Không',
              confirmText: 'Xóa',
              onConfirm: () {
                final assetGroupBloc =
                    context.read<AssetGroupBloc>();
                assetGroupBloc.add(
                  DeleteAssetGroupBatchEvent(ids),
                );
              },
            );
          },
        ),
    ];
  }
}
