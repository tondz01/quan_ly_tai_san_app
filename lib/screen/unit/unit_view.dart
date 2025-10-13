import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart' as provider;
import 'package:quan_ly_tai_san_app/common/page/common_page_view.dart';
import 'package:quan_ly_tai_san_app/core/utils/utils.dart';
import 'package:quan_ly_tai_san_app/screen/home/scroll_controller.dart';
import 'package:quan_ly_tai_san_app/screen/unit/bloc/unit_bloc.dart';
import 'package:quan_ly_tai_san_app/screen/unit/bloc/unit_event.dart';
import 'package:quan_ly_tai_san_app/screen/unit/bloc/unit_state.dart';
import 'package:quan_ly_tai_san_app/screen/unit/component/convert_excel_to_unit.dart';
import 'package:quan_ly_tai_san_app/screen/unit/model/unit_dto.dart';
import 'package:quan_ly_tai_san_app/screen/unit/provider/unit_provider.dart';
import 'package:quan_ly_tai_san_app/screen/unit/provider/table_unit_provider.dart';
import 'package:quan_ly_tai_san_app/screen/unit/widget/unit_detail.dart';
import 'package:quan_ly_tai_san_app/screen/unit/widget/unit_list.dart';
import 'package:quan_ly_tai_san_app/common/components/header_component.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UnitView extends StatefulWidget {
  const UnitView({super.key});

  @override
  State<UnitView> createState() => _UnitViewState();
}

class _UnitViewState extends State<UnitView> {
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
      provider.Provider.of<UnitProvider>(context, listen: false).onInit(context);
    });
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScrollStateChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: BlocConsumer<UnitBloc, UnitState>(
        builder: (context, state) {
          // Sử dụng ChangeNotifierProvider.value để đảm bảo tất cả thay đổi trong provider cập nhật UI
        return provider.ChangeNotifierProvider.value(
          value: context.read<UnitProvider>(),
          child: provider.Consumer<UnitProvider>(
              builder: (context, provider, child) {
                if (provider.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (provider.data == null) {
                  return const Center(child: Text('Không có dữ liệu'));
                }

                // Khởi tạo dữ liệu cho bảng mới
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  final tableNotifier = context.read<TableUnitProvider>();
                  tableNotifier.setData(provider.data ?? []);
                });

              return Scaffold(
                appBar: AppBar(
                  title: HeaderComponent(
                    controller: _searchController,
                    onSearchChanged: (value) {
                      provider.searchTerm = value;
                    },
                    isShowSearch: false,
                    onTap: () {},
                    onNew: () {
                      provider.onChangeDetail(null);
                    },
                    mainScreen: 'Đơn vị tính',
                    onFileSelected: (fileName, filePath, fileBytes) async {
                      final unitBloc = context.read<UnitBloc>();
                      final result = await convertExcelToUnit(
                        filePath!,
                        fileBytes: fileBytes,
                      );
                      if (!mounted) return;
                      if (result['success']) {
                        List<UnitDto> units = result['data'];
                        unitBloc.add(CreateUnitBatchEvent(units));
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

                        log('[UnitView] errorMessages: $errorMessages');
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
                        "don_vi",
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
                            title: "Chi tiết đơn vị tính",
                            childInput: UnitDetail(provider: provider),
                            childTableView: UnitList(provider: provider),
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
          if (state is UnitLoadingState) {
            // Hiển thị loading
          }
          if (state is GetListUnitSuccessState) {
            context.read<UnitProvider>().getListUnitSuccess(context, state);
          }
          if (state is CreateUnitSuccessState) {
            context.read<UnitProvider>().createUnitSuccess(context, state);
          }
          if (state is CreateUnitFailedState) {
            context.read<UnitProvider>().createUnitFailed(context, state);
          }
          if (state is GetListUnitFailedState) {
            // Xử lý lỗi
            context.read<UnitProvider>().getListUnitFailed(context, state);
          }
          if (state is UpdateUnitSuccessState) {
            context.read<UnitProvider>().updateUnitSuccess(context, state);
          }
          if (state is DeleteUnitSuccessState) {
            context.read<UnitProvider>().deleteUnitSuccess(context, state);
          }
          if (state is PutPostDeleteFailedState) {
            context.read<UnitProvider>().putPostDeleteFailed(context, state);
          }
        },
      ),
    );
  }
}
