import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:quan_ly_tai_san_app/common/components/header_component.dart';
import 'package:quan_ly_tai_san_app/common/page/common_page_view.dart';
import 'package:quan_ly_tai_san_app/routes/routes.dart';
import 'package:quan_ly_tai_san_app/screen/asset_handover/bloc/asset_handover_event.dart';
import 'package:quan_ly_tai_san_app/screen/asset_handover/model/asset_handover_dto.dart';
import 'package:quan_ly_tai_san_app/screen/asset_handover/widget/asset_handover_detail.dart';
import 'package:quan_ly_tai_san_app/screen/asset_handover/widget/tab_bar_table_asset.dart';

import 'package:se_gay_components/common/pagination/sg_pagination_controls.dart';
import 'package:se_gay_components/core/utils/sg_log.dart';

import 'bloc/asset_handover_bloc.dart';
import 'bloc/asset_handover_state.dart';
import 'provider/asset_handover_provider.dart';

class AssetHandoverView extends StatefulWidget {
  const AssetHandoverView({super.key});

  @override
  State<AssetHandoverView> createState() => _AssetHandoverViewState();
}

class _AssetHandoverViewState extends State<AssetHandoverView> {
  AssetHandoverDto? assetHandoverData;
  Map<String, dynamic>? menuSelectionData;
  final TextEditingController _searchController = TextEditingController();
  String searchTerm = "";

  @override
  void initState() {
    super.initState();
    _initData();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final extra = GoRouterState.of(context).extra;

    if (extra is Map<String, dynamic>) {
      assetHandoverData = extra['AssetHandoverDto'] as AssetHandoverDto?;
      menuSelectionData = extra['menuSelection'] as Map<String, dynamic>?;

      if (assetHandoverData != null) {
        _handleAssetHandoverData(assetHandoverData!);
      }

      if (menuSelectionData != null) {
        _updateMenuSelection();
      }
    } else if (extra is AssetHandoverDto) {
      assetHandoverData = extra;
      if (assetHandoverData != null) {
        _handleAssetHandoverData(assetHandoverData!);
      }
    }
  }

  void _updateMenuSelection() {
    if (menuSelectionData != null) {
      final selectedIndex = menuSelectionData!['selectedIndex'] as int?;
      final selectedSubIndex = menuSelectionData!['selectedSubIndex'] as int?;

      if (selectedIndex != null && selectedSubIndex != null) {
        SGLog.debug(
          'AssetHandoverView',
          'Updating menu selection: index=$selectedIndex, subIndex=$selectedSubIndex',
        );
        // Có thể thêm logic để cập nhật menu selection ở đây nếu cần
      }
    }
  }

  void _handleAssetHandoverData(AssetHandoverDto assetHandoverDto) {
    final provider = Provider.of<AssetHandoverProvider>(context, listen: false);

    provider.onInit(context);
    provider.onChangeDetail(context, assetHandoverDto);
  }

  @override
  void didUpdateWidget(AssetHandoverView oldWidget) {
    super.didUpdateWidget(oldWidget);
    _initData();
  }

  void _initData() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<AssetHandoverProvider>(
        context,
        listen: false,
      );

      // Chỉ khởi tạo nếu không có data từ router
      if (assetHandoverData == null) {
        provider.onInit(context);
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AssetHandoverBloc, AssetHandoverState>(
      listener: (context, state) {
        if (state is AssetHandoverLoadingState) {
        } else if (state is GetListAssetHandoverSuccessState) {
          log('message filteredData  state ${state.data}');
          context.read<AssetHandoverProvider>().getListAssetHandoverSuccess(
            context,
            state,
          );
        } else if (state is CreateAssetHandoverSuccessState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Tạo biên bản bàn giao thành công'),
              backgroundColor: Colors.green,
            ),
          );
          context.read<AssetHandoverBloc>().add(
            GetListAssetHandoverEvent(context),
          );
          context.read<AssetHandoverProvider>().isShowInput = false;
        } else if (state is UpdateAssetHandoverSuccessState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Cập nhật biên bản bàn giao thành công'),
              backgroundColor: Colors.green,
            ),
          );
          context.read<AssetHandoverBloc>().add(
            GetListAssetHandoverEvent(context),
          );
          context.read<AssetHandoverProvider>().isShowInput = false;
        } else if (state is DeleteAssetHandoverSuccessState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Xóa biên bản bàn giao thành công'),
              backgroundColor: Colors.green,
            ),
          );

          context.read<AssetHandoverBloc>().add(
            GetListAssetHandoverEvent(context),
          );
          context.read<AssetHandoverProvider>().isShowInput = false;
        } else if (state is ErrorState) {
          context.read<AssetHandoverProvider>().isLoading = false;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Lỗi: ${state.message}'),
              backgroundColor: Colors.red,
            ),
          );
        } else if (state is UpdateSigningStatusSuccessState) {
          // bool isUpdateOwnershipUnit = state.isUpdateOwnershipUnit;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Cập nhật trạng thái ký biên bản thành công'),
              backgroundColor: Colors.green,
            ),
          );
          context.read<AssetHandoverBloc>().add(
            GetListAssetHandoverEvent(context),
          );
          context.read<AssetHandoverProvider>().isShowInput = false;
        } else if (state is CancelAssetHandoverSuccessState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Hủy biên bản bàn giao thành công'),
              backgroundColor: Colors.green,
            ),
          );
          context.read<AssetHandoverBloc>().add(
            GetListAssetHandoverEvent(context),
          );
          context.read<AssetHandoverProvider>().isShowInput = false;
        }
      },
      builder: (context, state) {
        return ChangeNotifierProvider.value(
          value: context.read<AssetHandoverProvider>(),
          child: Consumer<AssetHandoverProvider>(
            builder: (context, provider, child) {
              if (provider.isLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              // Ensure pagination controller is initialized before use
              provider.controllerDropdownPage ??= TextEditingController(
                text: provider.rowsPerPage.toString(),
              );
              return Scaffold(
                appBar: AppBar(
                  title: HeaderComponent(
                    controller: _searchController,
                    onSearchChanged: (value) {
                      provider.searchTerm = value;
                    },
                    onTap: provider.onTapBackHeader,
                    onNew: () {
                      provider.onChangeDetail(context, null);
                      provider.onTapNewHeader();
                    },
                    mainScreen: 'Biên bản bàn giao tài sản',
                    subScreen: provider.subScreen,
                  ),
                ),
                body: Column(
                  children: [
                    Flexible(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: CommonPageView(
                          title: "Chi tiết biên bản bàn giao tài sản",
                          childInput: AssetHandoverDetail(provider: provider,isFindNew: provider.isFindNew,),
                          childTableView: TabBarTableAsset(provider: provider),
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
