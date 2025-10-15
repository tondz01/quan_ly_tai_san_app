import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:quan_ly_tai_san_app/common/page/common_page_view.dart';
import 'package:quan_ly_tai_san_app/core/utils/utils.dart';
import 'package:quan_ly_tai_san_app/screen/asset_group/bloc/asset_group_bloc.dart';
import 'package:quan_ly_tai_san_app/screen/asset_group/bloc/asset_group_event.dart';
import 'package:quan_ly_tai_san_app/screen/asset_group/bloc/asset_group_state.dart';
import 'package:quan_ly_tai_san_app/screen/asset_group/component/convert_excel_to_asset_group.dart';
import 'package:quan_ly_tai_san_app/screen/asset_group/model/asset_group_dto.dart';
import 'package:quan_ly_tai_san_app/screen/asset_group/provider/asset_group_provide.dart';
import 'package:quan_ly_tai_san_app/screen/asset_group/widget/asset_group_detail.dart';
import 'package:quan_ly_tai_san_app/screen/asset_group/widget/asset_group_list.dart';
import 'package:quan_ly_tai_san_app/common/components/header_component.dart';
import 'package:quan_ly_tai_san_app/screen/home/scroll_controller.dart';
import 'package:se_gay_components/common/pagination/sg_pagination_controls.dart';

class AssetGroupView extends StatefulWidget {
  const AssetGroupView({super.key});

  @override
  State<AssetGroupView> createState() =>
      _AssetGroupViewState();
}

class _AssetGroupViewState extends State<AssetGroupView> {
  final TextEditingController _searchController =
      TextEditingController();
  String searchTerm = "";
  late HomeScrollController _scrollController;
  @override
  void initState() {
    super.initState();
    _scrollController = HomeScrollController();
    _scrollController.addListener((_onScrollStateChanged));
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AssetGroupProvider>(
        context,
        listen: false,
      ).onInit(context);
    });
  }

  void _onScrollStateChanged() {
    setState(() {});
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScrollStateChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AssetGroupBloc, AssetGroupState>(
      builder: (context, state) {
        // Sử dụng ChangeNotifierProvider.value để đảm bảo tất cả thay đổi trong provider cập nhật UI
        return ChangeNotifierProvider.value(
          value: context.read<AssetGroupProvider>(),
          child: Consumer<AssetGroupProvider>(
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
                    mainScreen: 'Nhóm tài sản',
                    isShowSearch: false,
                    onFileSelected: (
                      fileName,
                      filePath,
                      fileBytes,
                    ) async {
                      final assetGroubBloc =
                          context.read<AssetGroupBloc>();
                      final result =
                          await convertExcelToAssetGroup(
                            filePath!,
                            fileBytes: fileBytes,
                          );
                      if (!mounted) return;
                      if (result['success']) {
                        List<AssetGroupDto> assetGroupList =
                            result['data'];
                        assetGroubBloc.add(
                          CreateAssetGroupBatchEvent(
                            assetGroupList,
                          ),
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
                          '[AssetGroupView] errorMessages: $errorMessages',
                        );
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
                        "nhom_tai_san",
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
                            title: "Chi tiết nhóm tài sản",
                            childInput: AssetGroupDetail(
                              provider: provider,
                            ),
                            childTableView: AssetGroupList(
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
                    // Visibility(
                    //   visible:
                    //       (provider.data?.length ?? 0) >= 5,
                    //   child: SGPaginationControls(
                    //     totalPages: provider.totalPages,
                    //     currentPage: provider.currentPage,
                    //     rowsPerPage: provider.rowsPerPage,
                    //     controllerDropdownPage:
                    //         provider
                    //             .controllerDropdownPage!,
                    //     items: provider.items,
                    //     onPageChanged:
                    //         provider.onPageChanged,
                    //     onRowsPerPageChanged:
                    //         provider.onRowsPerPageChanged,
                    //   ),
                    // ),
                  ],
                ),
              );
            },
          ),
        );
      },

      listener: (context, state) {
        if (state is AssetGroupLoadingState) {
          // Hiển thị loading
        }
        if (state is GetListAssetGroupSuccessState) {
          log(
            'GetListAssetGroupSuccessState ${state.data.length}',
          );
          context
              .read<AssetGroupProvider>()
              .getListAssetGroupSuccess(context, state);
        }
        if (state is CreateAssetGroupSuccessState) {
          context
              .read<AssetGroupProvider>()
              .createAssetGroupSuccess(context, state);
        }
        if (state is CreateAssetGroupFailedState) {
          context
              .read<AssetGroupProvider>()
              .createAssetGroupFailed(context, state);
        }
        if (state is GetListAssetGroupFailedState) {
          // Xử lý lỗi
          context
              .read<AssetGroupProvider>()
              .getListAssetGroupFailed(context, state);
        }
        if (state is UpdateAssetGroupSuccessState) {
          context
              .read<AssetGroupProvider>()
              .updateAssetGroupSuccess(context, state);
        }
        if (state is DeleteAssetGroupSuccessState) {
          context
              .read<AssetGroupProvider>()
              .deleteAssetGroupSuccess(context, state);
        }
        if (state is PutPostDeleteFailedState) {
          context
              .read<AssetGroupProvider>()
              .putPostDeleteFailed(context, state);
        }
      },
    );
  }
}
