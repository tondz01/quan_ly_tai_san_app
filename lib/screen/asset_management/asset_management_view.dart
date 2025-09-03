import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:quan_ly_tai_san_app/common/page/common_page_view.dart';
import 'package:quan_ly_tai_san_app/core/constants/app_colors.dart';
import 'package:quan_ly_tai_san_app/core/utils/utils.dart';
import 'package:quan_ly_tai_san_app/screen/asset_management/bloc/asset_management_state.dart';
import 'package:quan_ly_tai_san_app/screen/asset_management/bloc/asset_management_bloc.dart';
import 'package:quan_ly_tai_san_app/screen/asset_management/provider/asset_management_provider.dart';
import 'package:quan_ly_tai_san_app/screen/asset_management/widget/asset_depreciation_detail.dart';
import 'package:quan_ly_tai_san_app/screen/asset_management/widget/asset_depreciation_list.dart';
import 'package:quan_ly_tai_san_app/screen/asset_management/widget/asset_detail.dart';
import 'package:quan_ly_tai_san_app/screen/asset_management/widget/asset_management_list.dart';
import 'package:quan_ly_tai_san_app/common/components/header_component.dart';

class AssetManagementView extends StatefulWidget {
  const AssetManagementView({super.key});

  @override
  State<AssetManagementView> createState() => _AssetManagementViewState();
}

class _AssetManagementViewState extends State<AssetManagementView> {
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _searchKhauHaoController =
      TextEditingController();
  String searchTerm = "";
  bool isShowKhauHao = false;

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
                    controller:
                        provider.typeBody == ShowBody.taiSan
                            ? _searchController
                            : _searchKhauHaoController,
                    onSearchChanged: (value) {
                      // provider.searchTerm = value;
                    },
                    onTap: () {
                      // provider.onChangeDetailAssetManagement(null);
                      provider.onChangeBody(ShowBody.taiSan);
                    },
                    onNew: () {
                      // provider.onChangeDetailAssetManagement(null);
                      if (provider.typeBody == ShowBody.taiSan) {
                        provider.onChangeDetail(null);
                      }
                    },
                    mainScreen: "Quản lý tài sản",
                    subScreen: provider.subScreen,
                  ),
                ),
                body: Column(
                  children: [
                    provider.typeBody == ShowBody.taiSan
                        ? Flexible(
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
                        )
                        : Flexible(
                          child: SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: CommonPageView(
                              childInput: AssetDepreciationDetail(
                                provider: provider,
                              ),
                              childTableView: AssetDepreciationList(
                                provider: provider,
                              ),
                              title: "Chi tiết khấu hao tài sản",
                              isShowInput: provider.isShowInputKhauHao,
                              isShowCollapse: provider.isShowCollapseKhauHao,
                              onExpandedChanged: (isExpanded) {
                                provider.isShowCollapseKhauHao = isExpanded;
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
        if (state is GetListChildAssetsSuccessState) {
          context.read<AssetManagementProvider>().getListChildAssetsSuccess(
            context,
            state,
          );
        }
        if (state is GetListChildAssetsFailedState) {
          log('GetListChildAssetsFailedState');
        }
        if (state is GetListKhauHaoSuccessState) {
          context.read<AssetManagementProvider>().getListKhauHaoSuccess(
            context,
            state,
          );
        }
        if (state is GetListKhauHaoFailedState) {
          log('GetListChildAssetsFailedState');
        }
        if (state is GetListAssetGroupSuccessState) {
          context.read<AssetManagementProvider>().getListAssetGroupSuccess(
            context,
            state,
          );
        }
        if (state is GetListAssetGroupFailedState) {
          log('GetListAssetGroupFailedState');
        }
        if (state is GetListProjectSuccessState) {
          context.read<AssetManagementProvider>().getListProjectSuccess(
            context,
            state,
          );
        }
        if (state is GetListKhauHaoFailedState) {
          log('GetListProjectFailedState');
        }
        if (state is GetListCapitalSourceSuccessState) {
          context.read<AssetManagementProvider>().getListCapitalSourceSuccess(
            context,
            state,
          );
        }
        if (state is GetListCapitalSourceFailedState) {
          log('GetListCapitalSourceFailedState');
        }
        if (state is GetListDepartmentSuccessState) {
          context.read<AssetManagementProvider>().getListDepartmentSuccess(
            context,
            state,
          );
        }
        if (state is GetListDepartmentFailedState) {
          log('Error at GetListDepartmentFailedState: ${state.message}');
        }
        if (state is GetAllChildAssetsSuccessState) {
          context.read<AssetManagementProvider>().getAllChildAssetsSuccess(
            context,
            state,
          );
        }
        if (state is GetAllChildAssetsFailedState) {
          log('GetAllChildAssetsFailedState');
        }
        if (state is CreateAssetSuccessState) {
          log('DeleteAssetSuccessState');
          context.read<AssetManagementProvider>().createAssetSuccess(
            context,
            state,
          );
        }
        if (state is DeleteAssetSuccessState) {
          log('DeleteAssetSuccessState');
          context.read<AssetManagementProvider>().deleteAssetSuccess(
            context,
            state,
          );
        }
        if (state is UpdateAssetSuccessState) {
          context.read<AssetManagementProvider>().updateAssetSuccess(
            context,
            state,
          );
        }
        if (state is UpdateAndDeleteAssetFailedState) {
          log('DeleteAssetFailedState');
          AppUtility.showSnackBar(context, state.message);
        }
      },
    );
  }
}
