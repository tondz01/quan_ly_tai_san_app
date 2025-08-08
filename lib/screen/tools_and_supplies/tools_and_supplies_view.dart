import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:quan_ly_tai_san_app/common/page/common_page_view.dart';

import 'package:quan_ly_tai_san_app/screen/tools_and_supplies/bloc/tools_and_supplies_bloc.dart';
import 'package:quan_ly_tai_san_app/screen/tools_and_supplies/widget/header_component.dart';
import 'package:quan_ly_tai_san_app/screen/tools_and_supplies/widget/tools_and_supplies_detail.dart';
import 'package:quan_ly_tai_san_app/screen/tools_and_supplies/widget/tools_and_supplies_list.dart';
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
  String searchTerm = "";

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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
          log('message: ${state.data.length}');
        }
        if (state is GetListToolsAndSuppliesFailedState) {}
        if (state is CreateToolsAndSuppliesSuccessState) {
          // Refresh list
          context.read<ToolsAndSuppliesProvider>().getListToolsAndSupplies(context);
          // Close input panel if open
          context.read<ToolsAndSuppliesProvider>().isShowInput = false;
          // Show success
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Tạo CCDC - Vật tư thành công!'),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 2),
            ),
          );
        }
        if (state is CreateToolsAndSuppliesFailedState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 3),
            ),
          );
        }
        if (state is UpdateToolsAndSuppliesSuccessState) {
          context.read<ToolsAndSuppliesProvider>().getListToolsAndSupplies(context);
          context.read<ToolsAndSuppliesProvider>().isShowInput = false;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Cập nhật CCDC - Vật tư thành công!'),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 2),
            ),
          );
        }
        if (state is UpdateToolsAndSuppliesFailedState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 3),
            ),
          );
        }
      },
      builder: (context, state) {
        return Consumer<ToolsAndSuppliesProvider>(
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

            return Scaffold(
              appBar: AppBar(
                title: HeaderComponent(
                  controller: _searchController,
                  onSearchChanged: (value) {
                    provider.onSearchToolsAndSupplies(value);
                  },
                  onTap: () {
                    // provider.onChangeDetailAssetTransfer(null);
                  },
                  onNew: () {
                    provider.onChangeDetail(context, null);
                  },
                  mainScreen: 'Quản lý CCDC - Vật tư',
                  subScreen: provider.subScreen,
                ),
              ),
              body: Column(
                children: [
                  Flexible(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: CommonPageView(
                        childInput: ToolsAndSuppliesDetail(
                          item: provider.item,
                        ),
                        childTableView: ToolsAndSuppliesList(
                          provider: provider,
                        ),
                        isShowInput: provider.isShowInput,
                        isShowCollapse: provider.isShowCollapse,
                        onExpandedChanged: (isExpanded) {
                          provider.isShowCollapse = isExpanded;
                        },
                      ),
                    ),
                  ),
                  Visibility(
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
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
