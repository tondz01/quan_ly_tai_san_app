import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:quan_ly_tai_san_app/common/components/header_component.dart';
import 'package:quan_ly_tai_san_app/common/page/common_page_view.dart';
import 'package:quan_ly_tai_san_app/main.dart';
import 'package:quan_ly_tai_san_app/routes/routes.dart';
import 'package:quan_ly_tai_san_app/screen/home/scroll_controller.dart';
import 'package:quan_ly_tai_san_app/screen/login/auth/account_helper.dart';
import 'package:quan_ly_tai_san_app/screen/tool_and_supplies_handover/bloc/tool_and_supplies_handover_event.dart';
import 'package:quan_ly_tai_san_app/screen/tool_and_supplies_handover/model/tool_and_supplies_handover_dto.dart';
import 'package:quan_ly_tai_san_app/screen/tool_and_supplies_handover/widget/tab_bar_table_ccdc.dart';
import 'package:quan_ly_tai_san_app/screen/tool_and_supplies_handover/widget/tool_and_supplies_handover_detail.dart';
import 'package:quan_ly_tai_san_app/services/websocket_service.dart';

import 'package:se_gay_components/core/utils/sg_log.dart';

import 'bloc/tool_and_supplies_handover_bloc.dart';
import 'bloc/tool_and_supplies_handover_state.dart';
import 'provider/tool_and_supplies_handover_provider.dart';

class ToolAndSuppliesHandoverView extends StatefulWidget {
  const ToolAndSuppliesHandoverView({super.key});

  @override
  State<ToolAndSuppliesHandoverView> createState() =>
      _ToolAndSuppliesHandoverViewState();
}

class _ToolAndSuppliesHandoverViewState
    extends State<ToolAndSuppliesHandoverView> {
  ToolAndSuppliesHandoverDto? toolAndSuppliesHandoverData;
  Map<String, dynamic>? menuSelectionData;
  final TextEditingController _searchController = TextEditingController();
  String searchTerm = "";
  late HomeScrollController _scrollController;
  ToolAndSuppliesHandoverProvider? _providerRef;
  @override
  void initState() {
    super.initState();
    _scrollController = HomeScrollController();
    _scrollController.addListener((_onScrollStateChanged));
    _initData();
    // _initWebSocket();
  }

  @override
  void dispose() {
    _providerRef?.onDispose();
    _scrollController.removeListener(_onScrollStateChanged);
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _initWebSocket() async {
    final user = AccountHelper.instance.getUserInfo();
    final companyId = user?.idCongTy ?? '';
    final userId = user?.id ?? '';
    if (companyId.isEmpty || userId.isEmpty) return;

    final ws = WebSocketService();
    await ws.initializeNotifications();
    await ws.connect(
      serverUrl: Config.baseUrl,
      companyId: companyId,
      userId: userId,
      onNotification: (n) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(n.title.isNotEmpty ? n.title : n.message)),
        );
      },
    );
  }

  void _onScrollStateChanged() {
    setState(() {});
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _providerRef ??= Provider.of<ToolAndSuppliesHandoverProvider>(context, listen: false);
    final extra = GoRouterState.of(context).extra;

    if (extra is Map<String, dynamic>) {
      toolAndSuppliesHandoverData =
          extra['ToolAndSuppliesHandoverDto'] as ToolAndSuppliesHandoverDto?;
      menuSelectionData = extra['menuSelection'] as Map<String, dynamic>?;

      if (toolAndSuppliesHandoverData != null) {
        _handleToolAndSuppliesHandoverData(toolAndSuppliesHandoverData!);
      }

      if (menuSelectionData != null) {
        _updateMenuSelection();
      }
    } else if (extra is ToolAndSuppliesHandoverDto) {
      toolAndSuppliesHandoverData = extra;
      if (toolAndSuppliesHandoverData != null) {
        _handleToolAndSuppliesHandoverData(toolAndSuppliesHandoverData!);
      }
    }
  }

  void _updateMenuSelection() {
    if (menuSelectionData != null) {
      final selectedIndex = menuSelectionData!['selectedIndex'] as int?;
      final selectedSubIndex = menuSelectionData!['selectedSubIndex'] as int?;

      if (selectedIndex != null && selectedSubIndex != null) {
        SGLog.debug(
          'ToolAndSuppliesHandoverView',
          'Updating menu selection: index=$selectedIndex, subIndex=$selectedSubIndex',
        );
        // Có thể thêm logic để cập nhật menu selection ở đây nếu cần
      }
    }
  }

  void _handleToolAndSuppliesHandoverData(
    ToolAndSuppliesHandoverDto toolAndSuppliesHandoverDto,
  ) {
    final provider = Provider.of<ToolAndSuppliesHandoverProvider>(
      context,
      listen: false,
    );

    provider.onInit(context);
    provider.onChangeDetail(
      context,
      toolAndSuppliesHandoverDto,
      isFindNewItem: false,
    );
  }

  @override
  void didUpdateWidget(ToolAndSuppliesHandoverView oldWidget) {
    super.didUpdateWidget(oldWidget);
    _initData();
  }

  void _initData() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<ToolAndSuppliesHandoverProvider>(
        context,
        listen: false,
      );

      // Chỉ khởi tạo nếu không có data từ router
      if (toolAndSuppliesHandoverData == null) {
        provider.onInit(context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<
      ToolAndSuppliesHandoverBloc,
      ToolAndSuppliesHandoverState
    >(
      listener: (context, state) {
        if (state is ToolAndSuppliesHandoverLoadingState) {
        } else if (state is GetListToolAndSuppliesHandoverSuccessState) {
          context
              .read<ToolAndSuppliesHandoverProvider>()
              .getListToolAndSuppliesHandoverSuccess(context, state);
        } else if (state is CreateToolAndSuppliesHandoverSuccessState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Tạo biên bản bàn giao thành công'),
              backgroundColor: Colors.green,
            ),
          );
          context.read<ToolAndSuppliesHandoverBloc>().add(
            GetListToolAndSuppliesHandoverEvent(context),
          );
          AccountHelper.refreshAllCounts();
          context.read<ToolAndSuppliesHandoverProvider>().isShowInput = false;
        } else if (state is UpdateToolAndSuppliesHandoverSuccessState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Cập nhật biên bản bàn giao thành công'),
              backgroundColor: Colors.green,
            ),
          );
          context.read<ToolAndSuppliesHandoverBloc>().add(
            GetListToolAndSuppliesHandoverEvent(context),
          );
          context.read<ToolAndSuppliesHandoverProvider>().isShowInput = false;
        } else if (state is DeleteToolAndSuppliesHandoverSuccessState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Xóa biên bản bàn giao thành công'),
              backgroundColor: Colors.green,
            ),
          );

          context.read<ToolAndSuppliesHandoverBloc>().add(
            GetListToolAndSuppliesHandoverEvent(context),
          );
          context.read<ToolAndSuppliesHandoverProvider>().isShowInput = false;
        } else if (state is ErrorState) {
          context.read<ToolAndSuppliesHandoverProvider>().isLoading = false;
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
          context.read<ToolAndSuppliesHandoverBloc>().add(
            GetListToolAndSuppliesHandoverEvent(context),
          );
          context.read<ToolAndSuppliesHandoverProvider>().isShowInput = false;
        } else if (state is CancelToolAndSuppliesHandoverSuccessState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Hủy biên bản bàn giao thành công'),
              backgroundColor: Colors.green,
            ),
          );
          context.read<ToolAndSuppliesHandoverBloc>().add(
            GetListToolAndSuppliesHandoverEvent(context),
          );
          context.read<ToolAndSuppliesHandoverProvider>().isShowInput = false;
        }
      },
      builder: (context, state) {
        return ChangeNotifierProvider.value(
          value: context.read<ToolAndSuppliesHandoverProvider>(),
          child: Consumer<ToolAndSuppliesHandoverProvider>(
            builder: (context, provider, child) {
              if (provider.isLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              // Ensure pagination controller is initialized before use
              return Scaffold(
                appBar: AppBar(
                  title: HeaderComponent(
                    controller: _searchController,
                    onSearchChanged: (value) {
                      provider.searchTerm = value;
                    },
                    isShowSearch: false,
                    onTap: provider.onTapBackHeader,
                    onNew: () {
                      provider.onChangeDetail(context, null);
                      provider.onTapNewHeader();
                    },
                    mainScreen: 'Biên bản bàn giao CCDC-Vật tư',
                    subScreen: provider.subScreen,
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
                            title: "Chi tiết biên bản bàn giao tài sản",
                            childInput: ToolAndSuppliesHandoverDetail(
                              provider: provider,
                              isFindNew: provider.isFindNew,
                            ),
                            childTableView: TabBarTableCcdc(provider: provider),
                            isShowInput: provider.isShowInput,
                            isShowCollapse: provider.isShowCollapse,
                            onExpandedChanged: (isExpanded) {
                              provider.isShowCollapse = isExpanded;
                            },
                          ),
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
    );
  }
}
