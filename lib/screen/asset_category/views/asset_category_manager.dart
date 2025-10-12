// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quan_ly_tai_san_app/common/page/common_page_view.dart';
import 'package:quan_ly_tai_san_app/core/utils/check_status_code_done.dart';
import 'package:quan_ly_tai_san_app/core/utils/utils.dart';
import 'package:quan_ly_tai_san_app/screen/asset_category/bloc/asset_category_bloc.dart';
import 'package:quan_ly_tai_san_app/screen/asset_category/bloc/asset_category_event.dart';
import 'package:quan_ly_tai_san_app/screen/asset_category/bloc/asset_category_state.dart';
import 'package:quan_ly_tai_san_app/screen/asset_category/component/convert_excel_to_asset_category.dart';
import 'package:quan_ly_tai_san_app/screen/asset_category/constants/asset_category_constants.dart';
import 'package:quan_ly_tai_san_app/screen/asset_category/pages/asset_category_form_page.dart';
import 'package:quan_ly_tai_san_app/screen/asset_category/models/asset_category_dto.dart';
import 'package:quan_ly_tai_san_app/screen/asset_category/asset_category_list.dart';
import 'package:quan_ly_tai_san_app/common/components/header_component.dart';
import 'package:quan_ly_tai_san_app/screen/asset_category/repository/asset_category_repository.dart';
import 'package:quan_ly_tai_san_app/screen/home/scroll_controller.dart';

class AssetCategoryManager extends StatefulWidget {
  const AssetCategoryManager({super.key});

  @override
  State<AssetCategoryManager> createState() => _AssetCategoryManagerState();
}

class _AssetCategoryManagerState extends State<AssetCategoryManager>
    with RouteAware {
  bool showForm = false;
  AssetCategoryDto? editingAssetCategory;

  late int totalEntries;
  late int totalPages = 0;
  late int startIndex;
  late int endIndex;
  int rowsPerPage = AssetCategoryConstants.defaultRowsPerPage;
  int currentPage = 1;

  final ScrollController horizontalController = ScrollController();
  final TextEditingController controller = TextEditingController();
  final TextEditingController searchController = TextEditingController();
  List<AssetCategoryDto> data = [];
  List<AssetCategoryDto> filteredData = [];
  List<AssetCategoryDto> dataPage = [];
  bool isFirstLoad = false;
  bool isShowInput = false;
  late HomeScrollController _scrollController;
  @override
  void initState() {
    super.initState();
    _scrollController = HomeScrollController();
    _scrollController.addListener((_onScrollStateChanged));
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AssetCategoryBloc>().add(
        GetListAssetCategoryEvent(context, 'ct001'),
      );
    });
  }

  void _onScrollStateChanged() {
    setState(() {});
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Removed duplicate LoadAssetCategories call
  }

  @override
  void didPopNext() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AssetCategoryBloc>().add(
        GetListAssetCategoryEvent(context, 'ct001'),
      );
    });
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScrollStateChanged);
    super.dispose();
  }

  void _showForm([AssetCategoryDto? assetCategory]) {
    setState(() {
      isShowInput = true;
      editingAssetCategory = assetCategory;
    });
  }

  void _updatePagination() {
    // Sử dụng filteredData thay vì data
    totalEntries = filteredData.length;
    totalPages = (totalEntries / rowsPerPage).ceil().clamp(
      1,
      AssetCategoryConstants.maxPaginationPages,
    );
    startIndex = (currentPage - 1) * rowsPerPage;
    endIndex = (startIndex + rowsPerPage).clamp(0, totalEntries);

    if (startIndex >= totalEntries && totalEntries > 0) {
      currentPage = 1;
      startIndex = 0;
      endIndex = rowsPerPage.clamp(0, totalEntries);
    }
    dataPage =
        filteredData.isNotEmpty
            ? filteredData.sublist(
              startIndex < totalEntries ? startIndex : 0,
              endIndex < totalEntries ? endIndex : totalEntries,
            )
            : [];
  }

  void _importData(List<AssetCategoryDto> assetCategories) async {
    if (assetCategories.isNotEmpty) {
      final result = await AssetCategoryRepository().saveAssetCategoryBatch(
        assetCategories,
      );
      if (checkStatusCodeDone(result)) {
        if (context.mounted) {
          AppUtility.showSnackBar(context, 'Import dữ liệu thành công');
          searchController.clear();
          currentPage = 1;
          rowsPerPage = AssetCategoryConstants.defaultRowsPerPage;
          filteredData = [];
          dataPage = [];
          context.read<AssetCategoryBloc>().add(
            GetListAssetCategoryEvent(context, 'ct001'),
          );
          setState(() {
            isShowInput = false;
          });
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

  void _showDeleteDialog(BuildContext context, AssetCategoryDto assetCategory) {
    showDialog(
      context: context,
      builder:
          (ctx) => AlertDialog(
            title: const Text('Xác nhận xóa'),
            content: const Text(
              'Bạn có chắc chắn muốn xóa mô hình tài sản này?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(),
                child: const Text('Hủy'),
              ),
              ElevatedButton(
                onPressed: () {
                  context.read<AssetCategoryBloc>().add(
                    DeleteAssetCategoryEvent(context, assetCategory.id ?? ''),
                  );
                  Navigator.of(ctx).pop();
                },
                child: const Text('Xóa'),
              ),
            ],
          ),
    );
  }

  void _searchAssetCategory(String value) {
    context.read<AssetCategoryBloc>().add(SearchAssetCategoryEvent(value));
  }

  void onPageChanged(int page) {
    setState(() {
      currentPage = page;
      _updatePagination();
    });
  }

  void onRowsPerPageChanged(int? value) {
    setState(() {
      if (value == null) return;
      rowsPerPage = value;
      currentPage = 1;
      _updatePagination();
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AssetCategoryBloc, AssetCategoryState>(
      listener: (context, state) {
        isShowInput = false;
        if (state is AddAssetCategorySuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.green.shade600,
              duration:
                  kIsWeb
                      ? AssetCategoryConstants.webSnackBarDuration
                      : AssetCategoryConstants.mobileSnackBarDuration,
            ),
          );
        }
        if (state is UpdateAssetCategorySuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.green.shade600,
              duration:
                  kIsWeb
                      ? AssetCategoryConstants.webSnackBarDuration
                      : AssetCategoryConstants.mobileSnackBarDuration,
            ),
          );
        }
        if (state is DeleteAssetCategorySuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.green.shade600,
              duration:
                  kIsWeb
                      ? AssetCategoryConstants.webSnackBarDuration
                      : AssetCategoryConstants.mobileSnackBarDuration,
            ),
          );
        }
        if (state is AssetCategoryError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Lỗi: ${state.message}'),
              backgroundColor: Colors.red.shade600,
              duration:
                  kIsWeb
                      ? AssetCategoryConstants.webSnackBarDuration
                      : AssetCategoryConstants.mobileSnackBarDuration,
            ),
          );
        }
        if (state is DeleteAssetCategoryBatchSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Xóa mô hình tài sản thành công'),
              backgroundColor: Colors.green.shade600,
              duration:
                  kIsWeb
                      ? AssetCategoryConstants.webSnackBarDuration
                      : AssetCategoryConstants.mobileSnackBarDuration,
            ),
          );
        } else if (state is DeleteAssetCategoryBatchFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Xóa mô hình tài sản thất bại: ${state.message}'),
              backgroundColor: Colors.red.shade600,
              duration:
                  kIsWeb
                      ? AssetCategoryConstants.webSnackBarDuration
                      : AssetCategoryConstants.mobileSnackBarDuration,
            ),
          );
        }
      },
      child: BlocBuilder<AssetCategoryBloc, AssetCategoryState>(
        builder: (context, state) {
          if (state is AssetCategoryLoaded) {
            List<AssetCategoryDto> assetCategories = state.assetCategories;
            data = assetCategories;
            filteredData = data;
            _updatePagination();

            return Scaffold(
              backgroundColor: Colors.transparent,
              appBar: AppBar(
                title: HeaderComponent(
                  controller: searchController,
                  onSearchChanged: (value) {
                    setState(() {
                      _searchAssetCategory(value);
                    });
                  },
                  onNew: () {
                    setState(() {
                      _showForm(null);
                      isShowInput = true;
                      editingAssetCategory = null;
                    });
                  },
                  mainScreen: 'Quản lý mô hình tài sản',
                  onFileSelected: (fileName, filePath, fileBytes) async {
                    final result = await convertExcelToAssetCategory(
                      filePath!,
                      fileBytes: fileBytes,
                    );

                    if (result['success']) {
                      List<AssetCategoryDto> assetCategories = result['data'];
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
                        '[AssetCategoryManager] errorMessages: $errorMessages',
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
                      "mo_hinh_tai_san",
                      assetCategories.map((e) => e.toExportJson()).toList(),
                    );
                  },
                ),
              ),
              body: Column(
                children: [
                  Expanded(
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
                          title: 'Chi tiết mô hình tài sản',
                          childInput: AssetCategoryFormPage(
                            data: editingAssetCategory,
                            onSave: (assetCategory) {
                              if (editingAssetCategory != null) {
                                context.read<AssetCategoryBloc>().add(
                                  UpdateAssetCategoryEvent(
                                    context,
                                    assetCategory,
                                    editingAssetCategory!.id ?? '',
                                  ),
                                );
                              } else {
                                context.read<AssetCategoryBloc>().add(
                                  CreateAssetCategoryEvent(
                                    context,
                                    assetCategory,
                                  ),
                                );
                              }
                            },
                            onCancel: () {
                              setState(() {
                                isShowInput = false;
                                editingAssetCategory = null;
                              });
                            },
                          ),
                          childTableView: AssetCategoryList(
                            data: dataPage,
                            onChangeDetail: (item) {
                              _showForm(item);
                            },
                            onDelete: (item) {
                              _showDeleteDialog(context, item);
                            },
                            onEdit: (item) {
                              _showForm(item);
                            },
                          ),
                          isShowInput: isShowInput,
                          onExpandedChanged: (isExpanded) {
                            isShowInput = isExpanded;
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          } else if (state is AssetCategoryError) {
            return Center(child: Text(state.message));
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
