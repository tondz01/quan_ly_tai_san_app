import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:quan_ly_tai_san_app/screen/ToolsAndSupplies/bloc/tools_and_supplies_bloc.dart';
import 'package:quan_ly_tai_san_app/screen/ToolsAndSupplies/model/tools_and_supplies_dto.dart';
import 'package:quan_ly_tai_san_app/screen/ToolsAndSupplies/widget/detail_and_edit.dart';
import 'package:quan_ly_tai_san_app/screen/ToolsAndSupplies/widget/header_component.dart';
import 'package:se_gay_components/common/table/sg_table.dart';
import 'package:se_gay_components/common/table/sg_table_component.dart';
import 'package:se_gay_components/common/pagination/sg_pagination_controls.dart';

import 'bloc/tools_and_supplies_state.dart';
import 'provider/tools_and_supplies_provide.dart';

class ToolsAndSuppliesView extends StatefulWidget {
  const ToolsAndSuppliesView({super.key});

  @override
  State<ToolsAndSuppliesView> createState() => _ToolsAndSuppliesViewState();
}

class _ToolsAndSuppliesViewState extends State<ToolsAndSuppliesView> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController horizontalController = ScrollController();
  String searchTerm = "";

  final List<DropdownMenuItem<int>> items = [
    const DropdownMenuItem(value: 5, child: Text('5')),
    const DropdownMenuItem(value: 10, child: Text('10')),
    const DropdownMenuItem(value: 20, child: Text('20')),
    const DropdownMenuItem(value: 50, child: Text('50')),
  ];

  // Không tạo TextEditingController ở đây để tránh lỗi dispose
  // Thay vào đó, sử dụng controller từ provider hoặc tạo mới trong build

  @override
  void initState() {
    super.initState();
    Provider.of<ToolsAndSuppliesProvider>(
      context,
      listen: false,
    ).onInit(context);
  }

  @override
  void dispose() {
    _searchController.dispose();
    // Không dispose _controllerDropdownPage vì nó không được tạo ở đây
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return BlocConsumer<ToolsAndSuppliesBloc, ToolsAndSuppliesState>(
      listener: (context, state) {
        if (state is ToolsAndSuppliesInitialState) {}
        if (state is ToolsAndSuppliesLoadingState) {}
        if (state is ToolsAndSuppliesLoadingDismissState) {}
        if (state is GetListToolsAndSuppliesSuccessState) {
          log('message GetListToolsAndSuppliesSuccessState');
          context
              .read<ToolsAndSuppliesProvider>()
              .getListToolsAndSuppliesSuccess(context, state);
        }
        if (state is GetListToolsAndSuppliesFailedState) {}
      },
      builder: (context, state) {
        return Scaffold(
          body: Consumer<ToolsAndSuppliesProvider>(
            builder: (context, provider, child) {
              if (provider.isLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              if (provider.data == null) {
                return const Center(child: Text('Không có dữ liệu'));
              }

              provider.controllerDropdownPage ??= TextEditingController(
                  text: provider.rowsPerPage.toString(),
                );

              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const SizedBox(height: 16),
                    buildHeader(size.width, _searchController, (value) {
                      setState(() {
                        searchTerm = value;
                      });
                    }),
                    const SizedBox(height: 16),
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
                            child: ConstrainedBox(
                              constraints: const BoxConstraints(minWidth: 1400),
                              child: _buildTable(
                                searchTerm,
                                provider.columns,
                                provider.dataPage ?? [],
                                onViewAction: (item) {
                                },
                                onEditAction: (item) {
                                },
                                onDeleteAction: (item) {
                                  _showDeleteConfirmationDialog(context, item, provider);
                                },
                                onRowTap: (item) {
                                  _navigateToDetailPage(context, item);
                                },
                                onSelectionChanged: (items) {},
                                onCustomFilter: (item) => false,
                                
                              ),
                            ),
                          ),
                        ),
                      ),

                    _buildPaginationControls(provider),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  void _navigateToDetailPage(BuildContext context, ToolsAndSuppliesDto item) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ToolsAndSuppliesDetailPage(item: item),
      ),
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context, ToolsAndSuppliesDto item, ToolsAndSuppliesProvider provider) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Xác nhận xóa'),
          content: Text('Bạn có chắc chắn muốn xóa công cụ dụng cụ "${item.name}" không?'),
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
}

class ToolsAndSuppliesDetailPage extends StatelessWidget {
  final ToolsAndSuppliesDto item;

  const ToolsAndSuppliesDetailPage({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('tas.info_tools_supplies'.tr),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => DetailAndEditView(
                    item: item,
                  //   onSave: (updatedItem) {
                  //     Provider.of<ToolsAndSuppliesProvider>(context, listen: false)
                  //         .updateItem(updatedItem);
                  //     Navigator.of(context).pop();
                  //   },
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: DetailAndEditView(item: item),
        ),
      ),
    );
  }
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
