import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quan_ly_tai_san_app/common/page/common_page_view.dart';
import 'package:quan_ly_tai_san_app/core/utils/utils.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/departments/department_list.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/departments/bloc/department_bloc.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/departments/bloc/department_event.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/departments/bloc/department_state.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/departments/models/department.dart';
import 'package:quan_ly_tai_san_app/screen/category_manager/departments/pages/department_form_page.dart';
import 'package:quan_ly_tai_san_app/common/components/header_component.dart';
import 'package:quan_ly_tai_san_app/screen/login/auth/account_helper.dart';
import 'package:se_gay_components/common/pagination/sg_pagination_controls.dart';

class DepartmentManager extends StatefulWidget {
  const DepartmentManager({super.key});

  @override
  State<DepartmentManager> createState() => _DepartmentManagerState();
}

class _DepartmentManagerState extends State<DepartmentManager> with RouteAware {
  bool showForm = false;
  PhongBan? editingDepartment;

  late int totalEntries;
  late int totalPages = 0;
  late int startIndex;
  late int endIndex;
  int rowsPerPage = 10;
  int currentPage = 1;

  final ScrollController horizontalController = ScrollController();
  final TextEditingController controller = TextEditingController();
  final TextEditingController searchController = TextEditingController();
  List<PhongBan> data = [];
  List<PhongBan> filteredData = [];
  List<PhongBan> dataPage = [];
  bool isFirstLoad = false;
  bool isShowInput = false;

  @override
  void initState() {
    super.initState();
    // Reload dữ liệu mỗi khi vào màn hình này
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DepartmentBloc>().add(const LoadDepartments());
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Reload dữ liệu khi màn hình được focus lại
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DepartmentBloc>().add(const LoadDepartments());
    });
  }

  @override
  void didPopNext() {
    // Khi quay lại màn hình này từ màn hình khác
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DepartmentBloc>().add(const LoadDepartments());
    });
  }

  void _showForm([PhongBan? department]) {
    setState(() {
      isShowInput = true;
      editingDepartment = department;
    });
  }

  void _showDeleteDialog(BuildContext context, PhongBan department) {
    showDialog(
      context: context,
      builder:
          (ctx) => AlertDialog(
            title: const Text('Xác nhận xóa'),
            content: const Text('Bạn có chắc chắn muốn xóa dự án này?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(),
                child: const Text('Hủy'),
              ),
              ElevatedButton(
                onPressed: () {
                  context.read<DepartmentBloc>().add(
                    DeleteDepartment(department),
                  );
                  Navigator.of(ctx).pop();
                },
                child: const Text('Xóa'),
              ),
            ],
          ),
    );
  }

  void _searchDepartment(String value) {
    context.read<DepartmentBloc>().add(SearchDepartment(value));
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

  void _updatePagination() {
    // Sử dụng _filteredData thay vì _data
    totalEntries = filteredData.length;
    totalPages = (totalEntries / rowsPerPage).ceil().clamp(1, 9999);
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

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DepartmentBloc, DepartmentState>(
      builder: (context, state) {
        if (state is DepartmentLoaded) {
          List<PhongBan> departments = state.departments;
          data = departments;
          AccountHelper.instance.clearDepartment();
          AccountHelper.instance.setDepartment(departments);
          filteredData = data;
          _updatePagination();

          return Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              title: HeaderComponent(
                controller: searchController,
                onSearchChanged: (value) {
                  setState(() {
                    _searchDepartment(value);
                  });
                },
                onNew: () {
                  setState(() {
                    _showForm(null);
                    isShowInput = true;
                  });
                },
                mainScreen: 'Quản lý phòng ban',
                onFileSelected: (fileName, filePath, fileBytes) {
                  AppUtility.showSnackBar(context, "Chức năng đang phát triển");
                },
                onExportData: () {
                  AppUtility.exportData(
                    context,
                    "Danh sách phòng ban",
                    departments.map((e) => e.toJson()).toList(),
                  );
                },
              ),
            ),
            body: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: CommonPageView(
                      title: 'Chi tiết phòng ban',
                      childInput: DepartmentFormPage(
                        department: editingDepartment,
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
                      childTableView: DepartmentList(
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
                Visibility(
                  visible: (departments.length) >= 5,
                  child: SGPaginationControls(
                    totalPages: totalPages,
                    currentPage: currentPage,
                    rowsPerPage: rowsPerPage,
                    controllerDropdownPage: controller,
                    items: [
                      DropdownMenuItem(value: 10, child: Text('10')),
                      DropdownMenuItem(value: 20, child: Text('20')),
                      DropdownMenuItem(value: 50, child: Text('50')),
                    ],
                    onPageChanged: onPageChanged,
                    onRowsPerPageChanged: onRowsPerPageChanged,
                  ),
                ),
              ],
            ),
          );
        } else if (state is DepartmentError) {
          return Center(child: Text(state.message));
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}
