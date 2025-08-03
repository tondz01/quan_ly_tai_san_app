// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quan_ly_tai_san_app/common/page/common_page_view.dart';
import 'package:quan_ly_tai_san_app/screen/Category/staff/widget/staff_list.dart';
import 'package:quan_ly_tai_san_app/screen/category/staff/bloc/staff_bloc.dart';
import 'package:quan_ly_tai_san_app/screen/category/staff/bloc/staff_event.dart';
import 'package:quan_ly_tai_san_app/screen/category/staff/bloc/staff_state.dart';
import 'package:quan_ly_tai_san_app/screen/category/staff/models/staff.dart';
import 'package:quan_ly_tai_san_app/screen/category/staff/pages/staff_form_page.dart';
import 'package:quan_ly_tai_san_app/screen/tools_and_supplies/widget/header_component.dart';
import 'package:se_gay_components/common/pagination/sg_pagination_controls.dart';

class StaffListPage extends StatefulWidget {
  final VoidCallback? onAdd;
  final void Function(StaffDTO)? onEdit;
  const StaffListPage({super.key, this.onAdd, this.onEdit});

  @override
  State<StaffListPage> createState() => _StaffListPageState();
}

class _StaffListPageState extends State<StaffListPage> {
  final ScrollController horizontalController = ScrollController();
  final TextEditingController controller = TextEditingController();

  bool isShowInput = false;
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
    return BlocBuilder<StaffBloc, StaffState>(
      builder: (context, state) {
        if (state is StaffLoaded) {
          List<StaffDTO> staffs = state.staffs;
          if (staffs.isEmpty) {
            return const Center(child: Text('Chưa có nhân viên nào.'));
          }
          return Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              title: HeaderComponent(
                controller: controller,
                onSearchChanged: (value) {
                  context.read<StaffBloc>().add(SearchStaff(value));
                },
                onNew: () {},
                mainScreen: 'Quản lý nhân viên',
              ),
            ),
            body: Column(
              children: [
                Expanded(
                  child: CommonPageView(
                    childInput: Container(height: 100),
                    childTableView: StaffList(
                      data: staffs,
                      onDelete: (item) {
                        _showDeleteDialog(context, item);
                      },
                      onEdit: (item) {
                        if (widget.onEdit != null) {
                          widget.onEdit!(item);
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
                    ),
                  
                    // Container(height: 200,color: Colors.limeAccent,),
                    isShowInput: isShowInput,
                    onExpandedChanged: (isExpanded) {
                      isShowInput = isExpanded;
                    },
                  ),
                ),
                Visibility(
                  visible: (staffs.length) >= 5,
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
        } else if (state is StaffError) {
          return Center(child: Text(state.message));
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}
