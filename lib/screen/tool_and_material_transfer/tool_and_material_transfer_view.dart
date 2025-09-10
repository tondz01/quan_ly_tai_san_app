import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:quan_ly_tai_san_app/common/page/common_page_view.dart';
import 'package:quan_ly_tai_san_app/core/utils/utils.dart';
import 'package:quan_ly_tai_san_app/screen/tool_and_material_transfer/provider/tool_and_material_transfer_provider.dart';
import 'package:quan_ly_tai_san_app/screen/tool_and_material_transfer/widget/tool_and_material_transfer_detail.dart';
import 'package:quan_ly_tai_san_app/screen/tool_and_material_transfer/widget/tool_and_material_transfer_list.dart';
import 'package:quan_ly_tai_san_app/common/components/header_component.dart';
import 'package:se_gay_components/common/pagination/sg_pagination_controls.dart';
import 'package:quan_ly_tai_san_app/screen/tool_and_material_transfer/bloc/tool_and_material_transfer_bloc.dart';
import 'package:quan_ly_tai_san_app/screen/tool_and_material_transfer/bloc/tool_and_material_transfer_state.dart';

class ToolAndMaterialTransferView extends StatefulWidget {
  final int typeAssetTransfer;

  const ToolAndMaterialTransferView({
    super.key,
    required this.typeAssetTransfer,
  });

  @override
  State<ToolAndMaterialTransferView> createState() =>
      _ToolAndMaterialTransferViewState();
}

class _ToolAndMaterialTransferViewState
    extends State<ToolAndMaterialTransferView>
    with AutomaticKeepAliveClientMixin {
  final TextEditingController _searchController = TextEditingController();
  String searchTerm = "";
  late int currentType;
  String idCongTy = "CT001";
  bool _isInitialized = false;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    currentType = widget.typeAssetTransfer;
    _initData();
  }

  @override
  void didUpdateWidget(ToolAndMaterialTransferView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.typeAssetTransfer != widget.typeAssetTransfer) {
      currentType = widget.typeAssetTransfer;
      log('currentType didUpdateWidget ccdc vt: $currentType');
      _initData();
      _reloadData();
    }
  }

  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();
  //   // Đảm bảo dữ liệu được tải lại khi màn hình được focus lại
  //   if (ModalRoute.of(context)?.isCurrent == true && _isInitialized) {
  //     _reloadData();
  //   }
  // }

  void _initData() {
    log('currentType _initData ccdc vt: $currentType');
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<ToolAndMaterialTransferProvider>(
        context,
        listen: false,
      );
      provider.onInit(context, currentType);
      _isInitialized = true;
    });
  }

  void _reloadData() {
    log('Reloading data for type: $currentType');
    final provider = Provider.of<ToolAndMaterialTransferProvider>(
      context,
      listen: false,
    );

    // Chỉ tải lại dữ liệu nếu đã khởi tạo trước đó
    if (_isInitialized) {
      provider.refreshData(context, currentType);
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // Cần thiết cho AutomaticKeepAliveClientMixin

    return BlocConsumer<
      ToolAndMaterialTransferBloc,
      ToolAndMaterialTransferState
    >(
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
                      // provider.onChangeDetail(context, item)
                      // provider.onChangeDetailAssetTransfer(null);
                      provider.onChangeDetailToolAndMaterialTransfer(null);
                    },
                    mainScreen: provider.getScreenTitle(),
                    subScreen: provider.subScreen,
                  ),
                ),
                body: Column(
                  children: [
                    Flexible(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: CommonPageView(
                          childInput: ToolAndMaterialTransferDetail(
                            provider: provider,
                            type: currentType,
                          ),
                          childTableView: ToolAndMaterialTransferList(
                            provider: provider,
                            typeAssetTransfer: currentType,
                            idCongTy: 'CT001',
                          ),
                          title: "Chi tiết điều chuyển CCDC - Vật tư",
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
      listener: (context, state) {
        if (state is ToolAndMaterialTransferLoadingState) {}
        if (state is GetListToolAndMaterialTransferSuccessState) {
          context
              .read<ToolAndMaterialTransferProvider>()
              .getListToolAndMaterialTransferSuccess(context, state);
        }
        if (state is GetListToolAndMaterialTransferFailedState) {
          log('GetListToolAndMaterialTransferFailedState');
        }
        if (state is GetListAssetSuccessState) {
          context.read<ToolAndMaterialTransferProvider>().getLisTaiSanSuccess(
            context,
            state,
          );
        }
        if (state is GetListAssetFailedState) {
          log('GetListAssetFailedState');
        }
        if (state is GetDataDropdownSuccessState) {
          context
              .read<ToolAndMaterialTransferProvider>()
              .getDataDropdownSuccess(context, state);
        }
        if (state is GetDataDropdownFailedState) {
          log('GetDataDropdownFailedState');
        }
        if (state is CreateDieuDongSuccessState) {
          log('CreateDieuDongSuccessState');
          context.read<ToolAndMaterialTransferProvider>().createDieuDongSuccess(
            context,
            state,
          );
        }
        if (state is CreateDieuDongFailedState) {
          log('CreateDieuDongFailedState');
          AppUtility.showSnackBar(context, state.message);
        }
        if (state is UpdateDieuDongSuccessState) {
          log('UpdateDieuDongSuccessState');
          context.read<ToolAndMaterialTransferProvider>().updateDieuDongSuccess(
            context,
            state,
          );
        }
        if (state is DeleteDieuDongSuccessState) {
          log('DeleteDieuDongSuccessState');
          context.read<ToolAndMaterialTransferProvider>().deleteDieuDongSuccess(
            context,
            state,
          );
        }
        if (state is PutPostDeleteFailedState) {
          log('PutPostDeleteFailedState');
          context.read<ToolAndMaterialTransferProvider>().putPostDeleteFailed(
            context,
            state,
          );
        }
        if (state is UpdateSigningTAMTStatusSuccessState) {
          log('UpdateSigningTAMTStatusSuccessState');
          context
              .read<ToolAndMaterialTransferProvider>()
              .updateSigningTAMTStatusSuccess(context, state);
        }
        if (state is CancelToolAndMaterialTransferSuccessState) {
          context.read<ToolAndMaterialTransferProvider>().onCloseDetail(context);
          AppUtility.showSnackBar(context, 'Đã hủy phiếu thành cồng!');
          context.read<ToolAndMaterialTransferProvider>().getDataAll(context);
        }
        if (state is UpdateSigningTAMTStatusFailedState) {
          log('UpdateSigningTAMTStatusFailedState');
          AppUtility.showSnackBar(context, state.message, isError: true);
        }
      },
    );
  }
}
