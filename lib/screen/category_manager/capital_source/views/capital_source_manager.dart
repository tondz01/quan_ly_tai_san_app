import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quan_ly_tai_san_app/common/page/common_page_view.dart';
import 'package:quan_ly_tai_san_app/common/reponsitory/permission_reponsitory.dart';
import 'package:quan_ly_tai_san_app/core/enum/role_code.dart';
import 'package:quan_ly_tai_san_app/core/utils/check_status_code_done.dart';
import 'package:quan_ly_tai_san_app/core/utils/utils.dart';

import 'package:quan_ly_tai_san_app/screen/category_manager/capital_source/captital_source_list.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/capital_source/bloc/capital_source_bloc.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/capital_source/bloc/capital_source_event.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/capital_source/bloc/capital_source_state.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/capital_source/component/convert_excel_to_capital_source.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/capital_source/constants/capital_source_constants.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/capital_source/models/capital_source.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/capital_source/pages/capital_source_form_page.dart';
import 'package:quan_ly_tai_san_app/common/components/header_component.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/capital_source/providers/capital_source_provider.dart';
import 'package:quan_ly_tai_san_app/screen/home/scroll_controller.dart';
import 'package:quan_ly_tai_san_app/screen/login/auth/account_helper.dart';
import 'package:se_gay_components/common/pagination/sg_pagination_controls.dart';
import 'package:se_gay_components/core/utils/sg_log.dart';

class CapitalSourceManager extends StatefulWidget {
  const CapitalSourceManager({super.key});

  @override
  State<CapitalSourceManager> createState() => _CapitalSourceManagerState();
}

class _CapitalSourceManagerState extends State<CapitalSourceManager>
    with RouteAware {
  bool showForm = false;
  NguonKinhPhi? editingCapitalSource;

  late int totalEntries;
  late int totalPages = 0;
  late int startIndex;
  late int endIndex;
  int rowsPerPage = CapitalSourceConstants.defaultRowsPerPage;
  int currentPage = 1;

  final ScrollController horizontalController = ScrollController();
  final TextEditingController controller = TextEditingController();
  final TextEditingController searchController = TextEditingController();
  List<NguonKinhPhi> data = [];
  List<NguonKinhPhi> filteredData = [];
  List<NguonKinhPhi> dataPage = [];
  bool isFirstLoad = false;
  bool isShowInput = false;
  bool isCanCreate = false;
  bool isCanUpdate = false;
  bool isCanDelete = false;
  bool isNew = false;
  late HomeScrollController _scrollController;
  void _showForm([NguonKinhPhi? capitalSource]) {
    setState(() {
      isShowInput = true;
      editingCapitalSource = capitalSource;
    });
  }

  @override
  void initState() {
    super.initState();
    _scrollController = HomeScrollController();
    _scrollController.addListener((_onScrollStateChanged));
    _checkPermission();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CapitalSourceBloc>().add(const LoadCapitalSources());
    });
  }

  void _onScrollStateChanged() {
    setState(() {});
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Removed duplicate LoadCapitalSources call
  }

  @override
  void didPopNext() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CapitalSourceBloc>().add(const LoadCapitalSources());
    });
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScrollStateChanged);
    super.dispose();
  }

  void _showDeleteDialog(BuildContext context, NguonKinhPhi capitalSource) {
    showDialog(
      context: context,
      builder:
          (ctx) => AlertDialog(
            title: const Text('Xác nhận xóa'),
            content: const Text('Bạn có chắc chắn muốn xóa nguồn vốn này?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(),
                child: const Text('Hủy'),
              ),
              ElevatedButton(
                onPressed: () {
                  context.read<CapitalSourceBloc>().add(
                    DeleteCapitalSource(capitalSource),
                  );
                  Navigator.of(ctx).pop();
                },
                child: const Text('Xóa'),
              ),
            ],
          ),
    );
  }

  void _searchCapitalSource(String value) {
    context.read<CapitalSourceBloc>().add(SearchCapitalSource(value));
  }

  void _updatePagination() {
    // Sử dụng filteredData thay vì data
    totalEntries = filteredData.length;
    totalPages = (totalEntries / rowsPerPage).ceil().clamp(
      1,
      CapitalSourceConstants.maxPaginationPages,
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

  void _checkPermission() async {
    final repo = PermissionRepository();
    final userId = AccountHelper.instance.getUserInfo()?.id ?? '';
    isCanCreate =
        await repo.checkCanCreatePermission(userId, RoleCode.NHANVIEN) ?? false;
    isCanUpdate =
        await repo.checkCanUpdatePermission(userId, RoleCode.NHANVIEN) ?? false;
    isCanDelete =
        await repo.checkCanDeletePermission(userId, RoleCode.NHANVIEN) ?? false;
    SGLog.info(
      "_checkPermission",
      'isCanCreate: $isCanCreate -- isCanDelete: $isCanDelete -- isCanUpdate: $isCanUpdate',
    );
  }

  void _importData(List<NguonKinhPhi> capitalSources) async {
    if (capitalSources.isNotEmpty) {
      final result = await CapitalSourceProvider().saveCapitalSourceBatch(
        capitalSources,
      );
      if (checkStatusCodeDone(result)) {
        if (context.mounted) {
          AppUtility.showSnackBar(
            context,
            'Import dữ liệu thành công ${capitalSources.length} nguồn vốn',
          );
          // Reload list after successful import
          context.read<CapitalSourceBloc>().add(LoadCapitalSources());
        }
      } else {
        if (context.mounted) {
          AppUtility.showSnackBar(
            context,
            'Import dữ liệu thất bại ${result['message']}',
            isError: true,
          );
        }
      }
    } else {
      if (context.mounted) {
        AppUtility.showSnackBar(
          context,
          'Import dữ liệu thất bại}',
          isError: true,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CapitalSourceBloc, CapitalSourceState>(
      listener: (context, state) {
        isShowInput = false;
        if (state is AddCapitalSourceSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: const Color(0xFF21A366),
              duration:
                  kIsWeb
                      ? CapitalSourceConstants.webSnackBarDuration
                      : CapitalSourceConstants.mobileSnackBarDuration,
            ),
          );
        }
        if (state is UpdateCapitalSourceSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: const Color(0xFF21A366),
              duration:
                  kIsWeb
                      ? CapitalSourceConstants.webSnackBarDuration
                      : CapitalSourceConstants.mobileSnackBarDuration,
            ),
          );
        }
        if (state is DeleteCapitalSourceSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: const Color(0xFF21A366),
              duration:
                  kIsWeb
                      ? CapitalSourceConstants.webSnackBarDuration
                      : CapitalSourceConstants.mobileSnackBarDuration,
            ),
          );
        }
        if (state is CapitalSourceError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Lỗi: ${state.message}'),
              backgroundColor: Colors.red.shade600,
              duration:
                  kIsWeb
                      ? CapitalSourceConstants.webSnackBarDuration
                      : CapitalSourceConstants.mobileSnackBarDuration,
            ),
          );
        }
        if (state is DeleteCapitalSourceBatchSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Xóa nguồn vốn thành công'),
              backgroundColor: const Color(0xFF21A366),
              duration:
                  kIsWeb
                      ? CapitalSourceConstants.webSnackBarDuration
                      : CapitalSourceConstants.mobileSnackBarDuration,
            ),
          );
        } else if (state is DeleteCapitalSourceBatchFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Xóa nguồn vốn thất bại: ${state.message}'),
              backgroundColor: Colors.red.shade600,
              duration:
                  kIsWeb
                      ? CapitalSourceConstants.webSnackBarDuration
                      : CapitalSourceConstants.mobileSnackBarDuration,
            ),
          );
        }
      },
      child: BlocBuilder<CapitalSourceBloc, CapitalSourceState>(
        builder: (context, state) {
          if (state is CapitalSourceLoaded) {
            List<NguonKinhPhi> capitalSources = state.capitalSources;
            data = capitalSources;
            filteredData = data;
            _updatePagination();

            return Scaffold(
              backgroundColor: Colors.transparent,
              appBar: AppBar(
                title: HeaderComponent(
                  controller: searchController,
                  onSearchChanged: (value) {
                    setState(() {
                      _searchCapitalSource(value);
                    });
                  },
                  onNew: () {
                    setState(() {
                      _showForm(null);
                    });
                  },
                  mainScreen: 'Quản lý nguồn vốn',
                  onFileSelected: (fileName, filePath, fileBytes) async {
                    final result = await convertExcelToCapitalSource(
                      filePath!,
                      fileBytes: fileBytes,
                    );
                    if (result['success']) {
                      List<NguonKinhPhi> nguonKinhPhi = result['data'];
                      _importData(nguonKinhPhi);
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
                      "nguon_von",
                      data.map((e) => e.toExportJson()).toList(),
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
                          title: 'Chi tiết nguồn vốn',
                          childInput: CapitalSourceFormPage(
                            isNew: isNew = true,
                            isCanUpdate: isCanUpdate = true,
                            capitalSource: editingCapitalSource,
                            onCancel: () {
                              setState(() {
                                isShowInput = false;
                              });
                            },
                            onSaved: () {
                              setState(() {
                                isShowInput = false;
                              });
                            },
                          ),
                          childTableView: CapitalSourceList(
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

                          // Container(height: 200,color: Colors.limeAccent,),
                          isShowInput: isShowInput,
                          onExpandedChanged: (isExpanded) {
                            isShowInput = isExpanded;
                          },
                        ),
                      ),
                    ),
                  ),
                  Visibility(
                    visible:
                        capitalSources.length >=
                        CapitalSourceConstants.minPaginationThreshold,
                    child: SGPaginationControls(
                      totalPages: totalPages,
                      currentPage: currentPage,
                      rowsPerPage: rowsPerPage,
                      controllerDropdownPage: controller,
                      items:
                          (CapitalSourceConstants.mobilePaginationOptions)
                              .map(
                                (value) => DropdownMenuItem(
                                  value: value,
                                  child: Text(value.toString()),
                                ),
                              )
                              .toList(),
                      onPageChanged: onPageChanged,
                      onRowsPerPageChanged: onRowsPerPageChanged,
                    ),
                  ),
                ],
              ),
            );
          } else if (state is CapitalSourceError) {
            return Center(child: Text(state.message));
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
