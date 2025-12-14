import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:quan_ly_tai_san_app/common/page/common_page_view.dart';
import 'package:quan_ly_tai_san_app/core/utils/utils.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/current_status/bloc/current_status_bloc.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/current_status/bloc/current_status_event.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/current_status/bloc/current_status_state.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/current_status/component/convert_excel_to_type_asset.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/current_status/model/current_status.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/current_status/provider/current_status_provider.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/current_status/widget/current_status_detail.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/current_status/widget/current_status_list.dart';
import 'package:quan_ly_tai_san_app/screen/home/scroll_controller.dart';
import 'package:quan_ly_tai_san_app/common/components/header_component.dart';
import 'package:se_gay_components/common/pagination/sg_pagination_controls.dart';

class CurrentStatusView extends StatefulWidget {
  const CurrentStatusView({super.key});

  @override
  State<CurrentStatusView> createState() =>
      _CurrentStatusViewState();
}

class _CurrentStatusViewState extends State<CurrentStatusView> {
  final TextEditingController _searchController =
      TextEditingController();
  String searchTerm = "";
  late HomeScrollController _scrollController;

  void _onScrollStateChanged() {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _scrollController = HomeScrollController();
    _scrollController.addListener((_onScrollStateChanged));
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<CurrentStatusProvider>(
        context,
        listen: false,
      ).onInit(context);
    });
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScrollStateChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CurrentStatusBloc, CurrentStatusState>(
      listener: (context, state) {
        if (state is CurrentStatusLoadingState) {}
        if (state is GetListCurrentStatusSuccessState) {
          context.read<CurrentStatusProvider>().getListSuccess(
            context,
            state,
          );
        }
        if (state is CreateCurrentStatusSuccessState) {
          context.read<CurrentStatusProvider>().createSuccess(
            context,
            state,
          );
        }
        if (state is CreateCurrentStatusFailedState) {
          context.read<CurrentStatusProvider>().createFailed(
            context,
            state,
          );
        }
        if (state is GetListCurrentStatusFailedState) {
          context.read<CurrentStatusProvider>().getListFailed(
            context,
            state,
          );
        }
        if (state is UpdateCurrentStatusSuccessState) {
          context.read<CurrentStatusProvider>().updateSuccess(
            context,
            state,
          );
        }
        if (state is DeleteCurrentStatusSuccessState) {
          context.read<CurrentStatusProvider>().deleteSuccess(
            context,
            state,
          );
        }
        if (state is PutPostDeleteFailedState) {
          context
              .read<CurrentStatusProvider>()
              .putPostDeleteFailed(context, state);
        }
      },
      builder: (context, state) {
        return ChangeNotifierProvider.value(
          value: context.read<CurrentStatusProvider>(),
          child: Consumer<CurrentStatusProvider>(
            builder: (context, provider, child) {
              if (provider.isLoading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (provider.data == null) {
                return const Center(
                  child: Text('Không có dữ liệu'),
                );
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
                    mainScreen: 'Loại tài sản',
                    isShowSearch: false,
                    onFileSelected: (
                      fileName,
                      filePath,
                      fileBytes,
                    ) async {
                      final bloc =
                          context.read<CurrentStatusBloc>();
                      final result =
                          await convertExcelToCurrentStatus(
                            filePath!,
                            fileBytes: fileBytes,
                          );
                      if (!mounted) return;

                      if (result['success']) {
                        List<CurrentStatus> list =
                            result['data'];
                        bloc.add(
                          CreateCurrentStatusBatchEvent(list),
                        );
                      } else {
                        List<dynamic> errors =
                            result['errors'];

                        // Tạo danh sách lỗi dạng list
                        List<String> errorMessages = [];
                        for (var error in errors) {
                          String rowNumber =
                              error['row'].toString();
                          List<String> rowErrors =
                              List<String>.from(
                                error['errors'],
                              );
                          String errorText =
                              'Dòng $rowNumber: ${rowErrors.join(', ')}\n';
                          errorMessages.add(errorText);
                        }

                        log(
                          '[ToolsAndSuppliesView] errorMessages: $errorMessages',
                        );
                        if (!mounted) return;

                        // Hiển thị thông báo tổng quan
                        AppUtility.showSnackBar(
                          // ignore: use_build_context_synchronously
                          context,
                          'Import dữ liệu thất bại: \n $errorMessages',
                          isError: true,
                          timeDuration: 4,
                        );
                      }
                    },
                    onExportData: () {
                      AppUtility.exportData(
                        context,
                        "type_asset",
                        provider.data
                                ?.map(
                                  (e) => e.toExportJson(),
                                )
                                .toList() ??
                            [],
                      );
                    },
                  ),
                ),
                body: Column(
                  children: [
                    Flexible(
                      child: NotificationListener<
                        ScrollNotification
                      >(
                        onNotification: (notification) {
                          return true; // Xử lý scroll event bình thường
                        },
                        child: SingleChildScrollView(
                          physics:
                              _scrollController
                                      .isParentScrolling
                                  ? const NeverScrollableScrollPhysics() // Parent đang cuộn => ngăn child cuộn
                                  : const BouncingScrollPhysics(), // Parent đã cuộn hết => cho phép child cuộn
                          scrollDirection: Axis.vertical,
                          child: CommonPageView(
                            title: "Chi tiết loại tài sản",
                            childInput: CurrentStatusDetail(
                              provider: provider,
                            ),
                            childTableView: CurrentStatusList(
                              provider: provider,
                            ),
                            isShowInput:
                                provider.isShowInput,
                            isShowCollapse:
                                provider.isShowCollapse,
                            onExpandedChanged: (
                              isExpanded,
                            ) {
                              provider.isShowCollapse =
                                  isExpanded;
                            },
                          ),
                        ),
                      ),
                    ),
                    Visibility(
                      visible:
                          (provider.data?.length ?? 0) >= 5,
                      child: SGPaginationControls(
                        totalPages: provider.totalPages,
                        currentPage: provider.currentPage,
                        rowsPerPage: provider.rowsPerPage,
                        controllerDropdownPage:
                            provider
                                .controllerDropdownPage!,
                        items: provider.items,
                        onPageChanged:
                            provider.onPageChanged,
                        onRowsPerPageChanged:
                            provider.onRowsPerPageChanged,
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
