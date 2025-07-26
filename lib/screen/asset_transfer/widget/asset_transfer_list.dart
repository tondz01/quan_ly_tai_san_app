import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:quan_ly_tai_san_app/screen/asset_transfer/model/asset_transfer_dto.dart';
import 'package:quan_ly_tai_san_app/screen/asset_transfer/provider/asset_transfer_provider.dart';
import 'package:se_gay_components/common/pagination/sg_pagination_controls.dart';
import 'package:se_gay_components/common/table/sg_table.dart';
import 'package:se_gay_components/common/table/sg_table_component.dart';

class AssetTransferList extends StatefulWidget {
  final AssetTransferProvider provider;
  final String mainScreen;
  const AssetTransferList({
    super.key,
    required this.provider,
    required this.mainScreen,
  });

  @override
  State<AssetTransferList> createState() => _AssetTransferListState();
}

class _AssetTransferListState extends State<AssetTransferList> {
  final ScrollController horizontalController = ScrollController();
  String searchTerm = "";
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (widget.provider.data != null)
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
                      widget.provider.columns,
                      widget.provider.dataPage ?? [],
                      onViewAction: (item) {},
                      onEditAction: (item) {},
                      onDeleteAction: (item) {
                       
                      },
                      onRowTap: (item) {
                        widget.provider.onChangeScreen(
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
        _buildPaginationControls(widget.provider),
      ],
    );
  }

  Widget _buildTable(
    String searchTerm,
    List<SgTableColumn<AssetTransferDto>> columns,
    List<AssetTransferDto> data, {
    Function(AssetTransferDto)? onViewAction,
    Function(AssetTransferDto)? onEditAction,
    Function(AssetTransferDto)? onDeleteAction,
    Function(AssetTransferDto)? onRowTap,
    Function(List<AssetTransferDto>)? onSelectionChanged,
    Function(AssetTransferDto)? onCustomFilter,
  }) {
    return SgTable<AssetTransferDto>(
      headerBackgroundColor: Colors.blue,
      evenRowBackgroundColor: Colors.grey.shade200,
      oddRowBackgroundColor: Colors.white,
      selectedRowColor: Colors.lightBlue.shade100,
      checkedRowColor: const Color(
        0xFFE8F4FE,
      ), // Light blue background for checked rows
      gridLineColor: Colors.grey.shade300,
      gridLineWidth: 1.0,
      showVerticalLines: true,
      showHorizontalLines: true,
      allowRowSelection: true,
      searchTerm: searchTerm,

      showCheckboxes: true, // on, off checkbox
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

  Widget _buildPaginationControls(AssetTransferProvider provider) {
    // Check if pagination is disabled or controller is null
    if (provider.controllerDropdownPage == null) {
      return const SizedBox(); // Return empty widget
    }
    return Visibility(
      visible: provider.data.length >= 5,
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
