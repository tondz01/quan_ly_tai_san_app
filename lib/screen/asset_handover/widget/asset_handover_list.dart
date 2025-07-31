// ignore_for_file: deprecated_member_use

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quan_ly_tai_san_app/core/constants/app_colors.dart';
import 'package:quan_ly_tai_san_app/screen/asset_handover/component/find_by_state_asset_handover.dart';
import 'package:quan_ly_tai_san_app/screen/asset_handover/model/asset_handover_dto.dart';
import 'package:quan_ly_tai_san_app/screen/asset_handover/provider/asset_handover_provider.dart';
import 'package:se_gay_components/common/pagination/sg_pagination_controls.dart';
import 'package:se_gay_components/common/table/sg_table.dart';
import 'package:se_gay_components/common/table/sg_table_component.dart';

class AssetHandoverList extends StatefulWidget {
  final AssetHandoverProvider provider;
  final String mainScreen;
  const AssetHandoverList({
    super.key,
    required this.provider,
    required this.mainScreen,
  });

  @override
  State<AssetHandoverList> createState() => _AssetHandoverListState();
}

class _AssetHandoverListState extends State<AssetHandoverList> {
  final ScrollController horizontalController = ScrollController();
  String searchTerm = "";

  @override
  Widget build(BuildContext context) {
    // Usar Consumer para reaccionar a cambios en el provider
    return Consumer<AssetHandoverProvider>(
      builder: (context, provider, child) {
        return Column(
          children: [
            FindByStateAssetHandover(provider: provider),
            const SizedBox(height: 10),
            if (provider.data != null)
              Expanded(
                child: Container(
                  margin: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: ColorValue.neutral300.withOpacity(0.4),
                        spreadRadius: 0,
                        blurRadius: 12,
                        offset: const Offset(0, 6),
                      ),
                      BoxShadow(
                        color: ColorValue.neutral200.withOpacity(0.2),
                        spreadRadius: 0,
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Scrollbar(
                      controller: horizontalController,
                      thumbVisibility: true,
                      thickness: 4,
                      notificationPredicate:
                          (notification) =>
                              notification.metrics.axis == Axis.horizontal,
                      child: SingleChildScrollView(
                        controller: horizontalController,
                        scrollDirection: Axis.horizontal,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: _buildTable(
                            searchTerm,
                            provider.columns,
                            provider.dataPage ?? [],
                            onViewAction: (item) {},
                            onEditAction: (item) {},
                            onDeleteAction: (item) {},
                            onRowTap: (item) {
                              provider.onChangeScreen(
                                item: item,
                                isMainScreen: false,
                                isEdit: false,
                              );
                            },
                            onSelectionChanged: (items) {},
                            onCustomFilter: (item) => false,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            _buildPaginationControls(provider),
          ],
        );
      },
    );
  }

  Widget _buildTable(
    String searchTerm,
    List<SgTableColumn<AssetHandoverDto>> columns,
    List<AssetHandoverDto> data, {
    Function(AssetHandoverDto)? onViewAction,
    Function(AssetHandoverDto)? onEditAction,
    Function(AssetHandoverDto)? onDeleteAction,
    Function(AssetHandoverDto)? onRowTap,
    Function(List<AssetHandoverDto>)? onSelectionChanged,
    Function(AssetHandoverDto)? onCustomFilter,
  }) {
    log('Construyendo tabla con ${data.length} elementos');
    return SgTable<AssetHandoverDto>(
      key: ValueKey(data.length),
      headerBackgroundColor: ColorValue.primaryBlue,
      textHeaderColor: Colors.white,
      evenRowBackgroundColor: ColorValue.neutral50,
      oddRowBackgroundColor: Colors.white,
      selectedRowColor: ColorValue.primaryLightBlue.withOpacity(0.2),
      gridLineColor: ColorValue.neutral200,
      gridLineWidth: 1.0,
      showVerticalLines: true,
      showHorizontalLines: true,
      allowRowSelection: true,
      searchTerm: searchTerm,
      rowHeight: 56.0,
      showCheckboxes: true,
      onSelectionChanged: (selectedItems) {
        onSelectionChanged?.call(selectedItems);
      },
      customFilter: (item) {
        if (onCustomFilter?.call(item) == true) {
          return false;
        }
        return true;
      },
      showActions: true,
      actionColumnTitle: 'Thao tác',
      actionColumnWidth: 160,
      actionViewColor: ColorValue.success,
      actionEditColor: ColorValue.primaryBlue,
      actionDeleteColor: ColorValue.error,
      onViewAction: (item) {
        onViewAction?.call(item);
      },
      onEditAction: (item) {
        onEditAction?.call(item);
      },
      onDeleteAction: (item) {
        onDeleteAction?.call(item);
      },
      columns: columns,
      data: data,
      onRowTap: (item) {
        log('message onRowTap called');
        onRowTap?.call(item);
      },
    );
  }

  Widget _buildPaginationControls(AssetHandoverProvider provider) {
    // Check if pagination is disabled or controller is null
    if (provider.controllerDropdownPage == null) {
      return const SizedBox(); // Return empty widget
    }
    return Visibility(
      visible: (provider.data?.length ?? 0) >= 5,
      child: SGPaginationControls(
        totalPages: provider.totalPages,
        currentPage: provider.currentPage,
        rowsPerPage: provider.rowsPerPage,
        controllerDropdownPage: provider.controllerDropdownPage!,
        items: provider.items,
        onPageChanged: provider.onPageChanged,
        onRowsPerPageChanged: provider.onRowsPerPageChanged,
      ),
    );
  }
}
