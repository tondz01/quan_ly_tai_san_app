import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart' as provider;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quan_ly_tai_san_app/common/page/common_page_view.dart';
import 'package:quan_ly_tai_san_app/core/utils/check_status_code_done.dart';
import 'package:quan_ly_tai_san_app/core/utils/utils.dart';
import 'package:quan_ly_tai_san_app/screen/asset_management/model/detail_assets_dto.dart';
import 'package:quan_ly_tai_san_app/screen/asset_management/repository/asset_detail_repository.dart';
import 'package:quan_ly_tai_san_app/screen/home/scroll_controller.dart';

import 'package:quan_ly_tai_san_app/screen/tools_and_supplies/bloc/tools_and_supplies_bloc.dart';
import 'package:quan_ly_tai_san_app/common/components/header_component.dart';
import 'package:quan_ly_tai_san_app/screen/tools_and_supplies/bloc/tools_and_supplies_event.dart';
import 'package:quan_ly_tai_san_app/screen/tools_and_supplies/component/convert_excel_to_ccdc_vt.dart';
import 'package:quan_ly_tai_san_app/screen/tools_and_supplies/model/tools_and_supplies_dto.dart';
import 'package:quan_ly_tai_san_app/screen/tools_and_supplies/repository/tools_and_supplies_repository.dart';
import 'package:quan_ly_tai_san_app/screen/tools_and_supplies/widget/tools_and_supplies_detail.dart';
import 'package:quan_ly_tai_san_app/screen/tools_and_supplies/widget/tools_and_supplies_list.dart';
import 'bloc/tools_and_supplies_state.dart';
import 'provider/tools_and_supplies_provide.dart';

class ToolsAndSuppliesView extends StatefulWidget {
  const ToolsAndSuppliesView({super.key});

  @override
  State<ToolsAndSuppliesView> createState() => _ToolsAndSuppliesViewState();
}

class _ToolsAndSuppliesViewState extends State<ToolsAndSuppliesView> {
  final TextEditingController _searchController = TextEditingController();
  String searchTerm = "";
  late HomeScrollController _scrollController;
  @override
  void initState() {
    super.initState();
    _scrollController = HomeScrollController();
    _scrollController.addListener((_onScrollStateChanged));
    provider.Provider.of<ToolsAndSuppliesProvider>(
      context,
      listen: false,
    ).onInit(context);
  }

  void _onScrollStateChanged() {
    setState(() {});
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    provider.Provider.of<ToolsAndSuppliesProvider>(
      context,
      listen: false,
    ).onInit(context);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScrollStateChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _importData(List<ToolsAndSuppliesDto> assetCategories) async {
    if (assetCategories.isNotEmpty) {
      final result = await ToolsAndSuppliesRepository()
          .saveToolsAndSuppliesBatch(assetCategories);
      List<DetailAssetDto> listDetailAsset =
          assetCategories.expand((item) => item.chiTietTaiSanList).toList();

      if (listDetailAsset.isNotEmpty) {
        log('listDetailAsset: ${jsonEncode(listDetailAsset)}');
        Map<String, dynamic> resultAssetDetail =
            await AssetManagementDetailRepository().createAssetDetail(
              jsonEncode(listDetailAsset),
            );
        if (checkStatusCodeDone(resultAssetDetail)) {
        } else {
          if (!mounted) return;
          AppUtility.showSnackBar(
            context,
            'Import dữ liệu chi tiết CCDC - Vật tư thất bại có lỗi: ${resultAssetDetail['message']}',
            isError: true,
          );
        }
      }

      if (checkStatusCodeDone(result)) {
        if (context.mounted) {
          if (!mounted) return;
          AppUtility.showSnackBar(context, 'Import dữ liệu thành công');
          _searchController.clear();
          context.read<ToolsAndSuppliesBloc>().add(
            GetListToolsAndSuppliesEvent(context, 'ct001'),
          );
        }
      } else {
        if (context.mounted) {
          if (!mounted) return;
          AppUtility.showSnackBar(
            context,
            'Import dữ liệu thất bại',
            isError: true,
          );
        }
      }
    } else {
      if (context.mounted) {
        AppUtility.showSnackBar(
          context,
          'Import dữ liệu thất bại',
          isError: true,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: BlocConsumer<ToolsAndSuppliesBloc, ToolsAndSuppliesState>(
        builder: (context, state) {
          return provider.Consumer<ToolsAndSuppliesProvider>(
          builder: (context, provider, child) {
            if (provider.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (provider.data == null) {
              return const Center(child: Text('Không có dữ liệu'));
            }
            provider.controllerDropdownPage ??= TextEditingController(
              text: provider.rowsPerPage.toString(),
            );

            return Scaffold(
              appBar: AppBar(
                title: HeaderComponent(
                  controller: _searchController,
                  onSearchChanged: (value) {
                    provider.onSearchToolsAndSupplies(value);
                  },
                  onTap: () {},
                  onNew: () {
                    provider.onChangeDetail(context, null);
                  },
                  mainScreen: 'Quản lý CCDC - Vật tư',
                  subScreen: provider.subScreen,
                  onFileSelected: (fileName, filePath, fileBytes) async {
                    final result = await convertExcelToCcdcVt(
                      filePath!,
                      fileBytes: fileBytes,
                      provider: provider,
                    );

                    if (result['success']) {
                      List<ToolsAndSuppliesDto> assetCategories =
                          result['data'];

                      for (var item in assetCategories) {
                        for (
                          var i = 0;
                          i < item.chiTietTaiSanList.length;
                          i++
                        ) {
                          item.chiTietTaiSanList[i].id = '${item.id}-STT-$i';
                        }

                        item.soLuong = item.chiTietTaiSanList.fold<int>(
                          0,
                          (sum, e) => sum + (e.soLuong ?? 0),
                        );
                      }
                      log('assetCategories: ${jsonEncode(assetCategories)}');
                      _importData(assetCategories);
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
                            'Dòng $rowNumber: ${rowErrors.join(', ')}';
                        errorMessages.add(errorText);
                      }

                      log(
                        '[ToolsAndSuppliesView] errorMessages: $errorMessages',
                      );
                      if (!context.mounted) return;
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
                    if (provider.data == null) return;
                    List<dynamic> data = [];
                    for (var item in provider.data) {
                      if (item.chiTietTaiSanList.isNotEmpty) {
                        for (var element in item.chiTietTaiSanList) {
                          Map<String, dynamic> dataItem = {
                            'Mã công cụ dụng cụ': item.id,
                            'Mã đơn vị': item.idDonVi,
                            'Tên công cụ dụng cụ': item.ten,
                            'Ngày nhập': item.ngayNhap,
                            'Mã đơn vị tính': item.donViTinh,
                            'Mã nhóm CCDC': item.idNhomCCDC,
                            'Mã loại CCDC con': item.idLoaiCCDCCon,
                            'Giá trị': item.giaTri,
                            'Ký hiệu': item.kyHieu,
                            'Ghi chú': item.ghiChu,
                            'Số ký hiệu': element.soKyHieu ?? '',
                            'Số lượng': element.soLuong ?? '',
                            'Công suất': element.congSuat ?? '',
                            'Nước sản xuất': element.nuocSanXuat ?? '',
                            'Năm sản xuất': element.namSanXuat ?? '',
                          };
                          data.add(dataItem);
                        }
                      } else {
                        Map<String, dynamic> dataItem = {
                          'Mã công cụ dụng cụ': item.id,
                          'Mã đơn vị': item.idDonVi,
                          'Tên công cụ dụng cụ': item.ten,
                          'Ngày nhập': item.ngayNhap,
                          'Mã đơn vị tính': item.donViTinh,
                          'Mã nhóm CCDC': item.idNhomCCDC,
                          'Mã loại CCDC con': item.idLoaiCCDCCon,
                          'Giá trị': item.giaTri,
                          'Ký hiệu': item.kyHieu,
                          'Ghi chú': item.ghiChu,
                          'Số ký hiệu': '',
                          'Số lượng': '',
                          'Công suất': '',
                          'Nước sản xuất': '',
                          'Năm sản xuất': '',
                        };
                        data.add(dataItem);
                      }
                    }
                    AppUtility.exportData(
                      context,
                      "Danh sách CCDC - Vật tư",
                      data,
                    );
                  },
                ),
              ),
              // body: DepartmentTreeDemo(),
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
                          childInput: ToolsAndSuppliesDetail(
                            provider: provider,
                          ),
                          childTableView: ToolsAndSuppliesList(
                            provider: provider,
                          ),
                          isShowInput: provider.isShowInput,
                          isShowCollapse: provider.isShowCollapse,
                          onExpandedChanged: (isExpanded) {
                            provider.onSetsShowCollapse(isExpanded);
                          },
                          title: 'Chi tiết CCDC - Vật tư',
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
      listener: (context, state) {
        if (state is ToolsAndSuppliesInitialState) {}
        if (state is ToolsAndSuppliesLoadingState) {}
        if (state is ToolsAndSuppliesLoadingDismissState) {}
        if (state is GetListToolsAndSuppliesSuccessState) {
          context
              .read<ToolsAndSuppliesProvider>()
              .getListToolsAndSuppliesSuccess(context, state);
        }
        if (state is GetListPhongBanSuccessState) {
          context.read<ToolsAndSuppliesProvider>().getListPhongBanSuccess(
            context,
            state,
          );
        }
        if (state is GetListTypeCcdcSuccessState) {
          context.read<ToolsAndSuppliesProvider>().getListTypeCcdcSuccess(
            context,
            state,
          );
        }
        if (state is GetListToolsAndSuppliesFailedState) {}
        if (state is GetListUnitSuccessState) {
          context.read<ToolsAndSuppliesProvider>().getListUnitSuccess(
            context,
            state,
          );
        }
        if (state is GetListUnitFailedState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 3),
            ),
          );
        }
        if (state is GetListTypeCcdcFailedState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 3),
            ),
          );
        }
        if (state is GetListPhongBanFailedState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 3),
            ),
          );
        }
        if (state is CreateToolsAndSuppliesSuccessState) {
          // Refresh list
          context
              .read<ToolsAndSuppliesProvider>()
              .createToolsAndSuppliesSuccess(context, state);
        }
        if (state is CreateToolsAndSuppliesFailedState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 3),
            ),
          );
        }
        if (state is UpdateToolsAndSuppliesSuccessState) {
          context
              .read<ToolsAndSuppliesProvider>()
              .updateToolsAndSuppliesSuccess(context, state);
        }
        if (state is DeleteToolsAndSuppliesSuccessState) {
          context
              .read<ToolsAndSuppliesProvider>()
              .deleteToolsAndSuppliesSuccess(context, state);
        }
        if (state is PutPostDeleteFailedState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 3),
            ),
          );
        }
        if (state is DeleteToolsAndSuppliesBatchSuccessState) {
          context
              .read<ToolsAndSuppliesProvider>()
              .deleteToolsAndSuppliesBatchSuccess(context, state);
        }
        if (state is DeleteToolsAndSuppliesBatchFailedState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 3),
            ),
          );
        }
      },
      ),
    );
  }
}
