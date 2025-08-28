import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:quan_ly_tai_san_app/common/page/common_page_view.dart';
import 'package:quan_ly_tai_san_app/screen/asset_group/bloc/asset_group_bloc.dart';
import 'package:quan_ly_tai_san_app/screen/asset_group/bloc/asset_group_state.dart';
import 'package:quan_ly_tai_san_app/screen/asset_group/provider/asset_group_provide.dart';
import 'package:quan_ly_tai_san_app/screen/ccdc_group/widget/ccdc_group_detail.dart';
import 'package:quan_ly_tai_san_app/screen/ccdc_group/widget/ccdc_group_list.dart';
import 'package:quan_ly_tai_san_app/screen/tools_and_supplies/widget/header_component.dart';
import 'package:se_gay_components/common/pagination/sg_pagination_controls.dart';

class CcdcGroupView extends StatefulWidget {
  const CcdcGroupView({super.key});

  @override
  State<CcdcGroupView> createState() => _CcdcGroupViewState();
}

class _CcdcGroupViewState extends State<CcdcGroupView> {
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
  Widget build(BuildContext context) {
    return BlocConsumer<AssetGroupBloc, AssetGroupState>(
      listener: (context, state) {
        if (state is AssetGroupLoadingState) {
        }
        if (state is GetListAssetGroupSuccessState) {
          context.read<AssetGroupProvider>().getListAssetGroupSuccess(
            context,
            state,
          );
        }
        if (state is CreateAssetGroupSuccessState) {
          context.read<AssetGroupProvider>().createAssetGroupSuccess(
            context,
            state,
          );
        }
        if (state is CreateAssetGroupFailedState) {
          context.read<AssetGroupProvider>().createAssetGroupFailed(
            context,
            state,
          );
        }
        if (state is GetListAssetGroupFailedState) {
          context.read<AssetGroupProvider>().getListAssetGroupFailed(
            context,
            state,
          );
        }
        if (state is UpdateAssetGroupSuccessState) {
          context.read<AssetGroupProvider>().updateAssetGroupSuccess(
            context,
            state,
          );
        }
        if (state is DeleteAssetGroupSuccessState) {
          context.read<AssetGroupProvider>().deleteAssetGroupSuccess(
            context,
            state,
          );
        }
        if (state is PutPostDeleteFailedState) {
          context.read<AssetGroupProvider>().putPostDeleteFailed(
            context,
            state,
          );
        }
      },
      builder: (context, state) {
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
                      provider.searchTerm = value;
                    },
                    onTap: () {},
                    onNew: () {
                      provider.onChangeDetail(null);
                    },
                    mainScreen: 'Nhóm ccdc',
                  ),
                ),
                body: Column(
                  children: [
                    Flexible(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: CommonPageView(
                          title: "Chi tiết nhóm ccdc",
                          childInput: CcdcGroupDetail(provider: provider),
                          childTableView: CcdcGroupList(provider: provider),
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
