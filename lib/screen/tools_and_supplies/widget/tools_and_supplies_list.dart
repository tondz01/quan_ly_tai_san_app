import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:quan_ly_tai_san_app/core/constants/app_colors.dart';
import 'package:quan_ly_tai_san_app/screen/tools_and_supplies/model/tools_and_supplies_dto.dart';
import 'package:quan_ly_tai_san_app/screen/tools_and_supplies/provider/tools_and_supplies_provide.dart';
import 'package:se_gay_components/common/pagination/sg_pagination_controls.dart';
import 'package:se_gay_components/common/table/sg_table.dart';
import 'package:se_gay_components/common/table/sg_table_component.dart';

class ToolsAndSuppliesList extends StatefulWidget {
  final ToolsAndSuppliesProvider provider;
  const ToolsAndSuppliesList({super.key, required this.provider});

  @override
  State<ToolsAndSuppliesList> createState() => _ToolsAndSuppliesListState();
}

class _ToolsAndSuppliesListState extends State<ToolsAndSuppliesList> {
  final ScrollController horizontalController = ScrollController();
  String searchTerm = "";
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
                    if (widget.provider.data != null)
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
                    child: _buildTable(
                      searchTerm,
                      widget.provider.columns,
                      widget.provider.dataPage ?? [],
                      onViewAction: (item) {},
                      onEditAction: (item) {},
                      onDeleteAction: (item) {
                        _showDeleteConfirmationDialog(
                          context,
                          item,
                          widget.provider,
                        );
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
        _buildPaginationControls(widget.provider),
      ],
    );
  }

  Widget _buildTable(
    String searchTerm,
    List<SgTableColumn<ToolsAndSuppliesDto>> columns,
    List<ToolsAndSuppliesDto> data, {
    Function(ToolsAndSuppliesDto)? onViewAction,
    Function(ToolsAndSuppliesDto)? onEditAction,
    Function(ToolsAndSuppliesDto)? onDeleteAction,
    Function(ToolsAndSuppliesDto)? onRowTap,
    Function(List<ToolsAndSuppliesDto>)? onSelectionChanged,
    Function(ToolsAndSuppliesDto)? onCustomFilter,
  }) {
    return SgTable<ToolsAndSuppliesDto>(
        headerBackgroundColor: ColorValue.primaryBlue,
        textHeaderColor: Colors.white,
        evenRowBackgroundColor: ColorValue.neutral50,
        oddRowBackgroundColor: Colors.white,
        selectedRowColor: ColorValue.primaryLightBlue.withOpacity(0.2),
        checkedRowColor: ColorValue.primaryLightBlue.withOpacity(0.1),
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

  Widget _buildPaginationControls(ToolsAndSuppliesProvider provider) {
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

  void _showDeleteConfirmationDialog(
    BuildContext context,
    ToolsAndSuppliesDto item,
    ToolsAndSuppliesProvider provider,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Xác nhận xóa'),
          content: Text(
            'Bạn có chắc chắn muốn xóa công cụ dụng cụ "${item.name}" không?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Hủy'),
            ),
            TextButton(
              onPressed: () {
                // Xóa item
                provider.deleteItem(item.id);
                Navigator.of(context).pop();
              },
              child: const Text('Xóa', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }
}
