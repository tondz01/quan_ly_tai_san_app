import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:quan_ly_tai_san_app/common/page/common_page_view.dart';
import 'package:quan_ly_tai_san_app/core/utils/utils.dart';
import 'package:quan_ly_tai_san_app/screen/ccdc_group/bloc/ccdc_group_bloc.dart';
import 'package:quan_ly_tai_san_app/screen/ccdc_group/bloc/ccdc_group_event.dart';
import 'package:quan_ly_tai_san_app/screen/ccdc_group/bloc/ccdc_group_state.dart';
import 'package:quan_ly_tai_san_app/screen/ccdc_group/component/convert_excel_to_ccdc_group.dart';
import 'package:quan_ly_tai_san_app/screen/ccdc_group/model/ccdc_group.dart';
import 'package:quan_ly_tai_san_app/screen/ccdc_group/provider/ccdc_group_provide.dart';
import 'package:quan_ly_tai_san_app/screen/ccdc_group/widget/ccdc_group_detail.dart';
import 'package:quan_ly_tai_san_app/screen/ccdc_group/widget/ccdc_group_list.dart';
import 'package:quan_ly_tai_san_app/common/components/header_component.dart';
import 'package:quan_ly_tai_san_app/screen/home/scroll_controller.dart';
import 'package:se_gay_components/common/pagination/sg_pagination_controls.dart';

class CcdcGroupView extends StatefulWidget {
  const CcdcGroupView({super.key});

  @override
  State<CcdcGroupView> createState() => _CcdcGroupViewState();
}

class _CcdcGroupViewState extends State<CcdcGroupView> {
  final TextEditingController _searchController = TextEditingController();
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
      Provider.of<CcdcGroupProvider>(context, listen: false).onInit(context);
    });
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.removeListener(_onScrollStateChanged);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CcdcGroupBloc, CcdcGroupState>(
      listener: (context, state) {
        if (state is CcdcGroupLoadingState) {}
        if (state is GetListCcdcGroupSuccessState) {
          context.read<CcdcGroupProvider>().getListCcdcGroupSuccess(
            context,
            state,
          );
        }
        if (state is CreateCcdcGroupSuccessState) {
          context.read<CcdcGroupProvider>().createCcdcGroupSuccess(
            context,
            state,
          );
        }
        if (state is CreateCcdcGroupBatchSuccessState) {
          context.read<CcdcGroupProvider>().createCcdcGroupBatchSuccess(
            context,
            state,
          );
        }
        if (state is CreateCcdcGroupBatchFailedState) {
          context.read<CcdcGroupProvider>().createCcdcGroupBatchFailed(
            context,
            state,
          );
        }
        if (state is CreateCcdcGroupFailedState) {
          context.read<CcdcGroupProvider>().createCcdcGroupFailed(
            context,
            state,
          );
        }
        if (state is GetListCcdcGroupFailedState) {
          context.read<CcdcGroupProvider>().getListCcdcGroupFailed(
            context,
            state,
          );
        }
        if (state is UpdateCcdcGroupSuccessState) {
          context.read<CcdcGroupProvider>().updateCcdcGroupSuccess(
            context,
            state,
          );
        }
        if (state is DeleteCcdcGroupSuccessState) {
          context.read<CcdcGroupProvider>().deleteCcdcGroupSuccess(
            context,
            state,
          );
        }
        if (state is PutPostDeleteFailedState) {
          context.read<CcdcGroupProvider>().putPostDeleteFailed(context, state);
        }
      },
      builder: (context, state) {
        return ChangeNotifierProvider.value(
          value: context.read<CcdcGroupProvider>(),
          child: Consumer<CcdcGroupProvider>(
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
                      // provider.searchTerm = value;
                    },
                    isShowSearch: false,
                    onTap: () {},
                    onNew: () {
                      provider.onChangeDetail(null);
                    },
                    mainScreen: 'Nhóm ccdc',
                    onFileSelected: (fileName, filePath, fileBytes) async {
                      final assetGroubBloc = context.read<CcdcGroupBloc>();
                      final result = await convertExcelToCcdcGroup(
                        filePath!,
                        fileBytes: fileBytes,
                      );
                      if (!mounted) return;
                      if (result['success']) {
                        List<CcdcGroup> ccdcList = result['data'];
                        assetGroubBloc.add(CreateCcdcGroupBatchEvent(ccdcList));
                      } else {
                        List<dynamic> errors = result['errors'];

                        // Tạo danh sách lỗi dạng list
                        List<String> errorMessages = [];
                        for (var error in errors) {
                          String rowNumber = error['row'].toString();
                          List<String> rowErrors = List<String>.from(
                            error['errors'],
                          );
                          String errorText =
                              'Dòng $rowNumber: ${rowErrors.join(', ')}\n';
                          errorMessages.add(errorText);
                        }

                        log('[CcdcGroupView] errorMessages: $errorMessages');
                        if (!mounted) return;

                        // Hiển thị thông báo tổng quan
                        AppUtility.showSnackBar(
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
                        "ccdc_vt",
                        provider.data?.map((e) => e.toExportJson()).toList() ??
                            [],
                      );
                    },
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
