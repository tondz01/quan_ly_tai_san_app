import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:quan_ly_tai_san_app/common/page/common_page_view.dart';
import 'package:quan_ly_tai_san_app/core/utils/utils.dart';
import 'package:quan_ly_tai_san_app/screen/home/scroll_controller.dart';
import 'package:quan_ly_tai_san_app/screen/tool_and_material_transfer/provider/tool_and_material_transfer_provider.dart';
import 'package:quan_ly_tai_san_app/screen/tool_and_material_transfer/widget/tool_and_material_transfer_detail.dart';
import 'package:quan_ly_tai_san_app/screen/tool_and_material_transfer/widget/tool_and_material_transfer_list.dart';
import 'package:quan_ly_tai_san_app/common/components/header_component.dart';
import 'package:quan_ly_tai_san_app/screen/tool_and_material_transfer/bloc/tool_and_material_transfer_bloc.dart';
import 'package:quan_ly_tai_san_app/screen/tool_and_material_transfer/bloc/tool_and_material_transfer_state.dart';

class ToolAndMaterialTransferView extends StatefulWidget {
  const ToolAndMaterialTransferView({super.key});

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
  ToolAndMaterialTransferProvider? _providerRef;

  late HomeScrollController _scrollController;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _scrollController = HomeScrollController();
    _scrollController.addListener((_onScrollStateChanged));
    currentType = 0;
    // _initWebSocket();
  }

  // Future<void> _initWebSocket() async {
  //   final user = AccountHelper.instance.getUserInfo();
  //   final companyId = user?.idCongTy ?? '';
  //   final userId = user?.id ?? '';
  //   if (companyId.isEmpty || userId.isEmpty) return;

  //   final ws = WebSocketService();
  //   await ws.initializeNotifications();
  //   await ws.connect(
  //     serverUrl: Config.baseUrl,
  //     companyId: companyId,
  //     userId: userId,
  //     onNotification: (n) {
  //       if (!mounted) return;
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(content: Text(n.title.isNotEmpty ? n.title : n.message)),
  //       );
  //     },
  //   );
  // }

  void _onScrollStateChanged() {
    setState(() {});
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _providerRef ??= Provider.of<ToolAndMaterialTransferProvider>(context, listen: false);
    final state = GoRouterState.of(context);
    final String? typeParam = state.uri.queryParameters['type'];
    final int newType = int.tryParse(typeParam ?? '') ?? 0;
    // Cache provider reference for safe use in dispose
    if (!_isInitialized) {
      currentType = newType;
      _initData();
    } else if (newType != currentType) {
      currentType = newType;
      // Defer reload to avoid calling notifyListeners during build
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _reloadData();
        }
      });
    }
  }

  void _initData() {
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
    final provider = Provider.of<ToolAndMaterialTransferProvider>(
      context,
      listen: false,
    );

    // Chỉ tải lại dữ liệu nếu đã khởi tạo trước đó
    if (_isInitialized) {
      // Defer provider refresh to avoid calling notifyListeners during build
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          provider.refreshData(context, currentType);
        }
      });
    }
  }

  @override
  void dispose() {
    _providerRef?.onDispose();
    _scrollController.removeListener(_onScrollStateChanged);
    _searchController.dispose();
    _isInitialized = false;
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
                    isShowInput: false,
                    mainScreen: provider.getScreenTitle(),
                    subScreen: provider.subScreen,
                  ),
                ),
                body: Column(
                  children: [
                    Flexible(
                      child: NotificationListener<ScrollNotification>(
                        onNotification: (notification) {
                          return true; // Xử lý scroll event bình thường
                        },
                        child: SingleChildScrollView(
                          physics:
                              _scrollController.isParentScrolling
                                  ? const NeverScrollableScrollPhysics() // Parent đang cuộn => ngăn child cuộn
                                  : const BouncingScrollPhysics(), // Parent đã cuộn hết => cho phép child cuộn
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
          context.read<ToolAndMaterialTransferProvider>().onCloseDetail(
            context,
          );
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
