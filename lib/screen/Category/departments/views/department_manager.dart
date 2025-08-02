import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quan_ly_tai_san_app/common/page/common_page_view.dart';
import 'package:quan_ly_tai_san_app/core/utils/utils.dart';
import 'package:quan_ly_tai_san_app/screen/Category/departments/department_list.dart';
import 'package:quan_ly_tai_san_app/screen/category/departments/bloc/department_bloc.dart';
import 'package:quan_ly_tai_san_app/screen/category/departments/bloc/department_event.dart';
import 'package:quan_ly_tai_san_app/screen/category/departments/bloc/department_state.dart';
import 'package:quan_ly_tai_san_app/screen/category/departments/models/department.dart';
import 'package:quan_ly_tai_san_app/screen/category/departments/pages/department_form_page.dart';
import 'package:quan_ly_tai_san_app/screen/category/departments/pages/department_list_page.dart';
import 'package:quan_ly_tai_san_app/screen/tools_and_supplies/widget/header_component.dart';
import 'package:se_gay_components/common/pagination/sg_pagination_controls.dart';

class DepartmentManager extends StatefulWidget {
  const DepartmentManager({super.key});

  @override
  State<DepartmentManager> createState() => _DepartmentManagerState();
}

class _DepartmentManagerState extends State<DepartmentManager> {
  bool showForm = false;
  Department? editingDepartment;

  final ScrollController horizontalController = ScrollController();
  final TextEditingController controller = TextEditingController();
  final TextEditingController searchController = TextEditingController();
  List<Department> data = [];
  List<Department> filteredData = [];
  bool isFirstLoad = false;
  bool isShowInput = false;

  void _showForm([Department? department]) {
    setState(() {
      showForm = true;
      editingDepartment = department;
    });
  }

  void _showList() {
    setState(() {
      showForm = false;
      editingDepartment = null;
    });
  }

  void _showDeleteDialog(BuildContext context, Department department) {
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
    if (value.isEmpty) {
      filteredData = data;
      return;
    }

    String searchLower = value.toLowerCase().trim();
    filteredData =
        data.where((item) {
          bool nameMatch = AppUtility.fuzzySearch(
            item.departmentName.toLowerCase(),
            searchLower,
          );

          bool staffIdMatch = item.departmentId.toLowerCase().contains(
            searchLower,
          );
          bool departmentGroup = item.departmentGroup.toLowerCase().contains(
            searchLower,
          );

          bool parentRoom = AppUtility.fuzzySearch(
            item.parentRoom.toLowerCase(),
            searchLower,
          );

          return nameMatch || staffIdMatch || parentRoom || departmentGroup;
        }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DepartmentBloc, DepartmentState>(
      builder: (context, state) {
        if (state is DepartmentLoaded) {
          List<Department> departments = state.departments;
          if (departments.isEmpty) {
            return const Center(child: Text('Chưa có đơn vị nào.'));
          }
          if (!isFirstLoad) {
            log('departments: ${departments.length}');
            data = departments;
            filteredData = data;
            isFirstLoad = true;
          }

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
              ),
            ),
            body: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: CommonPageView(
                      childInput: DepartmentFormPage(
                        department: editingDepartment,
                        // onCancel: _showList,
                        // onSaved: _showList,
                      ),
                      childTableView: DepartmentList(
                        data: filteredData,
                        onChangeDetail: (item) {
                          _showForm(item);
                          isShowInput = true;
                        },
                        onDelete: (item) {
                          _showDeleteDialog(context, item);
                        },
                        onEdit: (item) {
                          // if (widget.onEdit != null) {
                          //   widget.onEdit!(item);
                          // } else {
                          //   Navigator.of(context).push(
                          //     MaterialPageRoute(
                          //       builder:
                          //           (_) => BlocProvider.value(
                          //             value: context.read<StaffBloc>(),
                          //             child: StaffFormPage(staff: item),
                          //           ),
                          //     ),
                          //   );
                          // }
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
                Visibility(
                  visible: (departments.length) >= 5,
                  child: SGPaginationControls(
                    totalPages: 1,
                    currentPage: 1,
                    rowsPerPage: 10,
                    controllerDropdownPage: controller,
                    items: [
                      DropdownMenuItem(value: 10, child: Text('10')),
                      DropdownMenuItem(value: 20, child: Text('20')),
                      DropdownMenuItem(value: 50, child: Text('50')),
                    ],
                    onPageChanged: (page) {},
                    onRowsPerPageChanged: (rows) {},
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

  // @override
  // Widget build(BuildContext context) {
  //   if (showForm) {
  //     return DepartmentFormPage(
  //       department: editingDepartment,
  //       // Khi bấm Hủy hoặc Lưu sẽ quay lại danh sách
  //       key: ValueKey(editingDepartment?.departmentId ?? 'new'),
  //       onCancel: _showList,
  //       onSaved: _showList,
  //     );
  //   } else {
  //     return DepartmentListPage(
  //       onAdd: () => _showForm(),
  //       onEdit: (department) => _showForm(department),
  //     );
  //   }
  // }
}
