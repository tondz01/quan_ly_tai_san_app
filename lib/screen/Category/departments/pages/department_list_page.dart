import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quan_ly_tai_san_app/screen/category/departments/bloc/department_bloc.dart';
import 'package:quan_ly_tai_san_app/screen/category/departments/bloc/department_event.dart';
import 'package:quan_ly_tai_san_app/screen/category/departments/bloc/department_state.dart';
import 'package:quan_ly_tai_san_app/screen/category/departments/models/department.dart';
import 'package:quan_ly_tai_san_app/screen/category/departments/pages/department_form_page.dart';
import 'package:se_gay_components/common/sg_button.dart';
import 'package:se_gay_components/common/table/sg_table.dart';
import 'package:se_gay_components/common/table/sg_table_component.dart';

class DepartmentListPage extends StatelessWidget {
  final VoidCallback? onAdd;
  final void Function(Department)? onEdit;
  const DepartmentListPage({super.key, this.onAdd, this.onEdit});

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        children: [
          const SizedBox(height: 16),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.05,
            ),
            width: MediaQuery.of(context).size.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        alignment: Alignment.centerLeft,
                        child: SGButton(
                          text: 'Mới',
                          padding: EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 5,
                          ),
                          mainColor: Colors.deepPurple,
                          fontWeight: FontWeight.bold,
                          onPressed: () {
                            if (onAdd != null) {
                              onAdd!();
                            } else {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder:
                                      (_) => BlocProvider.value(
                                        value: context.read<DepartmentBloc>(),
                                        child: const DepartmentFormPage(),
                                      ),
                                ),
                              );
                            }
                          },
                        ),
                      ),
                    ),
                    Expanded(
                      child: SizedBox(
                        child: TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Tìm kiếm phòng ban',
                            prefixIcon: Icon(Icons.search),
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            isDense: true,
                          ),
                          onChanged: (value) {
                            context.read<DepartmentBloc>().add(
                              SearchDepartment(value),
                            );
                          },
                        ),
                      ),
                    ),
                    Expanded(child: SizedBox()),
                  ],
                ),

                SizedBox(height: 8),
                BlocBuilder<DepartmentBloc, DepartmentState>(
                  builder: (context, state) {
                    if (state is DepartmentLoaded) {
                      final departments = state.departments;
                      if (departments.isEmpty) {
                        return const Center(
                          child: Text('Chưa có phòng ban nào.'),
                        );
                      }
                      return SingleChildScrollView(
                        child: SgTable<Department>(
                          // textHeaderColor: SGAppColors.error50,
                          headerBackgroundColor: Colors.grey.shade300,
                                widthScreen: MediaQuery.of(context).size.width,
                          evenRowBackgroundColor: Colors.grey.shade200,
                          oddRowBackgroundColor: Colors.white,

                          gridLineColor: Colors.grey.shade300,
                          gridLineWidth: 1.0,
                          showVerticalLines: true,
                          showHorizontalLines: true,
                          allowRowSelection: true,
                          onSelectionChanged: (selectedItems) {
                            print(MediaQuery.of(context).size.width);
                          },
                          // Bật tính năng hiển thị cột hành động
                          showActions: true,
                          actionColumnTitle: 'Thao tác',
                          actionColumnWidth: 150,
                          actionEditColor: Colors.blue,
                          actionDeleteColor: Colors.red,
                          onEditAction: (item) {
                            if (onEdit != null) {
                              onEdit!(item);
                            } else {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder:
                                      (_) => BlocProvider.value(
                                        value: context.read<DepartmentBloc>(),
                                        child: DepartmentFormPage(
                                          department: item,
                                        ),
                                      ),
                                ),
                              );
                            }
                          },
                          onDeleteAction: (item) {
                            _showDeleteDialog(context, item);
                          },
                          columns: [
                            TableColumnBuilder.createTextColumn<Department>(
                              title: 'Mã đơn vị',
                              getValue: (item) => item.departmentId,
                            ),
                            TableColumnBuilder.createTextColumn<Department>(
                              title: 'Nhóm đơn vị',
                              getValue: (item) => item.departmentGroup,
                              isFullWidth: true
                            ),
                            TableColumnBuilder.createTextColumn<Department>(
                              title: 'Tên phòng/ban',
                              getValue: (item) => item.departmentName,
                              width: 250,
                              align: TextAlign.start,
                              isFullWidth: true
                            ),
                            TableColumnBuilder.createTextColumn<Department>(
                              title: 'Quản lý',
                              align: TextAlign.start,
                              getValue:
                                  (item) =>
                                      context
                                          .read<DepartmentBloc>()
                                          .staffs
                                          .firstWhere(
                                            (staff) =>
                                                staff.staffId == item.managerId,
                                          )
                                          .name,
                              isFullWidth: true
                            ),
                            TableColumnBuilder.createTextColumn<Department>(
                              title: 'Nhân viên',
                              getValue: (item) => item.employeeCount,
                              isFullWidth: true

                            ),
                            TableColumnBuilder.createTextColumn<Department>(
                              title: 'Phòng/ Ban cấp trên',
                              getValue: (item) => item.parentRoom,
                              align: TextAlign.start,
                                                            isFullWidth: true
                            ),
                          ],
                          data: departments,
                          onRowTap: (item) {},
                        ),
                      );
                    } else if (state is DepartmentError) {
                      return Center(child: Text(state.message));
                    }
                    return const Center(child: CircularProgressIndicator());
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
