import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quan_ly_tai_san_app/common/widgets/material_components.dart';
import 'package:quan_ly_tai_san_app/core/constants/app_colors.dart';
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
          Container(
            padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.05),
            width: MediaQuery.of(context).size.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                      child: Container(
                        alignment: Alignment.centerLeft,
                        child: MaterialTextButton(
                          text: 'Mới',
                          icon: Icons.add,
                          backgroundColor: ColorValue.primaryBlue,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 12,
                          ),
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
                      ),
                    ),
                    Expanded(
                      child: SizedBox(
                        child: TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Tìm kiếm nhân viên',
                              prefixIcon: Icon(Icons.search),
                              border: OutlineInputBorder(),
                              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              isDense: true,
                            ),
                            style: TextStyle(fontSize: 13),
                            onChanged: (value) {
                              context.read<StaffBloc>().add(SearchStaff(value));
                            },
                          ),
                      ),
                    ),
                    Expanded(
                      child: SizedBox(),
                    ),
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
                                            return Container(
                        margin: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: ColorValue.neutral300.withOpacity(0.4),
                              spreadRadius: 0,
                              blurRadius: 12,
                              offset: const Offset(0, 6),
                            ),
                            BoxShadow(
                              color: ColorValue.neutral200.withOpacity(0.2),
                              spreadRadius: 0,
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: SingleChildScrollView(
                            child: SgTable<StaffDTO>(
                              headerBackgroundColor: ColorValue.primaryBlue,
                              textHeaderColor: Colors.white,
                              widthScreen: MediaQuery.of(context).size.width,
                              evenRowBackgroundColor: ColorValue.neutral50,
                              oddRowBackgroundColor: Colors.white,
                              selectedRowColor: ColorValue.primaryLightBlue.withOpacity(0.2),
                              checkedRowColor: ColorValue.primaryLightBlue.withOpacity(0.1),
                              gridLineColor: ColorValue.neutral200,
                              gridLineWidth: 1.0,
                              showVerticalLines: true,
                              showHorizontalLines: true,
                              allowRowSelection: true,
                              rowHeight: 56.0,
                              onSelectionChanged: (selectedItems) {},
                              showActions: true,
                              actionColumnTitle: 'Thao tác',
                              actionColumnWidth: 160,
                              actionViewColor: ColorValue.success,
                              actionEditColor: ColorValue.primaryBlue,
                              actionDeleteColor: ColorValue.error,
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
                              isFullWidth: true

                            ),
                            TableColumnBuilder.createTextColumn<StaffDTO>(
                              title: 'Số điện thoại',
                              getValue: (item) => item.tel,
                              align: TextAlign.start,
                              isFullWidth: true
                            ),
                            TableColumnBuilder.createTextColumn<StaffDTO>(
                              title: 'Email',
                              getValue: (item) => item.email,
                              align: TextAlign.start,
                              isFullWidth: true
                            ),
                            TableColumnBuilder.createTextColumn<StaffDTO>(
                              title: 'Hoạt động',
                              getValue: (item) => item.activity,
                              align: TextAlign.start,
                              isFullWidth: true
                            ),
                            TableColumnBuilder.createTextColumn<StaffDTO>(
                              title: 'Hạn chót cho hoạt động tiếp theo',
                              getValue: (item) => item.timeForActivity,
                              align: TextAlign.center,
                              isFullWidth: true
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
                          ),
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
