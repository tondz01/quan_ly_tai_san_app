import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:quan_ly_tai_san_app/common/page/common_page_view.dart';
import 'package:quan_ly_tai_san_app/core/constants/app_colors.dart';
import 'package:quan_ly_tai_san_app/screen/asset_management/bloc/asset_management_state.dart';
import 'package:quan_ly_tai_san_app/screen/asset_management/bloc/asset_management_bloc.dart';
import 'package:quan_ly_tai_san_app/screen/asset_management/provider/asset_management_provider.dart';
import 'package:quan_ly_tai_san_app/screen/asset_management/widget/asset_detail.dart';
import 'package:quan_ly_tai_san_app/screen/asset_management/widget/asset_management_list.dart';
import 'package:quan_ly_tai_san_app/screen/tools_and_supplies/widget/header_component.dart';

class AssetManagementView extends StatefulWidget {
  const AssetManagementView({super.key});

  @override
  State<AssetManagementView> createState() => _AssetManagementViewState();
}

class _AssetManagementViewState extends State<AssetManagementView> {
  final TextEditingController _searchController = TextEditingController();
  String searchTerm = "";

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AssetManagementProvider>(
        context,
        listen: false,
      ).onInit(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AssetManagementBloc, AssetManagementState>(
      builder: (context, state) {
        return ChangeNotifierProvider.value(
          value: context.read<AssetManagementProvider>(),
          child: Consumer<AssetManagementProvider>(
            builder: (context, provider, child) {
              if (provider.isLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              if (provider.data == null) {
                return const Center(child: Text('Không có dữ liệu'));
              }

              return Scaffold(
                backgroundColor: ColorValue.neutral50,
                appBar: AppBar(
                  title: HeaderComponent(
                    controller: _searchController,
                    onSearchChanged: (value) {
                      // provider.searchTerm = value;
                    },
                    onTap: () {
                      // provider.onChangeDetailAssetManagement(null);
                    },
                    onNew: () {
                      // provider.onChangeDetailAssetManagement(null);
                      provider.onChangeDetail(null);
                    },
                    mainScreen: "Quản lý tài sản",
                    subScreen: provider.subScreen,
                  ),
                ),
                body: Column(
                  children: [
                    Flexible(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: CommonPageView(
                          childInput: AssetDetail(provider: provider),
                          childTableView: AssetManagementList(
                            provider: provider,
                          ),
                          title: "Tạo tài sản",
                          isShowInput: provider.isShowInput,
                          isShowCollapse: provider.isShowCollapse,
                          onExpandedChanged: (isExpanded) {
                            provider.isShowCollapse = isExpanded;
                          },
                        ),
                      ),
                    ),
                    // Visibility(
                    //   visible: (provider.data?.length ?? 0) >= 5,
                    //   child: SGPaginationControls(
                    //     totalPages: provider.totalPages,
                    //     currentPage: provider.currentPage,
                    //     rowsPerPage: provider.rowsPerPage,
                    //     controllerDropdownPage:
                    //         provider.controllerDropdownPage!,
                    //     items: provider.items,
                    //     onPageChanged: provider.onPageChanged,
                    //     onRowsPerPageChanged: provider.onRowsPerPageChanged,
                    //   ),
                    // ),
                  ],
                ),
              );
            },
          ),
        );
      },
      listener: (context, state) {
        if (state is AssetManagementLoadingState) {
          // Mostrar loading
        }
        if (state is GetListAssetManagementSuccessState) {
          log('GetListAssetManagementSuccessState ${state.data.length}');
          context.read<AssetManagementProvider>().getListAssetManagementSuccess(
            context,
            state,
          );
        }
        if (state is GetListAssetManagementFailedState) {
          // Manejar error
          log('GetListAssetManagementFailedState');
          // context.read<AssetManagementProvider>().getListAssetManagementFailed(
          //   context,
          //   state,
          // );
        }
        if (state is GetListAssetGroupSuccessState) {
          log('GetListAssetGroupSuccessState ${state.data.length}');
          context.read<AssetManagementProvider>().getListAssetGroupSuccess(
            context,
            state,
          );
          log('message: ${context.read<AssetManagementProvider>().dataGroup}');
        }
        if (state is GetListAssetGroupFailedState) {
          log('GetListAssetGroupFailedState');
        }
        if (state is GetListProjectSuccessState) {
          log('GetListProjectSuccessState ${state.data.length}');
          context.read<AssetManagementProvider>().getListProjectSuccess(
            context,
            state,
          );
          log(
            'message: ${context.read<AssetManagementProvider>().dataProject}',
          );
        }
        if (state is GetListProjectFailedState) {
          log('GetListProjectFailedState');
        }
        if (state is GetListCapitalSourceSuccessState) {
          log('GetListCapitalSourceSuccessState ${state.data.length}');
          context.read<AssetManagementProvider>().getListCapitalSourceSuccess(
            context,
            state,
          );
          log(
            'message: ${context.read<AssetManagementProvider>().dataCapitalSource}',
          );
        }
        if (state is GetListCapitalSourceFailedState) {
          log('GetListCapitalSourceFailedState');
        }
      },
    );
  }
}
