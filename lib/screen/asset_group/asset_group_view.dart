import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:quan_ly_tai_san_app/common/page/common_page_view.dart';
import 'package:quan_ly_tai_san_app/screen/asset_group/bloc/asset_group_bloc.dart';
import 'package:quan_ly_tai_san_app/screen/asset_group/bloc/asset_group_state.dart';
import 'package:quan_ly_tai_san_app/screen/asset_group/provider/asset_group_provide.dart';
import 'package:quan_ly_tai_san_app/screen/asset_group/widget/asset_group_detail.dart';
import 'package:quan_ly_tai_san_app/screen/asset_group/widget/asset_group_list.dart';
import 'package:quan_ly_tai_san_app/screen/tools_and_supplies/widget/header_component.dart';
import 'package:se_gay_components/common/pagination/sg_pagination_controls.dart';

class AssetGroupView extends StatefulWidget {
  const AssetGroupView({super.key});

  @override
  State<AssetGroupView> createState() => _AssetGroupViewState();
}

class _AssetGroupViewState extends State<AssetGroupView> {
  final TextEditingController _searchController = TextEditingController();
  String searchTerm = "";

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AssetGroupProvider>(context, listen: false).onInit(context);
    });
  }

  @override
  void didUpdateWidget(AssetGroupView oldWidget) {
    super.didUpdateWidget(oldWidget);
    log('AssetGroupView message didUpdateWidget');
    // if (oldWidget.typeAssetTransfer != widget.typeAssetTransfer) {
    //   currentType = widget.typeAssetTransfer;
    //   _initData();
    // }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AssetGroupBloc, AssetGroupState>(
      builder: (context, state) {
        // Usar el ChangeNotifierProvider.value en lugar de Consumer
        // Esto asegura que todos los cambios en el provider actualizan la UI
        return ChangeNotifierProvider.value(
          value: context.read<AssetGroupProvider>(),
          child: Consumer<AssetGroupProvider>(
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
                          childInput: AssetGroupDetail(provider: provider),
                          childTableView: AssetGroupList(provider: provider),
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
        if (state is AssetGroupLoadingState) {
          // Mostrar loading
        }
        if (state is GetListAssetGroupSuccessState) {
          log('GetListAssetGroupSuccessState ${state.data.length}');
          context.read<AssetGroupProvider>().getListAssetGroupSuccess(
            context,
            state,
          );
        }
        if (state is CreateAssetGroupSuccessState) {
          log('CreateAssetGroupSuccessState');
          context.read<AssetGroupProvider>().createAssetGroupSuccess(
            context,
            state,
          );
        }
        if (state is CreateAssetGroupFailedState) {
          log('CreateAssetGroupFailedState');
          context.read<AssetGroupProvider>().createAssetGroupFailed(
            context,
            state,
          );
        }
        if (state is GetListAssetGroupFailedState) {
          // Manejar error
          log('GetListAssetGroupFailedState');
          context.read<AssetGroupProvider>().getListAssetGroupFailed(
            context,
            state,
          );
        }
        if (state is UpdateAssetGroupSuccessState) {
          log('UpdateAssetGroupSuccessState');
          context.read<AssetGroupProvider>().updateAssetGroupSuccess(
            context,
            state,
          );
        }
        if (state is DeleteAssetGroupSuccessState) {
          log('DeleteAssetGroupSuccessState');
          context.read<AssetGroupProvider>().deleteAssetGroupSuccess(
            context,
            state,
          );
        }
        if (state is PutPostDeleteFailedState) {
          log('PutPostDeleteFailedState');
          context.read<AssetGroupProvider>().putPostDeleteFailed(
            context,
            state,
          );
        }
      },
    );
  }
}
