import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:quan_ly_tai_san_app/common/page/common_page_view.dart';
import 'package:quan_ly_tai_san_app/core/utils/utils.dart';
import 'package:quan_ly_tai_san_app/routes/routes.dart';
import 'package:quan_ly_tai_san_app/screen/asset_transfer/bloc/dieu_dong_tai_san_bloc.dart';
import 'package:quan_ly_tai_san_app/screen/asset_transfer/bloc/dieu_dong_tai_san_state.dart';
import 'package:quan_ly_tai_san_app/screen/asset_transfer/provider/dieu_dong_tai_san_provider.dart';
import 'package:quan_ly_tai_san_app/screen/asset_transfer/widget/dieu_dong_tai_san_detail.dart';
import 'package:quan_ly_tai_san_app/screen/asset_transfer/widget/dieu_dong_tai_san_list.dart';
import 'package:quan_ly_tai_san_app/common/components/header_component.dart';
import 'package:quan_ly_tai_san_app/screen/home/scroll_controller.dart';
import 'package:se_gay_components/common/pagination/sg_pagination_controls.dart';

class AssetTransferView extends StatefulWidget {
  const AssetTransferView({super.key});

  @override
  State<AssetTransferView> createState() => _AssetTransferViewState();
}

class _AssetTransferViewState extends State<AssetTransferView> {
  final TextEditingController _searchController = TextEditingController();
  String searchTerm = "";
  late int currentType;
  String idCongTy = "CT001";
  DieuDongTaiSanProvider? _providerRef;
  bool _isInitialized = false;
  late HomeScrollController _scrollController;
  @override
  void initState() {
    super.initState();
    _scrollController = HomeScrollController();
    _scrollController.addListener((_onScrollStateChanged));
    currentType = 0;
    // _initWebSocket();
    _initData();
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
    _providerRef ??= Provider.of<DieuDongTaiSanProvider>(context, listen: false);
    final state = GoRouterState.of(context);
    final String? typeParam = state.uri.queryParameters['type'];
    final int newType = int.tryParse(typeParam ?? '') ?? 0;
    // Cache provider reference for safe use in dispose

    if (!_isInitialized) {
      currentType = newType;
      _initData();
    } else if (newType != currentType) {
      currentType = newType;
      _reloadData();
    }
  }

  void _reloadData() {
    // Chỉ tải lại dữ liệu nếu đã khởi tạo trước đó
    if (_isInitialized) {
      _providerRef?.refreshData(context, currentType);
    }
    _initData();
  }

  void _initData() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<DieuDongTaiSanProvider>(
        context,
        listen: false,
      ).onInit(context, currentType);
    });
    _isInitialized = true;
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
    return BlocConsumer<DieuDongTaiSanBloc, DieuDongTaiSanState>(
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
                      provider.onChangeDetailDieuDongTaiSan(null);
                    },
                    mainScreen: provider.getScreenTitle(),
                    subScreen: provider.subScreen,
                    // onFileSelected: (fileName, filePath, fileBytes) {
                    //   AppUtility.showSnackBar(context, "Chức năng đang phát triển");
                    // },
                    isShowInput: false,
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
                            childInput: DieuDongTaiSanDetail(
                              provider: provider,
                              type: currentType,
                            ),
                            childTableView: DieuDongTaiSanList(
                              provider: provider,
                              typeAssetTransfer: currentType,
                              idCongTy: 'CT001',
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
        if (state is DieuDongTaiSanLoadingState) {}
        if (state is GetListDieuDongTaiSanSuccessState) {
          log('GetListAssetTransferSuccessState');
          context.read<DieuDongTaiSanProvider>().getListDieuDongTaiSanSuccess(
            context,
            state,
          );
        }
        if (state is GetListDieuDongTaiSanFailedState) {
          log('GetListDieuDongTaiSanFailedState');
        }
        if (state is GetListAssetSuccessState) {
          context.read<DieuDongTaiSanProvider>().getLisTaiSanSuccess(
            context,
            state,
          );
        }
        if (state is GetListAssetFailedState) {
          AppUtility.showSnackBar(
            context,
            'Lấy dữ liệu "Tài sản" thất bại!',
            isError: true,
          );
        }
        if (state is GetDataDropdownSuccessState) {
          context.read<DieuDongTaiSanProvider>().getDataDropdownSuccess(
            context,
            state,
          );
        }
        if (state is GetDataDropdownFailedState) {
          AppUtility.showSnackBar(
            context,
            'Lấy dữ liệu "Nhân viên" và "Phòng ban" thất bại!',
            isError: true,
          );
        }
        if (state is CreateDieuDongSuccessState) {
          context.read<DieuDongTaiSanProvider>().createDieuDongSuccess(
            context,
            state,
          );
        }
        if (state is CreateDieuDongFailedState) {
          AppUtility.showSnackBar(context, state.message);
        }
        if (state is UpdateDieuDongSuccessState) {
          context.read<DieuDongTaiSanProvider>().updateDieuDongSuccess(
            context,
            state,
          );
        }
        if (state is DeleteDieuDongSuccessState) {
          context.read<DieuDongTaiSanProvider>().deleteDieuDongSuccess(
            context,
            state,
          );
        }
        if (state is UpdateSigningStatusSuccessState) {
          context.read<DieuDongTaiSanProvider>().updateSignatureSuccess(
            context,
            state,
          );
        }
        if (state is CancelDieuDongTaiSanSuccessState) {
          context.read<DieuDongTaiSanProvider>().onCloseDetail(context);
          AppUtility.showSnackBar(context, 'Cập nhập trạng thái thành công!');
          context.read<DieuDongTaiSanProvider>().getDataAll(context);
        }
        if (state is UpdateSigningStatusFailedState) {
          AppUtility.showSnackBar(context, state.message, isError: true);
        }
        if (state is PutPostDeleteFailedState) {
          context.read<DieuDongTaiSanProvider>().putPostDeleteFailed(
            context,
            state,
          );
        }
      },
    );
  }
}
