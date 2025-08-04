import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:quan_ly_tai_san_app/common/page/common_page_view.dart';
import 'package:quan_ly_tai_san_app/screen/tool_and_material_transfer/bloc/tool_and_material_transfer_bloc.dart';
import 'package:quan_ly_tai_san_app/screen/tool_and_material_transfer/bloc/tool_and_material_transfer_state.dart';
import 'package:quan_ly_tai_san_app/screen/tool_and_material_transfer/provider/tool_and_material_transfer_provider.dart';
import 'package:quan_ly_tai_san_app/screen/tool_and_material_transfer/widget/tool_and_material_transfer_detail.dart';
import 'package:quan_ly_tai_san_app/screen/tool_and_material_transfer/widget/tool_and_material_transfer_list.dart';
import 'package:quan_ly_tai_san_app/screen/tools_and_supplies/widget/header_component.dart';
import 'package:se_gay_components/common/pagination/sg_pagination_controls.dart';

class ToolAndMaterialTransferView extends StatefulWidget {

  const ToolAndMaterialTransferView({super.key});

  @override
  State<ToolAndMaterialTransferView> createState() => _ToolAndMaterialTransferViewState();
}

class _ToolAndMaterialTransferViewState extends State<ToolAndMaterialTransferView> {
  final TextEditingController _searchController = TextEditingController();
  String searchTerm = "";

  @override
  void initState() {
    super.initState();
    _initData();
  }

  @override
  void didUpdateWidget(ToolAndMaterialTransferView oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  void _initData() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ToolAndMaterialTransferProvider>(
        context,
        listen: false,
      ).onInit(context);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ToolAndMaterialTransferBloc, ToolAndMaterialTransferState>(
      listener: (context, state) {
        if (state is ToolAndMaterialTransferLoadingState) {
        } else if (state is GetListToolAndMaterialTransferSuccessState) {
          log('GetListAssetTransferSuccessState');
          context.read<ToolAndMaterialTransferProvider>().getListToolAndMaterialTransferSuccess(
            context,
            state,
          );
        } else if (state is GetListToolAndMaterialTransferFailedState) {}
      },
      builder: (context, state) {
        return ChangeNotifierProvider.value(
          value: context.read<ToolAndMaterialTransferProvider>(),
          child: Consumer<ToolAndMaterialTransferProvider>(
            builder: (context, provider, child) {
              if (provider.isLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              if (provider.data == null) {
                return const Center(child: Text('Không có dữ liệu'));
              }

              return Scaffold(
                appBar: AppBar(
                  title: HeaderComponent(
                    controller: _searchController,
                    onSearchChanged: (value) {
                      provider.searchTerm = value;
                    },
                    onTap: () {
                      // provider.onChangeDetailAssetTransfer(null);
                    },
                    onNew: () {
                      provider.onChangeDetailToolAndMaterialTransfer(null);
                    },
                    mainScreen: 'Điều động CCDC-Vật tư',
                    subScreen: provider.subScreen,
                  ),
                ),
                body: Column(
                  children: [
                    Flexible(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        
                        child: CommonPageView(
                          childInput: ToolAndMaterialTransferDetail(provider: provider),
                          childTableView: ToolAndMaterialTransferList(
                            provider: provider,
                          ),
                          title: "Chi tiết điều chuyển CCDC-Vật tư",
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
                        controllerDropdownPage:
                            provider.controllerDropdownPage!,
                        items: provider.items,
                        onPageChanged: provider.onPageChanged,
                        onRowsPerPageChanged: provider.onRowsPerPageChanged,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}
