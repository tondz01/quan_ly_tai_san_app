import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quan_ly_tai_san_app/screen/category/staff/bloc/staff_bloc.dart';
import 'package:quan_ly_tai_san_app/screen/category/staff/bloc/staff_event.dart';
import 'package:quan_ly_tai_san_app/screen/category/staff/bloc/staff_state.dart';
import 'package:quan_ly_tai_san_app/screen/category/staff/models/staff.dart';
import 'package:quan_ly_tai_san_app/screen/category/staff/pages/staff_form_page.dart';
import 'package:se_gay_components/common/sg_button.dart';
import 'package:se_gay_components/common/table/sg_table.dart';
import 'package:se_gay_components/common/table/sg_table_component.dart';

class StaffListPage extends StatelessWidget {
  final VoidCallback? onAdd;
  final void Function(StaffDTO)? onEdit;
  const StaffListPage({super.key, this.onAdd, this.onEdit});

  void _showDeleteDialog(BuildContext context, StaffDTO staff) {
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
                  context.read<StaffBloc>().add(DeleteStaff(staff));
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
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end, 
                  children: [
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          labelText: 'Tìm kiếm nhân viên',
                          prefixIcon: Icon(Icons.search),
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (value) {
                          context.read<StaffBloc>().add(SearchStaff(value));
                        },
                      ),
                    ),
                    SizedBox(width: 25),
                    SGButton(
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                      text: 'Thêm nhân viên',
                      onPressed: () {
                        if (onAdd != null) {
                          onAdd!();
                        } else {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder:
                                  (_) => BlocProvider.value(
                                    value: context.read<StaffBloc>(),
                                    child: const StaffFormPage(),
                                  ),
                            ),
                          );
                        }
                      },
                    ),
                    SizedBox(width: 25),
                  ],
                ),
                SizedBox(height: 8),
                BlocBuilder<StaffBloc, StaffState>(
                  builder: (context, state) {
                    if (state is StaffLoaded) {
                      final staffs = state.staffs;
                      if (staffs.isEmpty) {
                        return const Center(child: Text('Chưa có nhân viên nào.'));
                      }
                      return SingleChildScrollView(
                        child: SgTable<StaffDTO>(
                          // textHeaderColor: SGAppColors.error50,
                          headerBackgroundColor: Colors.blue,
                          evenRowBackgroundColor: Colors.grey.shade200,
                          oddRowBackgroundColor: Colors.white,

                          gridLineColor: Colors.grey.shade300,
                          gridLineWidth: 1.0,
                          showVerticalLines: true,
                          showHorizontalLines: true,
                          allowRowSelection: true,
                          onSelectionChanged: (selectedItems) {},
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
                                        value: context.read<StaffBloc>(),
                                        child: StaffFormPage(staff: item),
                                      ),
                                ),
                              );
                            }
                          },
                          onDeleteAction: (item) {
                            _showDeleteDialog(context, item);
                          },
                          columns: [
                            TableColumnBuilder.createTextColumn<StaffDTO>(
                              title: 'Mã nhân viên',
                              getValue: (item) => item.staffId,
                            ),
                            TableColumnBuilder.createTextColumn<StaffDTO>(
                              title: 'Tên nhân viên',
                              getValue: (item) => item.name,
                              align: TextAlign.start,
                              width: 150,
                            ),
                            TableColumnBuilder.createTextColumn<StaffDTO>(
                              title: 'Số điện thoại',
                              getValue: (item) => item.tel,
                              align: TextAlign.start,
                            ),
                            TableColumnBuilder.createTextColumn<StaffDTO>(
                              title: 'Email',
                              getValue: (item) => item.email,
                              align: TextAlign.start,
                              width: 200,
                            ),
                            TableColumnBuilder.createTextColumn<StaffDTO>(
                              title: 'Hoạt động',
                              getValue: (item) => item.activity,
                              align: TextAlign.start,
                            ),
                            TableColumnBuilder.createTextColumn<StaffDTO>(
                              title: 'Hạn chót cho hoạt động tiếp theo',
                              getValue: (item) => item.timeForActivity,
                              align: TextAlign.center,
                            ),
                            TableColumnBuilder.createTextColumn<StaffDTO>(
                              title: 'Phòng ban',
                              getValue: (item) => item.department,
                              align: TextAlign.center,
                            ),
                            TableColumnBuilder.createTextColumn<StaffDTO>(
                              title: 'Chức vụ',
                              getValue: (item) => item.position,
                              align: TextAlign.center,
                            ),
                            TableColumnBuilder.createTextColumn<StaffDTO>(
                              title: 'Người quản lý',
                              getValue: (item) => item.staffOwner,
                              align: TextAlign.start,
                            ),
                          ],
                          data: staffs,
                          onRowTap: (item) {},
                        ),
                      );
                    } else if (state is StaffError) {
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
