import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:quan_ly_tai_san_app/screen/ToolsAndSupplies/bloc/tools_and_supplies_bloc.dart';
import 'package:quan_ly_tai_san_app/screen/ToolsAndSupplies/model/tools_and_supplies_dto.dart';
import 'package:quan_ly_tai_san_app/screen/ToolsAndSupplies/widget/header_component.dart';
import 'package:se_gay_components/common/table/sg_table.dart';
import 'package:se_gay_components/common/table/sg_table_component.dart';

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
  @override
  void initState() {
    Provider.of<ToolsAndSuppliesProvider>(
      context,
      listen: false,
    ).onInit(context);
    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
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
              log('message provider data: ${provider.data}');
              log(
                'message provider data check : ${provider.data != null} -- ${provider.data != []}',
              );

              if (provider.isLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
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
                                provider.data,
                                onViewAction: (item) {},
                                onEditAction: (item) {},
                                onDeleteAction: (item) {},
                                onRowTap: (item) {},
                                onSelectionChanged: (items) {},
                                onCustomFilter: (item) => false,
                              ),
                            ),
                          ),
                        ),
                      ),
                    const SizedBox(height: 16),
                  ],
                ),
              );
            },
          ),
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
        onRowTap?.call(item);
      },
    );
  }
}
