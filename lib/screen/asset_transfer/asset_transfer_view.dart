import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:quan_ly_tai_san_app/common/page/common_page_view.dart';
import 'package:quan_ly_tai_san_app/screen/asset_transfer/bloc/dieu_dong_tai_san_bloc.dart';
import 'package:quan_ly_tai_san_app/screen/asset_transfer/bloc/dieu_dong_tai_san_state.dart';
import 'package:quan_ly_tai_san_app/screen/asset_transfer/provider/dieu_dong_tai_san_provider.dart';
import 'package:quan_ly_tai_san_app/screen/asset_transfer/widget/dieu_dong_tai_san_detail.dart';
import 'package:quan_ly_tai_san_app/screen/asset_transfer/widget/dieu_dong_tai_san_list.dart';
import 'package:quan_ly_tai_san_app/screen/tools_and_supplies/widget/header_component.dart';
import 'package:se_gay_components/common/pagination/sg_pagination_controls.dart';

class AssetTransferView extends StatefulWidget {
  final int typeAssetTransfer;


  const AssetTransferView({super.key, required this.typeAssetTransfer});

  @override
  State<AssetTransferView> createState() => _AssetTransferViewState();
}

class _AssetTransferViewState extends State<AssetTransferView> {
  final TextEditingController _searchController = TextEditingController();
  String searchTerm = "";
  late int currentType;
  String idCongTy = "CT001";

  @override
  void initState() {
    super.initState();
    currentType = widget.typeAssetTransfer;
    _initData();
  }

  @override
  void didUpdateWidget(AssetTransferView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.typeAssetTransfer != widget.typeAssetTransfer) {
      currentType = widget.typeAssetTransfer;
      _initData();
    }
  }

  void _initData() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<DieuDongTaiSanProvider>(
        context,
        listen: false,
      ).onInit(context,currentType);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  String _getScreenTitle() {
    switch (currentType) {
      case 1:
        return 'Cấp phát tài sản';
      case 2:
        return 'Thu hồi tài sản';
      case 3:
        return 'Điều chuyển tài sản';
      default:
        return 'Quản lý tài sản';
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DieuDongTaiSanBloc, DieuDongTaiSanState>(
      listener: (context, state) {
        if (state is DieuDongTaiSanLoadingState) {
        } else if (state is GetListDieuDongTaiSanSuccessState) {
          log('GetListAssetTransferSuccessState');
          context.read<DieuDongTaiSanProvider>().getListDieuDongTaiSanSuccess(
            context,
            state,
          );
        } else if (state is GetListDieuDongTaiSanFailedState) {}
      },
      builder: (context, state) {
        return ChangeNotifierProvider.value(
          value: context.read<DieuDongTaiSanProvider>(),
          child: Consumer<DieuDongTaiSanProvider>(
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
                      // provider.onChangeDetail(context, item)
                      // provider.onChangeDetailAssetTransfer(null);
                    },
                    mainScreen: _getScreenTitle(),
                    subScreen: provider.subScreen,
                  ),
                ),
                body: Column(
                  children: [
                    Flexible(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: CommonPageView(
                          childInput: DieuDongTaiSanDetail(provider: provider),
                          childTableView: DieuDongTaiSanList(
                            provider: provider,
                            typeAssetTransfer: currentType, idCongTy: 'CT001',
                          ),
                          title: "Chi tiết điều chuyển tài sản",
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
