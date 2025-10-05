import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:quan_ly_tai_san_app/common/page/common_page_view.dart';
import 'package:quan_ly_tai_san_app/core/utils/utils.dart';
import 'package:quan_ly_tai_san_app/screen/home/scroll_controller.dart';
import 'package:quan_ly_tai_san_app/screen/reason_increase/bloc/reason_increase_bloc.dart';
import 'package:quan_ly_tai_san_app/screen/reason_increase/bloc/reason_increase_event.dart';
import 'package:quan_ly_tai_san_app/screen/reason_increase/bloc/reason_increase_state.dart';
import 'package:quan_ly_tai_san_app/screen/reason_increase/component/convert_excel_to_ccdc_group.dart';
import 'package:quan_ly_tai_san_app/screen/reason_increase/model/reason_increase.dart';
import 'package:quan_ly_tai_san_app/screen/reason_increase/provider/reason_increase_provider.dart';
import 'package:quan_ly_tai_san_app/screen/reason_increase/widget/reason_increase_detail.dart';
import 'package:quan_ly_tai_san_app/screen/reason_increase/widget/reason_increase_list.dart';
import 'package:quan_ly_tai_san_app/common/components/header_component.dart';
import 'package:se_gay_components/common/pagination/sg_pagination_controls.dart';

class ReasonIncreaseView extends StatefulWidget {
  const ReasonIncreaseView({super.key});

  @override
  State<ReasonIncreaseView> createState() => _ReasonIncreaseViewState();
}

class _ReasonIncreaseViewState extends State<ReasonIncreaseView> {
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
      Provider.of<ReasonIncreaseProvider>(
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
    return BlocConsumer<ReasonIncreaseBloc, ReasonIncreaseState>(
      listener: (context, state) {
        if (state is ReasonIncreaseLoadingState) {}
        if (state is GetListReasonIncreaseSuccessState) {
          context.read<ReasonIncreaseProvider>().getListReasonIncreaseSuccess(
            context,
            state,
          );
        }
        if (state is CreateReasonIncreaseSuccessState) {
          context.read<ReasonIncreaseProvider>().createReasonIncreaseSuccess(
            context,
            state,
          );
        }
        if (state is CreateReasonIncreaseBatchSuccessState) {
          context
              .read<ReasonIncreaseProvider>()
              .createReasonIncreaseBatchSuccess(context, state);
        }
        if (state is CreateReasonIncreaseBatchFailedState) {
          context
              .read<ReasonIncreaseProvider>()
              .createReasonIncreaseBatchFailed(context, state);
        }
        if (state is CreateReasonIncreaseFailedState) {
          context.read<ReasonIncreaseProvider>().createReasonIncreaseFailed(
            context,
            state,
          );
        }
        if (state is GetListReasonIncreaseFailedState) {
          context.read<ReasonIncreaseProvider>().getListReasonIncreaseFailed(
            context,
            state,
          );
        }
        if (state is UpdateReasonIncreaseSuccessState) {
          context.read<ReasonIncreaseProvider>().updateReasonIncreaseSuccess(
            context,
            state,
          );
        }
        if (state is DeleteReasonIncreaseSuccessState) {
          context.read<ReasonIncreaseProvider>().deleteReasonIncreaseSuccess(
            context,
            state,
          );
        }
        if (state is PutPostDeleteFailedState) {
          context.read<ReasonIncreaseProvider>().putPostDeleteFailed(
            context,
            state,
          );
        }
      },
      builder: (context, state) {
        return ChangeNotifierProvider.value(
          value: context.read<ReasonIncreaseProvider>(),
          child: Consumer<ReasonIncreaseProvider>(
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
                    mainScreen: 'Lý do tăng',
                    onFileSelected: (fileName, filePath, fileBytes) async {
                      final bloc = context.read<ReasonIncreaseBloc>();
                      try {
                        final result = await convertExcelToReasonIncrease(
                          filePath!,
                          fileBytes: fileBytes,
                        );
                        if (!mounted) return;
                        if (result['success']) {
                          final List<dynamic> raw = result['data'];
                          final list =
                              raw
                                  .map(
                                    (e) => ReasonIncrease.fromJson(
                                      (e as ReasonIncrease).toJson(),
                                    ),
                                  )
                                  .toList();
                          bloc.add(CreateReasonIncreaseBatchEvent(list));
                        } else {
                          List<dynamic> errors = result['errors'];

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

                          log(
                            '[ReasonIncreaseView] errorMessages: $errorMessages',
                          );
                          if (!context.mounted) return;

                          AppUtility.showSnackBar(
                            context,
                            'Import dữ liệu thất bại: \n $errorMessages',
                            isError: true,
                            timeDuration: 4,
                          );
                        }
                      } catch (e) {
                        if (!context.mounted) return;

                        AppUtility.showSnackBar(
                          context,
                          'Import dữ liệu thất bại: \n $e',
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
                            title: "Chi tiết lý do tăng",
                            childInput: ReasonIncreaseDetail(
                              provider: provider,
                            ),
                            childTableView: ReasonIncreaseList(
                              provider: provider,
                            ),
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
    );
  }
}
