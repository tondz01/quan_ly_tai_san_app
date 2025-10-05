import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:quan_ly_tai_san_app/common/page/common_page_view.dart';
import 'package:quan_ly_tai_san_app/core/utils/utils.dart';
import 'package:quan_ly_tai_san_app/screen/home/scroll_controller.dart';
import 'package:quan_ly_tai_san_app/screen/type_asset/bloc/type_asset_bloc.dart';
import 'package:quan_ly_tai_san_app/screen/type_asset/bloc/type_asset_event.dart';
import 'package:quan_ly_tai_san_app/screen/type_asset/bloc/type_asset_state.dart';
import 'package:quan_ly_tai_san_app/screen/type_asset/component/convert_excel_to_type_asset.dart';
import 'package:quan_ly_tai_san_app/screen/type_asset/model/type_asset.dart';
import 'package:quan_ly_tai_san_app/screen/type_asset/provider/type_asset_provider.dart';
import 'package:quan_ly_tai_san_app/screen/type_asset/widget/type_asset_detail.dart';
import 'package:quan_ly_tai_san_app/screen/type_asset/widget/type_asset_list.dart';
import 'package:quan_ly_tai_san_app/common/components/header_component.dart';
import 'package:se_gay_components/common/pagination/sg_pagination_controls.dart';

class TypeAssetView extends StatefulWidget {
  const TypeAssetView({super.key});

  @override
  State<TypeAssetView> createState() => _TypeAssetViewState();
}

class _TypeAssetViewState extends State<TypeAssetView> {
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
      Provider.of<TypeAssetProvider>(context, listen: false).onInit(context);
    });
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScrollStateChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TypeAssetBloc, TypeAssetState>(
      listener: (context, state) {
        if (state is TypeAssetLoadingState) {}
        if (state is GetListTypeAssetSuccessState) {
          context.read<TypeAssetProvider>().getListSuccess(context, state);
        }
        if (state is CreateTypeAssetSuccessState) {
          context.read<TypeAssetProvider>().createSuccess(context, state);
        }
        if (state is CreateTypeAssetFailedState) {
          context.read<TypeAssetProvider>().createFailed(context, state);
        }
        if (state is GetListTypeAssetFailedState) {
          context.read<TypeAssetProvider>().getListFailed(context, state);
        }
        if (state is UpdateTypeAssetSuccessState) {
          context.read<TypeAssetProvider>().updateSuccess(context, state);
        }
        if (state is DeleteTypeAssetSuccessState) {
          context.read<TypeAssetProvider>().deleteSuccess(context, state);
        }
        if (state is PutPostDeleteFailedState) {
          context.read<TypeAssetProvider>().putPostDeleteFailed(context, state);
        }
      },
      builder: (context, state) {
        return ChangeNotifierProvider.value(
          value: context.read<TypeAssetProvider>(),
          child: Consumer<TypeAssetProvider>(
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
                    mainScreen: 'Loại tài sản',
                    onFileSelected: (fileName, filePath, fileBytes) async {
                      final bloc = context.read<TypeAssetBloc>();
                      final result = await convertExcelToTypeAsset(
                        filePath!,
                        fileBytes: fileBytes,
                      );
                      if (!mounted) return;

                      if (result['success']) {
                        List<TypeAsset> list = result['data'];
                        bloc.add(CreateTypeAssetBatchEvent(list));
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

                        log(
                          '[ToolsAndSuppliesView] errorMessages: $errorMessages',
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
                        "type_asset",
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
                            title: "Chi tiết loại tài sản",
                            childInput: TypeAssetDetail(provider: provider),
                            childTableView: TypeAssetList(provider: provider),
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
