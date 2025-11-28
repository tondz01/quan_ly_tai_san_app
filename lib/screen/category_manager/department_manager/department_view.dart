import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:quan_ly_tai_san_app/common/page/common_page_view.dart';
import 'package:quan_ly_tai_san_app/core/utils/utils.dart';
import 'package:flutter/foundation.dart';

import 'package:quan_ly_tai_san_app/common/components/header_component.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/department_manager/bloc/department_bloc.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/department_manager/bloc/department_event.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/department_manager/bloc/department_state.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/department_manager/component/convert_excel_to_department.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/department_manager/models/department.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/department_manager/provider/department_provide.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/department_manager/view/department_form_page.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/department_manager/view/department_list.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/role/constants/role_constants.dart';
import 'package:quan_ly_tai_san_app/screen/home/scroll_controller.dart';

class DepartmentView extends StatefulWidget {
  const DepartmentView({super.key});

  @override
  State<DepartmentView> createState() => _DepartmentViewState();
}

class _DepartmentViewState extends State<DepartmentView> {
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
    Provider.of<DepartmentProvider>(context, listen: false).onInit(context);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Removed duplicate onInit call
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScrollStateChanged);
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DepartmentBloc, DepartmentState>(
      builder: (context, state) {
        return Consumer<DepartmentProvider>(
          builder: (context, provider, child) {
            if (provider.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            return Scaffold(
              appBar: AppBar(
                title: HeaderComponent(
                  isShowSearch: false,
                  controller: _searchController,
                  onSearchChanged: (value) {},
                  onNew: () {
                    provider.onChangeDetail(context, null);
                  },
                  mainScreen: 'Quản lý phòng ban',
                  subScreen: provider.subScreen,
                  onFileSelected: (fileName, filePath, fileBytes) async {
                  final departmentBloc = context.read<DepartmentBloc>();
                    final result = await convertExcelToPhongBan(
                      filePath!,
                      fileBytes: fileBytes,
                    );
                    if (!mounted) return;

                    if (result['success']) {
                      List<PhongBan> pb = result['data'];
                      departmentBloc.add(CreateDepartmentBatchEvent(pb));
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
                      "chuc_vu",
                      provider.data?.map((e) => e.toExportJson()).toList() ??
                          [],
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
                          title: 'Chi tiết phòng ban',
                          childInput: DepartmentFormPage(provider: provider),
                          childTableView: DepartmentList(provider: provider),
                          isShowInput: provider.isShowInput,
                          isShowCollapse: provider.isShowCollapse,
                          onExpandedChanged: (isExpanded) {
                            provider.onSetsShowCollapse(isExpanded);
                          },
                        ),
                      ),
                    ),
                  ),
                  // Visibility(
                  //   visible:
                  //       (provider.data?.length ?? 0) >=
                  //       DepartmentConstants.minPaginationThreshold,
                  //   child: SGPaginationControls(
                  //     totalPages: provider.totalPages,
                  //     currentPage: provider.currentPage,
                  //     rowsPerPage: provider.rowsPerPage,
                  //     controllerDropdownPage: provider.controllerDropdownPage!,
                  //     items: provider.items,
                  //     onPageChanged: provider.onPageChanged,
                  //     onRowsPerPageChanged: provider.onRowsPerPageChanged,
                  //   ),
                  // ),
                ],
              ),
            );
          },
        );
      },
      listener: (context, state) {
        if (state is DepartmentsInitialState) {}
        if (state is DepartmentsLoadingState) {}
        if (state is DepartmentsLoadingDismissState) {}
        if (state is GetListDepartmentFailedState) {}
        if (state is CreateDepartmentSuccessState) {
          // Refresh list
          context.read<DepartmentProvider>().createDepartmentsSuccess(
            context,
            state,
          );
        }
        if (state is CreateDepartmentFailedState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red.shade600,
              duration:
                  kIsWeb
                      ? RoleConstants.webSnackBarDuration
                      : RoleConstants.mobileSnackBarDuration,
            ),
          );
        }
        if (state is UpdateDepartmentSuccessState) {
          context.read<DepartmentProvider>().updateDepartmentsSuccess(
            context,
            state,
          );
        }
        if (state is DeleteDepartmentSuccessState) {
          context.read<DepartmentProvider>().deleteDepartmentsSuccess(
            context,
            state,
          );
        }
        if (state is PutPostDeleteFailedState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red.shade600,
              duration:
                  kIsWeb
                      ? RoleConstants.webSnackBarDuration
                      : RoleConstants.mobileSnackBarDuration,
            ),
          );
        }
        if (state is DeleteDepartmentBatchSuccess) {
          context.read<DepartmentProvider>().deleteDepartmentBatchSuccess(
            context,
            state,
          );
        } else if (state is DeleteDepartmentBatchFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Xóa chức vụ thất bại: ${state.message}'),
              backgroundColor: Colors.red.shade600,
              duration:
                  kIsWeb
                      ? RoleConstants.webSnackBarDuration
                      : RoleConstants.mobileSnackBarDuration,
            ),
          );
        }
      },
    );
  }
}
