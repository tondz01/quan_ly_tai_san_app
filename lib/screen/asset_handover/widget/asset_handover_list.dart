import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(minWidth: 1400),
                        child: _buildTable(
                          searchTerm,
                          provider.columns,
                          provider.dataPage ?? [], // Usar dataPage que ya contiene los datos filtrados
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
            _buildPaginationControls(provider),
          ],
        );
      }
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
      key: ValueKey(data.length), // Agregar key para forzar reconstrucción
      headerBackgroundColor: Colors.blue,
      evenRowBackgroundColor: Colors.grey.shade200,
      oddRowBackgroundColor: Colors.white,
      selectedRowColor: Colors.lightBlue.shade100,
      checkedRowColor: const Color(
        0xFFE8F4FE,
      ),
      gridLineColor: Colors.grey.shade300,
      gridLineWidth: 1.0,
      showVerticalLines: true,
      showHorizontalLines: true,
      allowRowSelection: true,
      searchTerm: searchTerm,

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
      actionColumnWidth: 150,
      actionViewColor: Colors.green,
      actionEditColor: Colors.blue,
      actionDeleteColor: Colors.red,
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
