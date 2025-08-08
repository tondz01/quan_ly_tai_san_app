import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:quan_ly_tai_san_app/common/page/common_page_view.dart';
import 'package:quan_ly_tai_san_app/screen/asset_category/bloc/asset_category_bloc.dart';
import 'package:quan_ly_tai_san_app/screen/asset_category/bloc/asset_category_state.dart';
import 'package:quan_ly_tai_san_app/screen/asset_category/provider/asset_category_provide.dart';
import 'package:quan_ly_tai_san_app/screen/asset_category/widget/asset_category_detail.dart';
import 'package:quan_ly_tai_san_app/screen/asset_category/widget/asset_category_list.dart';
import 'package:quan_ly_tai_san_app/screen/tools_and_supplies/widget/header_component.dart';
import 'package:se_gay_components/common/pagination/sg_pagination_controls.dart';

class AssetCategoryView extends StatefulWidget {
  const AssetCategoryView({super.key});

  @override
  State<AssetCategoryView> createState() => _AssetCategoryViewState();
}

class _AssetCategoryViewState extends State<AssetCategoryView> {
  final TextEditingController _searchController = TextEditingController();
  String searchTerm = "";

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AssetCategoryProvider>(
        context,
        listen: false,
      ).onInit(context);
    });
  }

  @override
  void didUpdateWidget(AssetCategoryView oldWidget) {
    super.didUpdateWidget(oldWidget);
    log('AssetCategoryView message didUpdateWidget');
    // if (oldWidget.typeAssetTransfer != widget.typeAssetTransfer) {
    //   currentType = widget.typeAssetTransfer;
    //   _initData();
    // }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AssetCategoryBloc, AssetCategoryState>(
      builder: (context, state) {
        // Usar el ChangeNotifierProvider.value en lugar de Consumer
        // Esto asegura que todos los cambios en el provider actualizan la UI
        return ChangeNotifierProvider.value(
          value: context.read<AssetCategoryProvider>(),
          child: Consumer<AssetCategoryProvider>(
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
                      // Cập nhật trạng thái tìm kiếm trong provider
                      provider.searchTerm = value;
                    },
                    onTap: () {},
                    onNew: () {
                      provider.onChangeDetail(null);
                    },
                    mainScreen: 'Nhóm tài sản',
                  ),
                ),
                body: Column(
                  children: [
                    Flexible(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: CommonPageView(
                          title: "Chi tiết nhóm tài sản",
                          childInput: AssetCategoryDetail(provider: provider),
                          childTableView: AssetCategoryList(provider: provider),
                          isShowInput: provider.isShowInput,
                          isShowCollapse: provider.isShowCollapse,
                          onExpandedChanged: (isExpanded) {
                            provider.isShowCollapse = isExpanded;
                            log(
                              'message isShowCollapse: ${provider.isShowCollapse}',
                            );
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

      listener: (context, state) {
        if (state is AssetCategoryLoadingState) {
          // Mostrar loading
        }
        if (state is GetListAssetCategorySuccessState) {
          log('GetListAssetCategorySuccessState ${state.data.length}');
          context.read<AssetCategoryProvider>().getListAssetCategorySuccess(
            context,
            state,
          );
        }

        if (state is GetListAssetCategoryFailedState) {
          // Manejar error
          log('GetListAssetCategoryFailedState');
          context.read<AssetCategoryProvider>().getListAssetCategoryFailed(
            context,
            state,
          );
        }
        if (state is CreateAssetCategorySuccessState) {
          log('CreateAssetCategorySuccessState');
          context.read<AssetCategoryProvider>().createAssetCategorySuccess(
            context,
            state,
          );
        }
        if (state is CreateAssetCategoryFailedState) {
          log('CreateAssetCategoryFailedState');
          context.read<AssetCategoryProvider>().createAssetCategoryFailed(
            context,
            state,
          );
        }
        if (state is GetListAssetCategoryFailedState) {
          // Manejar error
          log('GetListAssetCategoryFailedState');
          context.read<AssetCategoryProvider>().getListAssetCategoryFailed(
            context,
            state,
          );
        }
        if (state is UpdateAssetCategorySuccessState) {
          log('UpdateAssetCategorySuccessState');
          context.read<AssetCategoryProvider>().updateAssetCategorySuccess(
            context,
            state,
          );
        }
        if (state is DeleteAssetCategorySuccessState) {
          log('DeleteAssetCategorySuccessState');
          context.read<AssetCategoryProvider>().deleteAssetCategorySuccess(
            context,
            state,
          );
        }
        if (state is PutPostDeleteFailedState) {
          log('PutPostDeleteFailedState');
          context.read<AssetCategoryProvider>().putPostDeleteFailed(
            context,
            state,
          );
        }
      },
    );
  }
}
